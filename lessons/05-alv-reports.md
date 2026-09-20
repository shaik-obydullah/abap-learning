# ALV Reports

The most important skill for reports — turn your internal table into a professional, sortable grid.

## What is ALV?

ALV (ABAP List Viewer) turns an internal table into an interactive grid with sorting, filtering, totals, and export — for free.

- Instead of printing rows with `WRITE`, you hand ALV an internal table and it renders a polished grid.
- Users get sort/filter/alphabetize out of the box.
- It's the standard output format for almost all SAP reports.

> 📌 Note: ALV requires a real SAP system — online emulators generally can't run the grid. Read the syntax here; practice later on the SAP CAL sandbox.

## Basic ALV Grid

The minimal call to display data.

**File:** `05-alv-reports/basic_alv.abap`

```
REPORT z_basic_alv.

DATA: lt_flights TYPE TABLE OF sflight.

SELECT * FROM sflight INTO TABLE lt_flights UP TO 50 ROWS.

CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
  EXPORTING
    i_structure_name = 'SFLIGHT'
  TABLES
    t_outtab         = lt_flights.
```

### Key points

- `i_structure_name = 'SFLIGHT'` — tells ALV the structure so it auto-builds the column list.
- `t_outtab = lt_flights` — the internal table containing your data.
- One function call produces the whole interactive grid.

> 💡 Tip: This single call is why ALV is brutal for beginners — but the payoff is a fully functional grid with zero UI code. Earlier version: `REUSE_ALV_LIST_DISPLAY` for a plain list.

## Field Catalog

Take control of which columns show, their titles, and alignment.

**File:** `05-alv-reports/fieldcatalog.abap`

```
REPORT z_fieldcatalog.

TYPES: BEGIN OF ty_out,
         carrid    TYPE sflight-carrid,
         carrname  TYPE scarr-carrname,
         seatsocc  TYPE sflight-seatsocc,
       END OF ty_out.

DATA: lt_out     TYPE TABLE OF ty_out,
      lt_fcat    TYPE lvc_t_fcat,
      ls_fcat    TYPE lvc_s_fcat.

* Build the field catalog manually
CLEAR ls_fcat.
ls_fcat-fieldname = 'CARRID'.
ls_fcat-coltext   = 'Airline Code'.
ls_fcat-outputlen = 10.
APPEND ls_fcat TO lt_fcat.

CLEAR ls_fcat.
ls_fcat-fieldname = 'CARRNAME'.
ls_fcat-coltext   = 'Airline Name'.
ls_fcat-outputlen = 30.
APPEND ls_fcat TO lt_fcat.

CLEAR ls_fcat.
ls_fcat-fieldname = 'SEATSOCC'.
ls_fcat-coltext   = 'Seats Occupied'.
ls_fcat-outputlen = 15.
APPEND ls_fcat TO lt_fcat.

* Fill data (simplified)
CLEAR ls_fcat.

CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
  EXPORTING
    i_structure_name = 'TY_OUT'
    it_fieldcat      = lt_fcat
  TABLES
    t_outtab         = lt_out.
```

### Key points

- `lvc_t_fcat` / `lvc_s_fcat` — the field-catalog table/structure types.
- `fieldname` — which structure field this column maps to.
- `coltext` — the displayed column title.
- `outputlen` — column width.

> ⚠️ Common pitfall: When you pass a field catalog, always keep the `fieldname` values identical to the structure fields, or ALV will display empty columns.

## ALV Events

React to user actions — double-clicks, hot spots, and toolbar buttons.

**File:** `05-alv-reports/events_alv.abap`

```
REPORT z_events_alv.

TYPE-POOLS: slis.

DATA: lt_out  TYPE TABLE OF sflight,
      ls_layo TYPE slis_layout_alv.

* Define a routine to handle user commands
FORM alv_user_command USING rv_ucomm TYPE sy-ucomm
                            rs_selfield TYPE slis_selfield.
  IF rv_ucomm = 'EXPORT'.
    MESSAGE 'Export clicked' TYPE 'I'.
  ENDIF.
ENDFORM.

START-OF-SELECTION.
  SELECT * FROM sflight INTO TABLE lt_out UP TO 20 ROWS.

  ls_layo-zebra = 'X'.
  ls_layo-colwidth_optimize = 'X'.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = sy-repid
      i_callback_user_command = 'ALV_USER_COMMAND'
      is_layout          = ls_layo
    TABLES
      t_outtab           = lt_out.
```

### Key points

- `slis_layout_alv` — the layout structure: `zebra` = striped rows, `colwidth_optimize` = auto width.
- Callbacks let ALV call your `FORM` when a user clicks something.
- `sy-ucomm` carries the function code of the clicked button.

> 💡 Tip: ALV is deeply configurable. Start with zebra striping and column optimization — they instantly make a report look professional.

## Practice & Next Steps

#### Build a flight report

1. Select flights into an internal table with a join for the airline name.
2. Build a field catalog with friendly column titles.
3. Apply zebra striping and optimized column widths.
4. Add a user command callback that shows a message.

> 📌 Note: ALV's structure types (`lvc_t_fcat`, `slis_layout_alv`) won't run in ABAP Dojo — this section is for reading. Commit the syntax to memory and practice on a real system.

> **Next up:** Section 06 — Interactive Reports with hotspots and double-click drill-down.
