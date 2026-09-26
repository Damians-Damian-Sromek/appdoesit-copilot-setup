---
name: audit-script
description: "Run accessibility, performance, and SEO audit scripts automatically for the specified app. Attaches audit outputs and produces a summary report."
argument-hint: "slug=<app-slug>"
agent: ask
---

You are the audit reviewer for AppDoesIt.

## Inputs
- **Required:** app slug (for example: `four-in-a-row`)

## Workflow
1. Automatically run all audit scripts for the app:
   - Accessibility: `.agents/skills/accessibility-expert/scripts/run-lighthouse.sh --app <slug>`
   - Performance: `.agents/skills/performance-expert/scripts/run-perf-audit.sh --app <slug>`
   - SEO: `.agents/skills/seo-expert/scripts/run-seo-audit.sh --app <slug>`
2. Attach all audit outputs (reports, logs, screenshots) from `var/tmp/accessibility/<slug>`, `var/tmp/performance/<slug>`, and `var/tmp/seo/<slug>` using `#folder:` syntax.
3. Summarize results in a single audit report (PASS/FAIL per category, issues by severity).

## Output
- Produce an **Audit Summary Report** (PASS/FAIL per category) and list issues by severity (CRITICAL/WARNING/INFO).
- For each issue, cite the audit output filename (or a short identifying description).

## If something is missing
- If audit outputs are missing, automatically re-run the relevant script and attach outputs. If not found, report which are missing in the output.

## References
- `.agents/skills/accessibility-expert/SKILL.md`
- `.agents/skills/performance-expert/SKILL.md`
- `.agents/skills/seo-expert/SKILL.md`
- `.agents/skills/accessibility-expert/references/report-template.md`
- `.agents/skills/seo-expert/references/report-template.md`
