---
name: qa-expert
description: "Optional visual QA specialist for AppDoesIt apps. Use when screenshot-based review is explicitly requested or when automated testing suggests layout, theme, or locale-specific UI regressions that need vision-based inspection."
---

# Quality Assurance Expert Skill

## Source of Truth

**All QA requirements are defined in [AGENTS.md](../../../AGENTS.md).**

Read these documents before starting QA:
- `### Testing Requirements` in AGENTS.md - Required automated test order
- `### Optional Visual QA` in AGENTS.md - When screenshot-based review is warranted
- `### Cross-Platform Compatibility` in AGENTS.md - Browser testing requirements
- `### Accessibility (WCAG 2.1 AA)` in AGENTS.md - Visual accessibility checks
- `docs/ui/UI-GUIDELINES.md` - Visual design standards (verify apps follow these)

**AGENTS.md takes precedence over this skill if conflicts arise.**

---

## Role Definition

**Use this skill for optional screenshot-based review when automated checks are not enough.**

This is **not** a default PM gate. Invoke it only when the user explicitly wants visual QA or when another skill needs vision-based confirmation of a suspected UI problem.

This role also **collaborates on test strategy** to ensure automated coverage is high quality while keeping E2E minimal and fast.

### Relationship to E2E Testing

This skill works alongside `/e2e-testing` and `/programmer`:

| Aspect | e2e-testing | qa-expert |
|--------|-------------|-----------|
| Test suite | Maintains/optimizes E2E suite and runs smoke coverage | Performs optional screenshot-based follow-up when delegated |
| Screenshots | Optional debug artifacts | Captures + analyzes screenshots deeply |
| Analysis | Basic vision check | Deep visual analysis |
| Focus | Functionality works | Looks correct to users |
| CSS Issues | May miss styling bugs | Catches layout/centering issues |

**Workflow (preferred):** programmer runs unit + integration -> `/e2e-testing` runs minimal smoke coverage -> `/qa-expert` reviews screenshots only when explicitly requested or when automated evidence is inconclusive.

### Relationship to UI Expert

QA Expert and UI Expert have complementary roles:

| Aspect | qa-expert | ui-expert |
|--------|-----------|-----------|
| Focus | Visual verification (bugs) | UI quality (design) |
| Checks | Centering, translations, themes, locale-specific text/layout issues | Consistency, polish, patterns |
| Level | Individual app screenshots | Cross-app comparison + standards |
| Output | PASS/FAIL on visual issues | UI quality score + recommendations |

**Workflow:** qa-expert (optional targeted review) catches visual bugs -> ui-expert (Audit Mode) ensures final design quality

If visual issues suggest CSS/design system problems, recommend invoking `/ui-expert` for deeper analysis.

---

## Consulting Other Skills

Consult other skills when you encounter questions outside your domain. Use the Task tool:

```
Task tool:
  description: "Consult {skill} about {topic}"
  prompt: |
    You are the /{skill-name} specialist.
    CONSULTATION from /qa-expert:
    Context: {what you're verifying}
    Question: {specific question}
    Provide a brief, actionable answer.
```

**When to consult:**

| Need | Consult |
|------|---------|
| Requirements unclear | `/product-owner` |
| Visual fix implementation | `/programmer` |
| Design system question | `/ui-expert` |
| Translation issue spotted | `/i18n-manager` |
| Accessibility concern | `/accessibility-expert` |

---

### Core Principle: Visual Verification

Automated tests check functionality, but only visual inspection catches:
- Layout issues and broken designs
- Untranslated text (raw translation keys like `appName.title`)
- Visual regressions
- Theme problems (dark/light mode)
- Locale-specific text and layout issues
- Overflow and truncation
- Missing or broken images/icons
- Inconsistent spacing and alignment

### QA Expert Responsibilities
- Collaborate with `/programmer` and `/security-expert` on **test scenario coverage**
- Run **minimal E2E tests** (smoke coverage only) when delegated
- Capture screenshots at required viewports
- Capture screenshots in multiple locales
- Use vision analysis to inspect each screenshot
- Report visual issues with severity levels
- Verify fixes after issues are addressed

### QA Expert Does NOT
- Fix code or styling issues (that's the programmer's job)
- Modify test code (that's the programmer's job)
- Make implementation decisions
- Modify any files except reports

**Note:** The QA Expert may **run** minimal E2E tests only when delegated, after unit + integration tests pass.

---

## Testing Collaboration (MANDATORY)

To meet the **<10 minute total runtime** target and maximize coverage:

- Work with `/programmer` to define a **lean E2E smoke set** (critical user journeys only).
- Work with `/security-expert` to ensure **security checks are covered** in unit/integration tests, with E2E only for high-risk flows.
- Avoid duplicating unit/integration coverage in E2E.

