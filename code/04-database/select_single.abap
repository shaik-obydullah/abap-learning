REPORT z_select_single.

TABLES: scarr.

SELECT SINGLE carrid carrname url
  FROM scarr
  INTO (lv_carrid, lv_carrname, lv_url)
  WHERE carrid = 'LH'.

IF sy-subrc = 0.
  WRITE: / 'Airline:', lv_carrname.
  WRITE: / 'URL:', lv_url.
ELSE.
  WRITE: / 'Airline not found'.
ENDIF.
