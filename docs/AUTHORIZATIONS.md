# Berechtigungskonzept

## Auth-Objekt `Z_SLM`

Klasse: `BC_C` (Basis: Customizing) oder eigene Z-Klasse.

Felder:

| Feld | Typ | Werte | Beschreibung |
|---|---|---|---|
| `ACTVT` | Activity | `01` Create, `02` Change, `03` Display, `06` Delete | Standard-Aktivitäten |
| `ZSLM_AREA` | CHAR(3) | `SVC` Services, `MSG` Messageserver, `VER` Versionen, `PUB` Publish | Funktionsbereich |

Geprüft in `ZCL_SLM_DPC_EXT` vor jeder schreibenden Operation und vor Function Imports.

## Rollen

### `Z_BASIS_TOOLS_LSC_ADMIN` — Vollzugriff

| Auth-Objekt | Feld | Werte |
|---|---|---|
| `Z_SLM` | `ACTVT` | 01, 02, 03, 06 |
| `Z_SLM` | `ZSLM_AREA` | SVC, MSG, VER, PUB |
| `S_SERVICE` | `SRV_NAME` | `ZSLM_LANDSCAPE_SRV` (zur Nutzung des OData-Service) |
| `S_TABU_DIS` | `DICBERCLS` | (frei lassen — wird via Z_SLM gesteuert) |

Auch im FLP: Catalog `Z_BASIS_TOOLS` (Basis Admin Tools) freischalten.

### `Z_BASIS_TOOLS_LSC_VIEWER` — Read-only

| Auth-Objekt | Feld | Werte |
|---|---|---|
| `Z_SLM` | `ACTVT` | 03 |
| `Z_SLM` | `ZSLM_AREA` | SVC, MSG, VER |
| `S_SERVICE` | `SRV_NAME` | `ZSLM_LANDSCAPE_SRV` |

### `Z_BASIS_TOOLS_LSC_PUBSERVE` — Tech-User für Public-Endpoint

**Nur für User `ZSLM_PUB`** (User-Type Service, kein Dialog-Login).

| Auth-Objekt | Feld | Werte |
|---|---|---|
| `S_TABU_DIS` | `ACTVT` | 03 |
| `S_TABU_DIS` | `DICBERCLS` | (Tabellenklasse von `ZSLM_T_ACTIVE`, in der Regel `&NC&` falls keine eigene Klasse) |
| `S_RFC` | (nicht nötig) |  |

**Kein** `Z_SLM` zugewiesen — Handler liest direkt aus der Tabelle, OData-Service wird nicht benutzt.

## Public-Endpoint-Spezialität

Der ICF-Service `/sap/bc/zslm/landscape_xml` läuft im Kontext von `ZSLM_PUB`. Diese Konfiguration wird **nur über SICF** gesetzt:

1. SICF-Knoten → Tab „Logon Daten"
2. Logon-Verfahren: „Alternative Logon-Verfahren"
3. Verfahren-Reihenfolge enthält **nur** „Anonymous"
4. Anonymer Service-User: `ZSLM_PUB`
5. Standard-Mandant des Service: derjenige, in dem die Daten gepflegt werden

**Sicherheits-Argument**:
- SICF lässt nur anonyme Aufrufe zu — kein Login möglich
- Tech-User hat ausschließlich Lese-Recht auf eine Tabelle
- Die Tabelle enthält nur das, was bewusst publiziert wurde (kein Draft, keine History)

Falls die Sicherheits-Policy anonyme Services kategorisch verbietet, ist Fallback: Basic-Auth mit dem Tech-User in der Logon-Pad-Konfiguration auf den Clients (GPO-Registry).
