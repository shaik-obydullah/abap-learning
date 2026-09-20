# SAP Lesson 2 — Internal Tables & Work Areas (In Depth)

> Month 1/2 territory. Internal tables are the single most-used ABAP construct — if Lesson 1 was "hello world", this is where you actually start writing professional business code. Your PHP-brain will keep trying to translate; resist the urge — internal tables have their own idioms that don't map 1:1 to arrays.

---

## 1. What an internal table really is

An internal table is an **in-memory, typed data set** of a single structure — think of it as a PHP array of associative arrays, but with a fixed, known shape and strict types, living in ABAP's runtime memory.

A pervasive mental model:

```
it_people          the internal table (the collection)
   ├── ls_person   a work area = one row (a single structure)
   ├── ls_person
   └── ls_person
```

ABAP works in two shapes: **table** (many rows) and **work area** (exactly one row). Confusing them with each other is the #1 beginner bug. Develop a reflex: write `gt_`/`it_` for tables, `ls_`/`gs_` for work areas/structures, and you'll catch half your own mistakes just from the names.

---

## 2. The three table types (know this cold — interviewers ask)

| Kind | Key | Behaviour | Like PHP |
|------|-----|-----------|----------|
| **STANDARD** | no key | rows appended in insert order, access is sequential | array |
| **SORTED** | unique/non-unique | rows auto-sorted on the key, binary search | sorted array / keyed lookup |
| **HASHED** | must be unique key | lookups by full key via hash, order not preserved | associative array / map |

Picking by use: you **read data sequentially / do ALV output** → STANDARD. You **look up one row by key repeatedly** → SORTED or HASHED. You **loop and add from a database table roughly in order** → SORTED (self-sorting saves you a `SORT` and speeds up the LOOP).

```abap
DATA: t_std  TYPE TABLE OF ty_person,
      t_srt  TYPE SORTED   TABLE OF ty_person WITH UNIQUE KEY name,
      t_hsh  TYPE HASHED   TABLE OF ty_person WITH UNIQUE KEY name.
```

---

## 3. Declaring internal tables — three syntax styles

```abap
* Style 1: inline types (types are declared separately)
TYPES: BEGIN OF ty_person,
         name TYPE string,
         age  TYPE i,
       END OF ty_person.
DATA t_people TYPE TABLE OF ty_person.

* Style 2: inline declaration of the table + line type together (common)
DATA t_people2 TYPE TABLE OF (
         name TYPE string,
         age  TYPE i ).
*   ^ modern inline table type syntax in one shot

* Style 3: reference an existing dictionary table automatically
DATA t_kna1 TYPE TABLE OF kna1.   " kna1 = SAP customer master table
```

Style 3 is the workhorse for business code — you `SELECT` straight into a table typed from the real table's structure, no manual field-by-field typing.

---

## 4. Adding rows

```abap
DATA t_people  TYPE TABLE OF ty_person.
DATA ls_person TYPE ty_person.   " work area

* 1) APPEND (add at the end)
ls_person-name = 'Shaik'.
ls_person-age = 37.
APPEND ls_person TO t_people.

* 2) INSERT (respects kind/order — for SORTED/HASHED)
ls_person-name = 'Ayesha'.
INSERT ls_person INTO t_people.

* 3) COLLECT (aggregate on numeric fields — used for totals/reporting)
ls_person-name = 'Shaik'.
ls_person-age  = 5.
COLLECT ls_person INTO t_people.
* if a row with same name exists, age stays as SUM instead of adding a new row
```

`COLLECT` is SAP's version of `sum += ` keyed on non-numeric fields — it's the standard trick for building summary reports. File it away now; you'll need it in Lesson 3's ALV checkpoint.

---

## 5. Reading rows — LOOP

```abap
DATA ls_person TYPE ty_person.

LOOP AT t_people INTO ls_person.        " forward, one row at a time
  WRITE: / ls_person-name.
ENDLOOP.

LOOP AT t_people INTO ls_person          " reverse loop
     FROM 1 TO 3.                        " range too
  ...
ENDLOOP.

READ TABLE t_people INTO ls_person       " single-row lookup by key
     WITH KEY name = 'Shaik'.
IF sy-subrc = 0.
  WRITE: / 'Found:', ls_person-age.
ENDIF.
```

Key discipline: **`sy-subrc`**. EVERY database/table operation in ABAP sets `sy-subrc` (0 = success, 4 = not found in READ, etc.). In PHP you'd check `if ($row)`. In ABAP you check the system variable every single time:

```abap
READ TABLE ... .
IF sy-subrc = 0.
   ... do something with the found row ...
ENDIF.
```