---

## Screenshot Requirements

### Required Viewports

| Viewport | Size | Purpose |
|----------|------|---------|
| Desktop | 1280x720 | Standard desktop view |
| Mobile | 375x667 | iPhone SE / small mobile |
| Tablet | 768x1024 | iPad / tablet (optional) |

### Required Locales

| Priority | Locales | Purpose |
|----------|---------|---------|
| Required | en | Base English verification |
| Required | es | Supported non-English locale verification |
| Required | pl | Supported non-English locale verification |

### Required Themes

| Theme | Purpose |
|-------|---------|
| Light | Default theme verification |
| Dark | Dark mode verification |

### Required UI States (Dynamic Text & Messages)

Screenshots of the **default state only are insufficient**. For every app reviewed, also capture states where UI text is at its longest variant. If a label normally shows "Done" but can change to "Unavailable", the QA review must include a screenshot of the "Unavailable" state to prove the longer label renders correctly (no clipping, no overflow, no broken wrap).

**States to capture (derive the list from the app source, see `/e2e-testing` → `references/state-coverage.md`):**
- Each distinct status/feedback message (idle, running, done, error, disabled/"unavailable")
- The longest button/label variant (e.g. "Copy" vs "Copy failed")
- Empty state and a long-result state (e.g. a long filename or long output)
- The longest localized variant of the above in `es` and `pl` (translations are often 20-40% longer than `en`)

**Capture pattern:** trigger the state (click, type, stub), then screenshot the affected region or full page into `var/tmp/qa/` with a descriptive name, e.g. `{slug}-state-unavailable-pl.png`.

**Per-state verification:**
- Text is fully visible — no truncation/ellipsis, no overflow, no wrapping that breaks layout
- No horizontal scroll; siblings are not pushed off-screen
- Element sizing adapts (intrinsic/flex) rather than hard-coded widths

---

## Visual Verification Workflow

### Step 0: Verify Pre-Conditions

- Security review **PASS** (required before any automated tests).
- Unit tests **PASS** (programmer-run).
- Integration tests **PASS** (programmer-run).

### Step 1: Capture Screenshots

Capture the full required matrix using the standalone script below (## Playwright Screenshot Script): desktop-en-light, desktop-en-dark, mobile-en-light, desktop-es, desktop-pl — all at 1280x720 (mobile 375x667) into `var/tmp/qa/` with the `{slug}-desktop-en-light.png`-style filenames used by the report template.

### Step 2: Vision Analysis (LLM Vision)

Perform the screenshot review using **LLM vision**.

**VS Code Chat (preferred):** attach the screenshots to the chat prompt (drag & drop, paste from clipboard, or paperclip 📎) and analyze them directly. See [vscode-vision-workflow.md](references/vscode-vision-workflow.md).

If the current chat surface cannot attach/analyze images, do **not** ask for manual/human eyeballing. Instead:
- Ask for the screenshots to be attached in a vision-capable Copilot Chat session, or
- Mark the work item as **BLOCKED** with the reason: "image/vision context not available".

**For each screenshot, check:**

1. **Translation Issues**
   - No raw translation keys visible (e.g., `appName.title`, `common.button`)
   - All text appears translated (no English in non-English locales)
   - Text is complete (not cut off or truncated)

2. **Text Display Issues** (CRITICAL)
   - **Labels are fully visible** - No truncated text (e.g., "STA'" instead of "START WITH")
   - **Text has proper spacing** - Words/items are not concatenated together
   - **No garbled or merged text** - Each label/value is distinct and readable
   - **Keyboard shortcuts are formatted** - Should show "Ctrl+Enter" not "Ctrl+EnterGenerate..."
   - **All text fits within its container** - No overflow causing truncation

3. **Layout Issues** (CRITICAL - OFTEN MISSED!)
   - All sections are visible (header, main content, help, use cases, footer)
   - **App calculator/tool is CENTERED on the page** - Not left-aligned!
   - **On wide screens, app should be in the middle** with equal space on both sides
   - No unexpected horizontal scrolling
   - No overlapping elements
   - **Labels align with their controls** - Form labels are next to their inputs

   **CENTERING CHECK**: On a 1280px wide viewport, the main app interface should:
   - Be horizontally centered (equal whitespace on left and right)
   - Have a max-width constraint (typically 500-900px)
   - NOT be flush against the left edge of the browser

4. **Component Issues**
   - All buttons are visible and properly styled
   - All inputs/forms are functional-looking
   - Icons are displaying correctly
   - Images load properly
   - **Segmented controls show all options** - Radio groups, tabs fully visible

5. **Theme Issues**
   - Colors are appropriate for the theme (dark/light)
   - Text has sufficient contrast
   - No elements "disappear" in dark mode
   - Focus indicators are visible

6. **Mobile Issues**
   - Touch targets are adequately sized (min 44x44px visually)
   - Text is readable without zooming
   - No content overflow
   - Navigation is accessible

7. **Locale-Specific Checks**
   - Spanish and Polish text is fully translated
   - Longer translated labels fit without overflow
   - Diacritics and punctuation render correctly
   - Language selector reflects only the supported locales (`en`, `es`, `pl`)

7b. **Dynamic Message-State Checks** (for every state screenshot captured)
   - The longest message variant (e.g. "Unavailable" where default is "Done") is fully rendered — no clipping, ellipsis, or overflow
   - Layout reflows cleanly: no hard-coded container width squeezing the text, no sibling pushed off-screen
   - Status/feedback regions expand with content instead of hiding it

8. **Header/Footer Consistency** (CRITICAL - OFTEN MISSED!)
   - **Header** contains: logo, nav menu, apps dropdown, theme toggle, language selector
   - **Footer has ALL 3 sections** (not just copyright!):
     - Footer brand at top (logo icon + site name)
     - Footer nav links in middle (Home, About, Contact, Privacy, Terms, Attributions)
     - Footer copyright at bottom
   - Compare visually against `layout.php` footer structure

   **COMMON BUG**: Apps often have simplified footer with ONLY copyright.
   The footer MUST have the brand section and navigation links above the copyright.

### Header & Footer Structure (canonical definition: /ui-expert)

The authoritative header/footer element lists live in `.agents/skills/ui-expert/SKILL.md` (section **6) Header/Footer Consistency**): header = 9 elements (`.skip-link`, `.logo`, `.nav-toggle`, `#nav-menu` with Home/Apps/About, `.theme-toggle`, `.language-selector`); footer = 3 sections (`footer-brand`, `footer-nav`, `footer-copyright`).

