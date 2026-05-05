# DDIC-Spezifikation

Vollständige Definition aller Domains, Datenelemente und Z-Tabellen für `Z_BASIS_TOOLS_LANDSCAPE`. Direkt in SE11 abtippbar.

**Konventionen**:
- Alle Tabellen mandantenabhängig (`MANDT` als erstes Schlüsselfeld, Datenelement `MANDT`, Initialwert).
- UUIDs: CHAR(36) mit Bindestrichen (Python `uuid.uuid4()`-Format → 1:1-portabel mit Cloud-Edition-Snapshots).
- Codierung der „Spaltenbreite" pro Feld: ABAP-Datentyp + Länge in Klammern.
- Tabellen-Typ: **transparent** (TRANSP). Erweiterungskategorie: `not classified` (oder `not specified`).
- Tabellen-Auslieferungsklasse: **A** (Anwendungstabelle).

---

## 1. Domains (`ZSLM_D_*`)

| Domain | Datentyp | Länge | Festwerte | Beschreibung |
|---|---|---|---|---|
| `ZSLM_D_UUID` | CHAR | 36 | — | UUID im Format `xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx` |
| `ZSLM_D_SVCTYPE` | CHAR | 6 | `SAPGUI`, `NWBC` | Service-Typ |
| `ZSLM_D_ACTION` | CHAR | 6 | `add`, `edit`, `delete`, `init` | Audit-Aktion |
| `ZSLM_D_ENTITY` | CHAR | 20 | — | Audit-Entität (`Service`, `Messageserver`, `Workspace`, `Include`, `System`) |
| `ZSLM_D_AREA` | CHAR | 3 | `SVC`, `MSG`, `VER`, `PUB` | Auth-Object-Bereich |
| `ZSLM_D_FLAG` | CHAR | 1 | `0`, `1` | Boolean-Flag (entspricht Cloud-Edition `expanded`/`hidden`) |
| `ZSLM_D_SVCNAME` | CHAR | 128 | — | Service-/Messageserver-Anzeigename |
| `ZSLM_D_HOST` | CHAR | 255 | — | Hostname inkl. optionalem `:port` |
| `ZSLM_D_URL` | CHAR | 2000 | — | URL (NWBC, Includes) |
| `ZSLM_D_SNC` | CHAR | 255 | — | SNC-Name (z. B. `p:CN=SNC-XYZ-01`) |
| `ZSLM_D_TEXT255` | CHAR | 255 | — | Allgemeine Beschreibung |
| `ZSLM_D_VERSNUM` | INT4 | — | — | Versionsnummer (1, 2, …) |

---

## 2. Datenelemente (`ZSLM_E_*`)

| Datenelement | Domain | Feldlabel kurz/lang | Beschreibung |
|---|---|---|---|
| `ZSLM_E_UUID` | `ZSLM_D_UUID` | UUID / Universally Unique ID | Generischer UUID-Schlüssel |
| `ZSLM_E_SVC_UUID` | `ZSLM_D_UUID` | Service-UUID | UUID eines Services |
| `ZSLM_E_MS_UUID` | `ZSLM_D_UUID` | Messageserver-UUID | UUID eines Messageservers |
| `ZSLM_E_WS_UUID` | `ZSLM_D_UUID` | Workspace-UUID | UUID eines Workspaces |
| `ZSLM_E_VER_ID` | `ZSLM_D_UUID` | Version-ID | UUID einer Version |
| `ZSLM_E_SVCTYPE` | `ZSLM_D_SVCTYPE` | Typ / Service-Typ | SAPGUI \| NWBC |
| `ZSLM_E_ACTION` | `ZSLM_D_ACTION` | Aktion / Audit-Aktion | add/edit/delete/init |
| `ZSLM_E_ENTITY` | `ZSLM_D_ENTITY` | Entität / Audit-Entität |  |
| `ZSLM_E_FLAG` | `ZSLM_D_FLAG` | Flag / Boolean-Flag | `0` \| `1` |
| `ZSLM_E_SVCNAME` | `ZSLM_D_SVCNAME` | Name / Anzeigename |  |
| `ZSLM_E_HOST` | `ZSLM_D_HOST` | Server / Host:Port |  |
| `ZSLM_E_URL` | `ZSLM_D_URL` | URL |  |
| `ZSLM_E_SNCNAME` | `ZSLM_D_SNC` | SNC-Name |  |
| `ZSLM_E_DESCR` | `ZSLM_D_TEXT255` | Beschreibung |  |
| `ZSLM_E_VERSNUM` | `ZSLM_D_VERSNUM` | Version / Versionsnummer |  |
| `ZSLM_E_DETAIL` | `ZSLM_D_TEXT255` | Detail / Audit-Detail |  |

