REPORT z_basic_alv.

DATA: lt_flights TYPE TABLE OF sflight.

SELECT * FROM sflight INTO TABLE lt_flights UP TO 50 ROWS.

CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
  EXPORTING
    i_structure_name = 'SFLIGHT'
  TABLES
    t_outtab         = lt_flights.