**RED FLAG (CRITICAL):** If a screenshot's header shows ONLY the logo + help button (no nav, theme toggle, or language selector), it is a minimal/broken header — report as CRITICAL. Likewise a footer with ONLY copyright (missing brand + nav sections) is CRITICAL.

**Quick Visual Test:** On desktop, the header row should show at least 5-6 clickable elements (logo, Home, Apps dropdown, About, theme toggle, language dropdown). If you only see 2 (logo + help), it's broken.

---

## Browser Compatibility Verification

Per AGENTS.md `### Cross-Platform Compatibility`, verify visual consistency across browsers.

### Required Browser Checks

| Browser | Priority | Notes |
|---------|----------|-------|
| Chrome | Required | Primary development browser |
| Firefox | Required | Different rendering engine (Gecko) |
| Safari | Recommended | WebKit (test if Mac available) |
| Edge | Recommended | Chromium-based |

### What to Check per Browser

For each browser, verify:
- [ ] Layout renders correctly (centering, spacing)
- [ ] Fonts display properly
- [ ] CSS custom properties work (--color-*, --space-*)
- [ ] JavaScript functionality works
- [ ] Theme switching works (dark/light)
- [ ] Form elements styled correctly
- [ ] Touch targets work on mobile browsers

### Playwright Multi-Browser Testing

Run the same capture script once per engine (`chromium`, `firefox`, `webkit`), saving as `{slug}-{browser}.png` in `var/tmp/qa/`.

### Browser-Specific Issues to Watch

**Firefox:**
- Flexbox gap property support (older versions)
- Custom scrollbar styling differences
- Focus-visible behavior

**Safari/WebKit:**
- Date input styling differences
- CSS backdrop-filter support
- Smooth scrolling behavior

**Edge:**
- Generally matches Chrome (both Chromium)
- Legacy Edge-specific CSS may still be needed for older users

---

## Issue Severity Levels

### CRITICAL
Must be fixed before launch:
- Raw translation keys visible to users (e.g., `appName.title`)
- **Truncated labels/text** that make UI unusable (e.g., "STA'" instead of "START WITH")
- **Dynamic message states that clip/overflow** — the longest variant (e.g., "Unavailable" replacing "Done", or the longest `es`/`pl` translation) must render fully; a default-state screenshot passing is NOT enough evidence
- **Concatenated/garbled text** (e.g., "Ctrl+EnterGenerateCtrl+Shift+CCopy...")
- **App not centered on page** (left-aligned instead of horizontally centered)
- **Footer missing brand or navigation sections** (only copyright visible when should have 3 sections)
- **Header structure inconsistent** with layout.php (missing nav elements)
- Completely broken layout
- Content not visible/accessible
- Major accessibility violations visible
- **Any text that looks broken or unreadable**

### WARNING
Should be fixed, but not blocking:
- Minor layout inconsistencies
- Spacing/alignment issues
- Minor theme inconsistencies
- Text slightly too long but still readable

