# Quality Gates Checklist

Complete checklist for all quality gates, derived from AGENTS.md requirements.

---

## Serial Campaign Gates (MANDATORY For "Fix All Apps")

Apply this section when the user requests full-catalog remediation.

- [ ] Canonical app inventory frozen from `apps/*/index.php` before delegation starts
- [ ] One work-log TODO item exists per app in the frozen inventory
- [ ] Exactly one app is `IN_PROGRESS` at any moment
- [ ] App N+1 is not delegated until app N is terminal (`DONE` or `BLOCKED`)
- [ ] `DONE` is used only after independent PM verification evidence is recorded
- [ ] First blocking failure sets app to `BLOCKED` and stops the campaign (unless user explicitly overrides)
- [ ] PM reports progress after each app with completed/remaining counts

---

## Documentation Requirements

**Every sub-agent must maintain documentation related to their responsibility.**

### App Documentation (Product Owner + Programmer)

- [ ] `apps/{slug}/SPEC.md` exists with product specification
- [ ] SPEC.md has correct Status field:
  - "Draft" - Initial creation
  - "Approved" - User approved
  - "Implemented" - Code complete
- [ ] SPEC.md includes File Locations section with actual file paths
- [ ] All features listed with acceptance criteria
- [ ] 5 use cases documented

### Module Documentation (All Sub-Agents)

When making significant changes to core modules, sub-agents must update:

| Changed Area | Documentation to Update |
|--------------|------------------------|
| i18n system | `docs/modules/i18n.md` |
| Routing | `docs/modules/routing.md` |
| Testing | `docs/modules/testing.md` |
| Configuration | `docs/modules/configuration.md` |
| Layout/Views | `docs/modules/layout-views.md` |
| Docker/Infrastructure | `docs/infrastructure/docker.md` |
| UI/Design System | `docs/ui/UI-GUIDELINES.md` |

### Documentation Verification Checklist

- [ ] SPEC.md created/updated for new apps
- [ ] SPEC.md status reflects current implementation state
- [ ] Relevant module docs updated if core patterns changed
- [ ] No outdated documentation left after changes
- [ ] File Locations section in SPEC.md is accurate

### PM Tracking Verification Checklist (MANDATORY)

- [ ] PM work log exists in `docs/work_logs/` for this task
- [ ] Work log filename follows `YYYY-MM-DD_HHMM_task-slug.md`
- [ ] Work log has required sections:
  - [ ] Task Metadata
  - [ ] TODO Assignment Table
  - [ ] Status Snapshot
  - [ ] Activity Timeline
  - [ ] Completion Summary
- [ ] TODO Assignment Table statuses use only `TODO|IN_PROGRESS|BLOCKED|DONE|CANCELLED`
- [ ] TODO Assignment Table entries remain non-technical (no file/command/code-level details)
- [ ] Work log updated after each delegation response
- [ ] PM Status Payload recorded for each delegated work item
- [ ] `apps/{slug}/PROJECT.md` (if app task) is generic only and links to the work log

---

## Configuration Requirements

### config/apps.php
- [ ] App added with correct metadata structure
- [ ] Entry sorted alphabetically by slug key
- [ ] Correct category assigned
- [ ] Icon specified

### Canonical slug source / config/slugs.php output
- [ ] Canonical slug source updated for `apps/{slug}`
- [ ] `config/slugs.php` regenerated (not hand-edited)
- [ ] Supported locales included in the emitted output:
  - [ ] en (English)
  - [ ] es (Spanish)
  - [ ] pl (Polish)
- [ ] Emitted entry sorted alphabetically
- [ ] Slugs are lowercase with dashes

---

## Translation Requirements

### All 3 Supported Locale Source Files

Location: `i18n/apps/{slug}/{locale}.json` (plus `_meta.json` for the app)

Rebuild generated runtime bundles with `npm run i18n:build`. Inspect `public/assets/i18n/{locale}.json` only as a targeted last-resort verification step.

**Required keys for each app:**

