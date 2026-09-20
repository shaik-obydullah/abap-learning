# OOP Basics

Classes and interfaces — modern ABAP is object-oriented, and your PHP OOP skills transfer almost 1:1.

## Modern ABAP is OOP

If you've written PHP classes, you're already 90% there. ABAP just uses `METHODS` instead of `function`.

| Concept | PHP | ABAP |
| --- | --- | --- |
| Class | `class Foo` | `CLASS foo DEFINITION` |
| Method | `function bar()` | `METHODS bar` |
| Instantiate | `new Foo()` | `CREATE OBJECT` |
| Spread the class in two parts | single file | DEFINITION + IMPLEMENTATION |

## Classes & Methods

An ABAP class is split into a definition and an implementation, usually in a separate class builder (SE24).

**File:** `09-oop-basics/class.abap`

```
* The DEFINITION declares the class "contract"
CLASS zcl_calculator DEFINITION.
  PUBLIC SECTION.
    METHODS add IMPORTING iv_a TYPE i
                           iv_b TYPE i
                 RETURNING VALUE(rv_result) TYPE i.
    METHODS subtract IMPORTING iv_a TYPE i
                               iv_b TYPE i
                     RETURNING VALUE(rv_result) TYPE i.
ENDCLASS.

* The IMPLEMENTATION holds the actual code
CLASS zcl_calculator IMPLEMENTATION.
  METHOD add.
    rv_result = iv_a + iv_b.
  ENDMETHOD.
  METHOD subtract.
    rv_result = iv_a - iv_b.
  ENDMETHOD.
ENDCLASS.

* Using the class
START-OF-SELECTION.
  DATA: lo_calc TYPE REF TO zcl_calculator,
        lv_sum  TYPE i.

  CREATE OBJECT lo_calc.
  lv_sum = lo_calc->add( iv_a = 10 iv_b = 5 ).
  WRITE: / 'Sum:', lv_sum.
```

### Key points

- `PUBLIC SECTION` — methods callable from outside (public methods).
- `IMPORTING iv_a` — input parameters; `RETURNING VALUE(rv_result)` — the return value.
- `CREATE OBJECT lo_calc` — instantiate; equivalent to `new`.
- `lo_calc->add( ... )` — call the method (the `->` operator).

> ⚠️ Common pitfall: `RETURNING` parameters must be declared with `VALUE(...)` so they're passed by value, not reference.

> 💡 Tip: The `iv_` prefix = importing variable, `rv_` = returning variable, `lo_` = local object reference.

## Interfaces

Define a contract that any class can implement — enabling polymorphism.

**File:** `09-oop-basics/interface.abap`

```
* An interface declares the contract
INTERFACE zif_animal.
  METHODS make_sound.
ENDINTERFACE.

* A class implements that contract
CLASS zcl_dog DEFINITION.
  PUBLIC SECTION.
    INTERFACES zif_animal.
ENDCLASS.

CLASS zcl_dog IMPLEMENTATION.
  METHOD zif_animal~make_sound.
    WRITE: / 'Woof!'.
  ENDMETHOD.
ENDCLASS.

CLASS zcl_cat DEFINITION.
  PUBLIC SECTION.
    INTERFACES zif_animal.
ENDCLASS.

CLASS zcl_cat IMPLEMENTATION.
  METHOD zif_animal~make_sound.
    WRITE: / 'Meow!'.
  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.
  DATA: lo_animal TYPE REF TO zif_animal,
        lo_dog    TYPE REF TO zcl_dog,
        lo_cat    TYPE REF TO zcl_cat.

  CREATE OBJECT lo_dog.
  CREATE OBJECT lo_cat.

  " Polymorphism: treat different classes through one interface
  lo_animal = lo_dog.
  lo_animal->make_sound( ).

  lo_animal = lo_cat.
  lo_animal->make_sound( ).
```

### Key points

- `INTERFACE zif_animal ... ENDINTERFACE.` — declares method signatures only.
- A class `IMPLEMENTS` the interface: `INTERFACES zif_animal.` in the PUBLIC section.
- Implemented methods are named `zif_animal~make_sound` (using `~`).
- Store objects as the interface type (`lo_animal`) to swap implementations — polymorphism.

> 📌 Note: The `zif_` / `zcl_` prefixes are the naming convention: `zcl_` = custom class, `zif_` = custom interface.

## Practice & Next Steps

#### Build a shape hierarchy

1. Define an interface `zif_shape` with a method `area` returning a decimal.
2. Create classes `zcl_rectangle` and `zcl_circle` implementing it.
3. Instantiate both, call `area` through the interface, and print the results.

> **Next up:** Section 10 — Projects: put it all together into real reports.
