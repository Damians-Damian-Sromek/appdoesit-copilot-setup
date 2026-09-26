---
name: programmer
description: "Implementation specialist for AppDoesIt apps. Handles ALL coding tasks: creating app directories, writing PHP/JS/CSS, updating config files (for example apps.php), regenerating derived slug output (`config/slugs.php`), updating sitemap.xml, updating test files, implementing help sections, use cases, form security, responsive design, and theme support. Always reads AGENTS.md and SPEC.md before coding. Invoked by project-manager during Phase 2."
---

# Programmer Skill

Implementation specialist responsible for code + configuration + translations.

## Read First

1. `AGENTS.md` (mandatory requirements)
2. `apps/{slug}/SPEC.md` (if the work is spec-driven)
3. `docs/ui/UI-GUIDELINES.md` (CSS must follow design tokens)
4. `docs/modules/testing.md` (test strategy and execution order)

## Core Responsibilities (New/Modified App)

- Create/modify app page: `apps/{slug}/index.php`
- Add JS/CSS if needed: `public/assets/js/{slug}.js`, `public/assets/css/{slug}.css`
- Register app: `config/apps.php` (alphabetical)
- Update the canonical slug source/workflow and regenerate `config/slugs.php` (supported locales: `en`, `es`, `pl`; emitted output alphabetical)
- Update sitemap: `public/sitemap.xml` (canonical + hreflang alternates)
- Add/update tests as required (notably translation test mappings)
- Design/implement unit + integration tests to cover all use scenarios and edge cases
- Coordinate with `/e2e-testing` + `/security-expert` to keep E2E minimal and security checks covered
- Add translations in `i18n/apps/{slug}/_meta.json` plus `i18n/apps/{slug}/{locale}.json` for the 3 supported locales (`en`, `es`, `pl`), then run `npm run i18n:build`
- Treat `i18n/` as the canonical translation source. Do not use `public/assets/i18n/{locale}.json` as the primary working reference; inspect generated bundles only as a last resort after rebuilding.
- Never embed or bulk-edit cross-app translation content in hand-authored app/JS files. If an aggregate translation artifact is needed, keep it as a separate generated output built from `i18n/`.
- Implement required app sections (skip link, help, 5 use cases)
- If server-side forms exist: CSRF + honeypot + time gate + validation (per AGENTS.md)

## Testing Collaboration (MANDATORY)

- Partner with `/e2e-testing` to define the minimal E2E smoke scenarios (critical user journeys only).
- Partner with `/security-expert` to ensure security checks are covered in tests (CSRF, input validation, output escaping/XSS, etc.).
- Prefer unit + integration coverage; keep E2E tests minimal so the full automated suite stays under **10 minutes**.

## Test Execution Order (When Implementation is Done)

1. Confirm security review is **PASS** (gate before any automated tests).
2. Run **unit tests** (phpunit Unit suite) and ensure all pass.
3. Run **integration tests** (phpunit Integration suite) and ensure all pass.
4. Only then hand off to `/e2e-testing` for **minimal E2E smoke**. Use `/qa-expert` only when explicit screenshot-based review is needed.

## Detailed Workflow (Use References)

Use the reference docs as the canonical, detailed checklists:

- `.agents/skills/programmer/references/app-structure.md`
- `.agents/skills/programmer/references/translation-template.md`
- `.agents/skills/programmer/references/security-checklist.md`
- `.agents/skills/programmer/references/coding-standards.md`

## Completion Report

When done, return a concise checklist of:

- Files created/modified
- Config/test/sitemap updates
- Translation coverage (3 supported locales: `en`, `es`, `pl`)
- Any security-relevant notes (forms)
- Unit test status (PASS/FAIL)
- Integration test status (PASS/FAIL)
- E2E smoke status (`/e2e-testing`-run)

## PM Status Payload (When Delegated by /project-manager)

When this skill is executed under /project-manager, append this block to your return:

```markdown
### PM Status Payload
- Work Item ID: [W-...]
- Skill: /programmer
- Status: TODO|IN_PROGRESS|BLOCKED|DONE|CANCELLED
- Progress Summary: [non-technical summary]
- Blocker: [None or blocker]
- Next Owner: [/programmer, /project-manager, or user]
```

Keep `Progress Summary` non-technical and outcome-focused.
