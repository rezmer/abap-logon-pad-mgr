"! <p class="shorttext synchronized" lang="en">Logon Pad Landscape Manager — Konstanten</p>
"!
"! Zentrale Konstanten für alle ZSLM_*-Klassen.
"! Service-Typen, Audit-Aktionen, Limits, Generator-String.
INTERFACE zif_slm_constants
  PUBLIC.

  " Maximale Anzahl Versionen, die in der Historie behalten werden.
  " Beim Erzeugen einer neuen Version wird die älteste automatisch entfernt.
  CONSTANTS max_versions TYPE i VALUE 10.

  " Service-Typen
  CONSTANTS:
    BEGIN OF service_type,
      sapgui TYPE c LENGTH 6 VALUE 'SAPGUI',
      nwbc   TYPE c LENGTH 6 VALUE 'NWBC',
    END OF service_type.

  " Audit-Aktionen
  CONSTANTS:
    BEGIN OF action,
      add    TYPE c LENGTH 6 VALUE 'add',
      edit   TYPE c LENGTH 6 VALUE 'edit',
      delete TYPE c LENGTH 6 VALUE 'delete',
      init   TYPE c LENGTH 6 VALUE 'init',
    END OF action.

  " Audit-Entitäten
  CONSTANTS:
    BEGIN OF entity,
      service       TYPE string VALUE 'Service',
      messageserver TYPE string VALUE 'Messageserver',
      workspace     TYPE string VALUE 'Workspace',
      include       TYPE string VALUE 'Include',
      system        TYPE string VALUE 'System',
    END OF entity.

  " Auth-Object-Bereiche (Z_SLM ZSLM_AREA)
  CONSTANTS:
    BEGIN OF area,
      service       TYPE c LENGTH 3 VALUE 'SVC',
      messageserver TYPE c LENGTH 3 VALUE 'MSG',
      version       TYPE c LENGTH 3 VALUE 'VER',
      publish       TYPE c LENGTH 3 VALUE 'PUB',
    END OF area.

  " Generator-String, der in jede generierte SAPUILandscape.xml geschrieben wird
  CONSTANTS generator_string TYPE string VALUE 'SAP Logon Pad Landscape Manager — ABAP Edition v1.0'.

  " HTTP-Cache-Lifetime in Sekunden für die ausgelieferte XML
  CONSTANTS cache_max_age TYPE i VALUE 300.

ENDINTERFACE.
