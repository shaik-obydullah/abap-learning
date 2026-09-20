REPORT z_upload.

TYPES: BEGIN OF ty_data,
         field1 TYPE c LENGTH 20,
         field2 TYPE c LENGTH 20,
       END OF ty_data.

DATA: lt_data     TYPE TABLE OF ty_data,
      lv_filename TYPE string.

CALL FUNCTION 'GUI_UPLOAD'
  EXPORTING
    filename                = lv_filename
  TABLES
    data_tab                = lt_data
  EXCEPTIONS
    file_open_error         = 1
    file_read_error         = 2
    OTHERS                  = 3.

IF sy-subrc = 0.
  WRITE: / 'File uploaded successfully'.
  LOOP AT lt_data INTO DATA(ls_data).
    WRITE: / ls_data-field1, ls_data-field2.
  ENDLOOP.
ELSE.
  MESSAGE 'Upload failed' TYPE 'E'.
ENDIF.