Standard-SAP-Datenelemente, die wiederverwendet werden:

| Datenelement | Bemerkung |
|---|---|
| `MANDT` | Mandant |
| `SYSID` | SAP-System-ID (3 Zeichen) — für `systemid` |
| `MANDT` (zusätzlich) | NWBC-Client-Feld nutzt CHAR(3) — siehe unten |
| `TIMESTAMPL` | DEC(21,7), für `created_at`, `last_changed_at`, `published_at` |
| `SYUNAME` | CHAR(12), Username — für `created_by`, `last_changed_by` |

---

## 3. Tabellen

### 3.1 `ZSLM_T_SERVICE` — Service-Stamm

Vereinigt SAPGUI- und NWBC-Felder (sparse). Unterscheidung über `SERVICE_TYPE`.

| Feld | Datenelement / Typ | Schlüssel | Pflicht (initial) | Bemerkung |
|---|---|---|---|---|
| `MANDT` | `MANDT` | ✓ | ✓ | Mandant |
| `UUID` | `ZSLM_E_SVC_UUID` (CHAR 36) | ✓ |  | Service-UUID |
| `SERVICE_TYPE` | `ZSLM_E_SVCTYPE` (CHAR 6) |  | ✓ | `SAPGUI` \| `NWBC` |
| `NAME` | `ZSLM_E_SVCNAME` (CHAR 128) |  | ✓ | Anzeigename |
| `SYSTEMID` | `SYSID` (CHAR 3) |  |  | SAP-SID (nur SAPGUI) |
| `MODE` | CHAR(8) (Datenelement: `ZSLM_E_DETAIL` reicht nicht — eigenes anlegen, oder `CHAR8` direkt) |  |  | Instance-No / Mode (Cloud: `"1"`) |
| `SERVER` | `ZSLM_E_HOST` (CHAR 255) |  |  | `host:port` (nur SAPGUI) |
| `MSID_UUID` | `ZSLM_E_MS_UUID` (CHAR 36) |  |  | optional: Verweis auf Messageserver |
| `SNCNAME` | `ZSLM_E_SNCNAME` (CHAR 255) |  |  | nur SAPGUI |
| `SNCOP` | CHAR(4) |  |  | nur SAPGUI; Werte wie `9`, `-1` |
| `DCPG` | CHAR(8) |  |  | Codepage (nur SAPGUI), z. B. `2`, `4103` |
| `DESCRIPTION` | `ZSLM_E_DESCR` (CHAR 255) |  |  | nur NWBC |
| `CLIENT` | CHAR(3) (Datenelement `MANDT_NEW` nicht verwenden — eigenes `ZSLM_E_NWBC_CLIENT` anlegen, oder `MANDT` als Datentyp neutral) |  |  | nur NWBC |
| `URL` | `ZSLM_E_URL` (CHAR 2000) |  |  | nur NWBC |
| `SLC` | CHAR(20) |  |  | nur NWBC |
| `LAST_CHANGED_AT` | `TIMESTAMPL` |  |  |  |
| `LAST_CHANGED_BY` | `SYUNAME` |  |  |  |

**Technische Einstellungen**:
- Datenart: `APPL1` (Stammdaten, transparent)
- Größenkategorie: 0 (< 1.000 Sätze)
- Pufferung: nicht gepuffert
- Protokollierung: ja (Tabellenänderungen via `RSVTPROT`)

