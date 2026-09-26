---
name: i18n-manager
description: Internationalization validation and management for AppDoesIt apps. Use when adding translations, validating i18n completeness, fixing untranslated strings, or auditing locale coverage. Invoked by project-manager during Phase 2 to verify the 3 supported locales (`en`, `es`, `pl`) are complete. Runs AppTranslationsTest.php, detects English text in non-English locales, fixes issues, and generates coverage reports.
---

# i18n Manager Skill

Ensure all 3 supported locales (`en`, `es`, `pl`) have complete, non-English translations with key parity.

## Read First

1. `AGENTS.md` (i18n system + required app keys)
2. `tests/php/Unit/AppTranslationsTest.php` (required keys + enforced parity)

## Primary Gates

- Key parity with English for every locale
- No empty strings
- No English copied into non-English locales
- Required per-app keys present (title/description/seo/help/use cases/skip link)

## Where to Work

- Source files (validate and edit these first): `i18n/apps/{slug}/_meta.json` + `i18n/apps/{slug}/{locale}.json`, `i18n/pages/{slug}/_meta.json` + `i18n/pages/{slug}/{locale}.json`, `i18n/common/_meta.json` + `i18n/common/{locale}.json`
- Built files (generated runtime bundles): `public/assets/i18n/{locale}.json` — do not read these by default; use them only as a targeted last-resort verification step after rebuilding or when diagnosing build/runtime drift; never hand-author, bulk-rewrite, or use them as the working source
- Aggregate bundle rule: any file containing translations for multiple apps/pages/common domains must remain a separate generated artifact; edit the smallest relevant `i18n/...` source files and let the build regenerate the aggregate output
- Build command: `npm run i18n:build` (rebuilds monolithic files from source)
- Helper scripts: `node scripts/i18n-app.js export|import|split|build`
- Tests: `tests/php/Unit/AppTranslationsTest.php`

## Detailed Workflow (Use References)

- `.agents/skills/i18n-manager/references/translation-keys.md`
- `.agents/skills/i18n-manager/references/validation-guide.md`
- `.agents/skills/i18n-manager/references/locale-list.md`

## Output

Return a short report:

- Locales verified (3/3)
- Any missing keys fixed
- Any quality issues found (English leakage, missing parity, layout/text expansion concerns)

## PM Status Payload (When Delegated by /project-manager)

When this skill is executed under /project-manager, append this block to your return:

```markdown
### PM Status Payload
- Work Item ID: [W-...]
- Skill: /i18n-manager
- Status: TODO|IN_PROGRESS|BLOCKED|DONE|CANCELLED
- Progress Summary: [non-technical summary]
- Blocker: [None or blocker]
- Next Owner: [/i18n-manager, /project-manager, or user]
```

Keep `Progress Summary` non-technical and outcome-focused.
