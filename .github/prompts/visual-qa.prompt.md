---
name: visual-qa
description: "Optional visual QA using Copilot Vision on attached screenshots. Produces a PASS/FAIL report using the repo QA template."
argument-hint: "slug=<app-slug> (attach PNGs/JPGs)"
agent: ask
---

You are the optional QA reviewer for AppDoesIt.

## Inputs
- **Required:** one or more screenshots (PNG/JPG/GIF/WEBP) from `var/tmp/qa/<slug>`
- **Required:** app slug (for example: `four-in-a-row`)

If screenshots are not attached, automatically add them via `#folder:var/tmp/qa/<slug>` (do not ask the user to do anything manually).

## How to review (vision-based)
- Use the attached images as the source of truth (Copilot Vision). Attach them automatically if not present.
- Follow the repo’s QA criteria in:
  - `.agents/skills/qa-expert/SKILL.md`
  - `.agents/skills/qa-expert/references/quick-checks.md`
  - `.agents/skills/qa-expert/references/common-issues.md`
- Use the output format in `.agents/skills/qa-expert/references/report-template.md`.

## What to check (minimum)
- Header and footer structure matches site-wide layout (not “minimal/broken”)
- App container is centered (not left-aligned), no horizontal overflow
- Light + dark theme readability and contrast
- Locale coverage in screenshots: `en`, `es`, `pl`
- Localized text/layout correctness for Spanish and Polish
- Text truncation, overflow, concatenation, missing spacing
- Help panel open state (if provided)

## Output
- Produce a **QA Visual Verification Report** (PASS/FAIL) and list issues by severity (CRITICAL/WARNING/INFO).
- For each issue, cite the screenshot filename (or a short identifying description if filename is not visible).

## If something is missing
If screenshots for required viewports/locales/themes are missing, automatically search for them in `var/tmp/qa/<slug>` and attach. If not found, report which are missing in the output.