**Fremdschlüssel**:
- `MSID_UUID` → `ZSLM_T_MSGSRV.UUID` (Cardinalität: `C:CN`, semantisches Attribut: schwach)

---

### 3.2 `ZSLM_T_MSGSRV` — Messageserver

| Feld | Datenelement / Typ | Schlüssel | Pflicht | Bemerkung |
|---|---|---|---|---|
| `MANDT` | `MANDT` | ✓ | ✓ |  |
| `UUID` | `ZSLM_E_MS_UUID` (CHAR 36) | ✓ |  |  |
| `NAME` | `ZSLM_E_SVCNAME` (CHAR 128) |  | ✓ |  |
| `HOST` | `ZSLM_E_HOST` (CHAR 255) |  | ✓ |  |
| `LAST_CHANGED_AT` | `TIMESTAMPL` |  |  |  |
| `LAST_CHANGED_BY` | `SYUNAME` |  |  |  |

**Technische Einstellungen**: APPL1, Größe 0, nicht gepuffert, protokolliert.

---

### 3.3 `ZSLM_T_WORKSPACE` — Workspaces

| Feld | Datenelement / Typ | Schlüssel | Pflicht | Bemerkung |
|---|---|---|---|---|
| `MANDT` | `MANDT` | ✓ | ✓ |  |
| `UUID` | `ZSLM_E_WS_UUID` (CHAR 36) | ✓ |  |  |
| `NAME` | `ZSLM_E_SVCNAME` (CHAR 128) |  | ✓ |  |
| `EXPANDED` | `ZSLM_E_FLAG` (CHAR 1) |  |  | `0`/`1` |
| `HIDDEN` | `ZSLM_E_FLAG` (CHAR 1) |  |  | `0`/`1` |
| `LAST_CHANGED_AT` | `TIMESTAMPL` |  |  |  |
| `LAST_CHANGED_BY` | `SYUNAME` |  |  |  |

**Technische Einstellungen**: APPL1, Größe 0, **vollgepuffert** (typischerweise 1 Eintrag pro Mandant).

---

### 3.4 `ZSLM_T_WS_ITEM` — n:m Workspace ↔ Service

| Feld | Datenelement / Typ | Schlüssel | Pflicht | Bemerkung |
|---|---|---|---|---|
| `MANDT` | `MANDT` | ✓ | ✓ |  |
| `WS_UUID` | `ZSLM_E_WS_UUID` (CHAR 36) | ✓ |  | FK → `ZSLM_T_WORKSPACE` |
| `POS` | NUMC(4) | ✓ |  | Sortier-Reihenfolge |
| `SERVICE_UUID` | `ZSLM_E_SVC_UUID` (CHAR 36) |  | ✓ | FK → `ZSLM_T_SERVICE` |

**Technische Einstellungen**: APPL1, Größe 0, **vollgepuffert**.

**Fremdschlüssel**:
- `WS_UUID` → `ZSLM_T_WORKSPACE.UUID` (`CN:N`)
- `SERVICE_UUID` → `ZSLM_T_SERVICE.UUID` (`CN:N`)

---

### 3.5 `ZSLM_T_INCLUDE` — Includes

| Feld | Datenelement / Typ | Schlüssel | Pflicht | Bemerkung |
|---|---|---|---|---|
| `MANDT` | `MANDT` | ✓ | ✓ |  |
| `SEQNO` | NUMC(4) | ✓ |  | Reihenfolge |
| `URL` | `ZSLM_E_URL` (CHAR 2000) |  | ✓ |  |
| `IDX` | NUMC(4) |  |  | Cloud-Feld `index` |
| `DESCRIPTION` | `ZSLM_E_DESCR` (CHAR 255) |  |  |  |
| `LAST_CHANGED_AT` | `TIMESTAMPL` |  |  |  |
| `LAST_CHANGED_BY` | `SYUNAME` |  |  |  |

---

### 3.6 `ZSLM_T_VERSION` — Version-Header

