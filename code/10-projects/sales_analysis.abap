REPORT z_sales_analysis.

TABLES: vbak, vbap.

TYPES: BEGIN OF ty_sales,
         vkorg   TYPE vbak-vkorg,   " Sales organization
         auart   TYPE vbak-auart,   " Order type
         sum_val TYPE p DECIMALS 2, " Total value
       END OF ty_sales.

DATA: lt_sales TYPE TABLE OF ty_sales,
      ls_sales TYPE ty_sales,
      lv_total TYPE p DECIMALS 2.

PARAMETERS: p_vkorg TYPE vbak-vkorg DEFAULT '1000'.

START-OF-SELECTION.
  SELECT v~vkorg v~auart SUM( p~netwr ) AS sum_val
    FROM vbak AS v
    INNER JOIN vbap AS p ON p~vbeln = v~vbeln
    INTO CORRESPONDING FIELDS OF TABLE lt_sales
    WHERE v~vkorg = p_vkorg
    GROUP BY v~vkorg v~auart.

  IF lt_sales IS INITIAL.
    MESSAGE 'No sales data found' TYPE 'W'.
    EXIT.
  ENDIF.

  WRITE: / 'Sales analysis for org', p_vkorg.
  ULINE.

  LOOP AT lt_sales INTO ls_sales.
    WRITE: / ls_sales-vkorg,
             ls_sales-auart,
             ls_sales-sum_val.
    lv_total = lv_total + ls_sales-sum_val.
  ENDLOOP.

  ULINE.
  WRITE: / 'Grand total:', lv_total.
