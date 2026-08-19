REPORT z_selection_events.

PARAMETERS: p_name TYPE string,
            p_age  TYPE i.

INITIALIZATION.
  p_name = 'John Doe'.
  p_age = 25.

AT SELECTION-SCREEN.
  IF p_name IS INITIAL.
    MESSAGE 'Name is required' TYPE 'E'.
  ENDIF.

  IF p_age < 18.
    MESSAGE 'Age must be 18 or older' TYPE 'E'.
  ENDIF.

START-OF-SELECTION.
  WRITE: / 'Name:', p_name.
  WRITE: / 'Age:', p_age.
  WRITE: / 'Status: Valid'.
