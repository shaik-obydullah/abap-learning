# 01 ABAP Basics

## hello_world.abap

```abap
REPORT z_hello_world.
WRITE: 'Hello, World!'.
```

### Explanation:
- **`REPORT z_hello_world.`** - Program header (mandatory)
  - `z` prefix = custom program (SAP convention)
  - Names must start with Z or Y for custom objects
  
- **`WRITE: 'Hello, World!'.`** - Output text to screen
  - `WRITE` = display/output statement
  - `:` = chain operator (allows multiple outputs)
  - `' '` = string literal (single quotes)
  - `.` = statement terminator (required)

### Key Points:
1. Every ABAP program starts with `REPORT`
2. `WRITE` is used for output (like `print` in other languages)
3. Statements end with period `.`
4. Single quotes for strings, not double quotes

---

## data_types.abap

```abap
REPORT z_data_types.

DATA: lv_integer   TYPE i,
      lv_decimal   TYPE p LENGTH 8 DECIMALS 2,
      lv_string    TYPE string,
      lv_date      TYPE d,
      lv_time      TYPE t,
      lv_boolean   TYPE abap_bool.
```

### Explanation:
- **`DATA:`** - Declare variables
- **`lv_`** prefix = local variable (naming convention)

### Data Types:

| Type | Description | Example |
|------|-------------|---------|
| `TYPE i` | Integer (whole number) | 100, -50, 0 |
| `TYPE p` | Packed decimal | 123.45 |
| `TYPE string` | Text/string | 'Hello' |
| `TYPE d` | Date | 20260819 |
| `TYPE t` | Time | 143025 |
| `TYPE abap_bool` | Boolean (true/false) | abap_true, abap_false |

### Special Variables:
- **`sy-datum`** = Current system date
- **`sy-uzeit`** = Current system time
- **`abap_true`** = Boolean true

### Output with `/`:
```abap
WRITE: / 'Integer:', lv_integer.
```
- `/` = new line before output

---

## operators.abap

```abap
REPORT z_operators.

DATA: lv_num1     TYPE i,
      lv_num2     TYPE i,
      lv_result   TYPE i.
```

### Arithmetic Operators:

| Operator | Description | Example |
|----------|-------------|---------|
| `+` | Addition | 10 + 3 = 13 |
| `-` | Subtraction | 10 - 3 = 7 |
| `*` | Multiplication | 10 * 3 = 30 |
| `/` | Division | 10 / 3 = 3.33 |
| `MOD` | Modulus (remainder) | 10 MOD 3 = 1 |

### String Operators:

| Operator | Description | Example |
|----------|-------------|---------|
| `&&` | Concatenation | 'Hello' && ' ' && 'World' |

### Comparison Operators:

| Operator | Description |
|----------|-------------|
| `=` | Equal to |
| `<>` | Not equal to |
| `>` | Greater than |
| `<` | Less than |
| `>=` | Greater or equal |
| `<=` | Less or equal |

### IF Statement:
```abap
IF lv_num1 > lv_num2.
  WRITE: / 'Num1 is greater'.
ENDIF.
```
- `IF` = condition check
- `ENDIF.` = end of IF block (mandatory)

---

## Practice Tips:

1. **Naming Conventions:**
   - `lv_` = local variable
   - `z_` or `y_` prefix for custom objects
   - Use descriptive names: `lv_employee_name` not `lv_x`

2. **Code Style:**
   - Indent 2 spaces
   - One statement per line (or chain with `:`)
   - Always end with period `.`

3. **Testing:**
   - Use ABAP Dojo (https://abapdojo.com) to test code
   - Start with simple programs
   - Build complexity gradually
