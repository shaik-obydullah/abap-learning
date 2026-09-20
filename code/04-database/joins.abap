REPORT z_joins.

TYPES: BEGIN OF ty_result,
         carrid   TYPE sflight-carrid,
         carrname TYPE scarr-carrname,
         connid   TYPE sflight-connid,
       END OF ty_result.

DATA: lt_result TYPE TABLE OF ty_result.

SELECT s~carrid c~carrname s~connid
  FROM sflight AS s
  INNER JOIN scarr AS c ON c~carrid = s~carrid
  INTO CORRESPONDING FIELDS OF TABLE lt_result
  UP TO 20 ROWS.

LOOP AT lt_result INTO DATA(ls_row).
  WRITE: / ls_row-carrid, ls_row-carrname, ls_row-connid.
ENDLOOP.
