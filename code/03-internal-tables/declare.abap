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
