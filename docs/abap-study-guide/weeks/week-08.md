# Week 8 — BAPIs & RFCs

BAPIs and RFCs are how systems talk to SAP and how SAP talks to other systems. Creating purchase orders, reading materials, integrating with external apps — all through these function-module-based APIs.

> ℹ️ Info: **What you'll build this week** Call `BAPI_PO_CREATE1` from a custom program to create a purchase order.

## Function Modules & Function Groups

A **function module** is a reusable, named chunk of code with defined parameters. Function modules are grouped into **function groups**. You manage them in `SE37` (Function Builder) and `SE80`.

Structure of a function module call:

```
CALL FUNCTION 'BAPI_PO_CREATE1'
  EXPORTING
    poheader     = ls_poheader
    poheaderx    = ls_poheaderx
  IMPORTING
    exppurchaseorder = lv_po_number
  TABLES
    return       = lt_return.
```

## What is an RFC?

An **RFC** (Remote Function Call) is a function module that can be called **remotely** — from another system, another program, or an external application (Java, .NET, etc.). A function module becomes an RFC by flagging it as "Remote-Enabled" in `SE37`.

This is the classic integration mechanism for SAP. When an HR system or a web app needs to read/write SAP data, it typically calls an RFC/BAPI.

## What is a BAPI?

A **BAPI** (Business Application Programming Interface) is a standardized RFC-enabled function module that performs a business operation on an SAP business object — create a purchase order, get a material list, update a customer, etc. BAPIs are the sanctioned way to touch SAP business data from outside.

BAPIs are named `BAPI_<OBJECT>_<ACTION>`, e.g.:

| BAPI | Action |
| --- | --- |
| `BAPI_PO_CREATE1` | Create a purchase order |
| `BAPI_MATERIAL_GETLIST` | List materials matching a selection |
| `BAPI_MATERIAL_SAVEDATA` | Create/change material master |
| `BAPI_CUSTOMER_CREATEFROMDATA1` | Create a customer |

## The BAPI calling pattern

Most BAPIs follow the same shape — and you **must** check the `RETURN` table (or `RETURN` structure) for messages, then call the matching `COMMIT_WORK` BAPI. Failing to commit discards your writes.

```
DATA: ls_poheader  TYPE bapimepoheader,
      lt_poitem    TYPE TABLE OF bapimepoitem,
      ls_poitem    TYPE bapimepoitem,
      lt_ret       TYPE TABLE OF bapiret2,
      lv_ponumber  TYPE bapimepoheader-po_number.

" Fill the header
ls_poheader-doc_type   = 'NB'.
ls_poheader-vendor     = '0000001000'.
ls_poheader-comp_code  = '1000'.
ls_poheader-purch_org  = '1000'.
ls_poheader-pur_group  = '001'.

" Fill at least one item
ls_poitem-po_item    = '00010'.
ls_poitem-material   = 'MAT-001'.
ls_poitem-quantity   = '10'.
ls_poitem-orderpr_un = 'PC'.
ls_poitem-net_price  = '10.00' .
ls_poitem-currency   = 'USD'.
APPEND ls_poitem TO lt_poitem.

" Call the BAPI
CALL FUNCTION 'BAPI_PO_CREATE1'
  EXPORTING
    poheader        = ls_poheader
    poitem          = lt_poitem
  IMPORTING
    exppurchaseorder = lv_ponumber
  TABLES
    return          = lt_ret.

" Check result
READ TABLE lt_ret TRANSPORTING NO FIELDS
  WITH KEY type = 'E'.
IF sy-subrc NE 0.
  " Success - commit
  CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
    EXPORTING
      wait = 'X'.
  WRITE: / 'PO created:', lv_ponumber.
ELSE.
  " Failure - rollback not needed, but log messages
  CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
  LOOP AT lt_ret INTO DATA(ls_msg).
    WRITE: / ls_msg-type, ls_msg-message.
  ENDLOOP.
ENDIF.
```

> ⚠️ Common pitfall: **Never forget COMMIT** BAPIs do **not** auto-commit. Call `BAPI_TRANSACTION_COMMIT` after a successful write, otherwise the data is rolled back when the RFC ends.

## Understanding BAPI parameters

In `SE37` you can inspect any BAPI. The key parameter patterns:

- `EXPORTING` — data you send in (headers, items, flags).
- `IMPORTING` — data returned (e.g., the created document number).
- `TABLES` — lists (often `RETURN`, plus `*ITEM` tables).
- `X`-suffixed parameter (e.g., `poheaderx`) — a "flags" structure telling SAP which fields to change/update. For creates you often pass them populated to match.
- `RETURN` — list of messages; check `TYPE` = 'E' (error) / 'W' (warning) / 'S' (success), etc.

## Creating your own RFC in SE37

1. Open `SE37`, create a new function module in a function group (e.g., `Z_FUNCTION_GROUP`).
2. In the **Attributes** tab, set **"Remote-Enabled Module"**.
3. Define `IMPORTING`, `EXPORTING`, `TABLES` parameters with types.
4. Write the source code in the Source code tab.
5. Activate.

A minimal remote-enabled function module:

```
FUNCTION z_get_material_name.
*" IMPORTING
*"   VALUE(IV_MATNR) TYPE MATNR
*" EXPORTING
*"   VALUE(EV_MAKTX) TYPE MAKTX

  SELECT SINGLE maktx
    FROM makt
    INTO ev_maktx
    WHERE matnr = iv_matnr
      AND spras = sy-langu.
ENDFUNCTION.
```

> 💡 Tip: **RFC destinations** To call an RFC in another system from a program you need an **RFC destination** (transaction `SM59` ). The destination defines the target system and connection type (3 = same system, etc.).

## Exercises

1. In `SE37`, display `BAPI_MATERIAL_GETLIST` and write a program that lists materials, checking `RETURN`.
2. Call `BAPI_PO_CREATE1` to create a purchase order and print the resulting number.
3. Add error handling: introduce a deliberately bad vendor and show how `RETURN` reports it.
4. Create your own remote-enabled function module that returns a material description given a material number.
5. Read about `SM59` RFC destinations and configure a sample destination (even same-system type 3).

> 💡 Tip: **Vocabulary boosters** function module, function group, `SE37` , RFC, remote-enabled, BAPI, `BAPI_TRANSACTION_COMMIT` , `RETURN` table, `SM59` , RFC destination, `CALL FUNCTION` .

← Week 7
Next: Week 9 — ALV + Fiori/OData Bridge →
