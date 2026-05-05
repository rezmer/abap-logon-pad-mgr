# DDIC-Objekte

**Vollständige Spezifikation**: [docs/DDIC.md](../../../../docs/DDIC.md) — alle Domains, Datenelemente, Tabellen mit Feldnamen, Datentypen, Längen, Schlüsseln, Pufferung, Fremdschlüsseln, Anlage-Reihenfolge.

## Erwartete Dateien (abapGit-Layout)

### Domains (`*.doma.xml`)
- `zslm_d_uuid.doma.xml` — CHAR(36)
- `zslm_d_svctype.doma.xml` — CHAR(6), Festwerte SAPGUI/NWBC
- `zslm_d_action.doma.xml` — CHAR(6), Festwerte add/edit/delete/init
- `zslm_d_entity.doma.xml` — CHAR(20)
- `zslm_d_area.doma.xml` — CHAR(3), Festwerte SVC/MSG/VER/PUB
- `zslm_d_flag.doma.xml` — CHAR(1), Festwerte 0/1
- `zslm_d_svcname.doma.xml` — CHAR(128)
- `zslm_d_host.doma.xml` — CHAR(255)
- `zslm_d_url.doma.xml` — CHAR(2000)
- `zslm_d_snc.doma.xml` — CHAR(255)
- `zslm_d_text255.doma.xml` — CHAR(255)
- `zslm_d_versnum.doma.xml` — INT4

### Datenelemente (`*.dtel.xml`)
- `zslm_e_uuid.dtel.xml`, `zslm_e_svc_uuid.dtel.xml`, `zslm_e_ms_uuid.dtel.xml`, `zslm_e_ws_uuid.dtel.xml`, `zslm_e_ver_id.dtel.xml`
- `zslm_e_svctype.dtel.xml`, `zslm_e_action.dtel.xml`, `zslm_e_entity.dtel.xml`, `zslm_e_flag.dtel.xml`
- `zslm_e_svcname.dtel.xml`, `zslm_e_host.dtel.xml`, `zslm_e_url.dtel.xml`, `zslm_e_sncname.dtel.xml`, `zslm_e_descr.dtel.xml`
- `zslm_e_versnum.dtel.xml`, `zslm_e_detail.dtel.xml`

### Tabellen (`*.tabl.xml`)
- `zslm_t_service.tabl.xml`
- `zslm_t_msgsrv.tabl.xml` ✅ (Vorlage vorhanden — Schema-Beispiel für die anderen)
- `zslm_t_workspace.tabl.xml`
- `zslm_t_ws_item.tabl.xml`
- `zslm_t_include.tabl.xml`
- `zslm_t_version.tabl.xml`
- `zslm_t_versdata.tabl.xml`
- `zslm_t_change.tabl.xml`
- `zslm_t_active.tabl.xml`

## Anlage-Reihenfolge in SE11

Wegen Abhängigkeiten: Domains → Datenelemente → Tabellen ohne FK → Tabellen mit FK → Sekundärindex.
Details siehe [docs/DDIC.md](../../../../docs/DDIC.md) Abschnitt 4.
