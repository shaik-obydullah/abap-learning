# Week 1 — Syntax, Data Types & Flow Control

Your first week of the ABAP journey. By the end you'll write your first report and a small console-style calculator.

> ℹ️ Info: **What you'll build this week** A "Hello World" report and a small calculator (no screens yet).

## What is ABAP?

ABAP (Advanced Business Application Programming) is SAP's own programming language. Code lives in **reports** (executable programs) that run in the SAP system. ABAP programs are written in the ABAP Editor — transaction `SE38` (classic) or object navigator `SE80`.

The simplest programs are called **executable programs** and start with the statement `REPORT`.

```
REPORT ZHELLO_WORLD.

WRITE: 'Hello, world!'.
```

> 💡 Tip: **Naming convention** Customer/developer objects in SAP start with the letter `Z` or `Y` to keep them separate from SAP-standard objects. Always name your programs starting with `Z` .

## Basic Data Types

ABAP has elementary data types. The most important primitives:

| Type | Meaning | Example |
| --- | --- | --- |
| `I` | Integer (whole number) | `42` |
| `C` | Character string (text) | `'ABAP'` |
| `N` | Numeric text (string that can hold digits) | `'0042'` |
| `D` | Date (YYYYMMDD) | `'20260907'` |
| `T` | Time (HHMMSS) | `'143000'` |
| `P` | Packed number (decimals, for money/quantities) | `123.45` |
| `X` | Hexadecimal / byte string | `'FF'` |
| `STRING` | Variable-length string | `'Any length text'` |

### Declaring data

```
DATA lv_number TYPE i.
DATA lv_name   TYPE string.
DATA lv_price  TYPE p DECIMALS 2.
DATA lv_date   TYPE d.
DATA lv_text(10) TYPE c.

lv_number = 100.
lv_name = 'SAP'.
lv_price = 19.99.
lv_date = sy-datum.
lv_text = 'Hello'.
```

> ℹ️ Info: **Naming prefixes** A common naming convention helps you read code fast: `lv_` — local variable (`lv_number`) `lt_` — internal table (`lt_data`) `ls_` — structure / work area (`ls_row`) `gs_` — global structure, `gt_` — global table `mv_` — class attribute

## System Fields (sy)

ABAP provides built-in system fields you can read. The most common:

| Field | Meaning |
| --- | --- |
| `sy-uname` | Current user name |
| `sy-datum` | Current date |
| `sy-uzeit` | Current time |
| `sy-subrc` | Return code (0 = success) |
| `sy-tabix` | Current line index in a table loop |
| `sy-index` | Loop index of DO/WHILE |

## Arithmetic & Operations

```
DATA lv_a TYPE i VALUE 10.
DATA lv_b TYPE i VALUE 3.
DATA lv_r TYPE i.

lv_r = lv_a + lv_b.   " addition        -> 13
lv_r = lv_a - lv_b.   " subtraction     -> 7
lv_r = lv_a * lv_b.   " multiplication  -> 30
lv_r = lv_a / lv_b.   " division        -> 3 (integer)
lv_r = lv_a MOD lv_b. " remainder       -> 1
lv_r = lv_a ** 2.     " power           -> 100

ADD 1 TO lv_a.        " add shorthand
lv_a += 5.            " add shorthand (modern)
```

> ⚠️ Common pitfall: **Strings are case-sensitive** `'abap'` and `'ABAP'` are different. Use string functions when comparing case-insensitively.

## String Operations

```
DATA lv_s TYPE string.
DATA lv_len TYPE i.

lv_s = 'Hello ABAP'.
lv_len = strlen( lv_s ).          " length -> 10
CONCATENATE 'Hello' ' World' INTO lv_s.     " 'Hello World'
CONDENSE lv_s.                    " remove leading/trailing spaces
lv_s = to_upper( lv_s ).          " 'HELLO WORLD'
lv_s = to_lower( lv_s ).          " 'hello world'
REPLACE 'Hello' IN lv_s WITH 'Hi'.
SEARCH lv_s FOR 'ABAP'.
```

## Flow Control

### IF / ELSEIF / ELSE