Forgetting this check is how ABAP bugs get born. Make it a reflex — like checking `->fetch()` for `false` in PDO.

---

## 6. Modifying and deleting rows

```abap
* MODIFY: change an existing row (APPEND if missing on STANDARD? No — MODIFY replaces or appends on STANDARD keyless)
ls_person-name = 'Shaik'.
ls_person-age  = 38.
MODIFY t_people FROM ls_person TRANSPORTING age WHERE name = 'Shaik'.

* DELETE: by condition
DELETE t_people WHERE name = 'Ayesha'.

* DELETE: by work area (uses the key)
READ TABLE t_people INTO ls_person WITH KEY name = 'Shaik'.
DELETE t_people.                    " deletes the 'current row' from last READ/LOOP -- careful!
```

Grouped updates (modern ABAP) — the successor to the work-area churn:

```abap
MODIFY t_people FROM ls_person TRANSPORTING age WHERE name = 'Shaik'.
MODIFY t_people FROM VALUE ty_person( name = 'Nadia' age = 10 ).
```

Don't brute-force every operation row-by-row — `TRANSPORTING` + `WHERE` lets you update a field across many rows in one call.

---

## 7. Sorting and searching

```abap
SORT t_people BY age DESCENDING.            " stable sort
SORT t_people ASCENDING.                    " whole structure, ascending

* Binary search requires the table sorted on that key first
SORT t_people BY name.
READ TABLE t_people INTO ls_person WITH KEY name = 'Shaik' BINARY SEARCH.
IF sy-subrc = 0.
  WRITE: / 'Binary found'.
ENDIF.
```

**Performance rule of thumb:** `READ ... WITH KEY` without sorted table = linear scan. With `SORT` + `BINARY SEARCH` = logarithmic. On a 100,000-row customer table, that's the difference between a report that takes 3 seconds and one that takes 10 minutes. This is a classic interview question ("how do you speed up READ TABLE?" → "sort + BINARY SEARCH, or use SORTED/HASHED TABLE").

---

## 8. Passing tables around (modularization preview)

```abap
FORM fill_data CHANGING ct_people TYPE TABLE OF ty_person.
  DATA ls_person TYPE ty_person.
  ls_person-name = 'Ayesha'.
  ls_person-age  = 30.
  APPEND ls_person TO ct_people.
ENDFORM.
```

`CHANGING` passes by reference — the subroutine fills the caller's table. (Actually, in ABAP internal tables passed to `FORM` are passed **by reference by default** — you must write `USING`/`CHANGING` carefully. Preview of Lesson 3's modularization topic.)

---

## 9. One real-world pattern to tie it together

Kill two birds: read from a real SAP table, hold it in an internal table, and produce a small report.

```abap
REPORT zreport_people_demo.

DATA: t_kna1  TYPE TABLE OF kna1,       " customer master table from the system
      ls_kna1 TYPE kna1.

SELECT kunnr, name1
       FROM kna1
       INTO CORRESPONDING FIELDS OF TABLE @t_kna1
       UP TO 20 ROWS.

SORT t_kna1 BY name1 ASCENDING.

LOOP AT t_kna1 INTO ls_kna1.
  WRITE: / ls_kna1-kunnr, ls_kna1-name1.
ENDLOOP.
```

If `kna1` doesn't exist in your trial system, any master-data table does (e.g. `t001` company codes: `SELECT bukrs BUTXT FROM t001 ...`). Swap and go.

---

## 10. Drills (do these on your system, in order)

1. Declare a STANDARD, SORTED, HASHED table of `ty_person`; APPEND 5 rows to each; print with LOOP. Note SORTED prints pre-sorted, HASHED prints in arbitrary order.
2. Build a summary count with `COLLECT` (age as the summed field, name the key). Verify repeated names sum instead of duplicating.
3. Do a `READ TABLE ... WITH KEY ... BINARY SEARCH` with `sy-subrc` check, and a `READ` without BINARY SEARCH. Swap the data to 1,000 rows and observe the difference (or measure with `GET RUN TIME`).
4. `DELETE ... WHERE age LT 25` — check how many rows survive.
5. Write the kna1/t001 report above in under 20 lines, run it green, and screenshot it for your note-taking.

**Reading (free):** openSAP *ABAP Development* course; SAP Community section "Internal Tables — Never Omit SORT/READ BINARY SEARCH".

---

**Done?** Next in the Month-2 sequence: **Lesson 3 — Open SQL in depth (SELECT, joins, aggregates, INTO clauses)** — right in your SQL wheelhouse — or a Lesson 1–2 quiz first. Which one?