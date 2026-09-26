---
applyTo: "config/**/*.php"
---

# Config Files (Copilot)

Read `AGENTS.md` first.

Config conventions live in:
- `docs/modules/configuration.md`
- `.agents/skills/programmer/SKILL.md` (when configs are part of app work)

`config/slugs.php` is a generated/derived artifact. Never hand-edit it.
If slug data changes, update the canonical slug source/workflow and regenerate `config/slugs.php`, then verify the emitted output is alphabetically sorted.
Keep other manually maintained config arrays alphabetically sorted as required by `AGENTS.md`.