```
DATA lv_n TYPE i VALUE 15.

IF lv_n GT 10.
  WRITE: / 'Greater than 10'.
ELSEIF lv_n EQ 10.
  WRITE: / 'Equal to 10'.
ELSE.
  WRITE: / 'Less than 10'.
ENDIF.
```

| Operator | Meaning | Alias |
| --- | --- | --- |
| `EQ` | Equal | `=` |
| `NE` | Not equal | `<>` |
| `GT` | Greater than | `>` |
| `LT` | Less than | `<` |
| `GE` | Greater or equal | `>=` |
| `LE` | Less or equal | `<=` |
| `CS` | Contains string |  |
| `CO` | Contains only |  |
| `IS INITIAL` | Is empty |  |
| `IS NOT INITIAL` | Is not empty |  |

### CASE

```
CASE lv_n.
  WHEN 1.
    WRITE: / 'One'.
  WHEN 2 OR 3.
    WRITE: / 'Two or three'.
  WHEN OTHERS.
    WRITE: / 'Something else'.
ENDCASE.
```

### Loops — DO (finite counting)

```
DATA lv_i TYPE i.
DO 5 TIMES.
  lv_i = sy-index.
  WRITE: / lv_i.
ENDDO.
```

### Loops — WHILE (condition based)

```
DATA lv_c TYPE i VALUE 0.
WHILE lv_c LT 3.
  lv_c = lv_c + 1.
  WRITE: / lv_c.
ENDWHILE.
```

### Loop control: CONTINUE, EXIT, CHECK

```
DO 10 TIMES.
  IF sy-index EQ 3.
    CONTINUE.        " skip iteration 3
  ENDIF.
  IF sy-index EQ 7.
    EXIT.            " stop the loop entirely
  ENDIF.
  WRITE: / sy-index.
ENDDO.
```

## Output: WRITE

```
WRITE: 'Simple text'.
WRITE: / 'On a new line'.
WRITE: 10 'Positioned'.
WRITE: / 'Name: ', lv_name.
ULINE.               " horizontal line
SKIP 2.              " skip 2 blank lines
```

> 💡 Tip: **Slash = new line** The `/` before a value in `WRITE` jumps to the next line. Useful inside loops to print one row per line.

## Comments

```
* This is a full-line comment.

DATA lv_x TYPE i.   " Inline comment after a statement

" Another way to write an inline comment
```

## Putting It Together — Mini Calculator

```
REPORT ZCALCULATOR.

DATA: lv_a TYPE p DECIMALS 2,
      lv_b TYPE p DECIMALS 2,
      lv_op TYPE c,
      lv_r  TYPE p DECIMALS 2.

lv_a = 10.
lv_b = 3.
lv_op = '/'.

CASE lv_op.
  WHEN '+'.
    lv_r = lv_a + lv_b.
  WHEN '-'.
    lv_r = lv_a - lv_b.
  WHEN '*'.
    lv_r = lv_a * lv_b.
  WHEN '/'.
    IF lv_b EQ 0.
      WRITE: / 'Cannot divide by zero'.
    ELSE.
      lv_r = lv_a / lv_b.
    ENDIF.
  WHEN OTHERS.
    WRITE: / 'Unknown operator'.
ENDCASE.

IF lv_b NE 0.
  WRITE: / 'Result = ', lv_r.
ENDIF.
```

## Exercises

1. Write a report that prints your name, today's date, and the current time using system fields.
2. Declare variables of each primitive type (`I`, `C`, `N`, `D`, `T`, `P`) and WRITE each one.
3. Write a loop that prints even numbers from 2 to 20 using `DO` and `sy-index`.
4. Enhance the calculator to compare two numbers and print which is larger.
5. Use `CONCATENATE` to build a greeting "Hello, <username>!" and print it.

> 💡 Tip: **Vocabulary boosters** `ABAP` , `REPORT` , `DATA` , `WRITE` , `TYPE` , `IF/ELSE/ENDIF` , `CASE/ENDCASE` , `DO/ENDDO` , `WHILE/ENDWHILE` , `sy-datum` , `sy-uname` .

Next: Week 2 — Internal Tables →
