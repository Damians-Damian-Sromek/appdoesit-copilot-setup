# QA Quick Checks

Use this as a fast visual checklist when reviewing screenshots.

## Critical Issues (Block Deployment)

- App not horizontally centered (missing `margin: 0 auto`)
- Raw translation keys visible (example: `appName.title`)
- Text truncation/overflow that hides meaning
- Concatenated text without spacing
- **Longest message variant clipped or overflowing** (e.g., label "Done" becomes "Unavailable" and gets cut off; longest `es`/`pl` translation overflows its container)

## Always Verify

- CSS variables look correct (example: `--space-*` not `--spacing-*`)
- Spanish and Polish screenshots render without overflow or untranslated text
- Theme switching works (light/dark)
- Header includes the site-wide navigation elements (logo, nav, theme toggle, language selector)
- Footer has expected structure (brand, nav links, copyright)
