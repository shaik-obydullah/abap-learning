# Week 9 — ALV + Fiori/OData Bridge

Modern ALV (with `CL_SALV_TABLE`) is far simpler than classic ALV, and OData is how Fiori apps get data from SAP. This week ties both together.

> ℹ️ Info: **What you'll build this week** Expose the Week-4 report as an OData service.

## Modern ALV — CL_SALV_TABLE

`CL_SALV_TABLE` is the simpler, object-oriented way to build ALV reports. You pass a data table; it auto-builds the field catalog, sorting, filtering, and layout. Much less boilerplate than classic ALV.

```
SELECT bukrs, lifnr, netwr
  FROM ekko
  INTO TABLE @DATA(lt_alv).

IF sy-subrc NE 0.
  MESSAGE 'No data' TYPE 'I'.
  RETURN.
ENDIF.

TRY.
    cl_salv_table=>factory(
      IMPORTING
        r_salv_table = DATA(lo_alv)
      CHANGING
        t_table      = lt_alv ).

    " Access the columns/display objects
    DATA(lo_columns) = lo_alv->get_columns( ).
    lo_columns->set_optimize( abap_true ).

    " Turn on totals/summation is via aggregate — or just display
    lo_alv->display( ).

  CATCH cx_salv_msg.
    MESSAGE 'Cannot build ALV' TYPE 'E'.
ENDTRY.
```

> 💡 Tip: **Why CL_SALV_TABLE?** Fewer lines, auto field catalog, and most standard features (sort/filter/export) come for free. Great for typical reports. Use classic ALV/CL_GUI_ALV_GRID when you need deep custom control (cell edits, events).

### Adding layout, sorting, and totals to SALV

```
DATA(lo_layout) = lo_alv->get_layout( ).
lo_layout->set_zebra( abap_true ).
lo_layout->set_key( VALUE salv_s_layout_key(
  report = sy-repid ) ).   " persist user layout per report

" Sorting by company code
DATA(lo_sorts) = lo_alv->get_sorts( ).
lo_sorts->add_sort(
  columnname = 'BUKRS'
  subtotal   = abap_true ).   " subtotal groups

" Totals row: use something like lo_columns->get_column('NETWR')
DATA(lo_col) = lo_columns->get_column( 'NETWR' ).
lo_col->set_aggr_planned( if_salv_c_aggregation->total ).
```

## What is OData?

OData is a REST-ish standard for data services. SAP exposes business data as an **OData service** (a set of entities with GET/POST/PUT/DELETE operations) so Fiori apps and external clients can consume it over HTTP(S).

Key concepts:

- **Entity** — a data record type (like a table: e.g., `Product`).
- **Entity set** — a collection (like a table's rows).
- **Service** — the group of entity sets + operations.
- JSON/XML as payload; the `$metadata` endpoint describes the service.

## Building an OData service with SEGW

The classic gateway builder is `SEGW` (Service Builder). The workflow:

1. **Create a project** in `SEGW` — pick a name (e.g., `ZPRODUCT_SRV`).
2. **Define a data model** — you can import from a structure/table, RFC, or CDS view. This creates entity types.
3. **Generate the service** — SEGW creates the OData model and code (MPC = model provider, DPC = data provider) as ABAP classes.
4. **Implement the DPC methods** — e.g., `PRODUCTSET_GET_ENTITYSET` (list/get) to actually fetch data.
5. **Register/publish** the service (via `/IWFND/MAINT_SERVICE` or the activation step) so it has a URL.

A simplified DPC read implementation looks like:

```
METHOD productset_get_entityset.
  SELECT * FROM mara INTO TABLE @DATA(lt_mara).
  MOVE-CORRESPONDING lt_mara TO et_entityset.
ENDMETHOD.
```

> ℹ️ Info: **The takeaway** You don't need to memorize every SEGW field. Understand the flow (project → model → generate → implement DPC → publish) and be able to implement a `GET_ENTITYSET` and `GET_ENTITY` .

## OData CRUD operations

| Operation | DPC method | Purpose |
| --- | --- | --- |
| Read list | ..._GET_ENTITYSET | Get many records |
| Read single | ..._GET_ENTITY | Get one record by key |
| Create | ..._CREATE_ENTITY | POST a new record |
| Update | ..._UPDATE_ENTITY | Modify existing (PUT/PATCH) |
| Delete | ..._DELETE_ENTITY | Remove a record |
| Function/action | ..._EXECUTE | Custom operations |

## From ALV report to OData in one sentence

Your Week-4 ALV report produced a list of rows from a SELECT. An OData service does the same SELECT but returns the rows as JSON over HTTP. So "exposing the Week-4 report as OData" simply means: put that SELECT inside a DPC `GET_ENTITYSET` method instead of an ALV call.

## Exercises

1. Rewrite last week's simple ALV report using `CL_SALV_TABLE` instead of classic ALV. Compare the code size.
2. Add zebra layout, a sort on company code with subtotals, and a totals row on net value.
3. In `SEGW`, create a project and import a structure/table as an entity type.
4. Generate the service and implement the `GET_ENTITYSET` to return data from MARA.
5. Publish the service and test it in the browser via the service URL/`$metadata`.

> 💡 Tip: **Vocabulary boosters** `CL_SALV_TABLE` , `factory( )` , `get_columns( )` , `display( )` , OData, `SEGW` , Service Builder, entity/entity set, DPC, MPC, `$metadata` , Fiori.

← Week 8
Next: Week 10 — ABAP Cloud / RAP →
