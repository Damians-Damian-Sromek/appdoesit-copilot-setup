---
applyTo: "tests/**/*.{js,php}"
---

# Tests (Copilot)

Read `AGENTS.md` first for mandatory testing requirements. Treat screenshot-based QA as optional unless the task explicitly calls for visual review or debugging artifacts.

For translation-related failures, debug against canonical source files under `i18n/` first. Use `public/assets/i18n/{locale}.json` only as a targeted last-resort check for build/runtime drift.
If a runtime bundle is stale or wrong, regenerate it from source. Never fix a test by rewriting `public/assets/i18n/{locale}.json` or any other cross-app translation bundle by hand.

Use:
- `.agents/skills/e2e-testing/SKILL.md`
- `docs/modules/testing.md`

Keep tests aligned with AGENTS.md requirements (translations, use cases, help sections, sitemap).
