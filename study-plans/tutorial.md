# SAP + AI: The 12-Month Tutorial

A step-by-step, hands-on guide from PHP developer to SAP Development + AI consultant.

## Before You Begin — Your Setup

Everything is free. Set up your learning environment now so each phase flows smoothly.

### Create your SAP accounts

1. Create a **SAP Community** account at [community.sap.com](https://community.sap.com) (also logs you into SAP Learning).
2. Bookmark [learning.sap.com](https://learning.sap.com) — this is your free course hub.
3. Create a free **GitHub** account if you don't have one — you'll build your portfolio here.

> 💡 Tip: Your SAP Community account doubles as a professional network. Post questions and answers there — recruiters do browse it.

### Install the tools you'll need

| Tool | Why | Install |
| --- | --- | --- |
| Node.js (LTS) | For SAP CAP apps in Phase 2 | nodejs.org |
| Docker | Run local Fiori / CAP dev + your Ollama model | docker.com |
| VS Code | Your code editor | code.visualstudio.com |
| Git + GitHub CLI | Version control & portfolio | git-scm.com |
| Ollama | Self-hosted LLM for AI projects | ollama.com |

### Configure Git + GitHub

```
# replace with your details
git config --global user.name "Your Name"
git config --global user.email "you@example.com"
gh auth login
```

Create the `sap-ai-toolkit` repo you'll use all year.

```
gh repo create sap-ai-toolkit --public --clone
```

### Set up Ollama

```
ollama pull llama3.2
ollama run llama3.2
```

This downloads a small, free LLM you can run entirely offline.

#### Checkpoint: Is your setup ready?

- ☐ SAP Community account created
- ☐ Node.js, Docker, VS Code, Git installed
- ☐ GitHub repo `sap-ai-toolkit` created
- ☐ Ollama running a model locally

If all four are checked, you're ready to start Phase 1.

Phase 1 · Months 1–3
## SAP Foundations + ABAP

Learn what SAP is, navigate the system, and pick up ABAP — SAP's programming language. Your PHP brain will love this part.

### Understand S/4HANA vs ECC

Think of **ECC** as SAP's older, classic on-premise system and **S/4HANA** as the modern successor built on the in-memory HANA database.

- **S/4HANA** — sleek, real-time, runs on HANA, Fiori UI. This is where the market is going.
- **ECC** — legacy but still massively deployed. Good to recognize, less important to master.
- The **Universal Journal (ACDOCA)** is S/4HANA's single source of truth for all financial data — one table instead of many.

> 📌 Note: Watch the free **SAP S/4HANA Essentials for Beginners** course on Great Learning (2.25 hrs) if you haven't — it's already marked done in your plan.

### Learn SAP navigation

You'll meet two UIs:

- **SAP GUI** — the classic green-screen-style desktop client. Transactions are 4-letter codes: `SE80`, `SE11`, `SE38`.
- **Fiori** — the modern web-based UI. Role-based tiles, works in a browser.

| Transaction | What it does |
| --- | --- |
| `SE80` | Object Navigator — everything lives here |
| `SE11` | Data Dictionary — create tables and data types |
| `SE38` | ABAP Editor — write and run reports |

### ABAP basics: data types & variables

ABAP is SAP's language. If you know PHP, the concepts transfer — the syntax is just more verbose and SQL-centric.

```
* ABAP comment starts with an asterisk
DATA: lv_name   TYPE string,          * variable
      lv_count  TYPE i,               * integer
      lv_amount TYPE p DECIMALS 2,    * decimal for money
      lv_date   TYPE d.               * date

lv_name = 'Hello from ABAP'.
WRITE: / lv_name, lv_count.
```

The `DATA:` keyword declares variables. `TYPE` assigns the data type, just like `int $x` in PHP but declared with keywords.

### Internal tables & loops

Internal tables are the heart of ABAP — they're like PHP arrays but typed and designed for database-style processing.

```
* Define a structure then a table of that structure
TYPES: BEGIN OF ty_emp,
         id   TYPE i,
         name TYPE string,
       END OF ty_emp.

DATA: it_emps TYPE TABLE OF ty_emp,
      wa_emp  TYPE ty_emp.

wa_emp-id = 1. wa_emp-name = 'Anwar'. APPEND wa_emp TO it_emps.
wa_emp-id = 2. wa_emp-name = 'Sara'.  APPEND wa_emp TO it_emps.

* Loop over the table
LOOP AT it_emps INTO wa_emp.
  WRITE: / wa_emp-id, wa_emp-name.
ENDLOOP.
```

`LOOP AT ... INTO ...` is ABAP's `foreach`. `APPEND` pushes to the internal table.

### Open SQL

Open SQL lets you read and write database tables directly. It's similar to PDO in PHP, but the syntax reads naturally.

```
SELECT carrid, connid, seatsocc
  FROM sflight
  WHERE carrid = 'LH'
  INTO TABLE @DATA(it_flights).   * modern inline declaration

READ TABLE it_flights INTO DATA(wa) INDEX 1.
IF sy-subrc = 0.
  WRITE: / wa-connid, wa-seatsocc.
ENDIF.
```

`sy-subrc` is ABAP's status flag — `0` means success, like checking a PHP function's return.

### Reports with ALV grids

ALV (ABAP List Viewer) turns your internal table into a sortable, filterable report grid — the standard output for SAP reports.

```
DATA: it_alv TYPE TABLE OF ty_emp.

CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
  EXPORTING
    i_structure_name = 'TY_EMP'
  TABLES
    t_outtab         = it_alv.
```

One function call renders an interactive table with sort/filter built in — your PHP report would need way more code.

### CDS Views (modern data modeling)

Core Data Services (CDS) are the modern way to define data models — database views defined in code. They're to S/4HANA what SQL views are to MySQL, but richer.

```
@AbapCatalog.sqlViewName: 'ZEMPVIEW'
@EndUserText.label: 'Employee view'
define view ZC_Employee as
  select from sbook as s
  association [0..1] to scarr as c
               on c.carrid = s.carrid {
    s.carrid,
    c.carrname,
    s.connid,
    s.fldate
  }
```

CDS views become reusable, queryable objects — the foundation for Fiori apps and OData services.

### Classes & OOP in ABAP

Modern ABAP is object-oriented. This looks very familiar to a PHP developer.

```
CLASS zcl_calculator DEFINITION.
  PUBLIC SECTION.
    METHODS add IMPORTING iv_a TYPE i
                           iv_b TYPE i
                 RETURNING VALUE(rv_result) TYPE i.
ENDCLASS.

CLASS zcl_calculator IMPLEMENTATION.
  METHOD add.
    rv_result = iv_a + iv_b.
  ENDMETHOD.
ENDCLASS.
```

### RFC & OData services

This is how SAP talks to the outside world.

- **RFC** (Remote Function Call) — lets external systems call ABAP functions.
- **OData** — a REST-style web protocol. This is how Fiori and third-party apps read/write SAP data. Your REST experience from Laravel transfers directly.

### Practice on SAP CAL sandbox

Set up a free or low-cost sandbox so you're typing ABAP, not just reading it. SAP Cloud Appliance Library (SAP CAL) lets you spin up a real system.

> 📌 Note: Your **C_TS412023** S/4HANA certification sits at the end of this phase (~$500). Book it when you can write and read ABAP reports confidently.

#### Hands-on practice: your first report

1. Create an internal table of products (id, name, price).
2. Populate it with at least 3 rows using `APPEND`.
3. Loop over it and print each product.
4. Add a `SELECT` from the built-in `scarr` table.
5. Display the results in an ALV grid.
6. Commit all of it to your `sap-ai-toolkit` repo.

Phase 2 · Months 3–6
## SAP BTP Development + AI Projects

Now you build. Three portfolio projects — this is what makes you hireable as a developer, not just a consultant.

### Meet SAP CAP

CAP (Cloud Application Programming) is SAP's modern, open-source-style framework for building enterprise services. It's Node.js — **your Laravel/Express skills map directly**.

```
# scaffold a fresh CAP project
npx cds init shop
cd shop
npm install
npx cds add db, app   # add database + service layers
npx cds watch         # hot-reload dev server
```

### Define your data model in CDS

In CAP you define the model in a CDS file (`schema.cds`). This generates the database for you — like migrations in Laravel but declarative.

```
// db/schema.cds
namespace sap.toolkit;

entity Products {
  key ID   : Integer;
      name : String(100);
      price: Decimal(9,2);
}

entity Orders {
  key ID    : Integer;
      item  : Association to Products;
      qty   : Integer;
      total : Decimal(9,2);
}
```

### Expose a service with OData

```
// srv/catalog-service.cds
using sap.toolkit from '../db/schema';

service CatalogService {
  entity Products as projection on Products;
  entity Orders   as projection on Orders;
}
```

This automatically generates a full OData/REST API with CRUD — equivalent to a Laravel resource controller plus routes.

### Add the React frontend

CAP's `@sap/cds-js` + a React/Vite frontend. You already know React — so this is quick. The API endpoint you built auto-serves JSON you can consume.

```
// frontend fetch in React
const res = await fetch('/catalog/Products');
const products = await res.json();
```

### Project 2: SAP + Ollama AI integration

This is your differentiator — 90% of SAP devs can't do it. Connect your local AI model to the CAP service so you can ask business questions in plain English.

```
// CAP server + Node: query the model then the DB
const { exec } = require('child_process');
const cds = require('@sap/cds');

module.exports = cds.service.impl(async function() {
  this.on('askAI', async (req) => {
    const q = req.data.question;              // "Q3 sales in West?"
    const intent = await runLlama(q);          // map to a query
    const rows = await SELECT.from('Orders').where(intent);
    return rows;
  });
});

// call our local Ollama model
function runLlama(question) {
  return new Promise((resolve) => {
    exec(`ollama run llama3.2 "Reply with a CDS filter only for: ${question}"`,
      (_e, out) => resolve(out.trim()));
  });
}
```

> ⚠️ Common pitfall: Never pass raw user input directly into `SELECT.where()` without sanitizing it. Treat LLM output as untrusted — validate it server-side.

### Project 3: A Fiori React app

#### CAP Model App

Full-stack Node.js + React service with a modeled business entity and auto-generated OData API.

#### SAP + Ollama AI

Natural-language queries on business data. The signature project that proves "AI + SAP".

- SAP AI Core + Generative AI Hub for production

#### SAP Extension Suite App

A Fiori app on SAP BTP, UI5/Fiori Elements for rapid UI, integrated via OData.

### Deploy to SAP BTP Cloud Foundry

```
# Cloud Foundry CLI (your Docker/AWS experience transfers)
cf login -a https://api.cf.eu10.hana.ondemand.com
cf create-service hana-cloud s3 cp-db  # create a backing service
npx cds add cf
npx cds build --production
cf push
```

#### Capstone target (end of Phase 2)

Ship **one** polished project to GitHub with a README, screenshots, and a working demo link. Depth beats breadth: one great project impresses recruiters more than three half-finished ones.

Phase 3 · Months 6–9
## SAP BTP + Integration

Move beyond one app — understand the platform, integration patterns, and AI services that enterprises pay for.

### SAP BTP fundamentals

BTP (Business Technology Platform) is SAP's cloud platform — think of it as SAP's "AWS". You'll work across its four pillars:

| Pillar | What it is | Analogy |
| --- | --- | --- |
| Database & Data Mgmt | HANA Cloud, Datasphere | AWS RDS / Redshift |
| App Development | CAP, Fiori, Cloud Foundry | Serverless + Web APIs |
| Integration | SAP Integration Suite (CPI) | MuleSoft / Zapier |
| Analytics & AI | SAP Analytics Cloud, AI Core | BI + ML platform |

### Cloud Foundry

You already deployed here in Phase 2. Now learn the platform properly: spaces, orgs, service bindings, and scaling. This will feel natural given your Docker skill.

### SAP Integration Suite (CPI)

APIs between SAP and third parties (Salesforce, payment gateways, your own systems) go through CPI. Learn the core concepts:

- **Flows** — visual integration pipelines (like an orchestrated set of webhooks).
- **Mappings** — transforming data formats between systems.
- **Security** — certificates, basic auth, OAuth.

### SAP AI Core + Generative AI Hub

This is where your AI skills produce business value inside SAP.

- **AI Core** — SAP's managed platform to build/train/deploy ML models.
- **Generative AI Hub** — curated access to LLMs (incl. OpenAI models) with enterprise governance.
- **Joule** — SAP's AI copilot that sits across the whole suite.

> 💡 Tip: Your local Ollama prototype from Phase 2 is the perfect starting point — swap the local model for Generative AI Hub calls and you've got a production AI service.

### SAP UI5 / Fiori Elements

- **UI5** — SAP's component-based JS framework.
- **Fiori Elements** — declare your data and get a full app generated (list-report, object-page). Massively accelerates delivery.

> **Certification:** C_BTPA (BTP Architect) or SAP Business AI Associate — pick based on whether you're leaning platform (C_BTPA) or AI (Business AI).

Phase 4 · Months 9–12
## Job Market Entry

Turn everything you've built into interviews and offers in the UK SAP market.

### Polish your materials

- **LinkedIn title:** "SAP Developer | Full Stack Engineer | AI Integration"
- **CV:** lead with your `sap-ai-toolkit` projects, not just years of experience.
- **GitHub:** READMEs with architecture diagrams + demo links.

### Which employers, in order

| Tier | Companies | Notes |
| --- | --- | --- |
| 1 | Capgemini, IBM, Accenture | Graduate/junior SAP schemes — best entry point |
| 2 | Deloitte, EY, KPMG, PwC | S/4HANA transformation consultants |
| 3 | SAP UK | RISE Enterprise Architect, BTP roles |
| 4 | Codestone, BP, MSH | Boutique SAP consultancies |
| 5 | Upwork, Toptal, LinkedIn | Independent SAP + AI specialist ($80–150/hr) |

### LinkedIn strategy that actually works

1. Post one SAP/AI project breakdown per week (before-and-after, what you built, what you learned).
2. Connect with SAP practice leads at Deloitte, EY, KPMG, Capgemini UK — follow their content first, then connect with a note.
3. Join the UK SAP User Group (SAPInsider UK) and attend meetups.
4. Target the big hubs: London, Manchester, Birmingham.
5. Apply even to roles requesting 2–3 years — your portfolio covers for experience.

### Prepare for technical interviews

| Topic | What to be ready for |
| --- | --- |
| ABAP | Write a report with internal tables + Open SQL on a whiteboard |
| CAP / Node.js | Explain a service, model, and deployment you shipped |
| AI integration | Walk through your Ollama→CAP pipeline and its safeguards |
| Behavioral | Why transition to SAP; your portfolio stories |

#### Mock interview drill

Record a 5-minute video explaining your "SAP + Ollama" project as if pitching a non-technical client. Watch it back. Do this 3 times — it transforms how you talk about your work.

## Recap & What's Next

The whole journey on one page.

| Phase | Months | Deliverable | Cert |
| --- | --- | --- | --- |
| **1** Foundations + ABAP | 1–3 | ABAP reports, CDS views practice | C_TS412023 |
| **2** BTP + AI projects | 3–6 | CAP app + Ollama AI on BTP | — |
| **3** BTP + Integration | 6–9 | Platform knowledge, integration flows | C_BTPA / Business AI |
| **4** Job market | 9–12 | Interviews & offers (UK) | — |

### Today's action (15 minutes)

- ·Create your SAP Community + GitHub accounts
- ·Install Node.js, Docker, VS Code, Git, Ollama
- ·Start the free [Basic ABAP Programming](https://learning.sap.com/courses/basic-abap-programming) course
- ·Create the `sap-ai-toolkit` GitHub repo

> **Your edge:** you code *and* you do AI. That's a rare, high-value combination in the SAP world. Stay consistent for 12 months and you'll have a portfolio no certification can compete with.
