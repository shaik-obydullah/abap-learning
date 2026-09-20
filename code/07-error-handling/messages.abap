REPORT z_messages.

PARAMETERS: p_amount TYPE p LENGTH 10 DECIMALS 2 OBLIGATORY.

AT SELECTION-SCREEN.
  IF p_amount <= 0.
    MESSAGE 'Amount must be positive' TYPE 'E'.
  ENDIF.

START-OF-SELECTION.
  IF p_amount > 1000000.
    MESSAGE 'Amount is very large' TYPE 'W'.
  ENDIF.

  MESSAGE 'Processing complete' TYPE 'S'.
