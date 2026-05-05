# SAP Logon Pad Landscape Manager — ABAP Edition

Verwaltet eine zentrale `SAPUILandscape.xml` direkt im SAP-System und liefert sie ohne Anmeldung über SMICM/ICF an alle SAP Logon Pad / SAP GUI Clients aus. Bedienung ausschließlich über eine Fiori-App.

> **Erste App** in einem mittelfristigen Katalog von **Basis Admin Tools**. Siehe [docs/CATALOG.md](docs/CATALOG.md).

> **Cloud Edition (Schwester-Projekt)**: Eine BTP-Cloud-Foundry-Variante (Flask + React) existiert weiterhin als eigenes Repo `SAP_Logon_Pad_Landscape_Manager`. Diese ist eingefroren — aktive Entwicklung erfolgt hier in der ABAP Edition.

---

## Features

- Zentrale Pflege aller SAP-Systeme (SAP GUI + NWBC) und Messageserver
- Versionierung mit max. 10 Versionen (Auto-Pruning)
- Publish-Workflow: nur freigegebene Versionen werden ausgeliefert
- Audit-Trail aller Änderungen
- Public XML-Endpoint für SAP Logon Pad / GUI ohne Anmeldung
- Fiori-App im SAP-Standard-Look-and-feel, DE + EN
- Versionsverwaltung: Aktivieren, Löschen, „Nur diese behalten"-Prune

---

## Architektur

```
┌─────────────────────────┐         ┌──────────────────────┐
│  SAP Logon Pad / GUI    │ ◄─XML── │  ICF /sap/bc/zslm/.. │  (anonym)
│  Clients                │         │  ZCL_SLM_XML_HANDLER │
└─────────────────────────┘         └──────────────────────┘
                                              │ liest
                                              ▼
                                    ┌──────────────────────┐
                                    │  ZSLM_T_ACTIVE       │
                                    │  (xml_content)       │
                                    └──────────────────────┘
                                              ▲ schreibt bei Publish
                                              │
┌─────────────────────────┐         ┌──────────────────────┐
│  Fiori-App              │ ◄─OData─│  /sap/opu/odata/sap/ │  (Z_SLM Auth)
│  (Basis Admin Tools)    │         │  ZSLM_LANDSCAPE_SRV  │
└─────────────────────────┘         └──────────────────────┘
                                              │
                                              ▼
                                    ┌──────────────────────┐
                                    │ Z-Tabellen (live)    │
                                    │ ZSLM_T_SERVICE       │
                                    │ ZSLM_T_MSGSRV        │
                                    │ ZSLM_T_VERSION/...   │
                                    └──────────────────────┘
```

Details: [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) · DDIC-Spezifikation: [docs/DDIC.md](docs/DDIC.md).

---

## Voraussetzungen

- ECC 6.0 EHP7+ **oder** S/4HANA (beides auf HDB)
- SAP Gateway Foundation (`SAP_GWFND`) installiert
- UI5 ≥ 1.108 in der Frontend-Server-Komponente verfügbar
- ICF-Anonymous-Logon laut Sicherheits-Policy erlaubt

---

## Installation

Schritt-für-Schritt-Anleitung (klassischer Transport, ohne abapGit): siehe [docs/INSTALLATION.md](docs/INSTALLATION.md).

Kurz:

1. Paket `Z_BASIS_TOOLS_LANDSCAPE` anlegen, DDIC-Objekte aus `abap/src/.../ddic/` importieren (SE11)
2. ABAP-Klassen aus `abap/src/.../classes/` importieren (SE80)
3. Auth-Objekt `Z_SLM` aus `abap/src/.../auth/` importieren (SU21)
4. SEGW-Service `ZSLM_LANDSCAPE_SRV` registrieren und aktivieren (`/IWFND/MAINT_SERVICE`)
5. SICF-Knoten `/sap/bc/zslm/landscape_xml` aktivieren, Tech-User `ZSLM_PUB` zuweisen
6. Fiori-App bauen (`cd fiori/webapp && npm install && npm run build`) und via `/UI5/UI5_REPOSITORY_LOAD` als BSP `ZSLM_LANDSCAPE_UI` hochladen
7. Tile in `/UI2/FLPD_CUST` im Catalog „Basis Admin Tools" registrieren

---

## Repo-Layout

```
abap-logon-pad-mgr/
├── README.md
├── docs/                — Architektur, Installation, Transport, Auth, Katalog-Vision
├── abap/src/z_basis_tools_landscape/
│   ├── ddic/            — Tabellen, Domains, Datenelemente
│   ├── classes/         — OO-Klassen (Store, Versions, XML-Generator, ICF-Handler, OData-DPC/MPC)
│   ├── interfaces/      — ZIF_SLM_CONSTANTS
│   ├── auth/            — Authority-Objekt Z_SLM
│   ├── sicf/            — ICF-Service-Knoten
│   └── gateway/         — SEGW-Service-Definition
└── fiori/webapp/        — Fiori-App-Quellen (UI5)
```

---

## Lizenz

Siehe [LICENSE](LICENSE).
