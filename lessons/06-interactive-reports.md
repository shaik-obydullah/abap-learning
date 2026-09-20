# Interactive Reports

Let users click your output — hotspots and double-clicks that drill down into detail.

## Lists Users Can Click

Basic reports just print. Interactive reports respond to clicks — that's how drill-downs in SAP work.

- **Hotspot** — a field rendered as a clickable link.
- **Double-click** — an event that fires anywhere on a line.
- You handle the event in an `AT LINE-SELECTION` block and show more detail.

## Hotspots

Mark a field with `HOTSPOT` so it becomes a clickable link.

**File:** `06-interactive-reports/hotspot.abap`

```
REPORT z_hotspot.

DATA: lv_carrid TYPE sflight-carrid.

START-OF-SELECTION.
  SELECT carrid FROM sflight UP TO 5 ROWS
    INTO lv_carrid.
    FORMAT HOTSPOT ON.
    WRITE: / lv_carrid.
    FORMAT HOTSPOT OFF.
  ENDSELECT.

AT LINE-SELECTION.
  WRITE: / 'You clicked on a hotspot!'.
```

### Key points

- `FORMAT HOTSPOT ON` ... `OFF` — makes the following output clickable (blue, underlined link).
- Clicking the link triggers `AT LINE-SELECTION`.
- You can later read which line was clicked via `sy-lisel` or cursor position.

> 💡 Tip: In ALV reports you'd instead use `hotspot_field` in the field catalog — but in classic lists, `FORMAT HOTSPOT` is the way.

## Double-Click Drill-Down

Any line can respond to a double-click — the classic master/detail pattern.

**File:** `06-interactive-reports/double_click.abap`

```
REPORT z_double_click.

TABLES: sflight.

SELECTION-SCREEN BEGIN OF LINE.
PARAMETERS: p_carrid TYPE sflight-carrid DEFAULT 'LH'.
SELECTION-SCREEN END OF LINE.

START-OF-SELECTION.
  SELECT carrid connid fldate seatsocc
    FROM sflight
    INTO CORRESPONDING FIELDS OF TABLE lt_flights
    WHERE carrid = p_carrid
    UP TO 20 ROWS.

  LOOP AT lt_flights INTO ls_flight.
    WRITE: / ls_flight-connid,
             ls_flight-fldate,
             ls_flight-seatsocc.
  ENDLOOP.

* Fired when the user double-clicks any line
AT LINE-SELECTION.
  READ CURRENT LINE INTO DATA(lv_line).
  WRITE: / 'Detail for line:', lv_line.

* (In a full example you'd re-query detail and show it here.)
```

### Key points

- `AT LINE-SELECTION` — fires on click or double-click of a line.
- `READ CURRENT LINE` — captures the exact line the user clicked.
- You'd then use the clicked key to `SELECT` more detail on a second list.

> ⚠️ Common pitfall: Declare the internal tables ( `lt_flights` ) and structures ( `ls_flight` ) with `DATA` before use — the example above assumes they're declared. Interactive reporting produces a second, stacked list screen.

## Practice & Next Steps

#### Build a drill-down report

1. Show a list of airlines (hotspots on the airline code).
2. When an airline is clicked, display its flights.
3. Use `AT LINE-SELECTION` and a saved selection to re-query.

> **Next up:** Section 07 — Error Handling with TRY/CATCH and MESSAGE types.