| Feld | Datenelement / Typ | Schlüssel | Pflicht | Bemerkung |
|---|---|---|---|---|
| `MANDT` | `MANDT` | ✓ | ✓ |  |
| `VERSION_ID` | `ZSLM_E_VER_ID` (CHAR 36) | ✓ |  |  |
| `NUMBER` | `ZSLM_E_VERSNUM` (INT4) |  | ✓ | 1..n |
| `IS_ACTIVE` | `ZSLM_E_FLAG` (CHAR 1) |  |  | `X` = aktiv, sonst leer/`0` |
| `CREATED_AT` | `TIMESTAMPL` |  |  |  |
| `CREATED_BY` | `SYUNAME` |  |  |  |

**Sekundärindex**:
- `Z01`: `MANDT`, `NUMBER` — für „höchste Version finden" und Sortierung in der UI

---

### 3.7 `ZSLM_T_VERSDATA` — Version-Snapshot (Blob)

| Feld | Datenelement / Typ | Schlüssel | Pflicht | Bemerkung |
|---|---|---|---|---|
| `MANDT` | `MANDT` | ✓ | ✓ |  |
| `VERSION_ID` | `ZSLM_E_VER_ID` (CHAR 36) | ✓ |  | FK → `ZSLM_T_VERSION` |
| `SNAPSHOT` | RAWSTRING (XSTRING) |  | ✓ | komplettes Snapshot-JSON, gleiche Struktur wie Cloud-Edition `landscape.json` |

**Technische Einstellungen**: APPL1, Größe 0, nicht gepuffert.

> Datentyp `RAWSTRING` für unbegrenzten Binär-Inhalt. Alternativ `STRING` (UTF-16-encoded) — beides funktioniert; `RAWSTRING` ist bei JSON praktischer, weil `/UI2/CL_JSON->serialize` einen STRING liefert, der dann via `cl_abap_codepage=>convert_to` → XSTRING gespeichert wird.

---

### 3.8 `ZSLM_T_CHANGE` — Audit-Trail

Eine Zeile pro Änderungseintrag. Pro Version meist 1 Eintrag (entspricht Cloud `changes[0]`); `init` kann allein in v1 stehen.

| Feld | Datenelement / Typ | Schlüssel | Pflicht | Bemerkung |
|---|---|---|---|---|
| `MANDT` | `MANDT` | ✓ | ✓ |  |
| `VERSION_ID` | `ZSLM_E_VER_ID` (CHAR 36) | ✓ |  | FK → `ZSLM_T_VERSION` |
| `SEQNO` | NUMC(4) | ✓ |  | 0001, 0002, ... innerhalb einer Version |
| `ACTION` | `ZSLM_E_ACTION` (CHAR 6) |  | ✓ | add/edit/delete/init |
| `ENTITY` | `ZSLM_E_ENTITY` (CHAR 20) |  | ✓ | Service/Messageserver/... |
| `NAME` | `ZSLM_E_SVCNAME` (CHAR 128) |  |  | Name des betroffenen Objekts |
| `DETAIL` | `ZSLM_E_DETAIL` (CHAR 255) |  |  | Freitext-Detail |
| `TS` | `TIMESTAMPL` |  | ✓ |  |

---

### 3.9 `ZSLM_T_ACTIVE` — aktive Version + pre-rendered XML

Singleton pro Mandant. Enthält das, was der ICF-Endpoint bei jedem Request 1:1 ausliefert.

| Feld | Datenelement / Typ | Schlüssel | Pflicht | Bemerkung |
|---|---|---|---|---|
| `MANDT` | `MANDT` | ✓ | ✓ | einziger Schlüssel — pro Mandant max. 1 Zeile |
| `ACTIVE_VERSION_ID` | `ZSLM_E_VER_ID` (CHAR 36) |  |  | leer, wenn noch nichts publiziert |
| `XML_CONTENT` | STRING |  |  | komplette SAPUILandscape.xml als String |
| `PUBLISHED_AT` | `TIMESTAMPL` |  |  |  |
| `PUBLISHED_BY` | `SYUNAME` |  |  |  |

