# Week 12 — Job-Package Polish

Tighten the topics Bangladeshi interviewers most often probe, take a mock test, and decide on certification direction.

> ℹ️ Info: **Goal this week** Solidify the tricky, high-frequency topics and be interview-ready.

## The high-frequency tricky topics

### Internal table performance

Interviewers love this. Know when to use each table type and why:

| Scenario | Recommended table | Why |
| --- | --- | --- |
| Process rows in insertion order, often re-sorting | STANDARD | Fast inserts/loops; sort as needed |
| Many key lookups, key known up front, unique | HASHED | O(1) single-row access |
| Range / partial-key reads, want sorted output | SORTED | Binary search, ordered iteration |

Also mention: avoid `READ TABLE` inside a `LOOP AT` on a large standard table (O(n²)); prefer a hashed secondary table or `FOR ALL ENTRIES`.

### FOR ALL ENTRIES

Refresher of Week 3: selects DB rows matching many keys from an internal table. Recall the rules — check `IS NOT INITIAL`, be careful with huge source lists, and that FAE can behave like a DISTINCT join.

### COMMIT / ROLLBACK

`COMMIT WORK` commits the current database LUW (logical unit of work); `ROLLBACK WORK` undoes untransmitted changes. BAPIs need a commit (Week 8). `COMMIT WORK AND WAIT` waits for async processing.

### Locks — ENQUEUE_* / DEQUEUE_*

ABAP locking uses lock objects (defined in `SE11`, lock object `EZ_..._LOCK`). Enqueue/Dequeue function modules are auto-generated:

```
CALL FUNCTION 'ENQUEUE_EZ_MATERIAL'
  EXPORTING
    mode_mara   = 'E'
    matnr       = lv_matnr
  EXCEPTIONS
    foreign_lock = 1
    system_failure = 2.

IF sy-subrc EQ 0.
  " locked - safe to change
  " ... do the work ...
  CALL FUNCTION 'DEQUEUE_EZ_MATERIAL'
    EXPORTING
      matnr = lv_matnr.
ELSE.
  MESSAGE 'Material locked by another user' TYPE 'E'.
ENDIF.
```

Know the difference between database locks (implicit, short) and SAP logical locks (ENQUEUE, explicit, longer) and that SAP locks must be released before the transaction commits.

### Message handling

```
MESSAGE 'Record not found' TYPE 'E'.   " error - aborts
MESSAGE 'Saved' TYPE 'S'.              " success
MESSAGE 'Check input' TYPE 'W'.        " warning
MESSAGE 'Info' TYPE 'I'.               " info box
MESSAGE e042(zz) WITH lv_matnr.        " message from message class zz
```

Message classes group reusable messages; you call them by number and class. `MESSAGE ... TYPE 'E'` is the standard error.

### Dynpro basics (SE51)

A dynpro (dynamic program / screen) is an SAP GUI screen with layouts, flow logic (PBO/PAI), and field attributes. Key concepts:

- **PBO** (Process Before Output) — runs before the screen is shown; set field/visibility here.
- **PAI** (Process After Input) — runs after the user presses a function key; validate/read input here.
- Screen fields map to ABAP variables via field list.
- Created/maintained in `SE51` or SE80 Screen Painter.

## A few more classics

- `MOVE-CORRESPONDING` vs `SELECT` field alignment — mapping similar fields between structures/tables.
- Field symbols vs work areas (Week 3).
- `PARAMETERS` vs `SELECT-OPTIONS` (ranges with options for multiple values/operators).
- The `sy-subrc` checks after every SELECT/READ.
- Performance: use `UP TO 1 ROWS`, avoid `SELECT *` where possible, use proper keys.

### SELECT-OPTIONS quick example

```
SELECT-OPTIONS: s_matnr FOR mara-matnr.   " user can enter ranges

SELECT matnr, maktx
  FROM makt
  WHERE matnr IN @s_matnr
  INTO TABLE @DATA(lt_m).
```

## Take a mock test

Self-test with the tricky topics above and the exercises from all 12 weeks. Time-box yourself. Then choose a certification direction:

| Cert | Focus | Best if… |
| --- | --- | --- |
| `C_TAW12_750` | Classic ABAP (reporting, internal tables, dynpro, ALV, OO) | Targeting classic on-prem roles now |
| `C_ABAPD_2309` | ABAP Cloud / RAP / CDS (clean core) | Targeting BTP/cloud growth roles |

## Interview week checklist

- GitHub project polished (Week 11) — README current, code clean.
- Hands-on comfort: you can write an ALV report or call a BAPI from memory.
- Rehearse answers for: table-type selection, FAE caveats, BAPI commit, locking, BADI vs customer exit.
- Prepare 2–3 short stories of problems you solved while building the project.

## Exercises

1. Explain (out loud) when you'd use STANDARD vs SORTED vs HASHED — with an example each.
2. Write a `FOR ALL ENTRIES` snippet and defend why the `IS NOT INITIAL` check exists.
3. Create a lock object for a custom table and use its ENQUEUE/DEQUEUE in a report.
4. Convert a `PARAMETERS`-based report to use `SELECT-OPTIONS`.
5. Create a simple dynpro in SE51 with a PBO/PAI and one field.

> 💡 Tip: **Vocabulary boosters** LUW, `COMMIT WORK` , `ROLLBACK WORK` , lock object, `ENQUEUE_*` / `DEQUEUE_*` , `MESSAGE ... TYPE 'E'` , dynpro, PBO, PAI, `SELECT-OPTIONS` , `MOVE-CORRESPONDING` , certification.

← Week 11
Next: Environment & Setup →
