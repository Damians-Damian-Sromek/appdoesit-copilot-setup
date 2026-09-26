# AppDoesIt — Copilot instruction set

This repo is the **standalone instruction set** behind
[AppDoesIt](https://appdoesit.com) — the 14 skill workflows, 3 custom agents,
path-scoped instruction files, and slash commands that let **VS Code + GitHub
Copilot** (and the GitHub Copilot CLI) build, audit, and ship the portal's 134+
apps with no dev team.

> **What this is and isn't.** This is *not* the running app codebase. It's the
> layer of well-organized files that an agent reads and follows: the "system
> prompt" of the project, split across skills and instructions. The site itself
> (vanilla PHP 8.4, no build step, Docker on an OVH VPS) lives in a separate
> private repo. Clone **this** repo to study how the delegation pipeline works,
> or copy the pattern into your own project.
>
> Companion article: *"134 apps, zero dev team: how VS Code + GitHub Copilot
> build and deploy my web portal"* — in `appdoesit_com`,
> `docs/marketing/articles/how-copilot-powers-appdoesit.md`.

## Why the setup works

The core idea: **the repo is the instruction set.** There's no fine-tuned model
and no private API — just files an agent follows. The design rules that make it
hold together:

1. **Single source of truth, read-only derivatives.** In the main repo,
   `AGENTS.md` is the source of truth and everything derived (generated slug
   maps, built i18n bundles) is regenerated, never hand-edited.
2. **Skills are workflows with numeric gates, not prompts.** "Run Lighthouse and
   fail if a11y < 100" is a procedure with an exit criterion, not a vibe.
3. **Tests are the contract.** Translation key-parity, alphabetical ordering,
   E2E route discovery. When an agent says "done", a machine decides.
4. **One orchestrator, many specialists.** The `project-manager` never writes
   code — it sequences work, owns a non-technical work log, and enforces the
   security gate *before* any test runs.
5. **Keep the agent list small, the skill list rich.** Three custom agents,
   fourteen skills. Agents are cheap to define but expensive to keep in sync;
   skills carry the actual knowledge.

## Layout

```
.agents/skills/          # 14 skill workflows (the knowledge)
├── project-manager/      # orchestrator — delegates, owns the work log
├── product-owner/        # writes the definitive SPEC.md ("no maybes")
├── programmer/           # implements apps (PHP/JS/CSS, configs, i18n, sitemap)
├── ui-expert/            # design direction (before) + UI audit (after)
├── security-expert/      # OWASP review — a BLOCKING gate before any test
├── i18n-manager/         # en/es/pl key parity, no English leakage
├── accessibility-expert/ # Lighthouse a11y 100/100
├── performance-expert/   # Lighthouse perf ≥ 90, caching, CWV
├── seo-expert/           # meta, JSON-LD, sitemap, technical SEO
├── e2e-testing/          # PHPUnit + Playwright, dynamic app discovery
├── qa-expert/            # optional vision-based QA (screenshots)
├── marketing-expert/     # competitor research, promotion, channels
├── playwright-mcp-extension-operator/  # human-in-the-loop browser flows
└── work-optimisation-expert/           # maintains the skill ecosystem itself
    # each: SKILL.md + references/ (guides, templates, checklists) + scripts/

.github/agents/          # 3 custom agents (the roles an agent can be)
├── product-owner.agent.md
├── project-manager.agent.md
└── work-optimisation-expert.agent.md

.github/instructions/    # path-scoped instructions (right rules for right files)
├── apps.instructions.md        # applies to apps/**/*.php
├── config.instructions.md      # applies to config/**/*.php
├── javascript.instructions.md  # applies to public/assets/js/*.js
└── tests.instructions.md       # applies to tests/

.github/prompts/         # slash commands
├── audit-script.prompt.md      # /audit-script slug=<app> — 3 audits, PASS/FAIL
└── visual-qa.prompt.md         # /visual-qa slug=<app> — vision screenshot review
```

## The pipeline it drives

```
you: "implement app X per the approved SPEC"
        │
        ▼
project-manager (orchestrator — never writes code)
        │  opens a non-technical work log (TODO table + timeline)
        │
        ├─► product-owner        → SPEC.md
        ├─► ui-expert            → design direction
        ├─► programmer           → app, configs, sitemap, i18n source
        ├─► security-expert      → BLOCKING gate (before any test)
        ├─► i18n-manager         → en / es / pl parity
        ├─► e2e-testing          → PHPUnit + Playwright green
        ├─► accessibility · perf · seo  → Lighthouse gates
        └─► ui-expert            → final UI audit
        │
        ▼  push main
GitHub Actions: php-tests ∥ e2e-tests ∥ i18n-sync ──► deploy (needs: all gates)
        │  rsync to VPS, Docker rebuild, health-check + live curl
        ▼
appdoesit.com is live
```

## Using it

- **In VS Code:** clone the *main* repo (this repo's files live inside it under
  `.agents/` and `.github/`). Copilot reads `AGENTS.md` + the skills + the
  path-scoped instructions automatically. Workspace tasks wrap the loop;
  `/audit-script` and `/visual-qa` are one-click.
- **In the GitHub Copilot CLI:** run `copilot --agent product-owner -p "..."`
  (or `project-manager`) from a clone. The `.github/agents/*` files make the
  roles available as named agents; the skills are the workflows they follow.
- **To copy the pattern:** start from `AGENTS.md` (single source of truth),
  add path-scoped instructions for your hot paths, build one orchestrator skill
  that refuses to implement, then specialist skills with numeric exit criteria.
  Make CI the safety net (parallel gates + a deploy job gated on `needs:`).

## Provenance

Extracted verbatim from the `appdoesit_com` private repo on 2026-09-26. Skill
and agent content is maintained there by the `work-optimisation-expert` skill;
this repo is a snapshot for study and reference. If they diverge, the main
repo's copy is authoritative.
