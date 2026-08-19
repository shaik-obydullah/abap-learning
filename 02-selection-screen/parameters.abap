REPORT z_parameters.

PARAMETERS: p_name   TYPE string,
            p_age    TYPE i,
            p_date   TYPE d,
            p_amount TYPE p LENGTH 10 DECIMALS 2.

WRITE: / 'Name:', p_name.
WRITE: / 'Age:', p_age.
WRITE: / 'Date:', p_date.
WRITE: / 'Amount:', p_amount.
