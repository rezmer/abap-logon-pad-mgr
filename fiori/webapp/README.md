# Fiori-App

Freestyle UI5 App, App-ID `z.basis.tools.landscape`.

## Stack

- UI5 ≥ 1.108 LTS
- OData v2 (kein Fiori Elements)
- DE + EN i18n

## Struktur (geplant)

```
webapp/
├── package.json          — Build-Skripte
├── ui5.yaml              — UI5-Tooling-Konfig
├── manifest.json         — App-Definition + OData-Datasource
└── webapp/
    ├── Component.js
    ├── i18n/
    │   ├── i18n.properties
    │   ├── i18n_de.properties
    │   └── i18n_en.properties
    ├── view/
    │   ├── App.view.xml
    │   ├── Main.view.xml
    │   ├── ServiceForm.fragment.xml
    │   ├── MsgServerForm.fragment.xml
    │   ├── XmlPreview.fragment.xml
    │   ├── VersionMgr.fragment.xml
    │   └── ConfirmDlg.fragment.xml
    ├── controller/
    │   ├── App.controller.js
    │   └── Main.controller.js
    ├── model/
    │   └── formatter.js  — Tier-Erkennung, Datum-Formatierung
    └── css/
        └── style.css
```

## Build & Upload

```bash
npm install
npm run build
# → dist/

# Upload via SAP GUI:
# Tx /n/UI5/UI5_REPOSITORY_LOAD
# SAPUI5 Repository: ZSLM_LANDSCAPE_UI
# External Path: <pfad zu dist/>
```

Cloud-Edition-Vorlage für UI-Logik: [SAP_Logon_Pad_Landscape_Manager/SourceCode/frontend/src/App.jsx](https://github.com/rezmer/...) — wird 1:1 ins Fiori-Layout portiert.
