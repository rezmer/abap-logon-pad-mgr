# Transport-Reihenfolge

Klassischer 3-System-Pfad **DEV → QAS → PROD**.

## Transport-Aufträge

Empfehlung: 4 separate Aufträge oder 1 großer mit Tasks pro Schicht. Reihenfolge bei Import in Folgesystemen unbedingt einhalten:

| # | Inhalt | Bemerkung |
|---|---|---|
| 1 | DDIC: Domains, Datenelemente, Tabellen `ZSLM_T_*` | Tabellen leer in QAS/PROD; Daten sind mandantenabhängig und werden dort separat gepflegt. |
| 2 | Klassen + Interface (`ZIF_SLM_CONSTANTS`, `ZCL_SLM_*`) | inkl. Test-Klassen. |
| 3 | Auth-Objekt `Z_SLM` + Rollen-Templates | Rollen werden in QAS/PROD ggf. lokal angepasst. |
| 4 | SEGW-Service `ZSLM_LANDSCAPE_SRV` (Modell + Aktivierung) | Service muss in QAS/PROD via `/IWFND/MAINT_SERVICE` zusätzlich registriert werden. |
| 5 | SICF-Knoten `/sap/bc/zslm/landscape_xml` | Aktivierung manuell pro System. |
| 6 | Fiori BSP-App `ZSLM_LANDSCAPE_UI` | via `/UI5/UI5_REPOSITORY_LOAD` mit Transport-Auftrag. |
| 7 | FLP-Tile + Target Mapping | optional über Customizing-Auftrag. |

## Manuelle Schritte pro Folgesystem

Nicht alles transportiert sich:

- Tech-User `ZSLM_PUB` (SU01) — **muss in jedem Mandanten manuell angelegt werden**
- SICF-Anonymous-Logon-Konfiguration — pro System manuell prüfen + setzen
- Service-Aktivierung in `/IWFND/MAINT_SERVICE`
- FLP-Konfiguration falls nicht via Customizing-Transport

## Smoke-Test nach Transport

```bash
# 1. OData-Metadata
curl -u <user> https://<host>:<port>/sap/opu/odata/sap/ZSLM_LANDSCAPE_SRV/\$metadata

# 2. Fiori-App im Launchpad öffnen, einen Service anlegen + publishen

# 3. Public-Endpoint
curl https://<host>:<port>/sap/bc/zslm/landscape_xml
```

Wenn alle drei klappen: Transport erfolgreich.
