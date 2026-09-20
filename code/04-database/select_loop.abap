REPORT z_select_loop.

DATA: lt_flights LIKE TABLE OF sflight.

SELECT carrid connid fldate seatsocc
  FROM sflight
  INTO CORRESPONDING FIELDS OF TABLE lt_flights
  UP TO 50 ROWS.

LOOP AT lt_flights INTO DATA(ls_flight).
  WRITE: / ls_flight-carrid,
           ls_flight-connid,
           ls_flight-seatsocc.
ENDLOOP.
