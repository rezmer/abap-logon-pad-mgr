# Installation

Klassischer Transport-Weg, ohne abapGit. Reihenfolge: **DDIC → Klassen → Auth → SEGW → SICF → Fiori**.

---

## Voraussetzungen

- Berechtigungen: SE11, SE24, SE80, SU21, SICF, SEGW, /IWFND/MAINT_SERVICE, /UI5/UI5_REPOSITORY_LOAD, /UI2/FLPD_CUST, PFCG, SU01
- Transportauftrag in DEV vorhanden
- SAP Gateway Foundation aktiv

---

## Schritt 1: ABAP-Paket

`SE80` → Repository Browser → Edit Object → Package → `Z_BASIS_TOOLS_LANDSCAPE`

- Description: `Basis Admin Tools — Logon Pad Landscape Manager`
- Application Component: `BC-MID-ICF` (oder eigene Z-Komponente)
- Software Component: `HOME` (oder Customer-spezifisch)
- Transport Layer: lokaler Layer

---

## Schritt 2: DDIC-Objekte

Domains, Datenelemente und Tabellen aus `abap/src/z_basis_tools_landscape/ddic/` anlegen.

**Reihenfolge** (jeweils SE11):

1. Domains (`ZSLM_D_*`): Service-Type, Action, Tier
2. Datenelemente (`ZSLM_E_*`): Verweise auf Domains + Standard-Typen
3. Strukturen (falls benötigt)
4. Tabellen (`ZSLM_T_*`):
   - `ZSLM_T_SERVICE`
   - `ZSLM_T_MSGSRV`
   - `ZSLM_T_WORKSPACE`
   - `ZSLM_T_WS_ITEM`
   - `ZSLM_T_INCLUDE`
   - `ZSLM_T_VERSION`
   - `ZSLM_T_VERSDATA`
   - `ZSLM_T_CHANGE`
   - `ZSLM_T_ACTIVE`

Alle Tabellen mit `MANDT` als erstem Schlüsselfeld (Mandantenabhängigkeit).

Aktivieren in dieser Reihenfolge: Domains → Datenelemente → Tabellen.

---

## Schritt 3: ABAP-Klassen

`SE80` oder `SE24` — aus `abap/src/z_basis_tools_landscape/classes/`:

1. `ZIF_SLM_CONSTANTS` (Interface, in `interfaces/`)
2. `ZCL_SLM_JSON` (JSON-Helper, dünner Wrapper um `/UI2/CL_JSON`)
3. `ZCL_SLM_AUDIT`
4. `ZCL_SLM_STORE`
5. `ZCL_SLM_XML_GENERATOR`
6. `ZCL_SLM_VERSIONS`
7. `ZCL_SLM_XML_HANDLER` (implements `IF_HTTP_EXTENSION`)
8. `ZCL_SLM_MPC_EXT` (extends `/IWBEP/CL_MGW_PUSH_ABS_MODEL`)
9. `ZCL_SLM_DPC_EXT` (extends `/IWBEP/CL_MGW_PUSH_ABS_DATA`)
10. Test-Klassen `ZCL_SLM_TEST_*`

---

## Schritt 4: Berechtigungen

`SU21` → Auth-Objekt `Z_SLM` aus `abap/src/.../auth/z_slm.auth.xml` importieren.

Felder:
- `ACTVT` (01/02/03/06)
- `ZSLM_AREA` (SVC/MSG/VER/PUB)

`PFCG` → Rollen anlegen (Templates in [AUTHORIZATIONS.md](AUTHORIZATIONS.md)):
- `Z_BASIS_TOOLS_LSC_ADMIN`
- `Z_BASIS_TOOLS_LSC_VIEWER`

---

## Schritt 5: OData-Service (SEGW)

1. `SEGW` → Project anlegen: `ZSLM_LANDSCAPE_SRV`
2. EntitySets aus `abap/src/.../gateway/zslm_landscape_srv.iwsv.xml` übernehmen
3. Function Imports: `Publish`, `DeleteVersion`, `PruneToVersion`, `ExportXml`
4. Generate Runtime Objects → `ZSLM_LANDSCAPE_SRV_DPC_EXT` ableiten von `ZCL_SLM_DPC_EXT`, MPC analog
5. `/IWFND/MAINT_SERVICE`: Service registrieren + aktivieren

Test: `https://<host>:<port>/sap/opu/odata/sap/ZSLM_LANDSCAPE_SRV/$metadata` muss alle EntitySets zeigen.

---

## Schritt 6: ICF-Service (öffentlicher Endpoint)

1. `SICF` → `default_host` → `sap` → `bc` → Subknoten `zslm` anlegen, darunter `landscape_xml`
2. Handler-Liste: `ZCL_SLM_XML_HANDLER`
3. Tab „Logon Daten":
   - Logon-Verfahren: **Alternative Logon-Verfahren**
   - Verfahren-Reihenfolge: **nur „Anonymous"** auswählen
   - Anonymer Service-User: `ZSLM_PUB` (siehe Schritt 7)
4. Service aktivieren (Rechtsklick → Service aktivieren)

Test: `curl http://<host>:<port>/sap/bc/zslm/landscape_xml` ohne Auth muss 200 zurückgeben (sobald Daten gepflegt + publiziert).

---

## Schritt 7: Tech-User für Public-Endpoint

`SU01` → User `ZSLM_PUB`:
- User-Type: **Service**
- Sprache: EN
- Profil: nur die Mini-Rolle `Z_BASIS_TOOLS_LSC_PUBSERVE` mit `S_TABU_DIS`-Display auf Tabelle `ZSLM_T_ACTIVE`. Sonst nichts.

Wichtig: Diesen User nirgendwo dialog-fähig machen, kein Passwort setzen.

---

## Schritt 8: Fiori-App

### Build (lokal)

```bash
cd fiori/webapp
npm install
npm run build
```

Output: `fiori/webapp/dist/`.

### Upload via /UI5/UI5_REPOSITORY_LOAD

1. SAP GUI → Transaktion `/n/UI5/UI5_REPOSITORY_LOAD`
2. SAPUI5 Repository: `ZSLM_LANDSCAPE_UI`
3. External Path: `<lokaler Pfad zu fiori/webapp/dist>`
4. Upload starten — BSP-Application wird angelegt

### FLP-Konfiguration

`/UI2/FLPD_CUST`:

1. Catalog **„Basis Admin Tools"** anlegen (falls nicht vorhanden)
2. Tile darin: Static App Launcher
   - Title: `Logon Pad Landscape`
   - Subtitle: `SAPUILandscape.xml`
   - Icon: `sap-icon://it-system`
3. Target Mapping:
   - Semantic Object: `Landscape`
   - Action: `display`
   - Application Type: SAPUI5 Fiori App
   - URL: `/sap/bc/ui5_ui5/sap/zslm_landscape_ui`
   - ID: `z.basis.tools.landscape`

---

## Schritt 9: Test

| Schritt | Erwartung |
|---|---|
| Fiori-Tile öffnen | App lädt, leerer Service-Stamm |
| Service anlegen, Speichern | OData POST 201, neue Version v1 in der Verwaltung |
| Publish | Version aktiv markiert, Toast „Publiziert" |
| `curl http://<host>:<port>/sap/bc/zslm/landscape_xml` | 200 OK, XML enthält den Service |
| `xmllint --noout` auf Output | wohlgeformt, keine Warnings |

---

## Transport DEV → QAS → PROD

Siehe [TRANSPORT.md](TRANSPORT.md).
