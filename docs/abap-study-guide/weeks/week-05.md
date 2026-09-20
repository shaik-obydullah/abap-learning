# Week 5 — ABAP Objects Core

ABAP is fully object-oriented. If you know OOP in PHP, the concepts transfer 1:1 — only the syntax changes. This week is about the core building blocks: classes, objects, methods, attributes, inheritance, interfaces, exceptions, and constructors.

> ℹ️ Info: **Goal this week** Be able to write and call your own OO classes in ABAP — the daily currency of an SE80 developer.

## Class & Object

A **class** is a template (blueprint); an **object** (instance) is a concrete copy created from it. In ABAP you define classes with `CLASS ... ENDCLASS`.

### Local classes (defined in a report/program)

```
CLASS lcl_calculator DEFINITION.
  PUBLIC SECTION.
    METHODS add
      IMPORTING
        iv_a TYPE i
        iv_b TYPE i
      RETURNING
        VALUE(rv_sum) TYPE i.

    METHODS multiply
      IMPORTING
        iv_a TYPE i
        iv_b TYPE i
      RETURNING
        VALUE(rv_result) TYPE i.
ENDCLASS.

CLASS lcl_calculator IMPLEMENTATION.
  METHOD add.
    rv_sum = iv_a + iv_b.
  ENDMETHOD.

  METHOD multiply.
    rv_result = iv_a * iv_b.
  ENDMETHOD.
ENDCLASS.
```

Two parts: the `DEFINITION` (signatures) and the `IMPLEMENTATION` (bodies).

## Creating and using objects

```
DATA lo_calc TYPE REF TO lcl_calculator.
CREATE OBJECT lo_calc.

DATA(lv_result) = lo_calc->add(
  iv_a = 4
  iv_b = 5 ).
WRITE: / 'Sum:', lv_result.

" Alternative modern inline creation
DATA(lo_calc2) = NEW lcl_calculator( ).
```

## Attributes (fields) & visibility

```
CLASS lcl_counter DEFINITION.
  PUBLIC SECTION.
    METHODS increment.
    METHODS get_value
      RETURNING VALUE(rv_value) TYPE i.
  PRIVATE SECTION.
    DATA mv_count TYPE i.   " only methods of this class can touch it
ENDCLASS.

CLASS lcl_counter IMPLEMENTATION.
  METHOD increment.
    mv_count = mv_count + 1.
  ENDMETHOD.
  METHOD get_value.
    rv_value = mv_count.
  ENDMETHOD.
ENDCLASS.
```

> 💡 Tip: **Visibility sections** `PUBLIC SECTION` — callable from anywhere `PROTECTED SECTION` — only this class and subclasses `PRIVATE SECTION` — only this class Attributes (DATA) usually belong in PRIVATE/PROTECTED.

## Constructors

The `CONSTRUCTOR` runs automatically when the object is created. Define it in the class and call with `NEW`.

```
CLASS lcl_person DEFINITION.
  PUBLIC SECTION.
    METHODS constructor
      IMPORTING iv_name TYPE string.
    METHODS greet.
  PRIVATE SECTION.
    DATA mv_name TYPE string.
ENDCLASS.

CLASS lcl_person IMPLEMENTATION.
  METHOD constructor.
    mv_name = iv_name.
  ENDMETHOD.
  METHOD greet.
    WRITE: / 'Hello', mv_name.
  ENDMETHOD.
ENDCLASS.

DATA(lo_person) = NEW lcl_person( iv_name = 'Alice' ).
lo_person->greet( ).
```

## Inheritance (EXTENDS)

```
CLASS lcl_animal DEFINITION.
  PUBLIC SECTION.
    METHODS sound.
ENDCLASS.
CLASS lcl_animal IMPLEMENTATION.
  METHOD sound.
    WRITE: / 'generic sound'.
  ENDMETHOD.
ENDCLASS.

* Subclass inherits + overrides
CLASS lcl_dog DEFINITION INHERITING FROM lcl_animal.
  PUBLIC SECTION.
    METHODS sound REDEFINITION.
ENDCLASS.
CLASS lcl_dog IMPLEMENTATION.
  METHOD sound.
    WRITE: / 'Woof!'.
  ENDMETHOD.
ENDCLASS.
```