```json
{
  "title": "App Title",
  "description": "Short description",
  "seoTitle": "SEO optimized title (50-60 chars)",
  "seoDescription": "SEO description (150-160 chars)",
  "helpTitle": "How to Use",
  "openHelp": "Open help",
  "closeHelp": "Close help",
  "skipTo{AppNamePascalCase}": "Skip to App Name",
  "useCasesTitle": "When to Use This App",
  "useCasesIntro": "Short intro sentence for the use cases section",
  "useCase1Title": "Use Case 1 Title",
  "useCase1Desc": "Use Case 1 description",
  "useCase2Title": "Use Case 2 Title",
  "useCase2Desc": "Use Case 2 description",
  "useCase3Title": "Use Case 3 Title",
  "useCase3Desc": "Use Case 3 description",
  "useCase4Title": "Use Case 4 Title",
  "useCase4Desc": "Use Case 4 description",
  "useCase5Title": "Use Case 5 Title",
  "useCase5Desc": "Use Case 5 description"
}
```

**Verification checklist:**
- [ ] All 3 supported locale source files updated
- [ ] No empty translation values
- [ ] Non-English locales have actual translations (not English text copied)
- [ ] Translation key follows camelCase convention
- [ ] Exactly 5 use cases with titles and descriptions

### i18n-manager Validation (MANDATORY)

**Invoke `/i18n-manager` skill after implementation to verify translations.**

The i18n-manager will:
1. Run `AppTranslationsTest.php`
2. Identify untranslated strings
3. Fix issues found
4. Spot-check 3 locales (de, ja, ar)
5. Generate verification report

**Common untranslated strings to check:**
- [ ] `metric` / `imperial` - measurement labels
- [ ] `height` / `weight` - form labels
- [ ] `feet` / `inches` - unit labels
- [ ] `age` / `sex` / `boy` / `girl` - demographic labels
- [ ] `years` / `months` - time labels
- [ ] All button labels
- [ ] All form field labels

**i18n-manager must report PASS before proceeding to Phase 3.**

### Locale-Aware Sorting Verification (MANDATORY)

Apps are automatically sorted by their translated titles for each locale. Verify this works correctly:

- [ ] Apps sorted alphabetically by translated title on homepage
- [ ] Apps sorted alphabetically by translated title on category pages
- [ ] App order differs between locales (e.g., English vs Spanish vs Polish)
- [ ] No app appears "stuck" in the same position across all locales

**How to verify:**
1. Visit homepage in English - note app order
2. Visit homepage in Spanish - app order should differ
3. Visit homepage in Polish - app order should differ

**If sorting appears incorrect:**
- Check that `sortAppsByLocale()` is called in templates
- Verify app has `{appKey}.title` translation in all locales
- Check for missing or copied English translations

### Test File Update

Location: `tests/php/Unit/AppTranslationsTest.php`

- [ ] App added to `APP_TRANSLATION_KEYS` constant
- [ ] Format: `'app-slug' => 'appKey'`
- [ ] Entry sorted alphabetically

---

## Sitemap Requirements

Location: `public/sitemap.xml`

**Add entry:**
```xml
<url>
    <loc>https://appdoesit.com/apps/{slug}</loc>
    <changefreq>monthly</changefreq>
    <priority>0.8</priority>
</url>
```

- [ ] URL entry added
- [ ] Priority set to 0.8 (for apps)
- [ ] Change frequency set to monthly

---

## Security Requirements (Forms Only)

If the app contains forms that submit data:

### CSRF Protection
- [ ] CSRF token generated per session
- [ ] Token included as hidden field in form
- [ ] Token validated server-side before processing
- [ ] Invalid requests rejected with 403

### Bot Protection
- [ ] Honeypot field included (hidden via CSS, not type="hidden")
- [ ] Honeypot field rejection if filled
- [ ] Time-based validation (reject < 3 seconds)
- [ ] Rate limiting considered (if high-value form)

