# E2E Testing Checklist

**Source of Truth: [AGENTS.md](../../../AGENTS.md)**

This checklist is derived from AGENTS.md Quality Standards. If requirements change, update this file to match.

> **Lean E2E policy:** Keep E2E tests **minimal** (critical journeys only). Unit + integration tests must cover edge cases. Target total automated runtime **< 10 minutes**. QA runs the minimal E2E set after unit/integration pass.

---

## Pre-Testing: Read AGENTS.md

Before testing, review these sections in AGENTS.md:
- [ ] Security review completed (MANDATORY before any automated tests, including translation tests)
- [ ] `## Quality Standards`
- [ ] `### Testing Requirements`
- [ ] `### App Page Requirements (MANDATORY)`
- [ ] `### App Help/Instructions (MANDATORY)`
- [ ] `### Translation Test Maintenance (MANDATORY)`
- [ ] `### Sitemap Maintenance (MANDATORY)`

---

## Functional Requirements

### Core App Functionality
- [ ] Primary feature works correctly
- [ ] All buttons/inputs respond to user interaction
- [ ] Form validation works (if applicable)
- [ ] Error states display correctly
- [ ] Success states display correctly
- [ ] Reset/clear functionality works
- [ ] Copy to clipboard works (if applicable)

### UI State Coverage (Dynamic Text & Messages)

Per `references/state-coverage.md` and UI-GUIDELINES.md "Dynamic Text & Message States":
- [ ] All dynamic text spots identified from source (statuses, button variants, errors, results)
- [ ] The **longest** variant of each message is rendered and asserted visible
- [ ] No clipping/overflow on any dynamic element (`scrollWidth <= clientWidth`)
- [ ] No ellipsis on semantic (non-user-data) text
- [ ] No document-level horizontal scroll in the longest state
- [ ] Checked for all 3 supported locales (`en`, `es`, `pl`)

### Keyboard Support
- [ ] Tab navigation works in logical order
- [ ] Enter/Space activate buttons
- [ ] Escape closes modals
- [ ] Arrow keys work where expected

---

## i18n Requirements (All 3 Supported Locales - per AGENTS.md)

**From AGENTS.md: All 3 supported locales (`en`, `es`, `pl`) must be supported.**

### Full Locale List
```
en, es, pl
```

### Locale Verification Table (All 3 Supported Locales Required)

| Locale | URL Works | Page Loads | No Raw Keys | Translated | Layout OK |
|--------|-----------|------------|-------------|------------|-----------|
| en | [ ] | [ ] | [ ] | N/A | [ ] |
| es | [ ] | [ ] | [ ] | [ ] | [ ] |
| pl | [ ] | [ ] | [ ] | [ ] | [ ] |

### Translation Keys (from AGENTS.md Translation Test Maintenance)
- [ ] `title`
- [ ] `description`
- [ ] `seoTitle`
- [ ] `seoDescription`
- [ ] `helpTitle`
- [ ] `openHelp`
- [ ] `closeHelp`
- [ ] Help content keys used by the app are present in all locales (key parity with English)
- [ ] `useCasesTitle`
- [ ] `useCasesIntro`
- [ ] `useCase1Title` / `useCase1Desc` ... `useCase5Title` / `useCase5Desc`
- [ ] `skipTo{AppNamePascalCase}` (exact key name must match `AppTranslationsTest.php`)

---

## Optional Screenshot Capture (Non-Gating)

Capture screenshots only when:
- the user explicitly asks for visual review
- you need artifacts to debug a suspected layout, theme, or locale issue
- documenting a failing E2E run will help the next owner reproduce the problem

If screenshots are captured:
- [ ] Store them under `var/tmp/qa/`
- [ ] Note the file paths in the report
- [ ] Treat them as supporting evidence, not as a release blocker by themselves

---

## App Help/Instructions (MANDATORY - per AGENTS.md)

**From AGENTS.md `### App Help/Instructions (MANDATORY)`**

### Structure
- [ ] Help toggle button present (`#help-toggle`)
- [ ] Help modal/section exists
- [ ] Close button present

### Content
- [ ] Step-by-step instructions
- [ ] All features documented
- [ ] Keyboard shortcuts listed (if any)
- [ ] Tips provided

### Accessibility
- [ ] `role="dialog"` on modal
- [ ] `aria-labelledby` references title
- [ ] `aria-modal="true"`
- [ ] Keyboard accessible

---

## App Page Requirements (MANDATORY - per AGENTS.md)

**From AGENTS.md `### App Page Requirements (MANDATORY)`**

### Use Cases Section
- [ ] Section present with visible content
- [ ] Title in `<h2>`
- [ ] Exactly 5 use cases
- [ ] Each has title and description
- [ ] Translated for all 3 supported locales

---

## Sitemap Maintenance (MANDATORY - per AGENTS.md)

**From AGENTS.md `### Sitemap Maintenance (MANDATORY)`**

- [ ] App URL in `public/sitemap.xml`
- [ ] All 3 supported locale variants have hreflang links
- [ ] Priority set to 0.8
- [ ] changefreq set to monthly
- [ ] English URLs don't have `/en/` prefix

---

## Accessibility (WCAG 2.1 AA - per AGENTS.md)

**From AGENTS.md `### Accessibility (WCAG 2.1 AA)`**

- [ ] Proper heading hierarchy
- [ ] ARIA labels for interactive elements
- [ ] Keyboard navigation support
- [ ] Sufficient color contrast
- [ ] Focus indicators
- [ ] Skip link present

---

## SEO (per AGENTS.md)

**From AGENTS.md `### SEO`**

- [ ] Semantic HTML5 structure
- [ ] Proper meta tags (title, description, Open Graph)
- [ ] Canonical URLs set
- [ ] JSON-LD structured data present

---

## Updating This Checklist

When AGENTS.md changes:

1. Check for new MANDATORY sections:
   ```bash
   grep -n "MANDATORY" AGENTS.md
   ```

2. Check for new requirements:
   ```bash
   git diff HEAD~5 AGENTS.md
   ```

3. Update this checklist to match AGENTS.md

4. Update the "From AGENTS.md" references