**Technische Einstellungen**: APPL1, Größe 0, **vollgepuffert** (jede Lese-Anfrage des ICF-Handlers → Buffer-Hit, kein DB-Roundtrip).

> `STRING` als Datentyp ist ungebunden in der Länge. Für die Mini-XML-Größen (typisch < 100 KB) völlig ausreichend.

**Pufferungs-Reset**: Nach jedem `MODIFY` auf diese Tabelle wird der Mandanten-Buffer automatisch invalidiert — kein expliziter Code nötig.

---

## 4. Anlage-Reihenfolge in SE11

Wegen Abhängigkeiten (Datenelemente referenzieren Domains, Tabellen referenzieren Datenelemente, Fremdschlüssel referenzieren Primärschlüssel anderer Tabellen):

1. Domains: alle `ZSLM_D_*`
2. Datenelemente: alle `ZSLM_E_*`
3. Tabellen ohne Fremdschlüssel: `ZSLM_T_MSGSRV`, `ZSLM_T_WORKSPACE`, `ZSLM_T_INCLUDE`, `ZSLM_T_VERSION`, `ZSLM_T_ACTIVE`
4. Tabellen mit Fremdschlüsseln: `ZSLM_T_SERVICE` (→ MSGSRV), `ZSLM_T_WS_ITEM` (→ WS, SERVICE), `ZSLM_T_VERSDATA` (→ VERSION), `ZSLM_T_CHANGE` (→ VERSION)
5. Sekundärindex `Z01` auf `ZSLM_T_VERSION`

Aktivieren in der gleichen Reihenfolge.

---

## 5. abapGit-XML-Format (Beispiel: `ZSLM_T_MSGSRV`)

Vorlage zum Befüllen unter `abap/src/z_basis_tools_landscape/ddic/zslm_t_msgsrv.tabl.xml`. Die anderen Tabellen folgen demselben Schema.

```xml
<?xml version="1.0" encoding="utf-8"?>
<abapGit version="v1.0.0" serializer="LCL_OBJECT_TABL" serializer_version="v1.0.0">
 <asx:abap xmlns:asx="http://www.sap.com/abapxml" version="1.0">
  <asx:values>
   <DD02V>
    <TABNAME>ZSLM_T_MSGSRV</TABNAME>
    <DDLANGUAGE>D</DDLANGUAGE>
    <TABCLASS>TRANSP</TABCLASS>
    <DDTEXT>Logon Pad — Messageserver</DDTEXT>
    <CONTFLAG>A</CONTFLAG>
    <EXCLASS>1</EXCLASS>
   </DD02V>
   <DD09L>
    <TABNAME>ZSLM_T_MSGSRV</TABNAME>
    <AS4LOCAL>A</AS4LOCAL>
    <TABKAT>0</TABKAT>
    <TABART>APPL1</TABART>
    <BUFALLOW>N</BUFALLOW>
    <SCHFELDAUS>X</SCHFELDAUS>
    <PROTOKOLL>X</PROTOKOLL>
   </DD09L>
   <DD03P_TABLE>
    <DD03P>
     <FIELDNAME>MANDT</FIELDNAME>
     <POSITION>0001</POSITION>
     <KEYFLAG>X</KEYFLAG>
     <ROLLNAME>MANDT</ROLLNAME>
     <NOTNULL>X</NOTNULL>
     <DATATYPE>CLNT</DATATYPE>
     <LENG>000003</LENG>
     <MASK>  CLNT</MASK>
    </DD03P>
    <DD03P>
     <FIELDNAME>UUID</FIELDNAME>
     <POSITION>0002</POSITION>
     <KEYFLAG>X</KEYFLAG>
     <ROLLNAME>ZSLM_E_MS_UUID</ROLLNAME>
     <NOTNULL>X</NOTNULL>
     <DATATYPE>CHAR</DATATYPE>
     <LENG>000036</LENG>
     <MASK>  CHAR</MASK>
    </DD03P>
    <DD03P>
     <FIELDNAME>NAME</FIELDNAME>
     <POSITION>0003</POSITION>
     <ROLLNAME>ZSLM_E_SVCNAME</ROLLNAME>
     <DATATYPE>CHAR</DATATYPE>
     <LENG>000128</LENG>
     <MASK>  CHAR</MASK>
    </DD03P>
    <DD03P>
     <FIELDNAME>HOST</FIELDNAME>
     <POSITION>0004</POSITION>
     <ROLLNAME>ZSLM_E_HOST</ROLLNAME>
     <DATATYPE>CHAR</DATATYPE>
     <LENG>000255</LENG>
     <MASK>  CHAR</MASK>
    </DD03P>
    <DD03P>
     <FIELDNAME>LAST_CHANGED_AT</FIELDNAME>
     <POSITION>0005</POSITION>
     <ROLLNAME>TIMESTAMPL</ROLLNAME>
     <DATATYPE>DEC</DATATYPE>
     <LENG>000021</LENG>
     <DECIMALS>000007</DECIMALS>
    </DD03P>
    <DD03P>
     <FIELDNAME>LAST_CHANGED_BY</FIELDNAME>
     <POSITION>0006</POSITION>
     <ROLLNAME>SYUNAME</ROLLNAME>
     <DATATYPE>CHAR</DATATYPE>
     <LENG>000012</LENG>
     <MASK>  CHAR</MASK>
    </DD03P>
   </DD03P_TABLE>
  </asx:values>
 </asx:abap>
</abapGit>
```

