---
applyTo: "apps/**/*.php"
---

# Apps (Copilot)

Read `AGENTS.md` first. It is the source of truth for app requirements (help/use cases, i18n, accessibility, sitemap, testing).

For translation work, inspect the matching source files under `i18n/` first. Treat `public/assets/i18n/{locale}.json` as generated output for last-resort verification only.
Never embed or edit cross-app translation dictionaries in app files. Authored translation content belongs in `i18n/`, and any aggregate runtime bundle must stay in a separate generated file.

For implementation details, use:
- `.agents/skills/programmer/SKILL.md`
- `.agents/skills/programmer/references/app-structure.md`
- `.agents/skills/i18n-manager/references/translation-keys.md`

When unsure, mirror the closest existing app in `apps/` and its matching authored assets in `public/assets/` (not the generated `public/assets/i18n/*.json` bundles).
