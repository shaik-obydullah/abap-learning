# ABAP Basics

Hello World, Data Types, and Operators — your first steps in SAP's programming language.

## Before You Start

If you know PHP, you already understand 80% of ABAP. The goal here is the *syntax and conventions*.

| Concern | PHP | ABAP |
| --- | --- | --- |
| Declaring a variable | `$x = 10;` | `DATA x TYPE i.` |
| Output | `echo $x;` | `WRITE: x.` |
| Statement end | `;` | `.` (period) |
| Strings | `'text'` or `"text"` | `'text'` only |
| If block | `if (...) { }` | `IF ... ENDIF.` |

> 📌 Note: ABAP is case-insensitive and keywords are typed in capitals by convention. Every statement ends with a period `.` — not a semicolon.

> 💡 Tip: Use [ABAP Dojo](https://abapdojo.com) to run every example — it's free, in your browser, no SAP system needed.

## Hello World

Every ABAP program starts with a `REPORT` header and uses `WRITE` for output.

**File:** `01-basics/hello_world.abap`

```
* REPORT is the mandatory header of a standalone program
REPORT z_hello_world.

* WRITE prints text to the output screen
WRITE: 'Hello, World!'.
```

### Line by line

- `REPORT z_hello_world.` — Program header. The `z` prefix is **mandatory** for custom objects in SAP. Names must start with `Z` or `Y`.
- `WRITE: 'Hello, World!'.` — Outputs text. The `:` is a **chain operator** that lets you write multiple outputs on one statement.
- `'...'` — strings use **single quotes**, never double quotes.
- `.` — every statement ends with a period.

| Keyword | Meaning (PHP equivalent) |
| --- | --- |
| `REPORT` | Program declaration header |
| `WRITE` | `echo` / `print` |
| `:` | Chain operator (multiple statements on one line) |
| `.` | Statement terminator (like `;`) |

> ⚠️ Common pitfall: Do not write `WRITE: "Hello"` with double quotes — ABAP only accepts single-quoted strings.

## Data Types

Declare variables with `DATA` and a `TYPE`. The `lv_` prefix means "local variable".

**File:** `01-basics/data_types.abap`

```
REPORT z_data_types.

DATA: lv_integer   TYPE i,
      lv_decimal   TYPE p LENGTH 8 DECIMALS 2,
      lv_string    TYPE string,
      lv_date      TYPE d,
      lv_time      TYPE t,
      lv_boolean   TYPE abap_bool.

lv_integer = 100.
lv_decimal = '123.45'.
lv_string = 'ABAP Programming'.
lv_date = sy-datum.
lv_time = sy-uzeit.
lv_boolean = abap_true.

WRITE: / 'Integer:', lv_integer.
WRITE: / 'Decimal:', lv_decimal.
WRITE: / 'String:', lv_string.
WRITE: / 'Date:', lv_date.
WRITE: / 'Time:', lv_time.
WRITE: / 'Boolean:', lv_boolean.
```

`/` inside `WRITE` starts a new line before the output.

| Type | Description | Example | PHP equivalent |
| --- | --- | --- | --- |
| `TYPE i` | Integer (whole number) | 100, -50, 0 | `int` |
| `TYPE p` | Packed decimal (money) | 123.45 | `float` |
| `TYPE string` | Text/string | 'Hello' | `string` |
| `TYPE d` | Date (YYYYMMDD) | 20260819 | `DateTime` |
| `TYPE t` | Time (HHMMSS) | 143025 | `DateTime` |
| `TYPE abap_bool` | Boolean | abap_true / abap_false | `bool` |

### Built-in system variables

- `sy-datum` — current system date
- `sy-uzeit` — current system time
- `abap_true` / `abap_false` — boolean constants

> 💡 Tip: Use `DECIMALS 2` for all money values. Floating point imprecision in money is a serious business-logic bug.

## Operators & Logic

Same math you know, with a few ABAP-specific quirks.

**File:** `01-basics/operators.abap`

```
REPORT z_operators.

DATA: lv_num1     TYPE i,
      lv_num2     TYPE i,
      lv_result   TYPE i,
      lv_string1  TYPE string,
      lv_string2  TYPE string,
      lv_concat   TYPE string.

lv_num1 = 10.
lv_num2 = 3.

lv_result = lv_num1 + lv_num2.
WRITE: / 'Addition:', lv_result.

lv_result = lv_num1 - lv_num2.
WRITE: / 'Subtraction:', lv_result.

lv_result = lv_num1 * lv_num2.
WRITE: / 'Multiplication:', lv_result.

lv_result = lv_num1 / lv_num2.
WRITE: / 'Division:', lv_result.

lv_result = lv_num1 MOD lv_num2.
WRITE: / 'Modulus:', lv_result.

lv_string1 = 'Hello'.
lv_string2 = 'World'.
lv_concat = lv_string1 && ' ' && lv_string2.
WRITE: / 'Concatenation:', lv_concat.

IF lv_num1 > lv_num2.
  WRITE: / 'Num1 is greater'.
ENDIF.

IF lv_num1 = lv_num2.
  WRITE: / 'Numbers are equal'.
ELSE.
  WRITE: / 'Numbers are not equal'.
ENDIF.
```

### Arithmetic operators

| Operator | Description | Example |
| --- | --- | --- |
| `+` | Addition | 10 + 3 = 13 |
| `-` | Subtraction | 10 - 3 = 7 |
| `*` | Multiplication | 10 * 3 = 30 |
| `/` | Division | 10 / 3 = 3.33 |
| `MOD` | Modulus (remainder) | 10 MOD 3 = 1 |

### String operator

- `&&` — concatenation: `'Hello' && ' ' && 'World'` → `Hello World`. (In PHP you'd use `.`.)

### Comparison operators

| Operator | Meaning | PHP equivalent |
| --- | --- | --- |
| `=` | Equal to | `==` |
| `<>` | Not equal to | `!=` |
| `>` | Greater than | `>` |
| `<` | Less than | `<` |
| `>=` | Greater or equal | `>=` |
| `<=` | Less or equal | `<=` |

### IF / ELSE

```
IF lv_num1 > lv_num2.
  WRITE: / 'Num1 is greater'.
ELSE.
  WRITE: / 'Num1 is not greater'.
ENDIF.
```

- `IF ...` ends with `ENDIF.` (mandatory) — there's no `}`.
- Optional `ELSE.` for the fallback branch.

> ⚠️ Common pitfall: Every `IF` must have a matching `ENDIF.` Many beginner bugs come from a forgotten `ENDIF` . Indent by 2 spaces to keep blocks readable.

## Practice & Next Steps

Try these in [ABAP Dojo](https://abapdojo.com) before moving on.

#### Exercise 1 — Your profile card

1. Create a report called `z_my_profile`.
2. Declare variables: name (string), age (integer), salary (packed decimal, 2 decimals).
3. Assign values to each.
4. Print them each on a new line with `WRITE: /`.

```
REPORT z_my_profile.

DATA: lv_name   TYPE string,
      lv_age    TYPE i,
      lv_salary TYPE p LENGTH 8 DECIMALS 2.

lv_name = 'Anwar'.
lv_age = 30.
lv_salary = '55000.00'.

WRITE: / 'Name:', lv_name.
WRITE: / 'Age:', lv_age.
WRITE: / 'Salary:', lv_salary.
```

#### Exercise 2 — Arithmetic logic

1. Declare two integers `lv_a = 7` and `lv_b = 2`.
2. Compute and print their sum, difference, product, and modulus.
3. Use `IF` to print whether `lv_a` is odd or even (hint: `lv_a MOD 2 = 0` means even).
4. Concatenate `lv_a` and `lv_b` into a string with `&&` and print it.

```
REPORT z_arithmetic.

DATA: lv_a TYPE i VALUE 7,
      lv_b TYPE i VALUE 2,
      lv_c TYPE string.

WRITE: / 'Sum:', lv_a + lv_b.
WRITE: / 'Diff:', lv_a - lv_b.
WRITE: / 'Prod:', lv_a * lv_b.
WRITE: / 'Mod:', lv_a MOD lv_b.

IF lv_a MOD 2 = 0.
  WRITE: / 'lv_a is even'.
ELSE.
  WRITE: / 'lv_a is odd'.
ENDIF.

lv_c = lv_a && ' and ' && lv_b.
WRITE: / lv_c.
```

### Key takeaways to remember

- Custom object names start with **Z** or **Y**.
- `REPORT` opens a program; statements end with **.**
- Strings use **single quotes**; concatenate with `&&`.
- `IF ... ENDIF.` — don't forget the `ENDIF`.
- Keep `DATA` declarations together at the top.

> **Next up:** Section 02 — Selection Screens ( `PARAMETERS` , `SELECT-OPTIONS` ), where programs start accepting user input.
