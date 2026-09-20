# ABAP Study Plan (12 Weeks)

Built for a working developer (~1–2 hrs/weekday + 4–6 hrs/weekend).
Target: SAP developer jobs in Bangladesh (S/4HANA implementation + AMS support).

## Phase 1 — Foundations (Weeks 1–4)

### Week 1 — Syntax, data types, flow control
- Fields, `WRITE`, basic types (`I`, `C`, `N`, `D`, `T`, `P`), `MOVE`, IF/CASE, DO/WHILE loops, string ops.
- Deliverable: "Hello World" report + a small calculator (no screens).

### Week 2 — Internal Tables (the ABAP bread & butter)
- `DATA: lt_... TYPE TABLE OF ...`, `APPEND`, `INSERT`, `READ TABLE`, `MODIFY`, `DELETE`, `LOOP AT`, work areas. Standard/key/unique sorted tables.
- Laravel brain: think of them as Laravel collections.
- Deliverable: report that loads a file/data and filters/aggregates with internal tables.

### Week 3 — Open SQL + Field Symbols
- `SELECT, WHERE, JOIN, ORDER BY, GROUP BY`, `UP TO 1 ROWS`, `SELECT ... FOR ALL ENTRIES`, `SELECT SINGLE`.
- Field symbols (`ASSIGNING <fs>`) — like PHP references but on collections.
- Deliverable: report joining 2 tables (e.g., EKKO/EKPO purchase docs) and outputting a summary list.

### Week 4 — Consolidate + ALV basics
- Data dictionary intro: `SE11` (tables, structures, data elements).
- Classic ALV: `REUSE_ALV_GRID_DISPLAY` / `CL_GUI_ALV_GRID`.
- Deliverable: an ALV report with sorting, totals, and layout settings.

## Phase 2 — Object Orientation + Extensibility (Weeks 5–8)

### Week 5 — ABAP Objects core
- Classes/local + global, methods, attributes, inheritance, interfaces, exception classes (`CX_*`), constructor.

### Week 6 — OO in practice (the SE80 day job)
- Local classes, `CL_...` utility classes, abstract/final, singleton DB helpers.
- Every OOP concept maps 1:1 to PHP except syntax.

### Week 7 — Enhancement framework
- BADIs (`GET BADI`/`CALL BADI`, `IF_BADI_INTERFACE`), Customer Exits, Implicit/Explicit Enhancement Points, `SE18/SE19`.
- Deliverable: extend a standard program/screen without touching SAP code.

### Week 8 — BAPIs + RFCs
- RFC function modules, `BAPI_*` (e.g., `BAPI_PO_CREATE1`, `BAPI_MATERIAL_GETLIST`), `SE37/SE80`, function group basics.
- Deliverable: call `BAPI_PO_CREATE1` from a custom program.

## Phase 3 — Modern ABAP + Cloud (Weeks 9–12)

### Week 9 — ALV + Fiori/ODATA bridge
- `CL_SALV_TABLE` (simpler modern ALV), define a basic OData service (`SEGW`), list/get entities.
- Deliverable: expose the Week-4 report as an OData service.

### Week 10 — ABAP Cloud / RAP fundamentals
- Business objects as RAP (ABAP RESTful Application Programming Model) CDS views + behavior. Clean core: no direct table access in cloud.
- Deliverable: a minimal RAP business object with read + create.

### Week 11 — Real project practice
- Build one realistic scenario end-to-end (classic core, since most BD jobs are still classic S/4HANA).
- Scenario idea: a material stock report with BADI to extend, BAPI to post, ALV + OData to serve.
- Put it on GitHub with a README (looks good in interviews).

### Week 12 — Job-package polish
- Review tricky topics likely asked in Bangladeshi interviews: internal table performance (sorted/hashed vs standard), `FOR ALL ENTRIES`, `COMMIT/ROLLBACK`, locks (`ENQUEUE_*`), message handling (`MESSAGE ... TYPE 'E'`), screen involvement (dynpro basics `SE51`).
- Take a mock certification test. Start `C_TAW12_750` (classic) or `C_ABAPD_2309` (cloud) prep if aiming for the cert.

---

## Environment (start Week 1, don't wait)
- Trial S/4HANA / ABAP: SAP BTP ABAP free tier, or Docker `sap-no-userabap:latest` (check MDDN docs/set-up guide).
- Transactions to bookmark: SE11, SE38/SE80, SE37, SE93, SM50, ST22, SLG1.

## Reality check for Bangladesh hiring
- Most openings: classic ABAP (S/4HANA migration + AMS support). Weeks 1–8 are the job-getting weeks.
- ABAP Cloud (RAP) is where growth is but commands fewer junior seats right now — hence placed Weeks 9–11, not Week 1.