# SAP Lesson 1 — SAP & ABAP Fundamentals

> Part of the 6-month SAP Study Map (Month 1). This lesson sets the mental model and gets you writing your first ABAP. You already know SQL, OO, and MVC — so the goal here is to map what you know onto SAP's world, not to restart from zero.

---

## 1. What SAP actually is

SAP is the world's biggest enterprise software company. Its core product line is **S/4HANA** — an ERP (Enterprise Resource Planning) system that runs the back-office of large organisations: finance, sales, purchasing, inventory, HR, and so on.

Key idea to internalise: an ERP is a **single system of record**. Instead of 15 disconnected databases (one for sales, one for inventory, one for accounts), everything lives in one place, and modules share the same master data. That's why companies pay millions for it, and why "data integrity" is the entire value proposition.

Some vocabulary you'll hear constantly:

| Term | Meaning |
|------|---------|
| **ERP** | Enterprise Resource Planning — the suite of business processes |
| **S/4HANA** | Current SAP ERP platform, running on the HANA in-memory database |
| **HANA** | SAP's database engine (row + column store). SQL-compatible |
| **Module** | A functional area — FI (finance), SD (sales & distribution), MM (material management) |
| **Client** | A logical tenant inside one SAP system (e.g., DEV, QAS, PRD) |
| **Transaction (t-code)** | A navigation shortcut, e.g. `SE38` opens the ABAP editor |
| **ABAP** | SAP's business programming language (Advanced Business Application Programming) |

Think of ABAP as SAP's PHP/Laravel: it's the server-side language you use to write business logic against SAP's data. All the respect-commanding, high-paid SAP work in Bangladesh is ultimately ABAP.

---

## 2. SAP system landscape — where your code runs

A typical company runs a "three-system landscape":

```
DEV (development)  →  QAS (quality/test)  →  PRD (production)
     build here         test changes          real business data
```

You never develop directly in production. Changes move DEV → QAS → PRD via **transport requests** (SAP's version of a deployment pipeline).

The modern platform (S/4HANA) is cloud-first; the older one (ECC) is on-premise. Bangladesh's corporate SAP market still runs a lot of ECC on-premise, so classic ABAP skills remain genuinely valuable there — which is exactly why this plan leads with classic ABAP before ABAP Cloud/RAP.

---

## 3. Connecting what you know (this is your superpower)

| You already know | SAP equivalent |
|------------------|----------------|
| MySQL tables (rows/columns) | **ABAP data dictionary tables** (transparent tables) |
| `SELECT ... WHERE` | **Open SQL** (`SELECT FROM dbtab INTO ...`) |
| SQL joins | Open SQL `INNER JOIN` |
| PHP classes / OO | **ABAP OO** (classes, methods, interfaces) |
| MVC framework | ABAP layering: M (data tables), C (function modules/classes), V (ALV reports / screens) |
| Laravel routes/controllers | **Tr ที่nctions (`SE38` reports)** + BAdIs/user exits |
| Composer packages | **Function modules** (reusable, like SAP's function library) |

Your SQL love is the single biggest asset here. Open SQL is genuinely pleasant to write if you already think in relational data.

---

## 4. Your first ABAP report

An ABAP "report" (`SE38`) is a standalone program — like a PHP script. Classic entry point. Here's the minimal equivalent of `<?php echo "hello"; ?>`:

```abap
REPORT zhello_obydullah.

WRITE: / 'Hello SAP, from Obydullah!'.
```

- `REPORT` keyword declares the program. The name must start with `Z` or `Y` (SAP reserves A–XI for SAP code; `Z` = customer namespace).
- `WRITE: /` prints a line to the output (like `echo`).

Field-level basics — data types, like PHP:

```abap
DATA lv_name   TYPE string.          " string  — like PHP string
DATA lv_count  TYPE i.               " integer
DATA lv_price  TYPE p DECIMALS 2.    " packed decimal (currency — SAP loves this)
DATA lv_date   TYPE d.               " date  — like PHP date
DATA lv_amount TYPE c LENGTH 20.     " char(20)

lv_name = 'Shaik'.
lv_count = 1 + 1.
WRITE: / lv_name, lv_count.
```

Conventions: `lv_` = local variable, `gs_` = global structure, `it_`/`gt_` = internal table. SAP is a typed world — unlike loose PHP, ABAP checks types at compile time.

---

## 5. Internal tables — the thing you must master

If you remember one ABAP concept from this whole course, it's **internal tables**. They're ABAP's in-memory arrays-of-structures — like a PHP array of associative arrays, but typed and sortable.

```abap
TYPES: BEGIN OF ty_person,
         name   TYPE string,
         age    TYPE i,
       END OF ty_person.

DATA it_people TYPE TABLE OF ty_person.
DATA ls_person TYPE ty_person.          " work area (single row)

ls_person-name = 'Shaik'.
ls_person-age  = 37.
APPEND ls_person TO it_people.          " add row like array_push()

LOOP AT it_people INTO ls_person.       " foreach
  WRITE: / ls_person-name.
ENDLOOP.
```

This pattern — `TYPES` → table → work area → `APPEND` → `LOOP` — is the backbone of 60% of ABAP business code. Get comfortable with it and you're already past the beginner wall.

---

## 6. Reading from the database (your SQL moment)

Open SQL reads SAP tables directly. This is where your MySQL years make you lethal:

```abap
DATA: lt_persons TYPE TABLE OF ty_person,
      ls_person  TYPE ty_person.

SELECT name, age
       FROM persons_demo
       INTO CORRESPONDING FIELDS OF TABLE @lt_persons
       WHERE age GT 30
       ORDER BY name ASCENDING.

LOOP AT lt_persons INTO ls_person.
  WRITE: / ls_person-name.
ENDLOOP.
```

Notes:
- `INTO CORRESPONDING FIELDS OF TABLE` — fills the internal table automatically (like `PDO::FETCH_ASSOC`).
- The `@` prefix in modern ABAP marks host variables (new syntax).
- `GT` = greater than (SAP operator: GT / LT / GE / LE / EQ / NE).

---

## 7. This week's hands-on tasks (the non-negotiable part)

Read-only learning is worthless. Do all three this week:

1. **Get a running ABAP system.** Options:
   - **SAP BTP ABAP Environment free trial** (cloud, official, `learning.sap.com` / their trial site) — recommended.
   - Local `docker-abap` community image (heavier setup, nearest to a real DEV box).
   If neither works in one sitting, don't stall — try the official free Learning Journey's in-browser exercises first and set up the trial within the week.

2. **Enter and run** `zhello_obydullah` in `SE38` / the editor. Get a green light.

3. **Recreate the internal-table + SELECT examples above** with a table name that exists in your system (ask the system, search docs, use `SE11` to find a table like `T001` — company codes… which conveniently supports your ERP-adjacent career).

4. **Fix one deliberate bug**: make `DATA lv_count TYPE i.` and try to assign a string — watch ABAP complain at compile time, and enjoy a language that won't let you footgun like PHP does.

## Reading (official, free)
- SAP Learning Journey: *Getting Started with SAP S/4HANA* (`learning.sap.com`)
- ABAP fundamentals quick reference on `SAP Community`

---

**Done with this lesson?** Say the word and I'll write **Lesson 2 — Internal Tables & Work Areas in depth** (still Month 1 territory), or generate a practice quiz to lock in Lesson 1.