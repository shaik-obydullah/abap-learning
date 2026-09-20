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
