# DDIC-Objekte

Hier liegen die abapGit-Serialisierungen der Z-Tabellen, Domains und Datenelemente.

Geplante Tabellen (siehe [docs/ARCHITECTURE.md](../../../../docs/ARCHITECTURE.md)):

- `ZSLM_T_SERVICE` — Service-Stamm (Live)
- `ZSLM_T_MSGSRV` — Messageserver
- `ZSLM_T_WORKSPACE` — Workspaces
- `ZSLM_T_WS_ITEM` — n:m WS↔Service mit Reihenfolge
- `ZSLM_T_INCLUDE` — Includes
- `ZSLM_T_VERSION` — Version-Header (max. 10)
- `ZSLM_T_VERSDATA` — Version-Snapshot (XSTRING/JSON)
- `ZSLM_T_CHANGE` — Audit-Trail
- `ZSLM_T_ACTIVE` — pre-rendered XML der aktiven Version
