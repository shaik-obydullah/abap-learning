# SAP ABAP Developer Tutorial
## From Hello World to Custom Reports

---

## Table of Contents
1. [Introduction to SAP ABAP](#1-introduction)
2. [Hello World Program](#2-hello-world)
3. [Basic Syntax & Data Types](#3-basic-syntax)
4. [Control Structures](#4-control-structures)
5. [Internal Tables](#5-internal-tables)
6. [Modularization](#6-modularization)
7. [Database Operations (Open SQL)](#7-database-operations)
8. [Selection Screens](#8-selection-screens)
9. [ALV Reports](#9-alv-reports)
10. [Custom Report Development](#10-custom-report)

---

## 1. Introduction to SAP ABAP

**ABAP** (Advanced Business Application Programming) is SAP's proprietary programming language for developing applications on the SAP platform.

### Key Concepts:
- **ABAP Dictionary** - Central metadata repository
- **Programs** - Executable code units
- **Includes** - Reusable code fragments
- **Function Modules** - Reusable function blocks
- **Classes** - Object-oriented programming units

### How to Access ABAP Editor:
- Transaction Code: **SE38** (ABAP Editor)
- Transaction Code: **SE80** (Object Navigator)

---

## 2. Hello World Program

### Step 1: Create a New Program
1. Open Transaction **SE38**
2. Enter program name: `ZHELLO_WORLD`
3. Click **Create**
4. Select type: **Executable Program**
5. Enter a title and save

### Step 2: Write the Code
```abap
REPORT zhello_world.

WRITE: 'Hello, World!'.
WRITE: / 'Welcome to SAP ABAP Development'.
```

### Step 3: Execute
- Press **F8** or click **Execute** button

### Output:
```
Hello, World!
Welcome to SAP ABAP Development
```

---

## 3. Basic Syntax & Data Types

### Data Declaration
```abap
REPORT zbasic_syntax.

* --- Data Types ---
DATA: lv_name    TYPE string,       " Character string
      lv_id      TYPE i,            " Integer
      lv_price   TYPE p LENGTH 8 DECIMALS 2,  " Packed number
      lv_date    TYPE d,            " Date
      lv_time    TYPE t,            " Time
      lv_flag    TYPE abap_bool.    " Boolean (abap_true/abap_false)

* --- Simple Assignment ---
lv_name = 'John Doe'.
lv_id = 1001.
lv_price = '29.99'.
lv_date = sy-datum.    " System date
lv_time = sy-uzeit.    " System time

* --- WRITE Output ---
WRITE: / 'Name:', lv_name.
WRITE: / 'ID:', lv_id.
WRITE: / 'Price:', lv_price CURRENCY 'USD'.
WRITE: / 'Date:', lv_date.
WRITE: / 'Time:', lv_time.
```

### Types of Variables:
| Type | Description | Example |
|------|-------------|---------|
| `i` | Integer | `DATA: lv_num TYPE i.` |
| `p` | Packed/Decimal | `DATA: lv_dec TYPE p LENGTH 8 DECIMALS 2.` |
| `c` | Character | `DATA: lv_char TYPE c LENGTH 10.` |
| `string` | String | `DATA: lv_str TYPE string.` |
| `d` | Date | `DATA: lv_date TYPE d.` |
| `t` | Time | `DATA: lv_time TYPE t.` |
| `x` | Hexadecimal | `DATA: lv_hex TYPE x LENGTH 4.` |

---

## 4. Control Structures

### IF...ELSEIF...ELSE...ENDIF
```abap
REPORT zcontrol_structures.

DATA: lv_grade TYPE c LENGTH 1,
      lv_score TYPE i VALUE 85.

lv_grade = 'A'.

IF lv_score >= 90.
  lv_grade = 'A'.
ELSEIF lv_score >= 80.
  lv_grade = 'B'.
ELSEIF lv_score >= 70.
  lv_grade = 'C'.
ELSE.
  lv_grade = 'F'.
ENDIF.

WRITE: / 'Score:', lv_score.
WRITE: / 'Grade:', lv_grade.
```

### CASE...ENDCASE
```abap
DATA: lv_day TYPE i VALUE 3,
      lv_day_name TYPE string.

CASE lv_day.
  WHEN 1.
    lv_day_name = 'Monday'.
  WHEN 2.
    lv_day_name = 'Tuesday'.
  WHEN 3.
    lv_day_name = 'Wednesday'.
  WHEN OTHERS.
    lv_day_name = 'Other Day'.
ENDCASE.

WRITE: / 'Day Number:', lv_day.
WRITE: / 'Day Name:', lv_day_name.
```

### DO...ENDDO Loop
```abap
DATA: lv_count TYPE i VALUE 1.

DO 5 TIMES.
  WRITE: / 'Iteration:', lv_count.
  lv_count = lv_count + 1.
ENDDO.
```

### WHILE...ENDWHILE Loop
```abap
DATA: lv_counter TYPE i VALUE 1.

WHILE lv_counter <= 10.
  WRITE: / 'Counter:', lv_counter.
  lv_counter = lv_counter + 1.
ENDWHILE.
```

### LOOP...ENDLOOP (For Internal Tables)
```abap
DATA: lt_numbers TYPE TABLE OF i,
      lv_num TYPE i.

APPEND 10 TO lt_numbers.
APPEND 20 TO lt_numbers.
APPEND 30 TO lt_numbers.

LOOP AT lt_numbers INTO lv_num.
  WRITE: / 'Number:', lv_num.
ENDLOOP.
```

---

## 5. Internal Tables

### Types of Internal Tables:
1. **Standard Table** - Index-accessed
2. **Sorted Table** - Binary search, sorted by key
3. **Hashed Table** - Hash access by key
4. **Index Table** - Generic index table

### Basic Operations
```abap
REPORT zinternal_tables.

* --- Define Structure ---
TYPES: BEGIN OF ty_employee,
         emp_id    TYPE i,
         name      TYPE string,
         department TYPE string,
         salary    TYPE p LENGTH 8 DECIMALS 2,
       END OF ty_employee.

* --- Define Table Type ---
DATA: lt_employees TYPE STANDARD TABLE OF ty_employee,
      ls_employee  TYPE ty_employee,
      lv_index     TYPE i.

* --- INSERT Records ---
ls_employee-emp_id = 1001.
ls_employee-name = 'Alice Johnson'.
ls_employee-department = 'IT'.
ls_employee-salary = 75000.
APPEND ls_employee TO lt_employees.

ls_employee-emp_id = 1002.
ls_employee-name = 'Bob Smith'.
ls_employee-department = 'HR'.
ls_employee-salary = 65000.
APPEND ls_employee TO lt_employees.

ls_employee-emp_id = 1003.
ls_employee-name = 'Charlie Brown'.
ls_employee-department = 'Finance'.
ls_employee-salary = 80000.
APPEND ls_employee TO lt_employees.

* --- READ Records ---
READ TABLE lt_employees INTO ls_employee 
  WITH KEY emp_id = 1002.
IF sy-subrc = 0.
  WRITE: / 'Found Employee:', ls_employee-name.
ENDIF.

* --- LOOP and Display ---
LOOP AT lt_employees INTO ls_employee.
  WRITE: / ls_employee-emp_id,
           ls_employee-name,
           ls_employee-department,
           ls_employee-salary.
ENDLOOP.

* --- DELETE Record ---
DELETE lt_employees WHERE emp_id = 1002.

* --- SORT ---
SORT lt_employees BY salary DESCENDING.

* --- MODIFY (Update) ---
LOOP AT lt_employees INTO ls_employee WHERE department = 'IT'.
  ls_employee-salary = ls_employee-salary * 1.10.  " 10% raise
  MODIFY lt_employees FROM ls_employee.
ENDLOOP.

* --- DESCRIBE Table ---
DATA: lv_lines TYPE i.
DESCRIBE TABLE lt_employees LINES lv_lines.
WRITE: / 'Total Employees:', lv_lines.
```

### Working with Structures
```abap
REPORT zstructures.

TYPES: BEGIN OF ty_product,
         product_id   TYPE c LENGTH 10,
         product_name TYPE string,
         price        TYPE p LENGTH 8 DECIMALS 2,
         quantity     TYPE i,
       END OF ty_product.

DATA: ls_product TYPE ty_product.

ls_product-product_id = 'P001'.
ls_product-product_name = 'Laptop'.
ls_product-price = 999.99.
ls_product-quantity = 50.

WRITE: / 'Product ID:', ls_product-product_id.
WRITE: / 'Product Name:', ls_product-product_name.
WRITE: / 'Price:', ls_product-price.
WRITE: / 'Quantity:', ls_product-quantity.
```

---

## 6. Modularization

### Subroutines (FORM...PERFORM)
```abap
REPORT zmodularization.

* --- Call Subroutines ---
PERFORM display_header.
PERFORM calculate_area USING 10 5.
PERFORM get_employee_info CHANGING ls_employee.

* --- Define Subroutines ---
FORM display_header.
  WRITE: / '================================'.
  WRITE: / '     EMPLOYEE REPORT'.
  WRITE: / '================================'.
ENDFORM.

FORM calculate_area USING iv_length TYPE i
                          iv_width TYPE i.
  DATA: lv_area TYPE i.
  lv_area = iv_length * iv_width.
  WRITE: / 'Area:', lv_area.
ENDFORM.

FORM get_employee_info CHANGING cs_employee TYPE ty_employee.
  cs_employee-emp_id = 1001.
  cs_employee-name = 'John Doe'.
ENDFORM.
```

### Function Modules
```abap
REPORT zfunction_modules.

DATA: lv_result TYPE p LENGTH 8 DECIMALS 2.

* --- Call Function Module ---
CALL FUNCTION 'CONVERT_TO_LOCAL_CURRENCY'
  EXPORTING
    date             = sy-datum
    foreign_amount   = 1000
    foreign_currency = 'USD'
    local_currency   = 'EUR'
  IMPORTING
    exchange_rate    = lv_result
  EXCEPTIONS
    no_rate_found    = 1
    overflow         = 2
    no_factors_found = 3
    no_spread_found  = 4
    derived_2_times  = 5
    OTHERS           = 6.

IF sy-subrc = 0.
  WRITE: / 'Exchange Rate:', lv_result.
ENDIF.
```

### Global Classes (OOP)
```abap
REPORT zoo_concepts.

* --- Define Local Class ---
CLASS lcl_vehicle DEFINITION.
  PUBLIC SECTION.
    METHODS: set_make IMPORTING iv_make TYPE string,
             set_model IMPORTING iv_model TYPE string,
             display_info.
  PRIVATE SECTION.
    DATA: mv_make  TYPE string,
          mv_model TYPE string.
ENDCLASS.

CLASS lcl_vehicle IMPLEMENTATION.
  METHOD set_make.
    mv_make = iv_make.
  ENDMETHOD.

  METHOD set_model.
    mv_model = iv_model.
  ENDMETHOD.

  METHOD display_info.
    WRITE: / 'Make:', mv_make.
    WRITE: / 'Model:', mv_model.
  ENDMETHOD.
ENDCLASS.

* --- Usage ---
DATA: lo_vehicle TYPE REF TO lcl_vehicle.

CREATE OBJECT lo_vehicle.

lo_vehicle->set_make( 'Toyota' ).
lo_vehicle->set_model( 'Camry' ).
lo_vehicle->display_info( ).
```

### Inheritance
```abap
REPORT zinheritance.

CLASS lcl_parent DEFINITION.
  PUBLIC SECTION.
    METHODS: display_name.
  PROTECTED SECTION.
    DATA: mv_name TYPE string.
ENDCLASS.

CLASS lcl_parent IMPLEMENTATION.
  METHOD display_name.
    WRITE: / 'Name:', mv_name.
  ENDMETHOD.
ENDCLASS.

CLASS lcl_child DEFINITION INHERITING FROM lcl_parent.
  PUBLIC SECTION.
    METHODS: set_age IMPORTING iv_age TYPE i,
             display_info.
  PRIVATE SECTION.
    DATA: mv_age TYPE i.
ENDCLASS.

CLASS lcl_child IMPLEMENTATION.
  METHOD set_age.
    mv_age = iv_age.
  ENDMETHOD.

  METHOD display_info.
    display_name( ).
    WRITE: / 'Age:', mv_age.
  ENDMETHOD.
ENDCLASS.

* --- Usage ---
DATA: lo_child TYPE REF TO lcl_child.

CREATE OBJECT lo_child.
lo_child->set_age( 25 ).
lo_child->mv_name = 'John'.  " Inherited attribute
lo_child->display_info( ).
```

---

## 7. Database Operations (Open SQL)

### SELECT Statement
```abap
REPORT zdatabase_ops.

TYPES: BEGIN OF ty_sflight,
         carrid   TYPE s_carr_id,
         connid   TYPE s_conn_id,
         fldate   TYPE s_date,
         seatsmax TYPE s_seatsmax,
         seatsocc TYPE s_seatsocc,
       END OF ty_sflight.

DATA: ls_sflight TYPE ty_sflight,
      lt_sflights TYPE STANDARD TABLE OF ty_sflight.

* --- Single Record ---
SELECT SINGLE carrid connid fldate seatsmax seatsocc
  INTO ls_sflight
  FROM sflight
  WHERE carrid = 'LH'.

IF sy-subrc = 0.
  WRITE: / ls_sflight-carrid,
           ls_sflight-connid,
           ls_sflight-fldate.
ENDIF.

* --- Multiple Records ---
SELECT carrid connid fldate seatsmax seatsocc
  INTO TABLE lt_sflights
  FROM sflight
  WHERE carrid = 'LH'.

LOOP AT lt_sflights INTO ls_sflight.
  WRITE: / ls_sflight-carrid,
           ls_sflight-connid,
           ls_sflight-fldate.
ENDLOOP.

* --- Aggregate Functions ---
DATA: lv_count TYPE i,
      lv_avg   TYPE p LENGTH 8 DECIMALS 2.

SELECT COUNT(*) FROM sflight INTO lv_count.

SELECT AVG( seatsocc ) FROM sflight INTO lv_avg.

WRITE: / 'Total Flights:', lv_count.
WRITE: / 'Average Seats:', lv_avg.
```

### INSERT Statement
```abap
* --- Insert Single Record ---
DATA: ls_spfli TYPE spfli.

ls_spfli-carrid = 'XY'.
ls_spfli-connid = '0001'.
ls_spfli-cityfrom = 'NEW YORK'.
ls_spfli-cityto = 'LOS ANGELES'.

INSERT INTO spfli VALUES ls_spfli.

IF sy-subrc = 0.
  WRITE: / 'Record inserted successfully'.
ENDIF.
```

### UPDATE Statement
```abap
* --- Update Single Record ---
UPDATE spfli SET cityfrom = 'CHICAGO'
  WHERE carrid = 'XY' AND connid = '0001'.

IF sy-subrc = 0.
  WRITE: / 'Record updated successfully'.
ENDIF.
```

### MODIFY Statement
```abap
* --- Insert or Update (Modify) ---
MODIFY spfli FROM ls_spfli.
```

### DELETE Statement
```abap
* --- Delete Single Record ---
DELETE FROM spfli WHERE carrid = 'XY' AND connid = '0001'.

IF sy-subrc = 0.
  WRITE: / 'Record deleted successfully'.
ENDIF.
```

### COMMIT and ROLLBACK
```abap
* --- Commit Work ---
COMMIT WORK.

* --- Rollback Work ---
ROLLBACK WORK.
```

---

## 8. Selection Screens

### Basic Selection Screen
```abap
REPORT zselection_screen.

* --- Parameters (Single Values) ---
PARAMETERS: p_carrid TYPE s_carr_id OBLIGATORY,
            p_connid TYPE s_conn_id,
            p_date   TYPE s_date DEFAULT sy-datum,
            p_show   TYPE abap_bool AS CHECKBOX DEFAULT 'X'.

* --- Select-Options (Range Values) ---
SELECT-OPTIONS: s_fldate FOR p_date,
                s_city   FOR sflight-cityfrom.

* --- Events ---
INITIALIZATION.
  p_carrid = 'LH'.

AT SELECTION-SCREEN.
  IF p_carrid IS INITIAL.
    MESSAGE 'Please enter a carrier ID' TYPE 'E'.
  ENDIF.

START-OF-SELECTION.
  WRITE: / 'Carrier:', p_carrid.
  WRITE: / 'Connection:', p_connid.
  WRITE: / 'Date Range:', s_fldate-low, 'to', s_fldate-high.
  WRITE: / 'City:', s_city-low, 'to', s_city-high.
```

### Selection Screen with Pushbuttons
```abap
REPORT zselection_pushbuttons.

PARAMETERS: p_carrid TYPE s_carr_id.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.
  PARAMETERS: p_direct TYPE abap_bool AS RADIOBUTTON GROUP r1,
              p_conctd TYPE abap_bool AS RADIOBUTTON GROUP r1.
SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE text-002.
  PARAMETERS: p_all    TYPE abap_bool AS CHECKBOX,
              p_active TYPE abap_bool AS CHECKBOX.
SELECTION-SCREEN END OF BLOCK b2.

* --- Text Elements ---
* text-001 = 'Flight Type'
* text-002 = 'Status'

START-OF-SELECTION.
  WRITE: / 'Carrier:', p_carrid.
```

### Dynamic Selection Screen
```abap
REPORT zdynamic_selection.

TABLES: sflight.

SELECT-OPTIONS: s_carrid FOR sflight-carrid.

* --- At Selection Screen Output ---
AT SELECTION-SCREEN OUTPUT.
  LOOP AT SCREEN.
    IF screen-group1 = 'M'.
      screen-active = 0.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.
```

---

## 9. ALV Reports

### Simple ALV Report
```abap
REPORT zsimple_alv.

* --- Define Structure ---
TYPES: BEGIN OF ty_sflight,
         carrid    TYPE s_carr_id,
         connid    TYPE s_conn_id,
         fldate    TYPE s_date,
         price     TYPE s_price,
         currency  TYPE s_currcode,
         seatsmax  TYPE s_seatsmax,
         seatsocc  TYPE s_seatsocc,
       END OF ty_sflight.

* --- Data Declarations ---
DATA: lt_sflight TYPE STANDARD TABLE OF ty_sflight,
      ls_sflight TYPE ty_sflight,
      lo_alv     TYPE REF TO cl_salv_table,
      lx_msg     TYPE REF TO cx_salv_msg.

* --- Fetch Data ---
SELECT carrid connid fldate price currency seatsmax seatsocc
  INTO TABLE lt_sflight
  FROM sflight.

* --- Create ALV ---
TRY.
    cl_salv_table=>factory(
      IMPORTING
        r_salv_table = lo_alv
      CHANGING
        t_table      = lt_sflight ).
  CATCH cx_salv_msg INTO lx_msg.
    WRITE: / 'Error:', lx_msg->get_text( ).
    RETURN.
ENDTRY.

* --- Display ALV ---
lo_alv->display( ).
```

### ALV with Layout Settings
```abap
REPORT zalv_layout.

TYPES: BEGIN OF ty_flight,
         carrid   TYPE s_carr_id,
         connid   TYPE s_conn_id,
         fldate   TYPE s_date,
         price    TYPE s_price,
         currency TYPE s_currcode,
       END OF ty_flight.

DATA: lt_flights TYPE STANDARD TABLE OF ty_flight,
      lo_alv     TYPE REF TO cl_salv_table,
      lo_display TYPE REF TO cl_salv_display_settings,
      lo_columns TYPE REF TO cl_salv_columns_table,
      lo_column  TYPE REF TO cl_salv_column,
      lx_msg     TYPE REF TO cx_salv_msg.

SELECT carrid connid fldate price currency
  INTO TABLE lt_flights
  FROM sflight.

TRY.
    cl_salv_table=>factory(
      IMPORTING
        r_salv_table = lo_alv
      CHANGING
        t_table      = lt_flights ).

    " --- Display Settings ---
    lo_display = lo_alv->get_display_settings( ).
    lo_display->set_striped_pattern( abap_true ).
    lo_display->set_list_header( 'Flight List' ).

    " --- Column Settings ---
    lo_columns = lo_alv->get_columns( ).
    lo_columns->set_optimize( abap_true ).

    " --- Hide Currency Column ---
    TRY.
        lo_column = lo_columns->get_column( 'CURRENCY' ).
        lo_column->set_visible( abap_false ).
      CATCH cx_salv_not_found.
    ENDTRY.

    " --- Set Column Headers ---
    TRY.
        lo_column = lo_columns->get_column( 'CARRID' ).
        lo_column->set_long_text( 'Airline' ).
        lo_column->set_medium_text( 'Airline Code' ).
        lo_column->set_short_text( 'Airline' ).
      CATCH cx_salv_not_found.
    ENDTRY.

    " --- Enable Totals ---
    lo_alv->get_aggregations( )->add_aggregation(
      columnname  = 'PRICE'
      aggregation = if_salv_c_aggregation=>total ).

    " --- Enable Sort ---
    lo_alv->get_sorts( )->add_sort( 'CARRID' ).

    lo_alv->display( ).

  CATCH cx_salv_msg INTO lx_msg.
    WRITE: / 'Error:', lx_msg->get_text( ).
ENDTRY.
```

### ALV with Events (User Commands)
```abap
REPORT zalv_events.

TYPES: BEGIN OF ty_flight,
         carrid   TYPE s_carr_id,
         connid   TYPE s_conn_id,
         fldate   TYPE s_date,
         price    TYPE s_price,
       END OF ty_flight.

DATA: lt_flights TYPE STANDARD TABLE OF ty_flight,
      lo_alv     TYPE REF TO cl_salv_table,
      lo_events  TYPE REF TO cl_salv_events_table,
      lx_msg     TYPE REF TO cx_salv_msg.

* --- Event Handler ---
CLASS lcl_alv_handler DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS: on_double_click FOR EVENT double_click 
                    OF cl_salv_events_table
                    IMPORTING row column.
ENDCLASS.

CLASS lcl_alv_handler IMPLEMENTATION.
  METHOD on_double_click.
    DATA: ls_flight TYPE ty_flight.
    READ TABLE lt_flights INTO ls_flight INDEX row.
    IF sy-subrc = 0.
      WRITE: / 'Double Clicked on Row:', row.
      WRITE: / 'Flight:', ls_flight-carrid, ls_flight-connid.
    ENDIF.
  ENDMETHOD.
ENDCLASS.

SELECT carrid connid fldate price
  INTO TABLE lt_flights
  FROM sflight.

TRY.
    cl_salv_table=>factory(
      IMPORTING
        r_salv_table = lo_alv
      CHANGING
        t_table      = lt_flights ).

    " --- Register Event Handler ---
    lo_events = lo_alv->get_event( ).
    SET HANDLER lcl_alv_handler=>on_double_click FOR lo_events.

    lo_alv->display( ).

  CATCH cx_salv_msg INTO lx_msg.
    WRITE: / 'Error:', lx_msg->get_text( ).
ENDTRY.
```

---

## 10. Custom Report Development

### Complete Custom Report Example
```abap
REPORT zcustom_report MESSAGE-ID zmsg.

* --- Type Definitions ---
TYPES: BEGIN OF ty_order,
         order_id    TYPE c LENGTH 10,
         customer_id TYPE c LENGTH 10,
         customer_name TYPE string,
         order_date  TYPE d,
         amount      TYPE p LENGTH 10 DECIMALS 2,
         status      TYPE c LENGTH 1,
       END OF ty_order.

* --- Global Data ---
DATA: gt_orders    TYPE STANDARD TABLE OF ty_order,
      gs_order     TYPE ty_order,
      go_alv       TYPE REF TO cl_salv_table,
      gx_msg       TYPE REF TO cx_salv_msg.

* --- Selection Screen ---
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.
  SELECT-OPTIONS: s_coid FOR gs_order-order_id,
                  s_cust FOR gs_order-customer_id,
                  s_date FOR gs_order-order_date.
  PARAMETERS:     p_stat AS LISTBOX VISIBLE LENGTH 20
                  USER-COMMAND u1.
SELECTION-SCREEN END OF BLOCK b1.

* --- Initialization ---
INITIALIZATION.
  s_date-low = sy-datum - 30.
  s_date-high = sy-datum.
  APPEND s_date.

  " Populate Status Listbox
  DATA: lt_values TYPE vrm_values,
        ls_value  TYPE vrm_value.
  
  ls_value-key = 'O'. ls_value-text = 'Open'.
  APPEND ls_value TO lt_values.
  ls_value-key = 'C'. ls_value-text = 'Closed'.
  APPEND ls_value TO lt_values.
  ls_value-key = 'X'. ls_value-text = 'Cancelled'.
  APPEND ls_value TO lt_values.
  
  CALL FUNCTION 'VRM_SET_VALUES'
    EXPORTING
      id     = 'P_STAT'
      values = lt_values.

* --- At Selection Screen ---
AT SELECTION-SCREEN.
  " Validate inputs
  IF s_coid[] IS INITIAL AND s_cust[] IS INITIAL.
    MESSAGE e001 WITH 'Please enter Order ID or Customer ID'.
  ENDIF.

* --- Main Processing ---
START-OF-SELECTION.
  PERFORM fetch_data.
  PERFORM process_data.
  PERFORM display_alv.

* --- Fetch Data from Database ---
FORM fetch_data.
  SELECT order_id customer_id customer_name order_date amount status
    INTO TABLE gt_orders
    FROM zorders
    WHERE order_id IN s_coid
      AND customer_id IN s_cust
      AND order_date IN s_date
      AND status = p_stat.

  IF gt_orders IS INITIAL.
    MESSAGE i002 WITH 'No data found for the given criteria'.
    LEAVE LIST-PROCESSING.
  ENDIF.
ENDFORM.

* --- Process Data ---
FORM process_data.
  DATA: ls_order TYPE ty_order.

  LOOP AT gt_orders INTO ls_order.
    " Apply business logic
    CASE ls_order-status.
      WHEN 'O'.
        " Open orders - no change
      WHEN 'C'.
        " Closed orders - apply discount
        ls_order-amount = ls_order-amount * 0.95.
      WHEN 'X'.
        " Cancelled - zero out amount
        ls_order-amount = 0.
    ENDCASE.

    MODIFY gt_orders FROM ls_order.
  ENDLOOP.

  " Sort orders by date
  SORT gt_orders BY order_date DESCENDING.
ENDFORM.

* --- Display ALV Report ---
FORM display_alv.
  TRY.
      cl_salv_table=>factory(
        IMPORTING
          r_salv_table = go_alv
        CHANGING
          t_table      = gt_orders ).

      " --- Configure ALV ---
      configure_alv( ).

      " --- Display ---
      go_alv->display( ).

    CATCH cx_salv_msg INTO gx_msg.
      MESSAGE gx_msg->get_text( ) TYPE 'E'.
  ENDTRY.
ENDFORM.

* --- Configure ALV Settings ---
FORM configure_alv.
  DATA: lo_display TYPE REF TO cl_salv_display_settings,
        lo_columns TYPE REF TO cl_salv_columns_table,
        lo_column  TYPE REF TO cl_salv_column,
        lo_funcs   TYPE REF TO cl_salv_functions_list,
        lo_agg     TYPE REF TO cl_salv_aggregations,
        lo_sorts   TYPE REF TO cl_salv_sorts_table.

  " --- Display Settings ---
  lo_display = go_alv->get_display_settings( ).
  lo_display->set_striped_pattern( abap_true ).
  lo_display->set_list_header( 'Custom Order Report' ).
  lo_display->set_horizontal_lines( abap_true ).

  " --- Enable Standard Functions ---
  lo_funcs = go_alv->get_functions( ).
  lo_funcs->set_all( abap_true ).

  " --- Column Settings ---
  lo_columns = go_alv->get_columns( ).
  lo_columns->set_optimize( abap_true ).

  " Configure specific columns
  TRY.
      lo_column = lo_columns->get_column( 'ORDER_ID' ).
      lo_column->set_long_text( 'Order Number' ).
      lo_column->set_medium_text( 'Order No.' ).
      lo_column->set_short_text( 'Order' ).
      lo_column->set_visible( abap_true ).

      lo_column = lo_columns->get_column( 'CUSTOMER_ID' ).
      lo_column->set_long_text( 'Customer Number' ).
      lo_column->set_medium_text( 'Customer No.' ).
      lo_column->set_short_text( 'Customer' ).

      lo_column = lo_columns->get_column( 'AMOUNT' ).
      lo_column->set_long_text( 'Order Amount' ).
      lo_column->set_medium_text( 'Amount' ).
      lo_column->set_short_text( 'Amount' ).

      lo_column = lo_columns->get_column( 'STATUS' ).
      lo_column->set_long_text( 'Order Status' ).
      lo_column->set_medium_text( 'Status' ).
      lo_column->set_short_text( 'Status' ).
    CATCH cx_salv_not_found.
  ENDTRY.

  " --- Enable Aggregations ---
  lo_agg = go_alv->get_aggregations( ).
  TRY.
      lo_agg->add_aggregation(
        columnname  = 'AMOUNT'
        aggregation = if_salv_c_aggregation=>total ).
      lo_agg->add_aggregation(
        columnname  = 'AMOUNT'
        aggregation = if_salv_c_aggregation=>average ).
    CATCH cx_salv_data_error cx_salv_not_found cx_salv_existing.
  ENDTRY.

  " --- Enable Sorting ---
  lo_sorts = go_alv->get_sorts( ).
  TRY.
      lo_sorts->add_sort( 'ORDER_DATE' ).
    CATCH cx_salv_not_found cx_salv_existing cx_salv_data_error.
  ENDTRY.

  " --- Set Column Colors (Optional) ---
  DATA: lo_col_tab TYPE REF TO cl_salv_column_table.
  TRY.
      lo_col_tab ?= lo_columns->get_column( 'STATUS' ).
      lo_col_tab->set_long_text( 'Status' ).
    CATCH cx_salv_not_found.
  ENDTRY.
ENDFORM.
```

### Using ABAP Classes (Modern Approach)
```abap
REPORT zmodern_abap.

* --- Define Local Class ---
CLASS lcl_order_processor DEFINITION.
  PUBLIC SECTION.
    TYPES: BEGIN OF ty_order,
             order_id TYPE c LENGTH 10,
             amount   TYPE p LENGTH 10 DECIMALS 2,
             status   TYPE c LENGTH 1,
           END OF ty_order.
    
    METHODS: constructor,
             fetch_orders
               IMPORTING
                 iv_status TYPE c OPTIONAL
               RETURNING
                 VALUE(rt_orders) TYPE STANDARD TABLE OF ty_order,
             process_orders
               IMPORTING
                 it_orders TYPE STANDARD TABLE OF ty_order,
             display_results.
  
  PRIVATE SECTION.
    DATA: mt_orders TYPE STANDARD TABLE OF ty_order.
ENDCLASS.

CLASS lcl_order_processor IMPLEMENTATION.
  METHOD constructor.
    " Initialization logic
  ENDMETHOD.

  METHOD fetch_orders.
    SELECT order_id amount status
      INTO TABLE rt_orders
      FROM zorders
      WHERE status = iv_status.
  ENDMETHOD.

  METHOD process_orders.
    DATA: ls_order TYPE ty_order.
    
    LOOP AT it_orders INTO ls_order.
      IF ls_order-status = 'O'.
        ls_order-amount = ls_order-amount * 1.10.
      ENDIF.
      MODIFY it_orders FROM ls_order.
    ENDLOOP.
    
    mt_orders = it_orders.
  ENDMETHOD.

  METHOD display_results.
    DATA: lo_alv TYPE REF TO cl_salv_table,
          lx_msg TYPE REF TO cx_salv_msg.
    
    TRY.
        cl_salv_table=>factory(
          IMPORTING
            r_salv_table = lo_alv
          CHANGING
            t_table      = mt_orders ).
        
        lo_alv->display( ).
      CATCH cx_salv_msg INTO lx_msg.
        WRITE: / 'Error:', lx_msg->get_text( ).
    ENDTRY.
  ENDMETHOD.
ENDCLASS.

* --- Main Program ---
DATA: lo_processor TYPE REF TO lcl_order_processor,
      lt_orders    TYPE STANDARD TABLE OF lcl_order_processor=>ty_order.

CREATE OBJECT lo_processor.

lt_orders = lo_processor->fetch_orders( iv_status = 'O' ).
lo_processor->process_orders( lt_orders ).
lo_processor->display_results( ).
```

---

## Quick Reference Commands

### Useful Transaction Codes
| T-Code | Description |
|--------|-------------|
| SE38 | ABAP Editor |
| SE80 | Object Navigator |
| SE11 | ABAP Dictionary |
| SE24 | Class Builder |
| SE37 | Function Builder |
| SE41 | Menu Painter |
| SE51 | Screen Painter |
| SM37 | Job Monitoring |
| ST05 | SQL Trace |
| SA38 | ABAP Program Execution |

### Useful Standard Programs
| Program | Description |
|---------|-------------|
| RSABAPSC | ABAP Source Scanner |
| RSINCL00 | Include Program List |
| RSBDCSUB | Batch Input Session Processing |

### Useful Function Modules
| Function Module | Description |
|-----------------|-------------|
| CONVERT_TO_LOCAL_CURRENCY | Currency Conversion |
| HR_DISPLAY_BASIC_LIST | Basic List Display |
| REUSE_ALV_GRID_DISPLAY | ALV Grid Display |
| VRM_SET_VALUES | Set Listbox Values |

---

## Tips for Beginners

1. **Use meaningful names** - Prefix variables with `lv_` (local variable), `gt_` (global table), `gs_` (global structure)
2. **Always check SY-SUBRC** after database operations
3. **Use SELECT...INTO TABLE** instead of SELECT...INTO in loops
4. **Use field symbols** for better performance with large tables
5. **Use ALV** instead of WRITE statements for reports
6. **Comment your code** - Use `*` for line comments and `"` for inline comments
7. **Use meaningful messages** - Create message class in SE91
8. **Test with different data** - Use test data before going live

---

## Next Steps

After mastering these basics, explore:
- **BAPIs** - Business Application Programming Interfaces
- **BADIs** - Business Add-Ins
- **Enhancement Framework** - User Exits and Customer Exits
- **Web Dynpro** - Web-based UI development
- **Fiori/SAPUI5** - Modern web development for SAP
- **CDS Views** - Core Data Services for HANA
- **AMDP** - ABAP Managed Database Procedures

---

**Happy Coding! 🚀**
