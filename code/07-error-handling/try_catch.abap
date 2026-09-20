REPORT z_try_catch.

DATA: lv_num   TYPE i,
      lv_value TYPE i.

TRY.
    lv_num = 10.
    lv_value = 100 / lv_num.
    WRITE: / 'Result:', lv_value.

    " Force an error to demonstrate exception handling
    lv_num = 0.
    lv_value = 100 / lv_num.

  CATCH cx_sy_zerodivide.
    WRITE: / 'Error: Division by zero caught!'.

  CATCH cx_root.
    WRITE: / 'Unknown error occurred'.
ENDTRY.