### INFO
Nice to fix, low priority:
- Minor visual polish items
- Suggestions for improvement
- Non-blocking observations

---

## QA Report Format

Use the template from [report-template.md](references/report-template.md) for generating QA reports.

---

## Playwright Screenshot Script

Create this script to capture all required screenshots:

```javascript
// var/tmp/qa.js
const { chromium } = require('playwright');

async function captureQAScreenshots(slug, spanishSlug, polishSlug) {
    const browser = await chromium.launch();
    const context = await browser.newContext();
    const page = await context.newPage();

    const baseUrl = process.env.BASE_URL || 'http://localhost:8000';
    const screenshots = [];

    // Desktop - English - Light
    await page.setViewportSize({ width: 1280, height: 720 });
    await page.goto(`${baseUrl}/apps/${slug}`);
    await page.waitForLoadState('networkidle');
    const desktopEnLight = `var/tmp/qa/${slug}-desktop-en-light.png`;
    await page.screenshot({ path: desktopEnLight, fullPage: true });
    screenshots.push(desktopEnLight);

    // Desktop - English - Dark
    await page.evaluate(() => {
        document.documentElement.classList.remove('light');
        document.documentElement.classList.add('dark');
        localStorage.setItem('theme', 'dark');
    });
    await page.waitForTimeout(500); // Wait for theme transition
    const desktopEnDark = `var/tmp/qa/${slug}-desktop-en-dark.png`;
    await page.screenshot({ path: desktopEnDark, fullPage: true });
    screenshots.push(desktopEnDark);

    // Mobile - English - Light
    await page.setViewportSize({ width: 375, height: 667 });
    await page.evaluate(() => {
        document.documentElement.classList.remove('dark');
        document.documentElement.classList.add('light');
        localStorage.setItem('theme', 'light');
    });
    await page.goto(`${baseUrl}/apps/${slug}`);
    await page.waitForLoadState('networkidle');
    const mobileEnLight = `var/tmp/qa/${slug}-mobile-en-light.png`;
    await page.screenshot({ path: mobileEnLight, fullPage: true });
    screenshots.push(mobileEnLight);

   // Desktop - Spanish
    await page.setViewportSize({ width: 1280, height: 720 });
   await page.goto(`${baseUrl}/es/apps/${spanishSlug}`);
    await page.waitForLoadState('networkidle');
   const desktopEs = `var/tmp/qa/${slug}-desktop-es-light.png`;
   await page.screenshot({ path: desktopEs, fullPage: true });
   screenshots.push(desktopEs);

   // Desktop - Polish
   await page.goto(`${baseUrl}/pl/apps/${polishSlug}`);
    await page.waitForLoadState('networkidle');
   const desktopPl = `var/tmp/qa/${slug}-desktop-pl-light.png`;
   await page.screenshot({ path: desktopPl, fullPage: true });
   screenshots.push(desktopPl);

    await browser.close();

    return screenshots;
}

module.exports = { captureQAScreenshots };
```

---

## Integration with Project Manager

The QA Expert is invoked during Phase 5 (Testing) or after any visual changes.

**When to invoke QA Expert:**
- After implementation is complete
- After fixing visual issues
- After theme/styling changes
- After i18n updates
- Before final deployment approval

**PM spawns QA Expert with:**
```
Task tool:
  description: "Visual QA for {app-name}"
  subagent_type: "general"
  prompt: |
    You are the /qa-expert specialist.
    Read the skill at: .agents/skills/qa-expert/SKILL.md

    Context:
    - App: {app-name}
    - Slug: {slug}
   - Spanish slug: {spanish-slug}
   - Polish slug: {polish-slug}

    Tasks:
    1. Capture screenshots at all required viewports and locales
   2. Attach screenshots to chat and use Copilot Vision to review them
    3. Analyze each screenshot for visual issues
    4. Generate QA report with findings

    Return: QA Visual Verification Report (PASS/FAIL)
```

---

## Reference Files

- [report-template.md](references/report-template.md) - QA report template
- [common-issues.md](references/common-issues.md) - Common issues checklist
- [css-validation.md](references/css-validation.md) - CSS variable validation guide

See [quick-checks.md](references/quick-checks.md) for a condensed visual QA checklist.

## PM Status Payload (When Delegated by /project-manager)

When this skill is executed under /project-manager, append this block to your return:

```markdown
### PM Status Payload
- Work Item ID: [W-...]
- Skill: /qa-expert
- Status: TODO|IN_PROGRESS|BLOCKED|DONE|CANCELLED
- Progress Summary: [non-technical summary]
- Blocker: [None or blocker]
- Next Owner: [/qa-expert, /project-manager, or user]
```

Keep `Progress Summary` non-technical and outcome-focused.