### Input Validation
- [ ] Email validated with `filter_var($email, FILTER_VALIDATE_EMAIL)`
- [ ] Maximum lengths enforced on text inputs
- [ ] Characters whitelisted where appropriate
- [ ] All output escaped with `e()` helper

---

## Accessibility Requirements (WCAG 2.1 AA)

### Structure
- [ ] Proper heading hierarchy (h1 -> h2 -> h3, no skipping)
- [ ] Semantic HTML5 elements (header, nav, main, section, footer)
- [ ] Single h1 per page

### Interactive Elements
- [ ] ARIA labels for all interactive elements
- [ ] Keyboard navigation fully functional
- [ ] Focus indicators visible (no outline:none without replacement)
- [ ] Focus order logical (follows DOM order or tabindex)

### Visual
- [ ] Text contrast ratio 4.5:1 minimum
- [ ] UI component contrast ratio 3:1 minimum
- [ ] Alt text for all images
- [ ] No color-only information

### Mobile
- [ ] Touch targets minimum 44x44px
- [ ] Text readable without zooming
- [ ] No horizontal scrolling
- [ ] Forms usable on mobile

---

## SEO Requirements

### Meta Tags
- [ ] Title tag (50-60 characters)
- [ ] Meta description (150-160 characters)
- [ ] Canonical URL set
- [ ] Open Graph title
- [ ] Open Graph description
- [ ] Open Graph type (website)
- [ ] Open Graph URL
- [ ] Open Graph image (if applicable)

