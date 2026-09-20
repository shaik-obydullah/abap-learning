REPORT z_hotspot.

DATA: lv_carrid TYPE sflight-carrid.

START-OF-SELECTION.
  SELECT carrid FROM sflight UP TO 5 ROWS
    INTO lv_carrid.
    FORMAT HOTSPOT ON.
    WRITE: / lv_carrid.
    FORMAT HOTSPOT OFF.
  ENDSELECT.

AT LINE-SELECTION.
  WRITE: / 'You clicked on a hotspot!'.
