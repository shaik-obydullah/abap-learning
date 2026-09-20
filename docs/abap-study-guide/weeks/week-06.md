# Week 6 — OO in Practice

Everything you learned in Week 5, applied the way professional ABAP devs use it day-to-day in SE80/SE38. Every OOP concept maps 1:1 to PHP — only the syntax differs.

> ℹ️ Info: **Goal this week** Build reusable, well-structured classes: utility classes, abstract/final classes, singletons, and layered data access.

## Global Classes (SE24)

Local classes live inside one program. **Global classes** are reusable across the whole system, created in transaction `SE24`. Their names typically start with `ZCL_`.

| Scope | Where defined | Used by |
| --- | --- | --- |
| Local class | Inside a report (SE38/SE80) | That one program |
| Global class | SE24 | Any program in the system |

Global classes can contain **class methods/attributes** and instance methods, just like local ones. They support the same OO features (inheritance, interfaces, exceptions).

## Utility / Helper Classes (static)

Utility classes expose purely static methods — no state, callable anywhere without an object. Pattern:

```
CLASS zcl_util_string DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS is_palindrome
      IMPORTING iv_text TYPE string
      RETURNING VALUE(rv_yes) TYPE abap_bool.

    CLASS-METHODS reverse
      IMPORTING iv_text TYPE string
      RETURNING VALUE(rv_rev) TYPE string.
ENDCLASS.

CLASS zcl_util_string IMPLEMENTATION.
  METHOD reverse.
    DATA lv_len TYPE i.
    lv_len = strlen( iv_text ).
    DO lv_len TIMES.
      rv_rev = rv_rev && iv_text+ ( lv_len - sy-index ) (1).
    ENDDO.
  ENDMETHOD.
  " ... is_palindrome similar ...
ENDCLASS.
```

> 💡 Tip: **Name it like SAP does** SAP's own helper classes use the `CL_` prefix and a domain, e.g., `CL_GUI_ALV_GRID` . Your custom ones use `ZCL_` .

## Abstraction — ABSTRACT & FINAL

```
CLASS zcl_export ABSTRACT.       " cannot be instantiated directly
  PUBLIC SECTION.
    METHODS export_abstract ABSTRACT.   " no body; subclasses must implement
ENDCLASS.

CLASS zcl_pdf_export DEFINITION INHERITING FROM zcl_export.
  PUBLIC SECTION.
    METHODS export_abstract REDEFINITION.
ENDCLASS.

CLASS zcl_csv_export DEFINITION INHERITING FROM zcl_export.
  PUBLIC SECTION.
    METHODS export_abstract REDEFINITION.
ENDCLASS.
```

- `ABSTRACT` class: cannot create objects; exists to be inherited.
- `ABSTRACT` method: no implementation; subclasses are forced to provide one.
- `FINAL` class: cannot be a parent (nothing may inherit from it).
- `FINAL` method: cannot be redefined.

## The Singleton Pattern

A singleton ensures only one instance of a class exists. Common for DB helpers, logger, and configuration readers. Achieved via a `CLASS-DATA` reference and a static accessor.

```
CLASS zcl_db_helper DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS get_instance
      RETURNING VALUE(ro_instance) TYPE REF TO zcl_db_helper.
    METHODS read_material
      IMPORTING iv_matnr TYPE matnr
      RETURNING VALUE(rs_mara) TYPE mara.
  PRIVATE SECTION.
    CLASS-DATA go_instance TYPE REF TO zcl_db_helper.
ENDCLASS.

CLASS zcl_db_helper IMPLEMENTATION.
  METHOD get_instance.
    IF go_instance IS NOT BOUND.
      go_instance = NEW zcl_db_helper( ).
    ENDIF.
    ro_instance = go_instance.
  ENDMETHOD.

  METHOD read_material.
    SELECT SINGLE * FROM mara INTO rs_mara
      WHERE matnr = @iv_matnr.
  ENDMETHOD.
ENDCLASS.

" Usage anywhere:
DATA(lo_helper) = zcl_db_helper=>get_instance( ).
DATA(ls_mara) = lo_helper->read_material( iv_matnr = 'MAT001' ).
```

> 💡 Tip: **IS NOT BOUND** `go_instance IS NOT BOUND` / `IS BOUND` checks whether an object reference points to an existing object — the modern replacement for `IS INITIAL` on references.

## Layering — Keep business logic out of the screen

A common, clean structure for a report:

1. **Data-access class** (e.g., `zcl_dao_material`) — only SELECTs. Returns data, no UI.
2. **Business/service class** — validation + rules, calls the DAO.
3. **UI layer** (report + ALV) — calls the service, renders output.

```
CLASS zcl_material_service DEFINITION.
  PUBLIC SECTION.
    METHODS get_materials
      IMPORTING iv_bukrs TYPE bukrs
      RETURNING VALUE(rt_mara) TYPE TABLE OF mara.
ENDCLASS.

CLASS zcl_material_service IMPLEMENTATION.
  METHOD get_materials.
    " DAO would be injected here; for simplicity direct select
    SELECT * FROM mara INTO TABLE @rt_mara UP TO 100 ROWS.
  ENDMETHOD.
ENDCLASS.
```

## Composition over inheritance

Prefer grouping responsibilities into small classes and injecting them, rather than deep inheritance chains. For example, a report object that "has a" logger and "has a" data-access class instead of inheriting logger behavior.

## Exercises

1. Create a global utility class `zcl_util_string` in SE24 with static `reverse` and `is_palindrome` methods.
2. Refactor Week 1's calculator into a class with instance methods `add`, `subtract`, etc.
3. Build an abstract `zcl_export` with two concrete subclasses `zcl_csv_export` and `zcl_pdf_export`; call them polymorphically via the base reference.
4. Implement a singleton configuration class that reads system settings once and caches them.
5. Split one of your earlier reports into a DAO + service + report structure.

> 💡 Tip: **Vocabulary boosters** `SE24` , global class, `ZCL_` , utility class, `ABSTRACT` , `FINAL` , singleton, `CLASS-DATA` , `IS BOUND` , DAO, layering, composition.

← Week 5
Next: Week 7 — Enhancement Framework →
