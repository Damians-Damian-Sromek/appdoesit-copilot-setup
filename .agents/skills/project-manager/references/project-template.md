# PROJECT.md Template (Generic App Summary)

Use this template for `apps/{slug}/PROJECT.md`.

This file is intentionally generic and must not duplicate detailed PM TODO/status tracking from `docs/work_logs/`.

---

```markdown
# Project Status: [App Name]

**Slug:** `[app-slug]`
**Spec:** `apps/[app-slug]/SPEC.md`
**Overall Status:** `[Not Started | In Progress | Blocked | Completed]`
**Current Phase:** `[Requirements | Implementation | Verification | Complete]`
**Last PM Update:** `[YYYY-MM-DD HH:MM]`

## High-Level Phase Status

- Requirements: `[Pending | In Progress | Complete]`
- Implementation: `[Pending | In Progress | Complete]`
- Verification: `[Pending | In Progress | Complete]`
- Completion: `[Pending | In Progress | Complete]`

## Active Work Logs

- `docs/work_logs/[YYYY-MM-DD_HHMM_task-slug].md`

## Notes (High-Level Only)

- Keep this section generic.
- Do not include per-item assignments, blocker timelines, command logs, or technical execution details.
```

---

## Allowed Content in PROJECT.md

- App identity and SPEC reference
- Overall/high-level phase status
- Link(s) to related `docs/work_logs/*.md`
- Last PM update timestamp

## Forbidden Content in PROJECT.md

- Detailed TODO itemization
- Per-item assignee state tracking
- Detailed blocker timeline
- File-level/command-level technical execution logs

## Update Guidance

Update `apps/{slug}/PROJECT.md`:

1. When app-level overall status changes
2. When current phase changes
3. When a new work log is created for the app
4. When final app status is reached

Keep detailed progress in `docs/work_logs/` only.
