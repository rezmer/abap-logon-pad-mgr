# ABAP-Klassen

Geplante Klassen:

| Klasse | Verantwortlichkeit |
|---|---|
| `ZCL_SLM_JSON` | Wrapper um `/UI2/CL_JSON` |
| `ZCL_SLM_AUDIT` | Change-Logging in `ZSLM_T_CHANGE` |
| `ZCL_SLM_STORE` | DAO-Layer auf Live-Tables |
| `ZCL_SLM_XML_GENERATOR` | Live-Snapshot → SAPUILandscape.xml (Port von `xml_generator.py`) |
| `ZCL_SLM_VERSIONS` | create / publish / delete / prune mit Schutz-Logik |
| `ZCL_SLM_XML_HANDLER` | implements `IF_HTTP_EXTENSION` für public Endpoint |
| `ZCL_SLM_DPC_EXT` | OData-Data-Provider (CRUD + Function Imports) |
| `ZCL_SLM_MPC_EXT` | OData-Model-Provider |
| `ZCL_SLM_TEST_*` | ABAP Unit Tests |