**Kommentar zu den DD09L-Feldern**:
- `TABART=APPL1` → Datenklasse Stammdaten
- `TABKAT=0` → Größe 0..1.000 Sätze
- `BUFALLOW=N` → keine Pufferung (für `ZSLM_T_ACTIVE` und `ZSLM_T_WORKSPACE` stattdessen `BUFALLOW=X` + `BUFFERED=A` für vollgepuffert)
- `PROTOKOLL=X` → Tabellenänderungen werden protokolliert (RSVTPROT)

---

## 6. JSON-Snapshot-Format (für `ZSLM_T_VERSDATA.SNAPSHOT`)

Identisch zur Cloud-Edition `data/landscape.json`:

```json
{
  "services": [
    {
      "uuid": "...",
      "type": "SAPGUI",
      "name": "...",
      "systemid": "...",
      "mode": "1",
      "server": "host:3200",
      "msid": "<uuid-oder-leer>",
      "sncname": "p:CN=...",
      "sncop": "9",
      "dcpg": "2"
    },
    {
      "uuid": "...",
      "type": "NWBC",
      "name": "...",
      "description": "...",
      "url": "https://...",
      "client": "100",
      "slc": "..."
    }
  ],
  "workspaces": [
    { "uuid": "...", "name": "Default", "expanded": "1", "hidden": "0",
      "items": ["<service-uuid>", "..."] }
  ],
  "messageservers": [
    { "uuid": "...", "name": "...", "host": "..." }
  ],
  "includes": [
    { "url": "...", "index": "0", "description": "..." }
  ]
}
```

`ZCL_SLM_JSON` serialisiert/deserialisiert via `/UI2/CL_JSON` mit `pretty_name = pretty_mode-low_case` damit JSON-Keys lowercase bleiben (Cloud-Kompatibilität).

---

## 7. Mandantenabhängigkeit

Alle Tabellen sind mandantenabhängig (`MANDT` als erstes Schlüsselfeld, Datenelement `MANDT`).

**Praktische Konsequenz**:
- Pflege erfolgt im Mandanten, in dem der ICF-Service läuft (üblicherweise der Customizing- oder Produktiv-Mandant)
- Transport bringt nur Strukturen, **keine Daten**
- In einem neuen Mandanten startet der Datenbestand leer; nach erstem Service-Anlegen entsteht v1

**Default-Mandant des ICF-Service** wird in SICF konfiguriert (siehe [INSTALLATION.md](INSTALLATION.md) Schritt 6) — der Tech-User `ZSLM_PUB` liest dann konsistent aus genau diesem Mandanten, egal von wo der Aufruf kommt.
