# Week 11 — Real Project Practice

Now build one realistic scenario end-to-end. Since most jobs in Bangladesh are still classic S/4HANA, we focus on the classic core: a report that reads data, can be extended with a BADI, posts via a BAPI, and is served through ALV and OData.

> ℹ️ Info: **Goal this week** A complete, portfolio-ready project on GitHub with a README that shows an interviewer you can deliver.

## The project idea — Material Stock Report

Scenario: a user wants a material stock report that

1. Reads current stock from material tables.
2. Lets a **BADI** extend the calculation (e.g., a custom price or a bonus quantity).
3. Posts an adjustment via a **BAPI** (e.g., a goods/stock count update).
4. Shows results in **ALV**.
5. Also exposes the same data through **OData** for a simple web/Fiori view.

This single project exercises almost everything from Weeks 1–9: internal tables, Open SQL, OO, field symbols, ALV, BADI, BAPI, and OData.

## Suggested architecture

| Layer | Artifact | Responsibilities |
| --- | --- | --- |
| Data access | Class `zcl_dao_stock` | SELECTs stock; returns internal table |
| Enhancement | BADI `z_stock_price` + impl | Optional price/bonus customization |
| Business/service | Class `zcl_stock_service` | Orchestrates read + BADI + BAPI |
| Reporting | Report `z_stock_report` | Selection screen + `CL_SALV_TABLE` display |
| Integration | OData service (`SEGW` or RAP) | Expose the stock list to Fiori/web |

## Build steps (a practical order)

### Step 1 — Data layer

Get the raw material stock. A classic starting point is `mara` + `makt` (descriptions). Real stock comes from `mard`/`mseg`/`mchb`, but for a portfolio project you can aggregate from `mara` + `mard`.

```
METHOD get_stock.
  SELECT a~matnr, b~maktx, a~matkl
    FROM mara AS a
    LEFT OUTER JOIN makt AS b
      ON b~matnr = a~matnr AND b~spras = @sy-langu
    INTO TABLE @rt_stock.
ENDMETHOD.
```

### Step 2 — BADI extension point

Define a BADI (or use an enhancement spot) with a method like `adjust_price`. In the service, call it with `GET BADI`/`CALL BADI` and let your implementation modify the prices. This demonstrates "extend without modifying SAP."

### Step 3 — Service that orchestrates

```
METHOD build_report.
  rt_out = get_stock( ).
  " call the BADI once to allow custom logic
  GET BADI DATA(lr_badi) = z_badi_stock_price.
  CALL BADI lr_badi->adjust_prices
    CHANGING ct_stock = rt_out.
ENDMETHOD.
```

### Step 4 — ALV display

```
TRY.
    cl_salv_table=>factory(
      IMPORTING r_salv_table = DATA(lo_alv)
      CHANGING  t_table      = lt_out ).
    lo_alv->get_functions( )->set_all( abap_true ).
    lo_alv->display( ).
  CATCH cx_salv_msg.
    MESSAGE 'ALV error' TYPE 'E'.
ENDTRY.
```

### Step 5 — BAPI posting

For a stock-relevant post, use a goods-movement style BAPI OR a simpler custom remote function. On a trial system that lacks business docs, you can either use `BAPI_MATERIAL_SAVEDATA` for a materials master table or write a custom RFC you control end-to-end. Either way, demonstrate the **create → check RETURN → commit** discipline from Week 8.

### Step 6 — OData exposure

Reuse the same service class inside a DPC `GET_ENTITYSET` (from Week 9) so the exact same stock list is available over HTTP.

## Make it portfolio-ready

- Commit clean code with meaningful names (`z_*` prefixes).
- Write a **README.md**: problem, architecture (diagram), how to run, what each artifact does, screenshots of the ALV.
- Add a **test** if you have ABAP Unit available (at least a couple of methods for the service).
- Screenshot the ALV output and the OData JSON — interview gold.
- Keep it small but complete; depth on one scenario beats breadth on many.

## What an interviewer wants to see

- Clean separation of concerns (data vs logic vs UI).
- Correct use of internal tables, field symbols, performance awareness.
- Proper BADI/BAPI usage with error handling.
- Ability to explain each layer — you'll get asked "why did you structure it this way?"

## Exercises / checklist

1. Create the data-access class and a working stock SELECT.
2. Define a BADI and wire it into the service.
3. Add the ALV report with selection screen (plant/material group).
4. Add a post action via a BAPI or your own remote function, with commit + RETURN handling.
5. Expose the same data as OData and capture the JSON response.
6. Write the README and push to GitHub.

> 💡 Tip: **Keep it shippable** A working, explained 3-layer project beats a sprawling one that doesn't run. Prioritize "it runs and I can explain it" over more features.

← Week 10
Next: Week 12 — Job-Package Polish →
