# Work Log Template (Authoritative PM Tracking)

Use this template for `docs/work_logs/YYYY-MM-DD_HHMM_task-slug.md`.

---

```markdown
# Work Log: [Task Title]

## Task Metadata

- Task Title: [Short user-facing title]
- Task Slug: [task-slug]
- Created: [YYYY-MM-DD HH:MM]
- Last Updated: [YYYY-MM-DD HH:MM]
- Overall Status: [TODO | IN_PROGRESS | BLOCKED | DONE | CANCELLED]
- Related App Slug: [app-slug | N/A]
- Related PROJECT.md: [apps/{slug}/PROJECT.md | N/A]

## TODO Assignment Table

| Item ID | Work Item (non-technical) | Assigned Skill/Sub-agent | Status | Last Updated | Blocker/Next Action |
|---|---|---|---|---|---|
| W-001 | [Outcome-focused item] | [/programmer] | TODO | [YYYY-MM-DD HH:MM] | [Next action] |

## Status Snapshot

- TODO: 0
- IN_PROGRESS: 0
- BLOCKED: 0
- DONE: 0
- CANCELLED: 0

## Activity Timeline

- [YYYY-MM-DD HH:MM] [W-001] Assigned to [/programmer], status set to IN_PROGRESS.
- [YYYY-MM-DD HH:MM] [W-001] Updated from payload: DONE, next owner [/qa-expert].

## Completion Summary

- Final Status: [DONE | CANCELLED]
- Summary: [Short non-technical summary of outcomes]
- Remaining Follow-ups: [None | list]
```

---

## Status Enum

Use only:

- `TODO`
- `IN_PROGRESS`
- `BLOCKED`
- `DONE`
- `CANCELLED`

## Non-Technical Rule for TODO Assignment Table

Do not include implementation details such as:

- file paths
- commands
- code-level plans

Items must still clearly identify:

- expected outcome
- owning skill/sub-agent

## Update Cadence

Update the work log:

1. At PM task start
2. Before each delegation
3. After each specialist response (using PM Status Payload)
4. When blockers change
5. Before each PM status update to the user
6. At completion
