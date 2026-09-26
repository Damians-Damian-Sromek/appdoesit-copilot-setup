---
name: e2e-testing
description: Lean E2E testing for AppDoesIt apps. Owns minimal Playwright smoke coverage, locale verification, and targeted debugging while keeping E2E fast. Capture screenshots only when debugging or when visual review is explicitly requested.
---

# E2E Testing Skill

Maintain a **lean, fast** E2E suite focused on critical user journeys. Target total automated runtime under **10 minutes** by avoiding E2E duplication of unit/integration coverage.

## Hard Gates (Order Matters)

1. Security review must PASS before running any automated tests (per `AGENTS.md`).
2. Translation verification/tests run before broader test suites.

## What To Verify

- PHPUnit unit tests (as applicable)
- Playwright E2E smoke tests for critical user journeys
- All 3 supported locales (`en`, `es`, `pl`) load without raw i18n keys
- Mandatory app UI sections exist (skip link, help, 5 use cases)
- **UI state coverage**: dynamic text/messages (status labels, button variants, errors, empty/long results) are checked in their **longest variant**, not just the default state. Every dynamic element must assert no clipping/overflow (see `references/state-coverage.md`)
- Capture screenshots only when debugging suspected layout/theme/locale regressions or when the user explicitly asks for visual review
- When debugging translation issues, inspect `i18n/` source files first. Treat `public/assets/i18n/{locale}.json` as generated runtime output and only sample it as a targeted last resort if build/runtime drift is suspected.

**Preferred execution flow:** programmer runs unit + integration tests first, then this skill runs minimal E2E smoke coverage. Escalate to `/qa-expert` only when screenshot-based review is explicitly requested or automated evidence is insufficient.

## Detailed Workflow (Use References)

- `.agents/skills/e2e-testing/references/test-checklist.md`
- `.agents/skills/e2e-testing/references/state-coverage.md` (UI state / longest-variant coverage)
- `.agents/skills/e2e-testing/references/debug-guide.md`
- `.agents/skills/e2e-testing/references/doc-verification.md`

## Output

Return a concise test report:

- Commands run
- Pass/fail summary
- Any debug artifact paths created (for example traces or screenshots stored under `var/tmp/`)
- Any failures with minimal reproduction notes

## PM Status Payload (When Delegated by /project-manager)

When this skill is executed under /project-manager, append this block to your return:

```markdown
### PM Status Payload
- Work Item ID: [W-...]
- Skill: /e2e-testing
- Status: TODO|IN_PROGRESS|BLOCKED|DONE|CANCELLED
- Progress Summary: [non-technical summary]
- Blocker: [None or blocker]
- Next Owner: [/e2e-testing, /project-manager, or user]
```

Keep `Progress Summary` non-technical and outcome-focused.
