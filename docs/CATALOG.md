# Vision: Basis Admin Tools

Der **Logon Pad Landscape Manager** ist die erste App eines mittelfristig geplanten Katalogs an Basis-Admin-Tools.

## Konzept

- Jedes Tool: **eigenes Git-Repo**, eigenes ABAP-Paket, eigene Fiori-App, eigener BSP-Container
- Gemeinsamer Auftritt im SAP-System: **Fiori-Launchpad-Catalog „Basis Admin Tools"**
- Tile-Group `Landscape Management`, weitere Groups je nach Tool
- Optionale Cross-Tool-Helper: separates Repo `abap-basis-tools-common` mit geteilten Klassen (Logging, JSON-Helper, ICF-Utilities). Wird nicht aufgezwungen — jedes Tool kann unabhängig leben.

## Geplante / mögliche Tools

| Tool | Zweck | Status |
|---|---|---|
| Logon Pad Landscape Manager | SAPUILandscape.xml zentral pflegen | **dieses Repo** — in Entwicklung |
| (TBD) | Übersicht aktiver Sperreinträge mit Bulk-Cleanup-Workflow | geplant |
| (TBD) | Hintergrund-Job-Übersicht / Kachel-Dashboard | geplant |
| (TBD) | RFC-Destination-Audit | geplant |
| (TBD) | Lock-Entry-Manager | geplant |

## Catalog-Konvention

| Element | Wert |
|---|---|
| Catalog-ID | `Z_BASIS_TOOLS` |
| Catalog-Title | `Basis Admin Tools` |
| Group für dieses Tool | `Landscape Management` |
| Tile-Title | `Logon Pad Landscape` |
| Tile-Subtitle | `SAPUILandscape.xml` |
| Tile-Icon | `sap-icon://it-system` |
| Semantic Object | `Landscape` |
| Action | `display` |

Folgende Tools verwenden eigene Semantic Objects + Actions, teilen sich aber den Catalog.
