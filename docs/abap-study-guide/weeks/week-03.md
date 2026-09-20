# Week 3 — Open SQL & Field Symbols

This is where you start pulling real data from the SAP database. Open SQL lets you query database tables as if writing SQL, but in ABAP syntax.

> ℹ️ Info: **What you'll build this week** A report that joins two tables (e.g., EKKO/EKPO purchase documents) and outputs a summary list.

## What is Open SQL?

Open SQL is ABAP's standard interface to the database. It's database-independent (works on HANA, DB2, Oracle, ...). The most important command is `SELECT`.

> ⚠️ Common pitfall: **Only SELECT in releases > 7.40** Everything below uses the modern `SELECT ... INTO TABLE @DATA(...)` syntax with inline declaration and `@` for host variables. On older systems you'd write `INTO TABLE lt_table` with pre-declared variables.

## The Basic SELECT

```
SELECT * FROM ekko INTO TABLE @DATA(lt_ekko).
IF sy-subrc EQ 0.
  WRITE: / 'Rows read: ', lines( lt_ekko ).
ENDIF.
```

`*` selects all columns. You can select specific columns instead:

```
SELECT ebeln, bukrs, lifnr
  FROM ekko
  INTO TABLE @DATA(lt_headers).
```

## WHERE — filtering

```
SELECT ebeln, bukrs, lifnr, netwr
  FROM ekko
  WHERE bukrs EQ '1000'
  INTO TABLE @DATA(lt_open).
```

Comparison operators and the `@` escape for host variables:

```
DATA(lv_company) = '1000'.

SELECT ebeln, bukrs, lifnr
  FROM ekko
  WHERE bukrs = @lv_company
    AND bsart IN ('NB', 'RE')
    AND netwr > 1000
  INTO TABLE @DATA(lt_sel).
```

## SELECT SINGLE, UP TO 1 ROWS

```
* Exactly one row expected (best for a key lookup)
SELECT SINGLE ebeln, bukrs
  FROM ekko
  WHERE ebeln = @lv_ebeln
  INTO @DATA(ls_one).

* Limit an arbitrary select
SELECT ebeln, bukrs
  FROM ekko
  UP TO 1 ROWS
  INTO TABLE @DATA(lt_first).
```

## ORDER BY, GROUP BY

```
* Order rows
SELECT bukrs, netwr
  FROM ekko
  ORDER BY bukrs ASCENDING, netwr DESCENDING
  INTO TABLE @DATA(lt_ordered).

* Aggregate: count + sum per company
SELECT bukrs,
       COUNT( * ) AS cnt,
       SUM( netwr ) AS total
  FROM ekko
  GROUP BY bukrs
  INTO TABLE @DATA(lt_totals).
```

## JOINs

Join the header table (EKKO) with its line items (EKPO):

```
SELECT a~ebeln, a~bukrs, b~ebelp, b~matnr, b~menge
  FROM ekko AS a
  INNER JOIN ekpo AS b ON b~ebeln = a~ebeln
  WHERE a~ebeln = @lv_ebeln
  INTO TABLE @DATA(lt_join).
```

> 💡 Tip: **Table aliases (a~, b~)** When columns have the same name in both tables (like `ebeln` ), you must prefix with the alias to avoid ambiguity. Use `FROM ekko AS a` then `a~ebeln` .

## FOR ALL ENTRIES (FAE)

A classic ABAP pattern for selecting data based on a list of keys already in an internal table. Very common in real reports.

```
DATA: BEGIN OF ls_key,
        ebeln TYPE ekko-ebeln,
      END OF ls_key,
      lt_keys LIKE TABLE OF ls_key.

" ... fill lt_keys with business docs ...

IF lt_keys IS NOT INITIAL.
  SELECT ebeln, bukrs, lifnr
    FROM ekko
    FOR ALL ENTRIES IN @lt_keys
    WHERE ebeln = @lt_keys-ebeln
    INTO TABLE @DATA(lt_fae).
ENDIF.
```

