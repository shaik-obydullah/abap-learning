REPORT z_events_alv.

TYPE-POOLS: slis.

DATA: lt_out  TYPE TABLE OF sflight,
      ls_layo TYPE slis_layout_alv.

* Routine to handle user commands from the ALV toolbar
FORM alv_user_command USING rv_ucomm    TYPE sy-ucomm
                            rs_selfield TYPE slis_selfield.
  IF rv_ucomm = 'EXPORT'.
    MESSAGE 'Export clicked' TYPE 'I'.
  ENDIF.
ENDFORM.

START-OF-SELECTION.
  SELECT * FROM sflight INTO TABLE lt_out UP TO 20 ROWS.

  ls_layo-zebra = 'X'.
  ls_layo-colwidth_optimize = 'X'.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program      = sy-repid
      i_callback_user_command = 'ALV_USER_COMMAND'
      is_layout               = ls_layo
    TABLES
      t_outtab                = lt_out.
