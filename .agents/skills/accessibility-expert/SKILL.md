---
name: accessibility-expert
description: Comprehensive accessibility auditing for AppDoesIt apps using Google Lighthouse and visual analysis. Use when creating new apps, modifying existing apps, or verifying WCAG 2.1 AA compliance. Covers color contrast, keyboard navigation, screen reader compatibility, focus management, and visual accessibility issues.
---

# Accessibility Expert Skill

Verify WCAG 2.1 AA compliance with Lighthouse + manual checks.

## Mandatory Gate

- Lighthouse Accessibility score must be 100/100 for new/modified app pages.

## What To Check

- Color contrast
- Labels and accessible names
- Keyboard navigation and focus visibility
- ARIA validity
- Heading hierarchy
- Dialog/help/modal accessibility (open/close, Escape)
- Locale-aware language and text rendering checks for the supported locales (`en`, `es`, `pl`)

## Detailed Workflow (Use References)

- `.agents/skills/accessibility-expert/references/lighthouse-guide.md`
- `.agents/skills/accessibility-expert/references/wcag-checklist.md`
- `.agents/skills/accessibility-expert/references/common-issues.md`
- `.agents/skills/accessibility-expert/references/report-template.md`

## Output

Return an audit report with:

- Lighthouse score + report path (under `var/tmp/accessibility/`)
- Issues grouped by severity with concrete fix guidance

## PM Status Payload (When Delegated by /project-manager)

When this skill is executed under /project-manager, append this block to your return:

```markdown
### PM Status Payload
- Work Item ID: [W-...]
- Skill: /accessibility-expert
- Status: TODO|IN_PROGRESS|BLOCKED|DONE|CANCELLED
- Progress Summary: [non-technical summary]
- Blocker: [None or blocker]
- Next Owner: [/accessibility-expert, /project-manager, or user]
```

Keep `Progress Summary` non-technical and outcome-focused.
