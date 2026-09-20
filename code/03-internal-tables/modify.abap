REPORT z_modify_internal_table.

DATA: lt_inventory TYPE TABLE OF string,
      lv_item      TYPE string.

APPEND 'Laptop' TO lt_inventory.
APPEND 'Mouse' TO lt_inventory.
APPEND 'Keyboard' TO lt_inventory.

LOOP AT lt_inventory INTO lv_item.
  WRITE: / 'Before:', lv_item.
ENDLOOP.

MODIFY lt_inventory FROM 'Monitor' INDEX 2.

WRITE: / ''.
WRITE: / 'After modification:'.
LOOP AT lt_inventory INTO lv_item.
  WRITE: / 'Item:', lv_item.
ENDLOOP.

DELETE lt_inventory INDEX 1.

WRITE: / ''.
WRITE: / 'After deletion:'.
LOOP AT lt_inventory INTO lv_item.
  WRITE: / 'Item:', lv_item.
ENDLOOP.
