# File Handling

Move data in and out of SAP — import files and export reports to your local machine.

## Moving Data In and Out

Businesses constantly import and export spreadsheets, CSVs, and flat files. These are the core patterns.

- **Upload** — read a file from the user's machine into an internal table.
- **Download** — take an internal table and write it to a file the user can open.
- Common via function modules that handle the file dialog, encoding, and error checking for you.

> 📌 Note: File handling needs a real SAP GUI to pick files — emulators can't run these. Learn the patterns here; practice on the SAP CAL sandbox.

## File Upload

Use a function module to present a file dialog and read the data.

**File:** `08-file-handling/upload.abap`

```
REPORT z_upload.

TYPES: BEGIN OF ty_data,
         field1 TYPE c LENGTH 20,
         field2 TYPE c LENGTH 20,
       END OF ty_data.

DATA: lt_data    TYPE TABLE OF ty_data,
      lv_filename TYPE string,
      lv_rc      TYPE i.

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
```

### Key points

- `GUI_UPLOAD` — reads a local file into `data_tab` (each file line becomes a row).
- The `filename` can be filled via a file dialog (`F4` / `GUI_GET_FILE_NAME`).
- Check `sy-subrc` (the `EXCEPTIONS` block) to report failures.

> 💡 Tip: Store each uploaded row as a string or a fixed-length structure, then validate and insert into the database.

## File Download

Export an internal table to a file the user can save.

**File:** `08-file-handling/download.abap`

```
REPORT z_download.

DATA: lt_data    TYPE TABLE OF string,
      lv_filename TYPE string,
      lv_line    TYPE string.

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
```

### Key points

- `GUI_DOWNLOAD` — writes `data_tab` lines to the specified file.
- Used to export reports, CSV extracts, and config to the local machine.
- Check `sy-subrc` after the call.

> ⚠️ Common pitfall: When exporting CSV, be careful with field separators and encoding (e.g. semicolons vs commas, character set). Wrong settings produce files Excel can't read correctly.

## Practice & Next Steps

#### CSV export of a report

1. Select flight data into an internal table.
2. Convert each row to a CSV string line (fields separated by `;`).
3. Download the lines with `GUI_DOWNLOAD`.

> **Next up:** Section 09 — OOP Basics: CLASSES and INTERFACES.
