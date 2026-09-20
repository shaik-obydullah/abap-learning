REPORT z_fieldcatalog.

TYPES: BEGIN OF ty_out,
         carrid   TYPE sflight-carrid,
         carrname TYPE scarr-carrname,
         seatsocc TYPE sflight-seatsocc,
       END OF ty_out.

DATA: lt_out  TYPE TABLE OF ty_out,
      lt_fcat TYPE lvc_t_fcat,
      ls_fcat TYPE lvc_s_fcat.

* Build the field catalog manually
CLEAR ls_fcat.
ls_fcat-fieldname = 'CARRID'.
ls_fcat-coltext   = 'Airline Code'.
ls_fcat-outputlen = 10.
APPEND ls_fcat TO lt_fcat.

CLEAR ls_fcat.
ls_fcat-fieldname = 'CARRNAME'.
ls_fcat-coltext   = 'Airline Name'.
ls_fcat-outputlen = 30.
APPEND ls_fcat TO lt_fcat.

CLEAR ls_fcat.
ls_fcat-fieldname = 'SEATSOCC'.
ls_fcat-coltext   = 'Seats Occupied'.
ls_fcat-outputlen = 15.
APPEND ls_fcat TO lt_fcat.

* Fill data (simplified for example)
SELECT carrid FROM sflight UP TO 5 ROWS
  INTO CORRESPONDING FIELDS OF TABLE lt_out.

CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
  EXPORTING
    i_structure_name = 'TY_OUT'
    it_fieldcat      = lt_fcat
  TABLES
    t_outtab         = lt_out.
