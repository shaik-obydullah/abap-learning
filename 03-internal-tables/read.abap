REPORT z_read_internal_table.

DATA: lt_employees TYPE TABLE OF string,
      lv_employee  TYPE string.

APPEND 'Alice' TO lt_employees.
APPEND 'Bob' TO lt_employees.
APPEND 'Charlie' TO lt_employees.

READ TABLE lt_employees INTO lv_employee INDEX 1.
WRITE: / 'First:', lv_employee.

READ TABLE lt_employees INTO lv_employee INDEX 2.
WRITE: / 'Second:', lv_employee.

LOOP AT lt_employees INTO lv_employee.
  WRITE: / 'Employee:', lv_employee.
ENDLOOP.