> ⚠️ Common pitfall: **FAE best practices** Always check the source table `IS NOT INITIAL` before FAE (empty tables cause an empty result). With a big source table, the generated SQL can be huge — batch large lists. The target table is implicit; you don't select with `SELECT SINGLE` + FAE.

## Field Symbols

A field symbol is a pointer/alias to a memory area — like PHP's `&$var` references but aimed at structured data. Declared with `FIELD-SYMBOLS: <fs> TYPE ...`.

```
FIELD-SYMBOLS <fs_row> TYPE ls_person.

LOOP AT lt_persons ASSIGNING <fs_row>.
  " No copy — <fs_row> points to the actual table row
  <fs_row>-age = <fs_row>-age + 1.
  WRITE: / <fs_row>-name, <fs_row>-age.
ENDLOOP.
```

> 💡 Tip: **ASSIGNING vs INTO** `INTO` copies the row into a work area. `ASSIGNING <fs>` points at the row, so changes to the field symbol update the table directly — faster and avoids copies for large data.

Field symbols also work with `READ TABLE`:

```
READ TABLE lt_persons ASSIGNING <fs_row> WITH KEY name = 'Bob'.
IF sy-subrc EQ 0.
  <fs_row>-age = 27.   " updates the table in place
ENDIF.
```

Always check the field symbol is assigned with `IS ASSIGNED` before use:

```
IF <fs_row> IS ASSIGNED.
  WRITE: / <fs_row>-name.
ENDIF.
```

## Putting It Together — EKKO/EKPO summary

```
REPORT ZPO_SUMMARY.

DATA: BEGIN OF ls_sum,
        ebeln TYPE ekko-ebeln,
        bukrs TYPE ekko-bukrs,
        lifnr TYPE ekko-lifnr,
        netwr TYPE ekpo-netwr,
      END OF ls_sum,
      lt_sum LIKE TABLE OF ls_sum.

SELECT a~ebeln, a~bukrs, a~lifnr, b~netwr
  FROM ekko AS a
  INNER JOIN ekpo AS b ON b~ebeln = a~ebeln
  INTO TABLE @DATA(lt_join).

" Aggregate by document
FIELD-SYMBOLS <fs_join> LIKE LINE OF lt_join.
SORT lt_join BY ebeln.
LOOP AT lt_join ASSIGNING <fs_join>.
  READ TABLE lt_sum ASSIGNING FIELD-SYMBOL(<fs_sum>)
    WITH KEY ebeln = <fs_join>-ebeln.
  IF sy-subrc NE 0.
    ls_sum-ebeln = <fs_join>-ebeln.
    ls_sum-bukrs = <fs_join>-bukrs.
    ls_sum-lifnr = <fs_join>-lifnr.
    ls_sum-netwr = <fs_join>-netwr.
    APPEND ls_sum TO lt_sum.
  ELSE.
    <fs_sum>-netwr = <fs_sum>-netwr + <fs_join>-netwr.
  ENDIF.
ENDLOOP.

LOOP AT lt_sum INTO ls_sum.
  WRITE: / ls_sum-ebeln, ls_sum-bukrs, ls_sum-lifnr, ls_sum-netwr.
ENDLOOP.
```

## Exercises

1. Select all rows from `mara` into an internal table and print the material number.
2. Select materials from `makt` where the description contains a keyword using `LIKE`.
3. Write a JOIN between `ekko` and `ekpo` and print document + line item.
4. Rewrite the JOIN loop: instead of INTO + READ TABLE, use `ASSIGNING` everywhere.
5. Use `FOR ALL ENTRIES` to load `ekpo` based on a list of `ebeln` you built in memory.

> 💡 Tip: **Vocabulary boosters** `SELECT` , `WHERE` , `JOIN` , `ORDER BY` , `GROUP BY` , `UP TO 1 ROWS` , `FOR ALL ENTRIES` , `SELECT SINGLE` , `FIELD-SYMBOLS` , `ASSIGNING` , `IS ASSIGNED` .

← Week 2
Next: Week 4 — Data Dictionary & ALV Basics →
