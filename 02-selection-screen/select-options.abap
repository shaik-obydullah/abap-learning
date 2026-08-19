REPORT z_select_options.

TABLES: mara.

SELECT-OPTIONS: s_matnr FOR mara-matnr,
                s_ersda FOR mara-ersda,
                s_mtart FOR mara-mtart.

WRITE: / 'Material Number:', s_matnr-low.
WRITE: / 'Created Date:', s_ersda-low.
WRITE: / 'Material Type:', s_mtart-low.
