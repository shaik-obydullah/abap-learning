REPORT z_double_click.

TABLES: sflight.

DATA: lt_flights TYPE TABLE OF sflight,
      ls_flight  TYPE sflight.

PARAMETERS: p_carrid TYPE sflight-carrid DEFAULT 'LH'.

START-OF-SELECTION.
  SELECT carrid connid fldate seatsocc
    FROM sflight
    INTO CORRESPONDING FIELDS OF TABLE lt_flights
    WHERE carrid = p_carrid
    UP TO 20 ROWS.

  LOOP AT lt_flights INTO ls_flight.
    WRITE: / ls_flight-connid,
             ls_flight-fldate,
             ls_flight-seatsocc.
  ENDLOOP.

* Fired when the user clicks or double-clicks any line
AT LINE-SELECTION.
  READ CURRENT LINE INTO DATA(lv_line).
  WRITE: / 'Detail for line:', lv_line.
