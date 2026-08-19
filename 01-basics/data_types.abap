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
