# Architektur

## Komponenten-Diagramm

```
┌──────────────────────────────────────────────────────────────────────┐
│                          SAP-System (ECC | S/4)                       │
│                                                                       │
│  ┌──────────────────┐   OData v2    ┌────────────────────────────┐   │
│  │  Fiori-App       │ ◄──────────►  │  ZSLM_LANDSCAPE_SRV (SEGW) │   │
│  │  ZSLM_LANDSCAPE  │  /sap/opu/    │  ZCL_SLM_DPC_EXT           │   │
│  │  _UI (BSP)       │  odata/sap/   │  ZCL_SLM_MPC_EXT           │   │
│  └──────────────────┘               └────────────┬───────────────┘   │
│                                                   │                   │
│                                                   ▼                   │
│                                        ┌────────────────────────┐    │
│                                        │  ZCL_SLM_VERSIONS      │    │
│                                        │  ZCL_SLM_STORE         │    │
│                                        │  ZCL_SLM_AUDIT         │    │
│                                        │  ZCL_SLM_XML_GENERATOR │    │
│                                        └────────────┬───────────┘    │
│                                                     │                 │
│                                                     ▼                 │
│   Z-Tabellen (live + history):                                        │
│   ZSLM_T_SERVICE  ZSLM_T_MSGSRV  ZSLM_T_WORKSPACE  ZSLM_T_WS_ITEM    │
│   ZSLM_T_INCLUDE  ZSLM_T_VERSION ZSLM_T_VERSDATA  ZSLM_T_CHANGE      │
│   ZSLM_T_ACTIVE  ◄─────────────── geschrieben bei Publish             │
│         │                                                             │
│         │ gelesen bei jedem Request                                   │
│         ▼                                                             │
│  ┌──────────────────────────┐                                         │
│  │ ICF /sap/bc/zslm/        │  liefert XML aus ZSLM_T_ACTIVE          │
│  │ landscape_xml            │  (anonymous, kein Re-Rendering)         │
│  │ ZCL_SLM_XML_HANDLER      │                                         │
│  └────────────┬─────────────┘                                         │
└───────────────┼───────────────────────────────────────────────────────┘
                │ HTTP GET (anonym)
                ▼
       ┌────────────────────┐
       │ SAP Logon Pad /    │
       │ SAP GUI Clients    │
       └────────────────────┘
```

## Datenfluss

### Mutation (Service anlegen / ändern / löschen)

1. Fiori-App ruft OData-Methode auf (POST/PUT/DELETE auf `Services` etc.)
2. `ZCL_SLM_DPC_EXT` validiert + delegiert an `ZCL_SLM_STORE`
3. `ZCL_SLM_STORE` ändert die Live-Tabelle
4. `ZCL_SLM_VERSIONS.create_version`:
   - Serialisiert kompletten Live-Stand zu JSON-Snapshot
   - Schreibt `ZSLM_T_VERSION` (neue Versionsnummer = max+1)
   - Schreibt `ZSLM_T_VERSDATA` (Snapshot-XSTRING)
   - `ZCL_SLM_AUDIT` schreibt `ZSLM_T_CHANGE`-Eintrag
   - Pruning: Versionen über `MAX_VERSIONS=10` entfernen
5. **Aktive Version + ausgelieferte XML bleiben unverändert** — bis Publish

### Publish

1. Fiori-App ruft Function Import `Publish(version_id)`
2. `ZCL_SLM_VERSIONS.publish`:
   - Prüft: Version existiert
   - Setzt `is_active = 'X'` auf gewählter Version, alle anderen `''`
   - Rendert XML aus aktuellen Live-Tabellen via `ZCL_SLM_XML_GENERATOR`
   - Schreibt `ZSLM_T_ACTIVE` (Singleton pro Mandant)
3. Ab sofort liefert der ICF-Endpoint die neue XML aus

### Public XML serve

1. SAP Logon Pad / GUI ruft `GET /sap/bc/zslm/landscape_xml`
2. SICF leitet an `ZCL_SLM_XML_HANDLER` weiter (anonymer Service-User)
3. Handler: `SELECT SINGLE xml_content FROM zslm_t_active WHERE mandt = sy-mandt`
4. Response: 200 OK + XML + `Cache-Control: max-age=300` + `X-Landscape-Version: <num>`

## Schutz-Logik

| Operation | Schutz |
|---|---|
| `DeleteVersion` | Aktive Version → Reject. Letzte verbleibende Version → Reject. Beim Erreichen von 1 Version: Auto-Renumber zu v1. |
| `PruneToVersion` | Setzt Snapshot der gewählten Version als alleinige v1, aktiviert sie. |
| `MAX_VERSIONS=10` | Beim Erzeugen einer 11. Version wird die älteste automatisch entfernt. |
| Anonymous-Endpoint | Tech-User `ZSLM_PUB` hat **nur** `S_TABU_DIS`-Read auf `ZSLM_T_ACTIVE`. Nichts sonst. |
