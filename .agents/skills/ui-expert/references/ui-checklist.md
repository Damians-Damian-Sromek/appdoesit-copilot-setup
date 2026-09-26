# UI Quality Checklist

Comprehensive checklist for verifying UI quality in AppDoesIt apps.

---

## 1. Design System Compliance (20 points)

### CSS Variables

- [ ] **Spacing** - All spacing uses `--space-*` (not px or `--spacing-*`)
- [ ] **Colors** - All colors use `--color-*` (not hex codes)
- [ ] **Typography** - Font sizes use `--font-size-*`
- [ ] **Borders** - Border radius uses `--radius-*`
- [ ] **Shadows** - Box shadows use `--shadow-*`
- [ ] **Transitions** - Animations use `--transition-*`

### Quick Check (grep for violations)

```bash
# Find hard-coded values (potential issues)
grep -E '(padding|margin|gap): [0-9]+px' public/assets/css/{app}.css
grep -E 'color: #[0-9a-fA-F]{3,6}' public/assets/css/{app}.css
grep -E 'font-size: [0-9]+px' public/assets/css/{app}.css
grep -E 'border-radius: [0-9]+px' public/assets/css/{app}.css
grep -E 'transition: [0-9]+' public/assets/css/{app}.css
```

**Scoring:**
- All variables correct: 20 points
- 1-2 violations: 15 points
- 3-5 violations: 10 points
- 6+ violations: 5 points

---

## 2. Component Pattern Consistency (20 points)

### App Container (CRITICAL)

- [ ] Has `margin: 0 auto` for horizontal centering
- [ ] Has `max-width` between 400-900px
- [ ] Uses `width: 100%` with max-width

### Buttons

- [ ] Primary buttons match `--color-primary` background
- [ ] Secondary buttons use `--color-bg-alt` background
- [ ] Icon buttons are 44x44px minimum
- [ ] All buttons have consistent border-radius (`--radius-md`)

### Form Inputs

- [ ] Inputs use `--color-bg-alt` or `--color-bg` background
- [ ] Border uses `--color-border`
- [ ] Consistent padding (`--space-3` to `--space-4`)
- [ ] Placeholder uses `--color-text-muted`

### Main App Card

- [ ] Uses `--color-bg-card` background
- [ ] Has `1px solid var(--color-border)` border
- [ ] Uses `--radius-lg` for border-radius
- [ ] Has `--shadow-lg` for elevation

### Help Panel

- [ ] Fixed positioning with backdrop
- [ ] Backdrop has blur effect
- [ ] Uses `--color-bg-card` background
- [ ] Close button is accessible

**Scoring:**
- All patterns match: 20 points
- Minor variations: 15 points
- Significant differences: 10 points
- Major inconsistencies: 5 points

---

## 3. Visual Hierarchy (20 points)

### Typography Scale

- [ ] Page title uses `--font-size-2xl` or larger
- [ ] Section headings use `--font-size-xl`
- [ ] Body text uses `--font-size-base`
- [ ] Labels/captions use `--font-size-sm`
- [ ] Headings have tighter line-height than body

### Spacing Progression

- [ ] Sections separated by larger spacing (`--space-8` to `--space-12`)
- [ ] Related items have smaller spacing (`--space-2` to `--space-4`)
- [ ] Consistent margin-bottom on headings

### Visual Emphasis

- [ ] Primary actions are visually prominent (larger, colored)
- [ ] Secondary actions are subdued
- [ ] Important information has sufficient contrast
- [ ] Success/error states use appropriate colors

### Information Flow

- [ ] Content flows logically top-to-bottom
- [ ] Labels positioned above or left of controls
- [ ] Related controls grouped together
- [ ] Clear visual separation between sections

**Scoring:**
- Clear, logical hierarchy: 20 points
- Minor hierarchy issues: 15 points
- Confusing hierarchy: 10 points
- No clear hierarchy: 5 points

---

## 4. Visual Polish (20 points)

### Interaction States

