# Database Access with Open SQL

Read live data from SAP tables using SELECT — the bridge between your program and business data.

## Open SQL Essentials

Open SQL lets your ABAP program read (and write) database tables directly. It's your PDO/ORM layer in the SAP world.

- Data goes **into internal tables** (from Section 03) — you rarely work on single rows alone.
- Use the `INTO ...` clause to receive the result.
- Common tables you'll meet: `SCARR` (airlines), `SFLIGHT` (flights), `MARA` (materials).

> 📌 Note: Online emulators (ABAP Dojo) have limited database support. For real `SELECT` you'll eventually want the SAP CAL sandbox, but you can still learn the syntax here.

## SELECT SINGLE

Fetch exactly one row.

**File:** `04-database/select_single.abap`

```
REPORT z_select_single.

TABLES: scarr.

SELECT SINGLE carrid carrname url
  FROM scarr
  INTO (lv_carrid, lv_carrname, lv_url)
  WHERE carrid = 'LH'.

IF sy-subrc = 0.
  WRITE: / 'Airline:', lv_carrname.
  WRITE: / 'URL:', lv_url.
ELSE.
  WRITE: / 'Airline not found'.
ENDIF.
```

### Key points

- `SELECT SINGLE` — expects exactly one row; perfect for reading by primary key.
- `INTO (a, b, c)` — maps selected columns into variables.
- `WHERE carrid = 'LH'` — filter the row (like WHERE in SQL).
- `sy-subrc` — `0` means the row was found; otherwise a non-zero value.

> ⚠️ Common pitfall: Always check `sy-subrc` after a SELECT. Reading from a variable that was never filled because no row matched will give you garbage or a short dump.

## SELECT into a table + LOOP

Fetch many rows into an internal table and process each one.

**File:** `04-database/select_loop.abap`

```
REPORT z_select_loop.

DATA: lt_flights LIKE TABLE OF sflight.

SELECT carrid connid fldate seatsocc
  FROM sflight
  INTO CORRESPONDING FIELDS OF TABLE lt_flights
  UP TO 50 ROWS.

LOOP AT lt_flights INTO DATA(ls_flight).
  WRITE: / ls_flight-carrid,
           ls_flight-connid,
           ls_flight-seatsocc.
ENDLOOP.
```

### Key points

- `INTO CORRESPONDING FIELDS OF TABLE lt_flights` — fills an internal table; matching column names transfer automatically.
- `UP TO 50 ROWS` — caps the result set (important to avoid pulling millions of rows).
- Then `LOOP AT` processes each fetched row.

> 💡 Tip: Prefer fetching into an internal table in one `SELECT` over looping through individual `SELECT SINGLE` calls — far fewer database round-trips and much faster.

## Joins

Combine data from multiple tables in a single query.

**File:** `04-database/joins.abap`

```
REPORT z_joins.

TYPES: BEGIN OF ty_result,
         carrid   TYPE sflight-carrid,
         carrname TYPE scarr-carrname,
         connid   TYPE sflight-connid,
       END OF ty_result.

DATA: lt_result TYPE TABLE OF ty_result.

SELECT s~carrid c~carrname s~connid
  FROM sflight AS s
  INNER JOIN scarr AS c ON c~carrid = s~carrid
  INTO CORRESPONDING FIELDS OF TABLE lt_result
  UP TO 20 ROWS.

LOOP AT lt_result INTO DATA(ls_row).
  WRITE: / ls_row-carrid, ls_row-carrname, ls_row-connid.
ENDLOOP.
```

### Key points

- Table aliases `AS s` / `AS c` keep the query readable.
- The `~` separator accesses fields of an aliased table (`s~carrid`).
- `INNER JOIN ... ON condition` links the two tables.
- Declare a structure type (`TYPES: BEGIN OF ... END OF`) to hold the combined columns.

> 📌 Note: In S/4HANA, the modern alternative is a **CDS View** — a reusable, queryable view object that abstracts joins. You'll build those later.

## Practice & Next Steps

#### Report: active flights per airline

1. Join `SFLIGHT` and `SCARR`.
2. Filter to a specific `carrid` using a `PARAMETERS` field.
3. Count the rows returned and print the airline name + count.

```
REPORT z_flight_count.

PARAMETERS: p_carrid TYPE sflight-carrid OBLIGATORY.

TYPES: BEGIN OF ty_result,
         carrid   TYPE sflight-carrid,
         carrname TYPE scarr-carrname,
       END OF ty_result.

DATA: lt_rows TYPE TABLE OF ty_result,
      lv_count TYPE i.

SELECT s~carrid c~carrname
  FROM sflight AS s
  INNER JOIN scarr AS c ON c~carrid = s~carrid
  WHERE s~carrid = p_carrid
  INTO CORRESPONDING FIELDS OF TABLE lt_rows.

DESCRIBE TABLE lt_rows LINES lv_count.

IF lv_count > 0.
  READ TABLE lt_rows INTO DATA(ls_row) INDEX 1.
  WRITE: / ls_row-carrname, 'has', lv_count, 'flights'.
ELSE.
  WRITE: / 'No flights found for', p_carrid.
ENDIF.
```

> **Next up:** Section 05 — ALV Reports, turning your query output into a polished, sortable grid.
