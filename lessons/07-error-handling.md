# Error Handling

Handle failures gracefully with TRY/CATCH and user-friendly MESSAGE types instead of crashes.

## Why Handle Errors?

A short dump (crash) frustrates users and loses work. Proper handling keeps your program alive and explains problems clearly.

- **Exceptions** — runtime errors caught by `TRY / CATCH`, like `try/catch` in PHP.
- **Messages** — user-facing notifications with a type (error, warning, success, info).
- Always check `sy-subrc` after operations that can fail (e.g. `SELECT`, `READ TABLE`).

## TRY / CATCH

Wrap risky operations and catch exceptions instead of crashing.

**File:** `07-error-handling/try_catch.abap`

```
REPORT z_try_catch.

DATA: lv_num   TYPE i,
      lv_value TYPE i.

TRY.
    lv_num = 10.
    lv_value = 100 / lv_num.
    WRITE: / 'Result:', lv_value.

    " Force an error to demonstrate exception handling
    lv_value = 100 / 0.

  CATCH cx_sy_zerodivide.
    WRITE: / 'Error: Division by zero caught!'.

  CATCH cx_root.
    WRITE: / 'Unknown error occurred'.
ENDTRY.
```

### Key points

- `TRY ... ENDTRY.` — the protected block.
- `CATCH cx_sy_zerodivide.` — catch a specific exception class.
- `CATCH cx_root.` — catch any exception (the base class, like catching `\Exception` in PHP).
- Order matters: catch specific exceptions before the general `cx_root`.

> ⚠️ Common pitfall: ABAP evaluates `CATCH` blocks top to bottom. Put specific exception classes first, and `cx_root` last, or the general catch will swallow the specific ones.

> 💡 Tip: Common exception classes: `cx_sy_zerodivide` (division by zero), `cx_sy_conversion_error` (bad type conversion), `cx_sy_range_out_of_bounds` (index out of range).

## MESSAGE types

Tell the user what happened with a clearly typed message.

**File:** `07-error-handling/messages.abap`

```
REPORT z_messages.

PARAMETERS: p_amount TYPE p LENGTH 10 DECIMALS 2 OBLIGATORY.

AT SELECTION-SCREEN.
  IF p_amount <= 0.
    MESSAGE 'Amount must be positive' TYPE 'E'.
  ENDIF.

START-OF-SELECTION.
  IF p_amount > 1000000.
    MESSAGE 'Amount is very large' TYPE 'W'.
  ENDIF.

  MESSAGE 'Processing complete' TYPE 'S'.
```

### The MESSAGE types

| Type | Description | Effect |
| --- | --- | --- |
| `E` | Error | Stops execution, shows error |
| `W` | Warning | Shows warning, continues |
| `S` | Success | Shows success message |
| `I` | Information | Shows info popup, continues |
| `A` | Abort | Terminates the program |
| `X` | Exit | Immediately terminates |

- `TYPE 'E'` in a selection screen keeps the user on the screen until they fix the input.
- `TYPE 'W'` and `TYPE 'I'` let processing continue.
- `TYPE 'X'` generates a short dump — use sparingly.

> 📌 Note: In real projects, messages are usually defined in message classes and raised with `MESSAGE e001(...)` — but inline `MESSAGE 'text' TYPE 'E'` works for learning and quick programs.

## Practice & Next Steps

#### Robust calculator

1. Accept two numbers and an operator as parameters.
2. Validate the operator and both numbers on the selection screen (message type E).
3. Wrap the calculation in `TRY` and catch `cx_sy_zerodivide`.
4. Show a success message when done.

> **Next up:** Section 08 — File Handling with upload and download.
