REPORT z_employee_report.

TABLES: pa0001.

TYPES: BEGIN OF ty_emp,
         pernr TYPE pa0001-pernr,
         ename TYPE pa0001-ename,
         kostl TYPE pa0001-kostl,
         begda TYPE pa0001-begda,
       END OF ty_emp.

DATA: lt_emp  TYPE TABLE OF ty_emp,
      lt_fcat TYPE lvc_t_fcat,
      ls_fcat TYPE lvc_s_fcat.

PARAMETERS: p_kostl TYPE pa0001-kostl DEFAULT '1000'.

START-OF-SELECTION.
  SELECT pernr ename kostl begda
    FROM pa0001
    INTO CORRESPONDING FIELDS OF TABLE lt_emp
    WHERE kostl = p_kostl
      AND begda <= sy-datum.

  IF lt_emp IS INITIAL.
    MESSAGE 'No employees found for this cost centre' TYPE 'W'.
    EXIT.
  ENDIF.

  " Build the field catalog for friendly column headers
  CLEAR ls_fcat.
  ls_fcat-fieldname = 'PERNR'.
  ls_fcat-coltext   = 'Personnel No'.
  ls_fcat-outputlen = 12.
  APPEND ls_fcat TO lt_fcat.

  CLEAR ls_fcat.
  ls_fcat-fieldname = 'ENAME'.
  ls_fcat-coltext   = 'Employee Name'.
  ls_fcat-outputlen = 35.
  APPEND ls_fcat TO lt_fcat.

  CLEAR ls_fcat.
  ls_fcat-fieldname = 'KOSTL'.
  ls_fcat-coltext   = 'Cost Centre'.
  ls_fcat-outputlen = 10.
  APPEND ls_fcat TO lt_fcat.

  CLEAR ls_fcat.
  ls_fcat-fieldname = 'BEGDA'.
  ls_fcat-coltext   = 'Start Date'.
  ls_fcat-outputlen = 12.
  APPEND ls_fcat TO lt_fcat.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_structure_name = 'TY_EMP'
      it_fieldcat      = lt_fcat
    TABLES
      t_outtab         = lt_emp.
