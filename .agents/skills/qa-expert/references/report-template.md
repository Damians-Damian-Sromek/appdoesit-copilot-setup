# QA Report Template

## Template

```markdown
## QA Visual Verification Report

**App:** {app-name}
**Slug:** {slug}
**Date:** {date}
**Status:** PASS / FAIL

---

### Screenshots Captured

| Screenshot | Viewport | Locale | Theme | Status |
|------------|----------|--------|-------|--------|
| {slug}-desktop-en-light.png | 1280x720 | en | light | OK / Issues |
| {slug}-desktop-en-dark.png | 1280x720 | en | dark | OK / Issues |
| {slug}-mobile-en-light.png | 375x667 | en | light | OK / Issues |
| {slug}-desktop-es-light.png | 1280x720 | es | light | OK / Issues |
| {slug}-desktop-pl-light.png | 1280x720 | pl | light | OK / Issues |

---

### Issues Found

#### CRITICAL
- [ ] {Issue description} - {screenshot reference}

#### WARNING
- [ ] {Issue description} - {screenshot reference}

#### INFO
- [ ] {Issue description} - {screenshot reference}

---

### Visual Checks

#### English Desktop (Light)
- [ ] All sections visible (header, content, help, use cases)
- [ ] No raw translation keys
- [ ] **All labels fully visible** (no truncation like "STA'" instead of "START WITH")
- [ ] **No concatenated text** (e.g., "Ctrl+EnterGenerate..." should be properly formatted)
- [ ] **App is CENTERED horizontally** (equal whitespace on left and right sides)
- [ ] **App is NOT left-aligned** (if left-aligned, CSS is missing `margin: 0 auto`)
- [ ] All interactive elements visible

#### English Desktop (Dark)
- [ ] Theme applied correctly
- [ ] Text has sufficient contrast
- [ ] No elements invisible/hidden

#### English Mobile
- [ ] Responsive layout working
- [ ] Touch targets adequate size
- [ ] No horizontal overflow
- [ ] Text readable
- [ ] **Labels not truncated** due to narrow viewport

#### Spanish Desktop
- [ ] All text translated (no English)
- [ ] Labels and punctuation read naturally
- [ ] No text truncation or overflow

#### Polish Desktop
- [ ] All text translated (no English)
- [ ] Diacritics render correctly
- [ ] All content visible with localized labels

#### CSS Layout Validation (MANDATORY)
- [ ] **App container is horizontally centered** (equal whitespace on left/right)
- [ ] App container has `margin: 0 auto` in CSS
- [ ] App container has appropriate `max-width` (500-900px typical)
- [ ] Visual layout matches other apps (stacked sections, proper spacing)

#### CSS Variable Validation
- [ ] Checked CSS file for invalid variable names
- [ ] No `--spacing-*` found (should be `--space-*`)
- [ ] No `--bg-*` found (should be `--color-bg-*`)
- [ ] No `--text-*` found (should be `--color-text-*`)
- [ ] No standalone `--border-color` found (should be `--color-border`)

---

### Recommendation

**PASS** - No critical issues, app ready for deployment
or
**FAIL** - Critical issues found, requires fixes:
{list of critical issues to fix}
```