### Structured Data
- [ ] JSON-LD SoftwareApplication schema
- [ ] Valid JSON-LD (test with Google's validator)
- [ ] Required properties: name, description, applicationCategory

### Content
- [ ] Descriptive, keyword-rich content
- [ ] Semantic HTML structure
- [ ] Proper heading hierarchy for SEO

---

## Performance Requirements

### Lighthouse Performance Audit
- [ ] Lighthouse performance score >= 90
- [ ] Run via: `./.agents/skills/performance-expert/scripts/run-perf-audit.sh --app {slug}`

### Core Web Vitals
- [ ] LCP (Largest Contentful Paint) < 2.5s
- [ ] FID (First Input Delay) < 100ms
- [ ] CLS (Cumulative Layout Shift) < 0.1
- [ ] TBT (Total Blocking Time) < 200ms

### HTTP Cache Headers
Verify via: `curl -I http://localhost:8000/apps/{slug}`

**HTML pages:**
- [ ] Cache-Control: no-cache, must-revalidate
- [ ] Vary: Accept-Encoding, Accept-Language

**Static assets (CSS/JS):**
- [ ] Cache-Control: public, max-age=31536000

### Compression
Verify via: `curl -H "Accept-Encoding: gzip" -I http://localhost:8000/apps/{slug}`

- [ ] Content-Encoding: gzip present

### Asset Optimization
- [ ] Cache busting via `asset()` helper (?v=VERSION)
- [ ] Images use WebP format where possible
- [ ] Images have width/height attributes (prevents CLS)
- [ ] Non-critical scripts use `defer` attribute

---

## Testing Requirements

### Test Strategy (Runtime Target)

- **Unit tests (PHPUnit):** cover all source code features + edge cases
- **Integration tests (PHPUnit):** cover all use scenarios + edge cases
- **E2E tests (Playwright):** minimal smoke coverage for critical user journeys only
- **Runtime target:** total automated tests should complete in **under 10 minutes**
- **Order:** Security review -> translation tests -> unit tests -> integration tests -> QA-run minimal E2E + visual analysis

### PHPUnit Tests
- [ ] All existing unit tests pass
- [ ] Route tests pass (`RoutesTest.php`)
- [ ] Translation tests pass (`AppTranslationsTest.php`)
- [ ] Alphabetical order tests pass (`AlphabeticalOrderTest.php`)

### E2E Tests (Playwright)
- [ ] All existing E2E tests pass
- [ ] App-specific tests written (if needed)
- [ ] Dynamic discovery tests automatically include new app
- [ ] E2E coverage is minimal and targeted (no duplication of unit/integration coverage)

### Test Commands
**CRITICAL:** Per `AGENTS.md`, complete a security review before running any automated tests (including `AppTranslationsTest.php`).
```bash
# All tests
.\docker.ps1 test

# PHPUnit only
docker run --rm -v "$(pwd)":/app -w /app php:8.4-cli \
  php vendor/bin/phpunit tests/php/Unit/ --testdox

# Integration only
docker run --rm -v "$(pwd)":/app -w /app php:8.4-cli \
  php vendor/bin/phpunit tests/php/Integration --testdox

# Specific test file
docker run --rm -v "$(pwd)":/app -w /app php:8.4-cli \
  php vendor/bin/phpunit tests/php/Unit/AppTranslationsTest.php --testdox
```

---

## Optional Screenshot Review (Non-Gating)

Use screenshot-based QA only when:
- the user explicitly asks for visual review
- automated test output is insufficient to explain a suspected UI regression
- a specialist requests screenshots for layout, theme, or locale debugging

If screenshots are captured, store them under `var/tmp/qa/` and treat them as supporting evidence rather than a release gate.

---

## UI Quality Requirements

### Dual-Mode UI Expert Coordination
- [ ] If task includes new/major UI changes, `/ui-expert` Interface Design Mode ran before programmer implementation
- [ ] UI Direction Brief shared with programmer, i18n-manager, accessibility-expert, e2e-testing, seo-expert, and performance-expert
- [ ] Programmer documented any justified deviations from the UI Direction Brief
- [ ] Final `/ui-expert` Audit Mode executed before PM marks task complete

### Design System Compliance
- [ ] All spacing uses `--space-*` CSS variables (not px values)
- [ ] All colors use `--color-*` CSS variables (not hex codes)
- [ ] All font sizes use `--font-size-*` variables
- [ ] All border radius uses `--radius-*` variables
- [ ] All shadows use `--shadow-*` variables
- [ ] All transitions use `--transition-*` variables

### Component Patterns
- [ ] App container has `margin: 0 auto` for centering
- [ ] App container has appropriate `max-width` (400-900px)
- [ ] Buttons match design system patterns
- [ ] Form inputs match design system patterns
- [ ] Help panel matches design system patterns

### Visual Polish
- [ ] All buttons have hover states
- [ ] All interactive elements have focus states using `--focus-ring`
- [ ] Transitions are smooth (no jarring state changes)
- [ ] Loading states present where needed
- [ ] Success/error feedback visible

### Cross-App Consistency
- [ ] Component styling matches other apps
- [ ] Spacing patterns match other apps
- [ ] Color usage consistent with other apps
- [ ] Mobile responsive behavior matches other apps

### UI Quality Score
- [ ] UI Expert audit score >= 80/100
- [ ] No CRITICAL issues found
- [ ] All WARNING issues addressed or acknowledged

---

## App Content Requirements

### Help Section
- [ ] Help section exists
- [ ] Step-by-step instructions provided
- [ ] All features documented
- [ ] Keyboard shortcuts listed (if applicable)
- [ ] Translation keys for all help content
- [ ] Accessible via keyboard

### Use Cases Section
- [ ] Use cases section exists
- [ ] Exactly 5 use cases with titles and descriptions
- [ ] Each use case describes specific scenario
- [ ] Translation keys for all use cases
- [ ] Semantic HTML structure

---

## Final Verification

Before marking deployment-ready:

1. **Run all tests:**
   ```bash
   .\docker.ps1 test
   ```
   All tests must pass.

2. **Verify PM tracking artifacts:**
   - Work log is complete and current
   - All delegated items have terminal status (`DONE` or `CANCELLED`) unless explicitly deferred
   - No unresolved blockers without a next owner/action
   - For app tasks, `PROJECT.md` is generic-only and links to the relevant work log

3. **Automated verification complete:**
  - Translation, unit, integration, and required Playwright smoke checks passed
  - No unresolved blockers remain from accessibility, SEO, performance, or UI audits

4. **User approval:**
   - User informed of completion
   - User approves deployment
