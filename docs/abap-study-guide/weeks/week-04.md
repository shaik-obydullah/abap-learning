# Week 4 — Data Dictionary & ALV Basics

Two big topics this week: how ABAP stores metadata (the Data Dictionary) and how to present data nicely (ALV — ABAP List Viewer).

> ℹ️ Info: **What you'll build this week** An ALV report with sorting, totals, and layout settings.

## The Data Dictionary (SE11)

The ABAP Data Dictionary (`SE11`) stores **metadata** — definitions of tables, structures, data elements, domains, and views. It's central to ABAP: database tables, screen fields, and program structures all pull definitions from here.

### Building blocks

| Object | Purpose | Example |
| --- | --- | --- |
| **Domain** | Lowest level: value range + type + length | `MATNR` (material number, CHAR 18) |
| **Data Element** | Semantic name for a field with F1/F4 help | `MATNR` |
| **Structure** | A collection of fields (no database table) | `MARA`-like structures, BAPI structures |
| **Table** | A database table definition | `MARA`, `EKKO`, `EKPO` |

### Creating a custom table

In `SE11` you create a table, define its fields (choosing a data element per field), set delivery class, set the client field, and activate it. The system creates the matching database table handle for you. Tables with a `CLIENT` field are client-dependent — the default and most common.

```
* A corresponding report can then read the custom table:
SELECT * FROM zmy_table INTO TABLE @DATA(lt_ztable).
IF sy-subrc EQ 0.
  WRITE: / 'Fetched rows: ', lines( lt_ztable ).
ENDIF.
```

> 💡 Tip: **Data element vs domain, in one line** A **domain** sets the technical type/length; a **data element** adds business meaning and text help. One domain can feed many data elements.

## Types & Structures in ABAP

You can reference dictionary types in your programs instead of hard-coding:

```
DATA lv_matnr TYPE mara-matnr.   " type taken from the MARA field
DATA ls_mara  TYPE mara.          " structure matching the table row
DATA lt_mara  TYPE TABLE OF mara. " table of MARA rows
```

## What is ALV?

ALV = ABAP List Viewer. It's SAP's grid/report control — a table with sorting, totals, filtering, and layout. Hand-writing alignment with `WRITE` is painful; professional reports almost always use ALV.

Two main approaches:

- **Classic ALV:** function modules like `REUSE_ALV_GRID_DISPLAY`, or the class `CL_GUI_ALV_GRID`.
- **Modern ALV:** class `CL_SALV_TABLE` (Week 9) — simpler for typical reports.

## Classic ALV with REUSE_ALV_GRID_DISPLAY

You pass an internal table and let the function module render it. For totals, you need a field catalog that marks certain columns as summable.

```
" 1) Build the data
SELECT bukrs, lifnr, netwr
  FROM ekko
  INTO TABLE @DATA(lt_alv).
IF sy-subrc NE 0.
  MESSAGE 'No data found' TYPE 'I'.
  RETURN.
ENDIF.

" 2) Build a field catalog
DATA ls_fcat TYPE lvc_s_fcat.
DATA lt_fcat TYPE lvc_t_fcat.

CLEAR ls_fcat.
ls_fcat-fieldname = 'BUKRS'.
ls_fcat-coltext   = 'Company'.
ls_fcat-outputlen = 10.
APPEND ls_fcat TO lt_fcat.

CLEAR ls_fcat.
ls_fcat-fieldname  = 'LIFNR'.
ls_fcat-coltext    = 'Vendor'.
ls_fcat-outputlen  = 20.
APPEND ls_fcat TO lt_fcat.

CLEAR ls_fcat.
ls_fcat-fieldname  = 'NETWR'.
ls_fcat-coltext    = 'Net Value'.
ls_fcat-do_sum     = 'X'.      " sum this column in the total row
ls_fcat-cfieldname = 'BUKRS'.  " subtotal per company
ls_fcat-outputlen  = 15.
APPEND ls_fcat TO lt_fcat.

" 3) Configure layout
DATA ls_layout TYPE lvc_s_layo.
ls_layout-colwidth_optimize = 'X'.
ls_layout-zebra             = 'X'.

" 4) Display
CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
  EXPORTING
    i_structure_name = 'BUKRS'
    is_layout        = ls_layout
    it_fieldcat      = lt_fcat
  TABLES
    t_outtab         = lt_alv
  EXCEPTIONS
    program_error    = 1.
IF sy-subrc NE 0.
  MESSAGE 'ALV display failed' TYPE 'E'.
ENDIF.
```

> ⚠️ Common pitfall: **Field catalog types** The types `lvc_s_fcat` / `lvc_t_fcat` (line/table of field catalog) and `lvc_s_layo` (layout) come from the `LVC` (List Viewer Control) types. You don't need to memorize fields — autocomplete in SE38/SE80 helps a lot.

## Built-in sorting & totals for the user

ALV gives the end-user sorting, filtering, and totals for free via the ALV toolbar — even without a substantial field catalog. In many reports you only need:

```
* Let ALV auto-build the field catalog from the structure
DATA ls_layout TYPE lvc_s_layo.
ls_layout-colwidth_optimize = 'X'.

CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
  EXPORTING
    i_structure_name = 'EKKO'   " ALV derives columns from EKKO
    is_layout        = ls_layout
  TABLES
    t_outtab         = lt_alv.
```

## About program parameters & selection screen

Most reports begin with a **selection screen** where the user enters criteria before the report runs:

```
REPORT ZALV_SAMPLE.

PARAMETERS: p_bukrs TYPE bukrs DEFAULT '1000'.

SELECT bukrs, lifnr, netwr
  FROM ekko
  WHERE bukrs = @p_bukrs
  INTO TABLE @DATA(lt_alv).

" ... build fcat + layout and display as above ...
```

## Exercises

1. Create a custom table `zstudents` in SE11 with fields student ID, name, and score.
2. Write a report that selects from your custom table and displays it with ALV.
3. Add a field catalog that sums the score column and subtotals by a category.
4. Play with layout: zebra rows, optimized width, and a default sort column.
5. Combine a `PARAMETERS` selection screen with your ALV report.

> 💡 Tip: **Vocabulary boosters** Data Dictionary, `SE11` , domain, data element, structure, table, `PARAMETERS` , selection screen, ALV, `REUSE_ALV_GRID_DISPLAY` , `CL_GUI_ALV_GRID` , field catalog ( `lvc_t_fcat` ), layout ( `lvc_s_layo` ).

← Week 3
Next: Week 5 — ABAP Objects Core →
