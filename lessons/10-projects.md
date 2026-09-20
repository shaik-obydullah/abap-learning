# Putting It All Together

Two complete projects that combine everything you've learned — your portfolio pieces.

## The Recipe

Every professional ABAP report follows the same shape. Master this, and you can build almost anything.

1. **Selection screen** — let the user filter (Section 02).
2. **SELECT** the data into an internal table (Sections 03 & 04).
3. **Validate and handle errors** along the way (Section 07).
4. **Display with ALV** for a professional grid (Section 05).

## Project 1 — Employee Report

A classic ABAP exercise: filter, read, and display employee data.

**File:** `10-projects/employee_report.abap`

```
REPORT z_employee_report.

TABLES: pa0001.

TYPES: BEGIN OF ty_emp,
         pernr     TYPE pa0001-pernr,
         ename     TYPE pa0001-ename,
         kostl     TYPE pa0001-kostl,
         begda     TYPE pa0001-begda,
       END OF ty_emp.

DATA: lt_emp   TYPE TABLE OF ty_emp,
      lt_fcat  TYPE lvc_t_fcat,
      ls_fcat  TYPE lvc_s_fcat.

PARAMETERS: p_kostl TYPE pa0001-kostl DEFAULT '1000'.

START-OF-SELECTION.
  SELECT pernr ename kostl begda
    FROM pa0001
    INTO CORRESPONDING FIELDS OF TABLE lt_emp
    WHERE kostl = p_kostl
      AND begda <= sy-datum.

  IF lt_emp IS INITIAL.
    MESSAGE 'No employees found for this cost centre' TYPE 'W'.
    EXIT.
  ENDIF.

  " Build the field catalog for friendly column headers
  CLEAR ls_fcat.
  ls_fcat-fieldname = 'PERNR'.
  ls_fcat-coltext   = 'Personnel No'.
  ls_fcat-outputlen = 12.
  APPEND ls_fcat TO lt_fcat.

  CLEAR ls_fcat.
  ls_fcat-fieldname = 'ENAME'.
  ls_fcat-coltext   = 'Employee Name'.
  ls_fcat-outputlen = 35.
  APPEND ls_fcat TO lt_fcat.

  CLEAR ls_fcat.
  ls_fcat-fieldname = 'KOSTL'.
  ls_fcat-coltext   = 'Cost Centre'.
  ls_fcat-outputlen = 10.
  APPEND ls_fcat TO lt_fcat.

  CLEAR ls_fcat.
  ls_fcat-fieldname = 'BEGDA'.
  ls_fcat-coltext   = 'Start Date'.
  ls_fcat-outputlen = 12.
  APPEND ls_fcat TO lt_fcat.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_structure_name = 'TY_EMP'
      it_fieldcat      = lt_fcat
    TABLES
      t_outtab         = lt_emp.
```

### What it teaches

- Selection parameter `p_kostl` filters the data.
- A `SELECT` with a `WHERE` pulls matching rows.
- An empty-table guard (`IF lt_emp IS INITIAL`) with a warning message.
- A field catalog for clean column headers.
- ALV display for the final grid.

## Project 2 — Sales Analysis

Aggregate sales data with grouping and totals — the kind of report managers actually ask for.

**File:** `10-projects/sales_analysis.abap`

```
REPORT z_sales_analysis.

TABLES: vbak, vbap.

TYPES: BEGIN OF ty_sales,
         vkorg   TYPE vbak-vkorg,   " Sales organization
         auart   TYPE vbak-auart,   " Order type
         sum_val TYPE p DECIMALS 2, " Total value
       END OF ty_sales.

DATA: lt_sales  TYPE TABLE OF ty_sales,
      ls_sales  TYPE ty_sales,
      lv_total  TYPE p DECIMALS 2.

PARAMETERS: p_vkorg TYPE vbak-vkorg DEFAULT '1000'.

START-OF-SELECTION.
  SELECT v~vkorg v~auart SUM( p~netwr ) AS sum_val
    FROM vbak AS v
    INNER JOIN vbap AS p ON p~vbeln = v~vbeln
    INTO CORRESPONDING FIELDS OF TABLE lt_sales
    WHERE v~vkorg = p_vkorg
    GROUP BY v~vkorg v~auart.

  IF lt_sales IS INITIAL.
    MESSAGE 'No sales data found' TYPE 'W'.
    EXIT.
  ENDIF.

  WRITE: / 'Sales analysis for org', p_vkorg.
  ULINE.

  LOOP AT lt_sales INTO ls_sales.
    WRITE: / ls_sales-vkorg,
             ls_sales-auart,
             ls_sales-sum_val.
    lv_total = lv_total + ls_sales-sum_val.
  ENDLOOP.

  ULINE.
  WRITE: / 'Grand total:', lv_total.
```

### What it teaches

- A **JOIN** across header (`VBAK`) and item (`VBAP`) tables.
- Aggregation with `SUM( ... )` and `GROUP BY`.
- Accumulating a running grand total in the loop.
- `ULINE` to draw separator lines for a cleaner list.

> 💡 Tip: For real UX you'd replace the `WRITE` list with an ALV grid and add subtotal columns. But this classic form shows the aggregation logic clearly.

## Make It a Portfolio Piece

These two projects are your ABAP foundation. Polish them.Note: PA0001/VBAK are HR/sales tables not on emulators — adapt them to SCARR/SFLIGHT for ABAP Dojo.

#### Dojo-friendly version

Rewrite Project 1 using `SCARR`/`SFLIGHT` (airline data) so you can actually run and test it in ABAP Dojo.

#### Next challenge

Add a `SELECT-OPTIONS` for dates, a hotspot drill-down, and a CSV download — combining every skill from sections 02–08.

> **You've completed the ABAP learning path.** Combine this with your CAP + AI work (from the main roadmap) and you'll have a genuinely hireable SAP + AI skill set.
