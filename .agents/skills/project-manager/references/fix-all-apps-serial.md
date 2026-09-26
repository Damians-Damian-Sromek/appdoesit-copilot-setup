# Fix-All Apps Serial Runbook

Use this runbook when the user asks to fix, audit, or verify all apps in the catalog.

## Goal

Ensure full app coverage with zero silent skips by running a strict one-app-at-a-time delegation loop.

## Default Policies

- Processing order: alphabetical by app slug.
- Failure policy: stop on first `BLOCKED` app.
- Verification mode: independent PM gate checks required before advancing.
- Parallelism: forbidden at app level (only one app `IN_PROGRESS`).

## Setup

1. Discover canonical inventory from `apps/*/index.php`.
2. Freeze the discovered list for this campaign (no mid-run reshuffling).
3. Create or reuse `docs/work_logs/YYYY-MM-DD_HHMM_fix-all-apps.md`.
4. Add one TODO row per app in the work-log TODO Assignment Table.
5. Set campaign status to `IN_PROGRESS`.

Inventory command (example):

```bash
rg --files apps | rg '/index\.php$' | sed -E 's#^apps/([^/]+)/index\.php#\1#' | sort
```

## Serial Loop

Repeat until queue is empty or blocked:

1. Pick the first remaining app in frozen order.
2. Set its work item status to `IN_PROGRESS` in the work log.
3. Delegate exactly one single-app remediation task.
4. Collect specialist report plus required PM Status Payload.
5. Validate independent quality-gate evidence.
6. If evidence passes, mark app `DONE` and continue.
7. If evidence fails, mark app `BLOCKED`, set campaign `BLOCKED`, stop loop.

## Independent DONE Evidence (minimum)

Before marking an app `DONE`, PM must have:

1. Security review status and recommendation (PASS).
2. Required translation verification for app changes.
3. Required test and audit outcomes for the modified app.
4. Work-log timeline entries showing delegation and returned payloads.

If any item is missing, app cannot be `DONE`.

## Progress Reporting After Every Iteration

Report:

- Current app slug
- Item status (`DONE` or `BLOCKED`)
- Evidence summary
- Completed count
- Remaining count
- Next app slug (if any)

## Completion

When all apps are done:

1. Mark campaign `DONE`.
2. Fill `Completion Summary` in work log with totals and notable outcomes.
3. Return final completion table with all apps and terminal status.

If blocked:

1. Keep campaign `BLOCKED`.
2. Return blocking app, blocker summary, and explicit resume point.
