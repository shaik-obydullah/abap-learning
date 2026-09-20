# Week 10 — ABAP Cloud / RAP

RAP (ABAP RESTful Application Programming Model) is the modern, cloud-ready way to build SAP applications: CDS-based data models plus behavior for create/update/delete. It enforces the **clean core** principle — no direct table access in cloud.

> ℹ️ Info: **What you'll build this week** A minimal RAP business object with read + create.

## The big idea: RAP

RAP = ABAP RESTful Application Programming Model. Instead of writing function modules and manually handling database access, you:

1. Define a **data model** with **CDS views** (Core Data Services).
2. Define **behavior** (what operations are allowed: create, update, delete, feature control).
3. Expose it as an **OData service** automatically.
4. Optionally add an app layer (Fiori Elements for UI).

## CDS Views — the data model

A CDS view is a SQL-like definition that projects, filters, and joins data. It's a database view defined in ABAP source rather than `SE11`.

```
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Z RAP Product CDS'
define root view entity ZR_RapProduct
  as select from mara
  association to makt as _makt on _makt.matnr = mara.matnr
{
  key mara.matnr as ProductId,
      mara.mtart as MaterialType,
      mara.mbrsh as IndustrySector,
      _makt.maktx as Description
}
where mara.mtart = 'ROH'
```

- `define root view entity` — a root entity (no parent).
- `key ...` — marks the (composite) key.
- `as select from mara` — selects from table/another view.
- Annotations (`@...`) drive UI behavior, semantics, and access control.

> ⚠️ Common pitfall: **Clean core** In ABAP Cloud, applications may **not** access base tables directly (no `SELECT * FROM mara` in application code). All access goes through CDS views and RAP entities. This keeps the core clean and upgrade-safe.

## Looking at a CDS structure

CDS has several view kinds you'll meet:

`define view` (plain), `define root view entity` (RAP root), `define view entity` (non-root entity), plus `abstract entity` for interface views. Projection views (`define root view entity ZC_...`) are what actually get exposed to OData for the app.

## Behavior — what the user can do

The **behavior definition** (BDEF) states the operations. For a minimal object with read + create:

```
define behavior for ZR_RapProduct alias Product
implementation in class zcl_bp_rap_product unique

define behavior for ZR_RapProduct
  persistent table mara
  lock master
  authorization master ( instance )
  create ;
  field ( readonly ) ProductId, MaterialType, IndustrySector, Description ;

define behavior for ZR_RapProduct alias Product
  create;      // user can create
  // updating/deleteing are omitted or specified here
```

The behavior is backed by a **behavior implementation class** where you write the create/update/delete logic (e.g., filling defaults, calling validation, setting the key).

```
CLASS zcl_bp_rap_product IMPLEMENTATION.
  METHOD create.
    " loop over the modified instances provided by RAP framework
    LOOP AT entities ASSIGNING FIELD-SYMBOL(<entity>).
      " set key if not given
      IF <entity>-ProductId IS INITIAL.
        <entity>-ProductId = cl_system_uuid=>create_uuid_c32_static( ).
      ENDIF.
      " ... persist via baked-in INSERT on the persistent table
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
```

> 💡 Tip: **Don't hand-write everything** ADT (ABAP Development Tools) and the RAP generator create most RAP scaffolding for you — the BDEF, implementation class skeleton, and service definition. You mostly fill in the custom logic. Focus on the concepts, not rote syntax.

## From RAP to OData (service definition)

To expose the RAP business object to Fiori/consumers, you define:

```
@EndUserText.label: 'Product service definition'
define service ZUI_RapProduct {
  expose ZC_RapProduct as Product;   " projection view exposed
}
```

This creates an OData service that Fiori Elements apps bind to, giving you list, detail, create, and edit UIs almost automatically.

## Classic vs Cloud recap

|  | Classic S/4HANA | ABAP Cloud / RAP |
| --- | --- | --- |
| Data access | Direct `SELECT *` from tables | CDS views + RAP entities only |
| Model | Function modules, ALV, dynpro screens | CDS + behavior + Fiori |
| UI | SAP GUI / ALV / dynpro | Fiori Elements / SAPUI5 |
| Upgrade safety | Moderate (enhancements needed) | Clean core, fully upgrade-safe |

## Exercises

1. Write a CDS view that selects material data from MARA joined to their descriptions in MAKT.
2. Add annotations for label and a semantic key so the view is RAP-ready.
3. Create a RAP business object via the ADT generator (or at least map out every artifact it creates).
4. Define behavior enabling read + create and implement the create method in the behavior class.
5. Define a service definition exposing your projection view, then preview it in Fiori Elements.

> 💡 Tip: **Vocabulary boosters** RAP, CDS, Core Data Services, `define view entity` , `define root view entity` , BDEF (behavior definition), behavior implementation class, projection view, clean core, service definition, Fiori Elements, ADT.

← Week 9
Next: Week 11 — Real Project Practice →
