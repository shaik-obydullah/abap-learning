REPORT z_download.

DATA: lt_data     TYPE TABLE OF string,
      lv_filename TYPE string,
      lv_line     TYPE string.

lv_line = 'Hello, World!'. APPEND lv_line TO lt_data.
lv_line = 'This is line two'. APPEND lv_line TO lt_data.

lv_filename = 'C:\temp\output.txt'.

CALL FUNCTION 'GUI_DOWNLOAD'
  EXPORTING
    filename                = lv_filename
  TABLES
    data_tab                = lt_data
  EXCEPTIONS
    file_write_error        = 1
    OTHERS                  = 2.

IF sy-subrc = 0.
  MESSAGE 'File downloaded successfully' TYPE 'S'.
ELSE.
  MESSAGE 'Download failed' TYPE 'E'.
ENDIF.
