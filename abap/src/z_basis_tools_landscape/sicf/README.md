# ICF-Service

Pfad: `/sap/bc/zslm/landscape_xml`
Handler: `ZCL_SLM_XML_HANDLER`

**Wichtig**: Anonymous-Logon-Konfiguration (Tab „Logon Daten" in SICF) lässt sich **nicht zuverlässig transportieren** — muss in jedem System manuell gesetzt werden:

1. Logon-Verfahren: „Alternative Logon-Verfahren"
2. Verfahren-Reihenfolge: nur „Anonymous"
3. Anonymer Service-User: `ZSLM_PUB`

Siehe [docs/INSTALLATION.md](../../../../docs/INSTALLATION.md) Schritt 6.
