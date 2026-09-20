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
