# Accessibility Audit Report Template

Use this template when generating accessibility audit reports.

## Template

```markdown
## Accessibility Audit Report: [App Name]

### Audit Completion Checklist (MANDATORY)

| Requirement | Completed | Evidence |
|-------------|-----------|----------|
| **Lighthouse audit executed** | YES/NO | Report: a11y-{app}-{timestamp}.report.json |
| Lighthouse score recorded | YES/NO | Score: XX/100 |
| Screenshots captured | YES/NO | Files: {app}-*.png |
| Visual analysis performed | YES/NO | See Visual Verification section |
| Manual keyboard testing | YES/NO | See Manual Checks section |

**IMPORTANT: If "Lighthouse audit executed" is NO, this audit is INCOMPLETE.**

### Test Conditions
- **State Tested**: Active (with user interaction and results visible)
- **Interactions Performed**: [List of actions taken before testing]
- **Results Visible**: Yes/No

### Lighthouse Results (MANDATORY)

**Report Files:**
- JSON: `var/tmp/accessibility/a11y-{app}-{timestamp}.report.json`
- HTML: `var/tmp/accessibility/a11y-{app}-{timestamp}.report.html`

**Score Summary:**
- **Lighthouse Accessibility Score**: XX/100
- **Status**: PASS (100) / FAIL (<100)

**REQUIRED SCORE: 100/100** - No exceptions.

### Lighthouse Violations (if score < 100)

Extract violations from JSON report:

```bash
cat var/tmp/accessibility/a11y-*.report.json | jq '
  .audits | to_entries[] |
  select(.value.score != null and .value.score < 1) |
  {
    id: .key,
    title: .value.title,
    description: .value.description,
    score: .value.score,
    elements: [.value.details.items[]?.node.selector // "N/A"] | unique
  }
'
```

**Violations Found:**

| Audit ID | Issue | WCAG | Elements Affected | How to Fix |
|----------|-------|------|-------------------|------------|
| `color-contrast` | Insufficient contrast ratio | 1.4.3 | `button.primary`, `.result-text` | Increase contrast to 4.5:1 minimum |
| `label` | Form input missing label | 1.3.1 | `#email-input` | Add `<label for="email-input">` |
| `button-name` | Button has no accessible name | 4.1.2 | `button.icon-only` | Add `aria-label` attribute |

### Visual Verification Results (Active State)

| Screenshot | Theme | State | Contrast | Layout | Issues |
|------------|-------|-------|----------|--------|--------|
| app-en-light-active.png | Light | Active | OK/FAIL | OK/FAIL | [notes] |
| app-en-dark-active.png | Dark | Active | OK/FAIL | OK/FAIL | [notes] |
| app-pl-active.png | Polish | Active | OK/FAIL | OK/FAIL | [notes] |
| app-mobile-active.png | Mobile | Active | OK/FAIL | OK/FAIL | [notes] |

### Dynamic Content Accessibility

| Element | Has ARIA | Announced | Keyboard Accessible |
|---------|----------|-----------|---------------------|
| Results display | Yes/No | Yes/No | Yes/No |
| Error messages | Yes/No | Yes/No | Yes/No |
| Loading indicator | Yes/No | Yes/No | N/A |

### Manual Checks (Active State)

| Check | Status | Notes |
|-------|--------|-------|
| Keyboard navigation | PASS/FAIL | [notes] |
| Focus order logical | PASS/FAIL | [notes] |
| Focus visible | PASS/FAIL | [notes] |
| Skip link works | PASS/FAIL | [notes] |
| No keyboard traps | PASS/FAIL | [notes] |
| Heading hierarchy | PASS/FAIL | [notes] |
| Results announced | PASS/FAIL | [notes] |
| Error messages accessible | PASS/FAIL | [notes] |

### Prioritized Fixes

**Critical (Must Fix - Blocks Release):**
1. [Issue] - [Fix recommendation]

**Moderate (Should Fix):**
1. [Issue] - [Fix recommendation]

**Minor (Consider Fixing):**
1. [Issue] - [Fix recommendation]

### Final Verdict

- [ ] **Lighthouse score is exactly 100/100** (REQUIRED)
- [ ] All Lighthouse violations resolved (zero violations)
- [ ] Visual verification passed
- [ ] Manual checks passed

**ACCESSIBILITY STATUS:**
- **APPROVED** - Only if Lighthouse score = 100 AND all other checks pass
- **NOT APPROVED** - If Lighthouse score < 100 OR any check fails

**If NOT APPROVED, list remaining issues and re-run audit after fixes.**
```