Use `REDEFINITION` to override an inherited method. Protected/private members follow normal rules.

## Interfaces (INTERFACE ... ENDINTERFACE)

An interface declares a contract; any class implementing it must provide the methods. This enables polymorphism — different classes treated through the same interface.

```
INTERFACE lif_drawable.
  METHODS draw.
ENDINTERFACE.

CLASS lcl_circle DEFINITION.
  PUBLIC SECTION.
    INTERFACES lif_drawable.
ENDCLASS.

CLASS lcl_circle IMPLEMENTATION.
  METHOD lif_drawable~draw.
    WRITE: / 'Drawing a circle'.
  ENDMETHOD.
ENDCLASS.

DATA(lo_shape) = NEW lcl_circle( ).
lo_shape->lif_drawable~draw( ).
```

> 💡 Tip: **Interface method names** An implemented interface method is named after the interface with `~` , e.g., `lif_drawable~draw` .

## Exception Classes (CX_*)

ABAP uses **class-based exceptions**. A method can raise an exception; the caller handles it with `TRY` / `CATCH`.

```
CLASS cx_calc_error DEFINITION INHERITING FROM cx_static_check.
ENDCLASS.
```

Custom exception classes inherit from one of the abstract base classes `cx_static_check` (recoverable), `cx_dynamic_check`, or `cx_no_check` (not recoverable / must not propagate unchecked).

```
CLASS lcl_divider DEFINITION.
  PUBLIC SECTION.
    METHODS divide
      IMPORTING iv_a TYPE i
                iv_b TYPE i
      RETURNING VALUE(rv_q) TYPE i
      RAISING   cx_calc_error.
ENDCLASS.

CLASS lcl_divider IMPLEMENTATION.
  METHOD divide.
    IF iv_b EQ 0.
      RAISE EXCEPTION TYPE cx_calc_error.
    ENDIF.
    rv_q = iv_a DIV iv_b.
  ENDMETHOD.
ENDCLASS.

DATA(lo_d) = NEW lcl_divider( ).
TRY.
    DATA(lv_q) = lo_d->divide( iv_a = 10 iv_b = 0 ).
    WRITE: / lv_q.
  CATCH cx_calc_error.
    WRITE: / 'Cannot divide by zero!'.
ENDTRY.
```

Built-in exceptions also exist, e.g., `cx_sy_zerodivide`, `cx_sy_arithmetic_error`. Use the right base class and always consider `MESSAGE` to show user-friendly texts.

## STATIC vs INSTANCE

Instance members belong to an object. `CLASS-METHODS` / `CLASS-DATA` belong to the class itself and are callable without creating an object:

```
CLASS lcl_math DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS square
      IMPORTING iv_n TYPE i
      RETURNING VALUE(rv_sq) TYPE i.
ENDCLASS.

CLASS lcl_math IMPLEMENTATION.
  METHOD square.
    rv_sq = iv_n * iv_n.
  ENDMETHOD.
ENDCLASS.

" No object needed:
DATA(lv_sq) = lcl_math=>square( iv_n = 6 ).   " 36
```

## Exercises

1. Create a local class `lcl_bank_account` with `deposit` and `withdraw` methods and a private balance. Prevent negative balance.
2. Add a constructor that sets an initial balance.
3. Create a subclass that adds an overdraft feature (REDEFINITION).
4. Define an interface `lif_loggable` with a `log` method and implement it in two different classes.
5. Write a method that raises a custom exception on invalid input and handle it with TRY/CATCH.

> 💡 Tip: **Vocabulary boosters** `CLASS` / `ENDCLASS` , `METHODS` , `CLASS-METHODS` , `IMPORTING` , `EXPORTING` , `RETURNING` , `CONSTRUCTOR` , `INHERITING FROM` , `REDEFINITION` , `INTERFACE` , `TRY/CATCH/ENDTRY` , `RAISE EXCEPTION` , `cx_*` , `NEW` .

← Week 4
Next: Week 6 — OO in Practice →
