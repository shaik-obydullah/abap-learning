# Week 7 — Enhancement Framework

SAP gives you several ways to **extend standard SAP code without modifying it** — so your changes survive support-package upgrades. This is a core professional skill for AMS/support roles.

> ℹ️ Info: **What you'll build this week** Extend a standard program/screen without touching SAP's code.

## Why enhance instead of modify?

Modifying SAP source directly (`MOD SCREEN`, changing user-exits source) creates upgrade conflicts. The enhancement framework provides officially supported hooks so your logic runs without touching the original code.

| Technique | What it is | Transactions |
| --- | --- | --- |
| BADI | Object-oriented enhancement spot you implement via a class | `SE18`, `SE19` |
| Customer Exits | Older function-module based hooks (FORM/CALL CUSTOMER-FUNCTION) | `CMOD`, `SMOD` |
| Enhancement Points | Implicit/explicit spots where you add code without a class | `SE80` enhancement mode |
| Enhancement Sections | Replace/extend a whole section of code | `SE80` |

## BADIs (Business Add-Ins)

A BADI is an interface (or **enhancement spot**) that SAP defines; you create an implementing class and register it. At runtime, SAP calls your implementation.

### The modern flow: Enhancement Spot + BADI

SAP defines an **enhancement spot** (identifier) and a **BADI interface** (e.g., `IF_BADI_INTERFACE`). You:

1. **Define/see the BADI** in `SE18` (or find existing ones via `SE18` / SPAU/SU24).
2. **Create an implementation BADI** in `SE19` — this creates a class that implements the interface methods.
3. **Implement the methods** with your logic.

Inside SAP's code, the call looks roughly like:

```
" get the BADI instance
GET BADI lr_badi.
" call all registered implementations
CALL BADI lr_badi->some_method
  IMPORTING et_result = lt_result.
```

Your job is only to create the **implementation** in `SE19` and fill in the method body.

> 💡 Tip: **Business Add-Ins vs old-style BADIs** Modern "new BADI" enhancements use **enhancement spots** and multiple implementations. Old-style BADIs ( `EXIT_BADI` older versions) allowed only one implementation and are deprecated. Prefer the enhancement-spot-based ones.

## Customer Exits (function-module based)

Customer exits are integration points where SAP calls a special function module (e.g., `EXIT_SAPMM06E_001`) via `CALL CUSTOMER-FUNCTION`. You provide the code inside that function module.

- Activate a customer exit with `CMOD` (project) linked via `SMOD`.
- The function module is empty; you fill it.
- Used heavily in older projects (e.g., purchase order exits, sales document exits).

While BADIs are the modern choice, customer exits still appear in AMS support work — understand both.

## Enhancement Points (implicit & explicit)

Enhancement points are marked spots inside SAP code where you can insert your own statements. SAP marks the spots; **you** decide what to insert (source-code enhancement).

```
" SAP standard code:
SELECT ... .
"ENHANCEMENT-POINT Z_EXTRA_SPOT SPOTS Z_SPOT.
" your inserted code runs here
"END-ENHANCEMENT-POINT.
"... rest of SAP code
```

- **Explicit enhancement points** — SAP authors place these markers deliberately.
- **Implicit enhancement points** — every statement block has implicit spots (e.g., before `ENDIF`, at subprogram start) that you can enhance without SAP placing markers.
- Created/maintained in `SE80` after toggling enhancement mode.

## Enhancement Sections

An enhancement section lets you **replace** (or extend) an existing chunk of SAP code with your own version. More powerful and riskier than enhancement points — used when you must change the logic itself, not just add logic.

## Transactions you'll live in

| Transaction | Purpose |
| --- | --- |
| `SE18` | Define/display BADI definitions & enhancement spots |
| `SE19` | Create/display BADI implementations |
| `SMOD` | Display enhancement (customer-exit) components |
| `CMOD` | Create an enhancement project linking components |
| `SE80` | Enhancement mode for points/sections |
| `SPAU` | Adjust objects after an upgrade (check enhancements) |

## A minimal BADI example (concept)

Suppose SAP defines the interface `IF_ZPRICE_CALC` with method `get_price`. In `SE19` you create implementation BADI `ZCL_IM_ZPRICE_CALC` implementing that interface:

```
CLASS zcl_im_zpricecalc IMPLEMENTATION.
  METHOD if_zprice_calc~get_price.
    " your override / augmentation logic
    ev_price = iv_base_price * ( 1 - iv_discount ).
  ENDMETHOD.
ENDCLASS.
```

Now every time SAP's code calls the BADI `get_price`, your method runs — without modifying SAP.

> ⚠️ Common pitfall: **Less is more** Enhancements are powerful but can hurt performance (many BADIs) and complicate upgrade behavior. Only add what's needed, and prefer the least invasive option (implicit point over full section replacement).

## Exercises

1. Use `SE18` to display the BADIs available for purchase order (`ME_PO_*`) — just explore and note which exist.
2. In `SE19`, create a BADI implementation for a price-calculation BADI and implement your own logic.
3. Read an implicit enhancement point of a standard program in `SE80` and add a harmless `WRITE` to understand the workflow.
4. Compare the effort of a source-code enhancement point vs a full enhancement section on a simple program.
5. Research `SPAU`/`SPDD` and explain why they matter after an upgrade.

> 💡 Tip: **Vocabulary boosters** BADI, `SE18` , `SE19` , enhancement spot, `GET BADI` / `CALL BADI` , customer exit, `CMOD` / `SMOD` , enhancement point, enhancement section, implicit/explicit, `SPAU` .

← Week 6
Next: Week 8 — BAPIs & RFCs →
