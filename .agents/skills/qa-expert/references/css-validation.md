# CSS Variable Validation Guide

**CRITICAL: Incorrect CSS variable names cause styling to break silently!**

Before completing QA, verify the app's CSS file uses correct variable names from main.css.

## How to Validate

Run this grep command to check for invalid variable names:

```bash
# Check for wrong variable names in the app's CSS file
grep -E '(--spacing-|--bg-primary|--bg-secondary|--bg-tertiary|--text-primary|--text-secondary|--text-tertiary|--border-color[^-])' public/assets/css/{slug}.css
```

If any matches are found, the CSS is BROKEN and must be fixed.

## Common Wrong -> Correct Variable Names

| WRONG (doesn't exist) | CORRECT (from main.css) |
|----------------------|-------------------------|
| `--spacing-*` | `--space-*` |
| `--bg-primary` | `--color-bg` |
| `--bg-secondary` | `--color-bg-card` |
| `--bg-tertiary` | `--color-bg-alt` |
| `--text-primary` | `--color-text` |
| `--text-secondary` | `--color-text-muted` |
| `--text-tertiary` | `--color-text-muted` |
| `--border-color` | `--color-border` |

## Visual Symptoms of Wrong Variables

When CSS variables don't exist, elements get no styling. Look for:
- **App left-aligned instead of centered** (missing `margin: 0 auto` on container)
- **Sections side-by-side instead of stacked** (missing flex/gap)
- **No spacing between elements** (missing padding/margin)
- **Missing backgrounds** (transparent when should have color)
- **Missing borders** (elements blend together)
- **Invisible text** (color not applied)

## CSS Selector Conflict Issues

Watch for CSS selectors that unintentionally match nested elements:
- **Truncated or garbled text** like "STA'T" instead of "START" (selector breaking layout)
- **Missing toggle switches** before labels (display:block breaking flex)
- **Elements overlapping text** (position or display conflicts)

Common culprit pattern:
```css
/* BAD - matches nested labels too */
.container > label:first-child { display: block; }

/* GOOD - excludes specific component classes */
.container > label:first-child:not(.toggle-class) { display: block; }
```

## Report Requirements

Add this section to every QA report:

```markdown
### CSS Layout Validation (MANDATORY)
- [ ] **App container is horizontally centered** (equal whitespace on left/right)
- [ ] App container has `margin: 0 auto` in CSS (verify by reading CSS file)
- [ ] App container has appropriate `max-width` (500-900px typical)
- [ ] Visual layout matches other apps (stacked sections, proper spacing)

### CSS Variable Validation
- [ ] Checked CSS file for invalid variable names
- [ ] No `--spacing-*` found (should be `--space-*`)
- [ ] No `--bg-*` found (should be `--color-bg-*`)
- [ ] No `--text-*` found (should be `--color-text-*`)
- [ ] No standalone `--border-color` found (should be `--color-border`)
```

**If app is not centered: Report as CRITICAL issue - CSS missing `margin: 0 auto`.**
**If invalid variables are found: Report as CRITICAL issue.**