- [ ] **Hover states** on all buttons and links
- [ ] **Focus states** using `--focus-ring` on all interactive elements
- [ ] **Active states** (pressed) on buttons
- [ ] **Disabled states** visually distinct (opacity, cursor)

### Transitions & Animations

- [ ] All state changes have smooth transitions
- [ ] Uses `--transition-fast` for micro-interactions
- [ ] Uses `--transition-base` for standard transitions
- [ ] No jarring or instant state changes

### Visual Feedback

- [ ] Loading indicators where needed
- [ ] Success confirmation visible
- [ ] Error messages clearly visible
- [ ] Copy-to-clipboard feedback

### Theme Support

- [ ] Works in light mode
- [ ] Works in dark mode
- [ ] No color contrast issues in either theme
- [ ] Shadows adapt to theme

**Scoring:**
- Fully polished: 20 points
- Minor polish missing: 15 points
- Some states missing: 10 points
- Unpolished: 5 points

---

## 5. Cross-App Consistency (20 points)

### Compare Against Reference Apps

Reference apps: `calculator`, `password-generator`, `bmi-calculator`

### Visual Comparison Points

- [ ] App container width is appropriate for complexity
- [ ] Header styling matches other apps
- [ ] Button styling matches other apps
- [ ] Form input styling matches other apps
- [ ] Help panel styling matches other apps

### Dynamic Message-State Coverage (i18n-Safe Layout)

Per UI-GUIDELINES.md "Dynamic Text & Message States": automated checks must exercise every
non-constant UI state, not just the default render. If a label normally shows "Done" but can
become "Unavailable", the check must prove the longer variant renders correctly.

- [ ] All dynamic text spots identified (statuses, button variants, errors, empty/long results)
- [ ] Longest message variant rendered in each spot (all branches: success, error, disabled/unavailable)
- [ ] Longest `es`/`pl` translation of each message fits (pl/es often 20-40% longer than `en`)
- [ ] No clipping/overflow on any dynamic element (`scrollWidth <= clientWidth`, no ellipsis on semantic text)
- [ ] No hard-coded element widths that squeeze growing text (intrinsic sizing / `fit-content` / `minmax(0, 1fr)`)
- [ ] Status regions (`role="status"`) expand with content; no sibling pushed off-screen
- [ ] No document-level horizontal scroll in the longest state

**Scoring:**
- All states covered and fit: full marks in the Component Patterns section
- Default state only checked (no longest-variant coverage): −10 points
- Any state clips/overflows: Component Patterns capped at 10 points

### Spacing Patterns

- [ ] Similar section spacing as other apps
- [ ] Similar component spacing
- [ ] Similar padding inside cards

**Scoring:**
- Fully consistent: 20 points
- Minor differences: 15 points
- Noticeable differences: 10 points
- Inconsistent: 5 points

---

## Total Score Calculation

| Area | Score |
|------|-------|
| Design System Compliance | /20 |
| Component Patterns | /20 |
| Visual Hierarchy | /20 |
| Visual Polish | /20 |
| Cross-App Consistency | /20 |
| **Total** | **/100** |

### Pass/Fail Thresholds

- **90-100**: Excellent - Ship it!
- **80-89**: Good - PASS (minor improvements optional)
- **70-79**: Fair - Fix issues before shipping
- **Below 70**: Needs work - FAIL

---

## Quick Reference: Common Issues

### CRITICAL Issues (must fix)

1. App not centered (missing `margin: 0 auto`)
2. Hard-coded colors (no CSS variables)
3. Missing focus states
4. No dark mode support
5. Dynamic message state clips/overflows (e.g., "Unavailable" variant of a "Done" label gets cut off, or longest `es`/`pl` translation overflows its container)

### WARNING Issues (should fix)

1. Inconsistent spacing
2. Missing hover states
3. Slightly different button styles
4. Minor typography variations

### INFO Issues (nice to have)

1. Could add more transitions
2. Could improve visual feedback
3. Minor alignment tweaks
