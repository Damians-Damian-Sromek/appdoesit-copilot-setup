---
applyTo: "public/assets/js/*.js"
---

# App JavaScript (Copilot)

Read `AGENTS.md` first. JS conventions and required patterns are defined there.

Keep shared/cross-app translation content out of hand-authored JS files. Use `AppDoesIt.i18n.t(...)` with canonical `i18n/` source files; if aggregated runtime translation data is needed, it must live in a separate generated file rather than being embedded or bulk-maintained in JS.

For coding tasks, follow `.agents/skills/programmer/SKILL.md`. When in doubt, mirror existing app JS files in `public/assets/js/`.
