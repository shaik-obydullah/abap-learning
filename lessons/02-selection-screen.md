# Selection Screens

Input forms that appear before your program runs — collect user input, validate it, then process.

## The Selection Screen Flow

A selection screen is SAP's input form. The program shows it, waits for the user, validates, then runs.

User runs program
↓
INITIALIZATION (set default values)
↓
Selection screen appears → user fills in values → clicks Execute (F8)
↓
AT SELECTION-SCREEN (validate input)
↓
If valid → START-OF-SELECTION (process data)
If invalid → show error, stay on the screen
> 📌 Note: `PARAMETERS` gives single-value fields; `SELECT-OPTIONS` gives from/to ranges. Both appear on the screen before the main body runs.

## Parameters

Simple single-value input fields.

**File:** `02-selection-screen/parameters.abap`

```
REPORT z_parameters.

PARAMETERS: p_name   TYPE string,
            p_age    TYPE i,
            p_date   TYPE d,
            p_amount TYPE p LENGTH 10 DECIMALS 2.

WRITE: / 'Name:', p_name.
WRITE: / 'Age:', p_age.
WRITE: / 'Date:', p_date.
WRITE: / 'Amount:', p_amount.
```

### How it works

1. Program starts.
2. Selection screen appears with one field per parameter.
3. User fills in values and presses Execute (`F8`).
4. Program runs, and each `p_` variable holds the user's input.

| Type | Input example |
| --- | --- |
| `TYPE string` | John Doe |
| `TYPE i` | 25 |
| `TYPE d` | 20260819 |
| `TYPE p` | 1234.56 |
| `TYPE c` | ABC (fixed length) |

> 💡 Tip: The `p_` prefix signals a parameter. Keep that convention — SAP programmers read it instantly.

> ⚠️ Common pitfall: Never trust user input. Validate it in `AT SELECTION-SCREEN` (next lesson).

## Select-Options

Range inputs (from/to) — perfect for date ranges, lists, and filtering database tables.

**File:** `02-selection-screen/select-options.abap`

```
REPORT z_select_options.

TABLES: mara.

SELECT-OPTIONS: s_matnr FOR mara-matnr,
                s_ersda FOR mara-ersda,
                s_mtart FOR mara-mtart.

WRITE: / 'Material Number:', s_matnr-low.
WRITE: / 'Created Date:', s_ersda-low.
WRITE: / 'Material Type:', s_mtart-low.
```

### Parameter vs Select-Option

| Feature | PARAMETERS | SELECT-OPTIONS |
| --- | --- | --- |
| Input | Single value | Range (from/to) |
| Screen | One field | Two fields + option |
| Use case | Simple input | Date ranges, lists |
| Prefix | `p_` | `s_` |

- `TABLES: mara.` — references the database table structure so you can link fields to it.
- `FOR mara-matnr` — binds the select-option to a table field.
- Each select-option internally has `-low` (from) and `-high` (to) values.

> 💡 Tip: Select-options accept a single value, a range, or even multiple ranges — far more flexible than a single `PARAMETERS` field.

## Events & Validation

Control the lifecycle: set defaults, validate, then process.

**File:** `02-selection-screen/events.abap`

```
REPORT z_selection_events.

PARAMETERS: p_name TYPE string,
            p_age  TYPE i.

INITIALIZATION.
  p_name = 'John Doe'.
  p_age = 25.

AT SELECTION-SCREEN.
  IF p_name IS INITIAL.
    MESSAGE 'Name is required' TYPE 'E'.
  ENDIF.

  IF p_age < 18.
    MESSAGE 'Age must be 18 or older' TYPE 'E'.
  ENDIF.

START-OF-SELECTION.
  WRITE: / 'Name:', p_name.
  WRITE: / 'Age:', p_age.
  WRITE: / 'Status: Valid'.
```

### The three key events

| Event | When it runs | Typical use |
| --- | --- | --- |
| `INITIALIZATION.` | Before the screen appears | Set default values |
| `AT SELECTION-SCREEN.` | When user clicks Execute | Validate input |
| `START-OF-SELECTION.` | After validation passes | Main logic |

### MESSAGE types

| Type | Description | Effect |
| --- | --- | --- |
| `E` | Error | Stops execution, shows error |
| `S` | Success | Shows success message |
| `W` | Warning | Shows warning, continues |
| `I` | Information | Shows info, continues |

- `IS INITIAL` checks if a field is empty.
- A `TYPE 'E'` message stops the program and keeps the user on the screen until fixed.

### Common attributes

```
PARAMETERS: p_name TYPE string OBLIGATORY,
            p_date TYPE d DEFAULT sy-datum.
```

`OBLIGATORY` = required field · `DEFAULT sy-datum` = pre-fill with today's date.

## Practice & Next Steps

Test in [ABAP Dojo](https://abapdojo.com).

#### Build an employee screen

1. Create parameters: employee name (string, obligatory), department (string), hire year (integer).
2. Add a select-option for hire date `s_hdate`.
3. Validate: name not empty; hire date must be in the past.
4. Print all inputs in `START-OF-SELECTION`.

```
REPORT z_employee_screen.

PARAMETERS: p_name TYPE string OBLIGATORY,
            p_dept TYPE string,
            p_year TYPE i.
SELECT-OPTIONS: s_hdate FOR sy-datum.

AT SELECTION-SCREEN.
  IF p_name IS INITIAL.
    MESSAGE 'Name cannot be empty' TYPE 'E'.
  ENDIF.
  IF s_hdate-high > sy-datum.
    MESSAGE 'Hire date must be in the past' TYPE 'E'.
  ENDIF.

START-OF-SELECTION.
  WRITE: / 'Employee:', p_name.
  WRITE: / 'Department:', p_dept.
  WRITE: / 'Hired:', s_hdate-low.
```

> **Next up:** Section 03 — Internal Tables, ABAP's arrays for storing multiple rows of data.
