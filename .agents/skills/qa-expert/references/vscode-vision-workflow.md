# VS Code: Vision-based Screenshot Review

Use this when running `/qa-expert` inside **VS Code Chat**.

VS Code Chat supports **Vision (Preview)**, meaning you can attach images as context and ask the agent to analyze them.

## How to attach screenshots

- Automatically attach all screenshots from `var/tmp/qa/<slug>` using `#folder:var/tmp/qa/<slug>` (no manual action required)

## Model requirement

If the selected model doesn’t support image attachments, VS Code shows a warning.
Switch to a vision-capable model and re-send.

## Recommended invocation

- Use the prompt file: `/visual-qa slug=<app-slug>`
- Or run `/qa-expert` and say: “Review the attached screenshots and output the report template.”

## Output format

Use `.agents/skills/qa-expert/references/report-template.md`.
