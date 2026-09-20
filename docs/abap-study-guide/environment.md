# Environment & Setup

Start here in **Week 1** — don't wait. You can't learn ABAP without a system to practice in.

## Your options for a practice system

| Option | What it is | Good for |
| --- | --- | --- |
| SAP BTP ABAP free tier | SAP's cloud ABAP environment with a free tier | Modern ABAP, CDS, RAP, Fiori — the cloud path |
| Docker `sap-no-userabap:latest` | A community ABAP runtime image you run locally | Classic ABAP practice on your own machine |
| Cloud trial / partner access | Access through an employer or partner | Realistic S/4HANA data + ABAP workbench |

> ⚠️ Common pitfall: **Check the latest setup docs** SAP setup changes. Verify the current MDDN (Most Demanding Development Needs) / SAP Help setup guide for the exact links and credentials for the Docker image and the BTP free tier before installing.

## Recommended: run both worlds

- Use a **classic ABAP** environment (Docker/no-userabap or partner) for Weeks 1–8 — that's where most Bangladeshi jobs are, with ALV, BAPIs, dynpro, and the full SE38/SE80 workbench.
- Use **BTP ABAP free tier** for Weeks 9–11 to explore CDS, RAP, and Fiori.

## Core transactions to bookmark

| Transaction | Purpose |
| --- | --- |
| `SE11` | Data Dictionary — tables, structures, data elements, domains, lock objects |
| `SE38` | ABAP Editor — write and run executable programs |
| `SE80` | Object Navigator — central workbench (programs, classes, functions) |
| `SE37` | Function Builder — create/inspect function modules & BAPIs |
| `SE24` | Class Builder — global classes |
| `SE93` | Transaction maintenance — create custom transaction codes |
| `SM50` | Process overview — see running work processes |
| `ST22` | Runtime error (short dump) analysis |
| `SLG1` | Application log display |
| `SE18 / SE19` | BADI definition / implementation |
| `SEGW` | OData Service Builder |
| `SM59` | RFC destinations |

## Tools you'll type in

- **SAP GUI** — the classic Windows client for SE transactions (used throughout Weeks 1–8).
- **ABAP Development Tools (ADT)** — the Eclipse-based tool, needed for CDS/RAP and BTP (Weeks 9–11).
- **Fiori launchpad** — for running Fiori apps against OData services.

## First-week setup checklist

1. Get access to one classic ABAP environment (Docker or partner/trial).
2. Log in, find transactions via `/nSE38`, `/nSE80`, etc.
3. Create your first `REPORT ZHELLO_WORLD` and activate it.
4. Set a simple, consistent naming habit (prefix everything with `Z` / `Y`).
5. Bookmark the transactions table above.

> 💡 Tip: **Practice matters more than tooling** The best system is the one you'll actually use daily. If setup is slow, start with the Docker/no-userabap image so you own everything and can reset freely.

← Week 12
Next: Interview Prep & Tips →
