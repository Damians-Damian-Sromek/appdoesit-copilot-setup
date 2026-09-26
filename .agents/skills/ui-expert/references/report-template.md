# UI Quality Report Template

Use this template for UI Expert reports.

---

## Report Structure

```markdown
# UI Quality Report: {App Name}

**Date:** {YYYY-MM-DD}
**App Slug:** {slug}
**CSS File:** public/assets/css/{slug}.css
**Auditor:** UI Expert

---

## Summary

| Metric | Value |
|--------|-------|
| **Overall Score** | {XX}/100 |
| **Status** | {PASS/FAIL} |
| **Critical Issues** | {count} |
| **Warnings** | {count} |
| **Recommendations** | {count} |

---

## Scores by Area

| Area | Score | Notes |
|------|-------|-------|
| Design System Compliance | {X}/20 | {brief note} |
| Component Patterns | {X}/20 | {brief note} |
| Visual Hierarchy | {X}/20 | {brief note} |
| Visual Polish | {X}/20 | {brief note} |
| Cross-App Consistency | {X}/20 | {brief note} |
| **Total** | **{XX}/100** | |

---

## Issues Found

### CRITICAL

{List critical issues that must be fixed}

| # | Issue | Location | Fix |
|---|-------|----------|-----|
| 1 | {description} | {file:line or selector} | {fix instruction} |
| 2 | ... | ... | ... |

### WARNING

{List warnings that should be fixed}

| # | Issue | Location | Fix |
|---|-------|----------|-----|
| 1 | {description} | {file:line or selector} | {fix instruction} |
| 2 | ... | ... | ... |

### INFO

{List recommendations/suggestions}

| # | Recommendation | Benefit |
|---|----------------|---------|
| 1 | {suggestion} | {why it's beneficial} |
| 2 | ... | ... |

---

## Detailed Analysis

### 1. Design System Compliance

**Score: {X}/20**

**CSS Variables Checked:**
- [ ] Spacing: {PASS/FAIL} - {details}
- [ ] Colors: {PASS/FAIL} - {details}
- [ ] Typography: {PASS/FAIL} - {details}
- [ ] Borders: {PASS/FAIL} - {details}
- [ ] Shadows: {PASS/FAIL} - {details}
- [ ] Transitions: {PASS/FAIL} - {details}

**Violations Found:**
{List any hard-coded values with line numbers}

### 2. Component Patterns

**Score: {X}/20**

**Components Verified:**
- [ ] App Container: {PASS/FAIL} - {has margin: 0 auto?}
- [ ] Buttons: {PASS/FAIL} - {match pattern?}
- [ ] Form Inputs: {PASS/FAIL} - {match pattern?}
- [ ] Main Card: {PASS/FAIL} - {match pattern?}
- [ ] Help Panel: {PASS/FAIL} - {match pattern?}

**Pattern Deviations:**
{List any deviations from expected patterns}

### 3. Visual Hierarchy

**Score: {X}/20**

- [ ] Typography scale is logical
- [ ] Spacing creates clear sections
- [ ] Primary actions are prominent
- [ ] Information flows clearly

**Hierarchy Issues:**
{List any hierarchy problems}

### 4. Visual Polish

**Score: {X}/20**

**Interaction States:**
- [ ] Hover states: {present/missing}
- [ ] Focus states: {present/missing}
- [ ] Active states: {present/missing}
- [ ] Disabled states: {present/missing}

**Transitions:**
- [ ] Button transitions: {smooth/missing}
- [ ] Input transitions: {smooth/missing}
- [ ] Modal transitions: {smooth/missing}

**Feedback:**
- [ ] Loading indicators: {present/N/A}
- [ ] Success feedback: {present/N/A}
- [ ] Error feedback: {present/N/A}

### 5. Cross-App Consistency

**Score: {X}/20**

**Compared Against:** calculator, password-generator, bmi-calculator

- [ ] Container width appropriate: {yes/no}
- [ ] Header styling matches: {yes/no}
- [ ] Button styling matches: {yes/no}
- [ ] Input styling matches: {yes/no}
- [ ] Help panel matches: {yes/no}

**Consistency Issues:**
{List any inconsistencies with other apps}

---

## Screenshots

{If applicable, reference screenshots taken during the audit}

- Desktop Light: `var/tmp/ui/{slug}-desktop-light.png`
- Desktop Dark: `var/tmp/ui/{slug}-desktop-dark.png`
- Mobile: `var/tmp/ui/{slug}-mobile.png`

---

## Conclusion

**Overall Assessment:** {PASS/FAIL}

**Action Required:**
{Summary of what needs to be done before the app can ship}

**Next Steps:**
1. {First action}
2. {Second action}
3. Re-run UI Expert audit after fixes
```

---

## Quick Report (Minimal Version)

For quick audits when no issues are found:

```markdown
# UI Quality Report: {App Name}

**Score:** {XX}/100 - **PASS**

All five UI quality areas verified:
- [x] Design System Compliance
- [x] Component Patterns
- [x] Visual Hierarchy
- [x] Visual Polish
- [x] Cross-App Consistency

No issues found. App is ready for deployment.
```

---

## Example Report

```markdown
# UI Quality Report: Percentage Calculator

**Date:** 2025-01-15
**App Slug:** percentage-calculator
**CSS File:** public/assets/css/percentage-calculator.css
**Auditor:** UI Expert

---

## Summary

| Metric | Value |
|--------|-------|
| **Overall Score** | 85/100 |
| **Status** | PASS |
| **Critical Issues** | 0 |
| **Warnings** | 2 |
| **Recommendations** | 1 |

---

## Scores by Area

| Area | Score | Notes |
|------|-------|-------|
| Design System Compliance | 18/20 | 2 hard-coded colors |
| Component Patterns | 20/20 | All patterns match |
| Visual Hierarchy | 17/20 | Minor spacing inconsistency |
| Visual Polish | 15/20 | Missing some hover states |
| Cross-App Consistency | 15/20 | Button style slightly different |
| **Total** | **85/100** | |

---

## Issues Found

### WARNING

| # | Issue | Location | Fix |
|---|-------|----------|-----|
| 1 | Hard-coded color `#f0f0f0` | Line 45 | Use `var(--color-bg-alt)` |
| 2 | Missing hover state on reset button | `.pc-reset-btn` | Add `:hover` rule |

### INFO

| # | Recommendation | Benefit |
|---|----------------|---------|
| 1 | Add transition to result display | Smoother value updates |

---

## Conclusion

**Overall Assessment:** PASS

App meets UI quality standards. Two minor warnings should be addressed but are not blocking.
```
