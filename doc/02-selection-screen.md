# 02 Selection Screen

Selection screens are input forms that appear before the program runs. Users fill in values, then the program processes them.

## parameters.abap

```abap
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

### Explanation:
- **`PARAMETERS:`** - Create input fields on selection screen
- **`p_`** prefix = parameter (naming convention)
- Each parameter creates one input field

### Parameter Types:

| Type | Description | Input Example |
|------|-------------|---------------|
| `TYPE string` | Text input | John Doe |
| `TYPE i` | Integer input | 25 |
| `TYPE d` | Date input | 20260819 |
| `TYPE p` | Decimal input | 1234.56 |
| `TYPE c` | Character (fixed length) | ABC |

### How it Works:
1. Program starts
2. Selection screen appears
3. User fills in values
4. User clicks Execute (F8)
5. Program runs with user values

---

## select-options.abap

```abap
REPORT z_select_options.

TABLES: mara.

SELECT-OPTIONS: s_matnr FOR mara-matnr,
                s_ersda FOR mara-ersda,
                s_mtart FOR mara-mtart.
```

### Explanation:
- **`SELECT-OPTIONS:`** - Create range inputs (from/to)
- **`TABLES:`** - Reference database table structure
- **`s_`** prefix = select-option (naming convention)
- **`FOR mara-matnr`** - Links to table field

### Parameters vs Select-Options:

| Feature | PARAMETERS | SELECT-OPTIONS |
|---------|------------|----------------|
| Input | Single value | Range (from/to) |
| Screen | One field | Two fields |
| Use | Simple input | Date ranges, lists |
| Prefix | `p_` | `s_` |

### Select-Option Benefits:
- Users can enter: single value, range, multiple ranges
- Example: Date from 20260101 to 20261231
- Example: Material numbers A001 to A100

---

## events.abap

```abap
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

### Explanation:
- **`INITIALIZATION.`** - Event before screen appears (set defaults)
- **`AT SELECTION-SCREEN.`** - Event when user clicks Execute (validation)
- **`START-OF-SELECTION.`** - Event to start processing (main logic)

### Event Order:
1. `INITIALIZATION` - Set default values
2. Selection screen appears
3. `AT SELECTION-SCREEN` - Validate input
4. `START-OF-SELECTION` - Process data

### MESSAGE Types:

| Type | Description | Effect |
|------|-------------|--------|
| `E` | Error | Stops execution, shows error |
| `S` | Success | Shows success message |
| `W` | Warning | Shows warning, continues |
| `I` | Information | Shows info, continues |

### Validation Example:
```abap
AT SELECTION-SCREEN.
  IF p_name IS INITIAL.
    MESSAGE 'Name is required' TYPE 'E'.
  ENDIF.
```
- `IS INITIAL` = checks if field is empty
- `TYPE 'E'` = error message
- Program stops, user must fix input

---

## Key Concepts:

### 1. Selection Screen Flow:
```
User runs program
       ↓
INITIALIZATION (set defaults)
       ↓
Selection Screen appears
       ↓
User fills in values
       ↓
User clicks Execute (F8)
       ↓
AT SELECTION-SCREEN (validate)
       ↓
If valid → START-OF-SELECTION (process)
If invalid → Show error, stay on screen
```

### 2. Naming Conventions:
- `p_` = parameter
- `s_` = select-option
- `t_` = table
- `v_` = variable
- `c_` = constant

### 3. Common Attributes:
```abap
PARAMETERS: p_name TYPE string OBLIGATORY,
            p_date TYPE d DEFAULT sy-datum.
```
- `OBLIGATORY` = required field
- `DEFAULT` = initial value

---

## Practice:

1. Create a report with:
   - Employee name (parameter)
   - Hire date (select-option)
   - Department (parameter)

2. Add validation:
   - Name cannot be empty
   - Hire date must be in the past

3. Test in ABAP Dojo

---

## Next: 03-internal-tables
Internal tables store multiple rows of data (like arrays in other languages).
