# 03 Internal Tables

Internal tables are ABAP's equivalent of arrays/lists. They store multiple rows of data in memory.

## declare.abap

```abap
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

### Explanation:
- **`lt_`** prefix = local table (naming convention)
- **`ls_`** prefix = local structure (single row)
- **`TYPE TABLE OF`** = creates an internal table
- **`TYPE i`** = table of integers
- **`TYPE string`** = table of strings
- **`TYPE scarr`** = table based on SCARR structure

### APPEND Statement:
```abap
APPEND 'Airline' TO lt_customers.
```
- Adds a new row to the table
- Like `push()` in JavaScript or `append()` in Python

### LOOP AT ... INTO:
```abap
LOOP AT lt_numbers INTO DATA(lv_number).
  WRITE: / 'Number:', lv_number.
ENDLOOP.
```
- Iterates through each row
- Current row value goes into `lv_number`
- `DATA(lv_number)` declares variable inline (modern ABAP)

---

## read.abap

```abap
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

### Explanation:
- **`READ TABLE ... INDEX`** = access row by position
- Index starts at 1 (not 0 like other languages)
- `INDEX 1` = first row, `INDEX 2` = second row

### READ TABLE Syntax:
```abap
READ TABLE lt_employees INTO lv_employee INDEX 1.
```
- `lt_employees` = source table
- `lv_employee` = target variable (receives the row)
- `INDEX 1` = position to read

### LOOP vs READ TABLE:

| Method | Use When |
|--------|----------|
| `READ TABLE ... INDEX` | You know the exact position |
| `LOOP AT` | You need to process all rows |
| `READ TABLE ... WITH KEY` | You need to find a specific value |

---

## modify.abap

```abap
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

### Explanation:
- **`MODIFY ... FROM ... INDEX`** = update a specific row
- **`DELETE ... INDEX`** = remove a specific row
- Both use INDEX (starts at 1)

### MODIFY Statement:
```abap
MODIFY lt_inventory FROM 'Monitor' INDEX 2.
```
- Replaces row at INDEX 2 with 'Monitor'
- Original value 'Mouse' is overwritten

### DELETE Statement:
```abap
DELETE lt_inventory INDEX 1.
```
- Removes row at INDEX 1
- Table shrinks by one row

---

## Key Concepts:

### 1. Naming Conventions:
| Prefix | Meaning | Example |
|--------|---------|---------|
| `lt_` | Local table | lt_employees |
| `ls_` | Local structure | ls_employee |
| `lv_` | Local variable | lv_name |
| `t_` | Table (old style) | t_numbers |

### 2. Table Types:

```abap
DATA: lt_standard  TYPE TABLE OF string,      " Standard table
      lt_sorted    TYPE SORTED TABLE OF string, " Sorted table
      lt_hashed    TYPE HASHED TABLE OF string.  " Hashed table
```

| Type | Performance | Use Case |
|------|-------------|----------|
| Standard | Slow for large tables | Small tables, unsorted data |
| Sorted | Fast for read/modify | Data that stays sorted |
| Hashed | Fastest for key access | Large tables, frequent key lookup |

### 3. Work Areas vs Inline Declaration:

```abap
" Old style (work area)
DATA: ls_employee TYPE scarr.
LOOP AT lt_customers INTO ls_employee.
  WRITE: / ls_employee-carrname.
ENDLOOP.

" Modern style (inline)
LOOP AT lt_customers INTO DATA(ls_emp).
  WRITE: / ls_emp-carrname.
ENDLOOP.
```

### 4. Common Table Operations:

| Operation | Syntax | Description |
|-----------|--------|-------------|
| Add row | `APPEND row TO lt_table.` | Add to end |
| Read row | `READ TABLE lt_table INTO var INDEX n.` | Read by position |
| Update row | `MODIFY lt_table FROM row INDEX n.` | Replace row |
| Delete row | `DELETE lt_table INDEX n.` | Remove row |
| Count rows | `DESCRIBE TABLE lt_table LINES lv_count.` | Get row count |
| Clear table | `CLEAR lt_table.` | Remove all rows |

### 5. Table Expressions (Modern ABAP):

```abap
" Read row 1
lv_value = lt_table[ 1 ].

" Read with condition
lv_value = lt_table[ field = 'value' ].

" Check if row exists
IF line_exists( lt_table[ field = 'value' ] ).
  WRITE: / 'Found'.
ENDIF.
```

---

## Comparison with Other Languages:

| ABAP | PHP | Python | JavaScript |
|------|-----|--------|------------|
| `APPEND` | `$arr[] =` | `.append()` | `.push()` |
| `LOOP AT` | `foreach` | `for x in` | `for...of` |
| `READ TABLE` | `$arr[0]` | `arr[0]` | `arr[0]` |
| `MODIFY` | `$arr[1] =` | `arr[1] =` | `arr[1] =` |
| `DELETE` | `unset()` | `del` | `.splice()` |

---

## Practice:

1. Create a report that:
   - Declares a table of 5 employee names
   - Loops through and displays each name
   - Modifies the 3rd name
   - Deletes the 1st name
   - Displays the final table

2. Test in ABAP Dojo (https://abapdojo.com)

---

## Next: 04-database
Learn how to read data from SAP database tables using SELECT.
