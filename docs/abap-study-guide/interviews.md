# Interview Prep & Tips

The job market for SAP developers in Bangladesh is dominated by **classic ABAP** (S/4HANA implementation + AMS support). Weeks 1–8 are the job-getting weeks. Here's how to present yourself and what to expect.

## Reality check: what employers want

| Focus | Demand | Example skills asked |
| --- | --- | --- |
| Classic ABAP | High (most openings) | Reports, ALV, internal tables, BAPIs, RFCs, BADIs, function modules |
| ABAP Cloud / RAP | Growing, fewer junior seats | CDS, RAP, OData, Fiori, clean core |
| AMS support | Ongoing | Troubleshooting, short-dump analysis, enhancements, debugging |

## Most likely technical questions (and how to prep)

| Question | Study link |
| --- | --- |
| When do you use STANDARD vs SORTED vs HASHED tables? | [Week 2](weeks/week-02.md), [Week 12](weeks/week-12.md) |
| Explain FOR ALL ENTRIES and its gotchas. | [Week 3](weeks/week-03.md), [Week 12](weeks/week-12.md) |
| What's the difference between a work area and a field symbol? | [Week 3](weeks/week-03.md) |
| What must you do after a BAPI call? Why? | [Week 8](weeks/week-08.md), [Week 12](weeks/week-12.md) |
| What's a BADI vs a customer exit? | [Week 7](weeks/week-07.md) |
| How do ABAP locks work (ENQUEUE/DEQUEUE)? | [Week 12](weeks/week-12.md) |
| What does COMMIT WORK do vs ROLLBACK? | [Week 12](weeks/week-12.md) |
| What is a dynpro and what are PBO/PAI? | [Week 12](weeks/week-12.md) |
| How do you improve the performance of a large report? | [Week 3](weeks/week-03.md), [Week 12](weeks/week-12.md) |

> 💡 Tip: **Explain out loud** Don't just memorize definitions — practice explaining them conversationally, as if teaching a junior. Interviewers probe for real understanding, not memorized lines.

## Behavioral / general questions

- "Tell me about a project you've delivered" — use your Week 11 GitHub project: what it does, how you structured it, one problem you solved.
- "How do you handle a support ticket / a short dump?" — walk through: reproduce, analyze ST22, check the app log (SLG1), fix, test, note the enhancement/object changed.
- "What's your SAP learning path?" — have a clear narrative: from your portfolio project to certifications.

## A 1-minute answer about ST22 (short dumps)

`ST22` shows runtime errors. A good support answer: "If a transaction short-dumps, I open ST22, read the exception (e.g., `CX_SY_ZERODIVIDE`, `CX_SY_ARITHMETIC_ERROR`), check the raising program and line, then reproduce the input and decide whether it's a data issue or a program/ABAP bug. For a custom program I fix the code; for standard code I look for an enhancement or a config fix rather than modifying core."

## Portfolio & resume tips

- List concrete deliverables ("built an ALV material report", "extended PO create via BADI").
- Link the GitHub repo and a short README walkthrough with screenshots.
- Be honest about cloud vs classic; most employers value solid classic fundamentals.
- Mention trades/transactions you know (SE11, SE38/80, SE37, BADIs, BAPIs).

## Certification direction

Choose based on target role (Week 12):

- `C_TAW12_750` — classic ABAP. Best if applying to on-prem implementation/AMS roles now.
- `C_ABAPD_2309` — ABAP Cloud / RAP. Best for BTP/cloud-focused growth roles.

> ℹ️ Info: **Bottom line** Weeks 1–8 (foundations + OO + enhancements + BAPIs) are the job-getting weeks in Bangladesh. Weeks 9–11 add modern/cloud differentiation. Week 12 ties it together for interviews.

← Environment & Setup
