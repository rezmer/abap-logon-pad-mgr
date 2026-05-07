# DDIC-Objekte

**Vollständige Spezifikation**: [docs/DDIC.md](../../../../docs/DDIC.md) — alle Domains, Datenelemente, Tabellen mit Feldnamen, Datentypen, Längen, Schlüsseln, Pufferung, Fremdschlüsseln, Anlage-Reihenfolge.

Alle 37 abapGit-XMLs sind vorhanden — direkt in einen abapGit-Pull importierbar oder via SE11 manuell abtippbar.

## Domains (12) — `*.doma.xml`

- ✅ `zslm_d_uuid.doma.xml` — CHAR(36)
- ✅ `zslm_d_svctype.doma.xml` — CHAR(6), Festwerte SAPGUI/NWBC
- ✅ `zslm_d_action.doma.xml` — CHAR(6), Festwerte add/edit/delete/init
- ✅ `zslm_d_entity.doma.xml` — CHAR(20)
- ✅ `zslm_d_area.doma.xml` — CHAR(3), Festwerte SVC/MSG/VER/PUB
- ✅ `zslm_d_flag.doma.xml` — CHAR(1), Festwerte 0/1
- ✅ `zslm_d_svcname.doma.xml` — CHAR(128)
- ✅ `zslm_d_host.doma.xml` — CHAR(255)
- ✅ `zslm_d_url.doma.xml` — CHAR(2000)
- ✅ `zslm_d_snc.doma.xml` — CHAR(255)
- ✅ `zslm_d_text255.doma.xml` — CHAR(255)
- ✅ `zslm_d_versnum.doma.xml` — INT4

## Datenelemente (16) — `*.dtel.xml`

- ✅ `zslm_e_uuid.dtel.xml`, `zslm_e_svc_uuid.dtel.xml`, `zslm_e_ms_uuid.dtel.xml`, `zslm_e_ws_uuid.dtel.xml`, `zslm_e_ver_id.dtel.xml`
- ✅ `zslm_e_svctype.dtel.xml`, `zslm_e_action.dtel.xml`, `zslm_e_entity.dtel.xml`, `zslm_e_flag.dtel.xml`
- ✅ `zslm_e_svcname.dtel.xml`, `zslm_e_host.dtel.xml`, `zslm_e_url.dtel.xml`, `zslm_e_sncname.dtel.xml`, `zslm_e_descr.dtel.xml`
- ✅ `zslm_e_versnum.dtel.xml`, `zslm_e_detail.dtel.xml`

## Tabellen (9) — `*.tabl.xml`

- ✅ `zslm_t_service.tabl.xml` — Service-Stamm, FK auf `MSID_UUID` → `ZSLM_T_MSGSRV`
- ✅ `zslm_t_msgsrv.tabl.xml` — Messageserver
- ✅ `zslm_t_workspace.tabl.xml` — vollgepuffert
- ✅ `zslm_t_ws_item.tabl.xml` — vollgepuffert, FKs auf WS + Service
- ✅ `zslm_t_include.tabl.xml`
- ✅ `zslm_t_version.tabl.xml` — inkl. Sekundärindex `Z01` auf (MANDT, NUMBER)
- ✅ `zslm_t_versdata.tabl.xml` — RAWSTRING-Feld, FK auf `ZSLM_T_VERSION`
- ✅ `zslm_t_change.tabl.xml` — FK auf `ZSLM_T_VERSION`
- ✅ `zslm_t_active.tabl.xml` — STRING-Feld, vollgepuffert

## Anlage-Reihenfolge in SE11

Wegen Abhängigkeiten: Domains → Datenelemente → Tabellen ohne FK → Tabellen mit FK → Sekundärindex.
Details siehe [docs/DDIC.md](../../../../docs/DDIC.md) Abschnitt 4.

## Hinweise

- Die abapGit-XMLs verwenden das Standard-Layout (`asx:abap`/`asx:values`/`DDxxV`-Strukturen). Falls deine abapGit-Version Schema-Validierungs-Warnungen wirft (z. B. wegen fehlender Felder wie `MASTERLANG`), Werte einfach in SE11 nachpflegen — die Kerninhalte (Felder, Typen, Längen, Schlüssel, FKs) sind komplett.
- Festwerte (`DD07V_TAB`) wurden für `ZSLM_D_SVCTYPE`, `ZSLM_D_ACTION`, `ZSLM_D_AREA`, `ZSLM_D_FLAG` definiert — andere Domains haben offene Wertebereiche.
- Pufferungs-Konvention: `BUFALLOW=X` + `PUFFERUNG=X` signalisiert Vollpufferung. Bei Bedarf in SE11 → "Technische Einstellungen" auf Generic-Pufferung umstellen, falls Mandanten-Datenmenge wächst.
