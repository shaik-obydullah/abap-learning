# Week 2 — Internal Tables

The ABAP bread-and-butter. If you only deeply learn one data structure, make it the internal table. If you come from Laravel, think of them as Laravel **collections**.

> ℹ️ Info: **What you'll build this week** A report that loads data, then filters and aggregates it using internal tables.

## What is an Internal Table?

An internal table is a runtime, in-memory table. Its rows (lines) all have the same structure — usually a **structure** or ABAP Dictionary table type. It's the main structure for processing data in ABAP, the way you'd use collections/arrays in PHP or JavaScript.

Every internal table operation happens in three typical steps:

1. Declare the table.
2. Fill it (APPEND / INSERT).
3. Read it back (LOOP AT / READ TABLE).

## Declaring an Internal Table

The classic way is to declare a **work area** (structure) plus a **table** of that structure:

```
DATA: BEGIN OF ls_person,
        name TYPE string,
        age  TYPE i,
      END OF ls_person.

DATA lt_persons TYPE TABLE OF ls_person.
```

A more common and concise approach uses `TYPE STANDARD TABLE OF` with an inline structure:

```
DATA: BEGIN OF ls_person,
        name TYPE string,
        age  TYPE i,
      END OF ls_person,
      lt_persons LIKE STANDARD TABLE OF ls_person.
```

> ℹ️ Info: **Modern inline declarations** ABAP allows inline declarations — the type is inferred from the right-hand side: `SELECT name, age FROM persons INTO TABLE @DATA(lt_persons).` Here `@DATA(lt_persons)` declares the table automatically.

## Standard vs Sorted vs Hashed Tables

| Type | Key | Best for | Note |
| --- | --- | --- | --- |
| **STANDARD** | Optional (non-unique by default) | Anything; order = insertion order | Slow random access by key; no automatic sort |
| **SORTED** | Required; rows auto-sorted | Reads by key, range searches, binary search | Keep key small; insert is a bit slower |
| **HASHED** | Required; must be UNIQUE | Very fast single-row lookup by key | No sorting; no range access; no index |

```
* Standard table (default)
DATA lt_std TYPE STANDARD TABLE OF ls_person.

* Sorted table
DATA lt_srt TYPE SORTED TABLE OF ls_person WITH UNIQUE KEY name.

* Hashed table
DATA lt_hsh TYPE HASHED TABLE OF ls_person WITH UNIQUE KEY name.
```

> 💡 Tip: **Rule of thumb** Start with **STANDARD** . Move to **SORTED** or **HASHED** only when you need fast key-based reads and the key is known up front.

## Filling a Table — APPEND, INSERT, MOVE

```
ls_person-name = 'Alice'.  ls_person-age = 30.
APPEND ls_person TO lt_persons.

ls_person-name = 'Bob'.    ls_person-age = 25.
APPEND ls_person TO lt_persons.

* INSERT adds at a specific index (or sorted position for sorted tables)
INSERT ls_person INTO lt_persons INDEX 1.

* CLEAR resets the work area before reusing it
CLEAR ls_person.
MOVE 'Carol' TO ls_person-name.
ls_person-age = 28.
APPEND ls_person TO lt_persons.
```

> ⚠️ Common pitfall: **Always CLEAR the work area** After `APPEND` , the work area still holds the old data. Clear it (or reassign every field) before filling again, or you'll duplicate values.

## Reading a Table

### LOOP AT — read every row

```
LOOP AT lt_persons INTO ls_person.
  WRITE: / ls_person-name, ls_person-age.
ENDLOOP.
```

### READ TABLE — read one specific row

```
READ TABLE lt_persons INTO ls_person WITH KEY name = 'Bob'.
IF sy-subrc EQ 0.
  WRITE: / 'Found: ', ls_person-name, ls_person-age.
ELSE.
  WRITE: / 'Not found'.
ENDIF.
```

> 💡 Tip: **Always check sy-subrc** After `READ TABLE` , `sy-subrc = 0` means found; anything else means the row doesn't exist. Check it before using the work area.

### Assigning instead of copying

For large data, avoid copying with `INTO`; instead use a **field symbol** or a table line reference. You'll meet field symbols in Week 3.

## MODIFY — change existing rows

```
ls_person-name = 'Bob'.
ls_person-age = 26.
MODIFY lt_persons FROM ls_person INDEX 2.
```

## DELETE — remove rows

```
* Delete by index
DELETE lt_persons INDEX 1.

* Delete current row inside a loop
LOOP AT lt_persons INTO ls_person.
  IF ls_person-age LT 18.
    DELETE lt_persons.
  ENDIF.
ENDLOOP.

* Delete all
CLEAR lt_persons.
```

## SORT, DESCRIBE, lines( )

```
* Sort ascending by name
SORT lt_persons BY name.

* Sort descending by age
SORT lt_persons BY age DESCENDING.

* Count rows
DATA lv_count TYPE i.
lv_count = lines( lt_persons ).
WRITE: / 'Total rows: ', lv_count.

* Number of rows also available via DESCRIBE
DESCRIBE TABLE lt_persons LINES lv_count.
```

> 💡 Tip: **lines( ) is your friend** `lines( lt_table )` returns the number of rows — works everywhere and is the modern way to count.

## Filtering & Aggregating (the Laravel-collection way)

```
* Filter + count adults
DATA lv_adults TYPE i.
lv_adults = 0.
LOOP AT lt_persons INTO ls_person.
  IF ls_person-age GE 18.
    lv_adults = lv_adults + 1.
  ENDIF.
ENDLOOP.

* Sum of ages
DATA lv_sum TYPE i.
LOOP AT lt_persons INTO ls_person.
  ADD ls_person-age TO lv_sum.
ENDLOOP.
```

This pattern — loop, check a condition, accumulate — is the everyday heart of ABAP report code.

## Internal Table of a Dictionary Type

Most real code works with tables whose row type is a database table or structure defined in `SE11` (Week 4). For example:

```
DATA lt_ekko TYPE TABLE OF ekko.   " EKKO = header table of purchase orders
```

## Exercises

1. Declare a structure with `product` (string) and `price` (P). Fill a standard table with 5 rows.
2. Loop the table and print all products over a given price.
3. Sort by price descending and `READ TABLE` to find the cheapest product by name.
4. Count how many products have prices above 100 using `lines( )` and filtering.
5. Build an internal table of type `TYPE TABLE OF ekko` and fill/loop it (even with empty data, the syntax should compile).

> 💡 Tip: **Vocabulary boosters** `TYPE TABLE OF` , `APPEND` , `INSERT` , `READ TABLE` , `MODIFY` , `DELETE` , `LOOP AT ... ENDLOOP` , `SORT` , `lines( )` , `sy-subrc` , `WITH KEY` , work area.

← Week 1
Next: Week 3 — Open SQL & Field Symbols →
