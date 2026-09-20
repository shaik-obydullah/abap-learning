* The DEFINITION declares the class "contract"
CLASS zcl_calculator DEFINITION.
  PUBLIC SECTION.
    METHODS add IMPORTING iv_a TYPE i
                           iv_b TYPE i
                 RETURNING VALUE(rv_result) TYPE i.
    METHODS subtract IMPORTING iv_a TYPE i
                               iv_b TYPE i
                     RETURNING VALUE(rv_result) TYPE i.
ENDCLASS.

* The IMPLEMENTATION holds the actual code
CLASS zcl_calculator IMPLEMENTATION.
  METHOD add.
    rv_result = iv_a + iv_b.
  ENDMETHOD.
  METHOD subtract.
    rv_result = iv_a - iv_b.
  ENDMETHOD.
ENDCLASS.

* Using the class
START-OF-SELECTION.
  DATA: lo_calc TYPE REF TO zcl_calculator,
        lv_sum  TYPE i.

  CREATE OBJECT lo_calc.
  lv_sum = lo_calc->add( iv_a = 10 iv_b = 5 ).
  WRITE: / 'Sum:', lv_sum.
