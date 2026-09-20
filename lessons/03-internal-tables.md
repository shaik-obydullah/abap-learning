# Internal Tables

The heart of ABAP — in-memory arrays that hold multiple rows, just like PHP arrays but typed.

## What is an Internal Table?

An internal table stores many rows in memory. It's ABAP's equivalent of an array or list.

| ABAP | PHP | Python | JavaScript |
| --- | --- | --- | --- |
| `APPEND row` | `$arr[] =` | `.append()` | `.push()` |
| `LOOP AT` | `foreach` | `for x in` | `for...of` |
| `READ TABLE` | `$arr[0]` | `arr[0]` | `arr[0]` |
| `MODIFY` | `$arr[1] =` | `arr[1] =` | `arr[1] =` |
| `DELETE` | `unset()` | `del` | `.splice()` |

> ⚠️ Common pitfall: ABAP table indexes start at **1** , not 0. `INDEX 1` is the first row.

## Declare & Append

Create the table with `TYPE TABLE OF`, then add rows with `APPEND`.

**File:** `03-internal-tables/declare.abap`

```
REPORT z_internal_tables.

DATA: lt_customers TYPE TABLE OF scarr,
      ls_customer  TYPE scarr,
      lt_numbers   TYPE TABLE OF i,
      lt_flights   TYPE TABLE OF sflight.

APPEND 'Airline' TO lt_customers.
APPEND 100 TO lt_numbers.
APPEND 200 TO lt_numbers.
APPEND 300 TO lt_numbers.

WRITE: / 'Numbers:', lt_numbers.

LOOP AT lt_numbers INTO DATA(lv_number).
  WRITE: / 'Number:', lv_number.
ENDLOOP.
```

### Naming conventions

| Prefix | Meaning | Example |
| --- | --- | --- |
| `lt_` | Local table | lt_employees |
| `ls_` | Local structure (single row) | ls_employee |
| `lv_` | Local variable | lv_name |

- `TYPE TABLE OF scarr` — a table where each row is a `scarr` structure.
- `TYPE TABLE OF i` — a table of integers.
- `APPEND` — adds a row to the end (like PHP's `$arr[]`).
- `LOOP AT ... INTO DATA(x)` — iterate each row; `DATA(x)` declares the variable inline (modern ABAP).

> 💡 Tip: `DATA(lv_number)` inside `LOOP AT ... INTO` is the modern inline declaration — no need to declare the loop variable separately.

## Read & Loop

Access one row by position, or process all rows with a loop.

**File:** `03-internal-tables/read.abap`

```
REPORT z_read_internal_table.

DATA: lt_employees TYPE TABLE OF string,
      lv_employee  TYPE string.

APPEND 'Alice' TO lt_employees.
APPEND 'Bob' TO lt_employees.
APPEND 'Charlie' TO lt_employees.

READ TABLE lt_employees INTO lv_employee INDEX 1.
WRITE: / 'First:', lv_employee.

READ TABLE lt_employees INTO lv_employee INDEX 2.
WRITE: / 'Second:', lv_employee.

LOOP AT lt_employees INTO lv_employee.
  WRITE: / 'Employee:', lv_employee.
ENDLOOP.
```

### READ TABLE syntax

```
READ TABLE lt_employees INTO lv_employee INDEX 1.
```

`lt_employees` = source table · `lv_employee` = target variable · `INDEX 1` = position.

### When to use which

| Method | Use when |
| --- | --- |
| `READ TABLE ... INDEX` | You know the exact position |
| `LOOP AT` | You need to process all rows |
| `READ TABLE ... WITH KEY` | You need to find a specific value |

## Modify & Delete

Update or remove specific rows by index.

**File:** `03-internal-tables/modify.abap`

```
REPORT z_modify_internal_table.

DATA: lt_inventory TYPE TABLE OF string,
      lv_item      TYPE string.

APPEND 'Laptop' TO lt_inventory.
APPEND 'Mouse' TO lt_inventory.
APPEND 'Keyboard' TO lt_inventory.

LOOP AT lt_inventory INTO lv_item.
  WRITE: / 'Before:', lv_item.
ENDLOOP.

MODIFY lt_inventory FROM 'Monitor' INDEX 2.

WRITE: / ''.
WRITE: / 'After modification:'.
LOOP AT lt_inventory INTO lv_item.
  WRITE: / 'Item:', lv_item.
ENDLOOP.

DELETE lt_inventory INDEX 1.

WRITE: / ''.
WRITE: / 'After deletion:'.
LOOP AT lt_inventory INTO lv_item.
  WRITE: / 'Item:', lv_item.
ENDLOOP.
```

- `MODIFY ... FROM ... INDEX n` — replaces the row at position `n` (overwrites the old value).
- `DELETE ... INDEX n` — removes that row; the table shrinks by one.

### Common table operations

| Operation | Syntax |
| --- | --- |
| Add row | `APPEND row TO lt_table.` |
| Read row | `READ TABLE lt_table INTO var INDEX n.` |
| Update row | `MODIFY lt_table FROM row INDEX n.` |
| Delete row | `DELETE lt_table INDEX n.` |
| Count rows | `DESCRIBE TABLE lt_table LINES lv_count.` |
| Clear table | `CLEAR lt_table.` |

### Table types

```
DATA: lt_standard TYPE STANDARD TABLE OF string,
      lt_sorted   TYPE SORTED TABLE OF string,
      lt_hashed   TYPE HASHED TABLE OF string.
```

Use **standard** for small/unsorted data, **sorted** for ordered data, **hashed** for large tables with frequent key lookups.

## Practice & Next Steps

#### Build an employee table manager

1. Declare a table of 5 employee names.
2. Loop through and display each name.
3. Modify the 3rd name.
4. Delete the 1st name.
5. Display the final table.

```
REPORT z_employee_crud.

DATA: lt_names TYPE TABLE OF string,
      lv_name  TYPE string.

APPEND 'Alice' TO lt_names.
APPEND 'Bob' TO lt_names.
APPEND 'Carol' TO lt_names.
APPEND 'Dave' TO lt_names.
APPEND 'Eve' TO lt_names.

LOOP AT lt_names INTO lv_name.
  WRITE: / 'Employee:', lv_name.
ENDLOOP.

MODIFY lt_names FROM 'Carla' INDEX 3.
DELETE lt_names INDEX 1.

WRITE: / ''.
WRITE: / 'Final list:'.
LOOP AT lt_names INTO lv_name.
  WRITE: / lv_name.
ENDLOOP.
```

> **Next up:** Section 04 — Database access with `SELECT` , reading real tables from SAP.
