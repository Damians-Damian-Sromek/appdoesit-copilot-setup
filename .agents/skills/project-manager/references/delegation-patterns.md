# Sub-Agent Delegation Patterns

How the Project Manager spawns sub-agents to delegate work to specialist skills.

## Delegation Mechanism

Use the **Task tool** with `subagent_type: "general"` to spawn sub-agents that execute specialist skills.

**Pattern:**
```
Task tool:
  description: "Brief description"
  subagent_type: "general"
  prompt: |
    You are the /{skill-name} specialist.
    Read AGENTS.md first, then read your skill file.
    Read the skill at: .agents/skills/{skill-name}/SKILL.md

    Work Item ID: {work-item-id}
    Context: {project context}
    Tasks: {specific tasks}

    Documentation: If your work changes any documented behavior or introduces
    new patterns, update the relevant documentation in docs/ or the skill file.

    Return:
    1) {expected output format}
    2) PM Status Payload:
       - Work Item ID: {work-item-id}
       - Skill: /{skill-name}
       - Status: TODO|IN_PROGRESS|BLOCKED|DONE|CANCELLED
       - Progress Summary: {non-technical summary}
       - Blocker: {None or blocker}
       - Next Owner: {skill-name or PM/user}
```

## Mandatory Prompt Fields (Apply To Every Template Below)

Every PM delegation prompt in this file must include:

- `Work Item ID`
- non-technical outcome-focused task statement
- required `PM Status Payload` in the return format

For brevity, if a template below does not explicitly restate the payload block, it is still mandatory and must be included in the delegated return.

Every PM update cycle must:

1. update `docs/work_logs/{YYYY-MM-DD_HHMM_task-slug}.md`
2. then update `apps/{slug}/PROJECT.md` only with high-level generic status (for app tasks)

---

## Fix-All Apps Serial Campaign (MANDATORY For "Fix All Apps" Requests)

Use this workflow when the user asks to remediate all apps or verify the whole app catalog.

### Campaign Contract (non-negotiable)

1. Freeze the app inventory from `apps/*/index.php` before any delegation.
2. Create one TODO row per app in the PM work log.
3. Keep only one app in `IN_PROGRESS` status at a time.
4. Spawn exactly one specialist sub-agent per app iteration.
5. Require independent quality-gate evidence before marking an app `DONE`.
6. Do not start app N+1 until app N is `DONE`.
7. On first blocking failure, set campaign status to `BLOCKED` and stop (unless the user explicitly chooses continue mode).

### Canonical Inventory Discovery (example command)

```bash
rg --files apps | rg '/index\.php$' | sed -E 's#^apps/([^/]+)/index\.php#\1#' | sort
```

### PM Kickoff Prompt Template (Use As-Is)

```
Task tool:
  description: "Run serial fix-all-apps campaign"
  subagent_type: "general"
  prompt: |
    You are the /project-manager specialist.
    Read AGENTS.md first, then read your skill file.
    Read the skill at: .agents/skills/project-manager/SKILL.md
    Read references:
    - .agents/skills/project-manager/references/delegation-patterns.md
    - .agents/skills/project-manager/references/fix-all-apps-serial.md
    - .agents/skills/project-manager/references/quality-gates.md

    Work Item ID: W-000
    Context:
    - Objective: Fix all apps with complete coverage and no skipped apps
    - Policy: Stop on first blocker
    - Verification: Independent gate evidence required per app before advancing

    Tasks:
    1. Build and freeze canonical app inventory from apps/*/index.php
    2. Create/reuse docs/work_logs/YYYY-MM-DD_HHMM_fix-all-apps.md
    3. Add one TODO row per app (non-technical wording)
    4. Execute strict serial loop:
       - Select next TODO app
       - Set IN_PROGRESS
       - Delegate one-app remediation
       - Validate independent gate evidence
       - Mark DONE or BLOCKED
       - Stop immediately on BLOCKED
    5. After each app iteration, emit progress:
       - app slug, status, evidence summary, remaining count

    Return:
    1) Campaign status report with completed app list + remaining queue
    2) PM Status Payload:
       - Work Item ID: W-000
       - Skill: /project-manager
       - Status: TODO|IN_PROGRESS|BLOCKED|DONE|CANCELLED
       - Progress Summary: non-technical summary
       - Blocker: None or blocker
       - Next Owner: PM/user
```

### Per-App Delegation Template (within campaign loop)

```
Task tool:
  description: "Remediate app {slug} (single-app iteration)"
  subagent_type: "general"
  prompt: |
    You are the /programmer specialist.
    Read AGENTS.md first, then read your skill file.
    Read the skill at: .agents/skills/programmer/SKILL.md

    Work Item ID: W-{NNN}
    Context:
    - Campaign: fix-all-apps serial loop
    - Target app: {slug}
    - Rule: only this app may be modified in this iteration

    Tasks:
    1. Fix implementation/compliance issues for this app only
    2. Coordinate with required specialist skills per quality gates
    3. Return concrete evidence needed for PM independent gate checks

    Return:
    1) Single-app completion report with evidence
    2) PM Status Payload:
       - Work Item ID: W-{NNN}
       - Skill: /programmer
       - Status: TODO|IN_PROGRESS|BLOCKED|DONE|CANCELLED
       - Progress Summary: non-technical summary
       - Blocker: None or blocker
       - Next Owner: PM/next specialist
```

---

## Documentation Ownership by Sub-Agent

Each sub-agent is responsible for maintaining documentation in their domain:

| Sub-Agent | Documentation Ownership |
|-----------|------------------------|
| `/product-owner` | `apps/{slug}/SPEC.md` - Create and maintain product specifications |
| `/programmer` | Update SPEC.md status, add code comments, document implementation changes |
| `/i18n-manager` | `docs/modules/i18n.md` - Keep i18n patterns and locale coverage updated |
| `/accessibility-expert` | Accessibility guidelines, document recurring a11y patterns |
| `/seo-expert` | SEO patterns in skill file, meta tag documentation |
| `/performance-expert` | `docs/infrastructure/` - Caching docs, performance guidelines |
| `/e2e-testing` | `docs/modules/testing.md` - Test patterns and workflows |
| `/qa-expert` | Optional visual QA guidance and screenshot review prompts |
| `/ui-expert` | `docs/ui/UI-GUIDELINES.md` - Design system documentation |

**IMPORTANT:** Always include the documentation reminder in delegation prompts.

---

## Consulting Product Owner (From Any Phase)

Any sub-agent can consult the Product Owner when requirements are unclear. Use this pattern when:
- A requirement is ambiguous
- Acceptance criteria need clarification
- User intent is not clear from the SPEC.md
- Trade-offs between features need decisions
- Scope questions arise

### Spawn Product Owner Consultation Sub-Agent

```
Task tool:
  description: "Clarify requirement for {feature}"
  subagent_type: "general"
  prompt: |
    You are the /product-owner specialist.
    Read the skill at: .agents/skills/product-owner/SKILL.md

    Work Item ID: {work-item-id}
    Context:
    - App: {app-name}
    - SPEC location: apps/{slug}/SPEC.md
    - Requesting skill: {skill-name} (e.g., programmer, accessibility-expert)

    Question:
    {specific question about requirements}

    Example questions:
    - "Should the calculator support keyboard shortcuts? Not specified in SPEC."
    - "What happens when input is invalid? Error message or silent rejection?"
    - "Is offline mode in scope or out of scope? Not specified in SPEC."
    - "The SPEC says '5 use cases' but only lists 4. What should the 5th be?"

    Tasks:
    1. Review the SPEC.md for relevant context
    2. Clarify the requirement based on the product vision
    3. If needed, ask the user for clarification
    4. Update SPEC.md with clarified acceptance criteria if significant

    Return:
    ## Requirement Clarification

    **Question:** {original question}

    **Answer:** {clear answer with rationale}

    **Updated Acceptance Criteria:** (if applicable)
    - {new or clarified criteria}

    **SPEC.md Updated:** Yes/No
```

### Expected Output
- Clear answer to the question
- Rationale for the decision
- Updated acceptance criteria if needed
- SPEC.md may be updated with clarifications

---

## Phase 1: Product Owner

### Spawn Product Owner Sub-Agent

```
Task tool:
  description: "Gather requirements for {app-name}"
  subagent_type: "general"
  prompt: |
    You are the /product-owner specialist.
    Read the skill at: .agents/skills/product-owner/SKILL.md

    Work Item ID: {work-item-id}
    Context:
    - User request: {user's original request}
    - App concept: {brief concept}

    Tasks:
    1. Clarify the app concept with the user
    2. Research competitors via web research (webfetch)
    3. Define target audience and 5 use cases
    4. Define features (WILL be built) with acceptance criteria
    5. Define out of scope (explicit exclusions)
    6. Specify UI/UX requirements
    7. Create product specification

    Documentation:
    - CREATE apps/{slug}/SPEC.md with complete product specification
    - Set Status: "Draft" until user approves, then "Approved"
    - Include all acceptance criteria for each feature

    Return:
    - Save specification to apps/{slug}/SPEC.md
    - Report: Specification summary and user approval status
```

### Expected Output
- `apps/{slug}/SPEC.md` created
- User approval obtained
- 5 use cases defined

---

## Phase 1b: UI Expert (Interface Design Mode - Recommended For New/Major UI)

Use this phase when the task includes new screens, significant layout changes, or major UI behavior changes.

### Spawn UI Expert Sub-Agent (Interface Design Mode)

```
Task tool:
  description: "Define UI direction for {app-name}"
  subagent_type: "general"
  prompt: |
    You are the /ui-expert specialist.
    Read the skill at: .agents/skills/ui-expert/SKILL.md

    Work Item ID: {work-item-id}
    Context:
    - App name: {app-name}
    - Slug: {slug}
    - SPEC location: apps/{slug}/SPEC.md
    - Existing UI patterns: docs/ui/UI-GUIDELINES.md + public/assets/css/main.css

    Tasks:
    1. Run Interface Design Mode
    2. Produce a UI Direction Brief with:
       - Intent summary (user + action + feel)
       - Domain, Color World, Signature, and Default replacements
       - Component hierarchy and interaction states
       - Design token and spacing guidance aligned to AppDoesIt
    3. Add cross-skill handoff notes:
       - Programmer: implementation constraints and component/state expectations
      - i18n-manager: text expansion and locale-specific layout concerns
       - accessibility-expert: keyboard/focus/contrast constraints
       - seo-expert: semantic structure and content hierarchy requirements
       - performance-expert: motion/animation limits and performance-sensitive UI choices
       - e2e-testing: smoke-flow priorities and likely regression hotspots
    4. Flag any high-risk tradeoffs requiring PM/user decision

    Return:
    ## UI Direction Brief
    {Full brief}

    ## Cross-Skill Handoff Notes
    - Programmer: ...
    - i18n-manager: ...
    - accessibility-expert: ...
    - seo-expert: ...
    - performance-expert: ...
    - e2e-testing: ...
```

### Expected Output
- UI Direction Brief usable by programmer and all audit specialists
- Explicit cross-skill constraints and handoff notes

---

## Phase 2a: Programmer

### Spawn Programmer Sub-Agent

```
Task tool:
  description: "Implement {app-name} app"
  subagent_type: "general"
  prompt: |
    You are the /programmer specialist.
    Read the skill at: .agents/skills/programmer/SKILL.md

    Work Item ID: {work-item-id}
    Context:
    - App name: {app-name}
    - Slug: {slug}
    - Translation key: {appKey}
    - SPEC location: apps/{slug}/SPEC.md
    - UI Direction Brief: {from Phase 1b if available}

    Tasks:
    1. Read the SPEC.md specification and UI Direction Brief (if provided)
    2. Create apps/{slug}/index.php (main template)
    3. Create public/assets/js/{slug}.js (if needed)
    4. Create public/assets/css/{slug}.css (if needed)
    5. Update config/apps.php (add entry alphabetically)
    6. Update the canonical slug source/workflow and regenerate config/slugs.php (supported locale slugs for `en`, `es`, `pl`; emitted output alphabetical)
    7. Update public/sitemap.xml (add URL entry)
    8. Update tests/php/Unit/AppTranslationsTest.php (add to APP_TRANSLATION_KEYS)
    9. Collaborate with /e2e-testing and /security-expert on test scenarios and security checks
    10. Implement unit + integration tests covering all use scenarios and edge cases
    11. Keep E2E coverage minimal (smoke tests only; avoid duplication)
    12. Implement help section with instructions
    13. Implement use cases section (5 cases)
    14. If forms: implement CSRF, honeypot, time validation
    15. If UI Direction Brief is provided, follow it and document justified deviations

    Documentation:
    - UPDATE apps/{slug}/SPEC.md: Set Status to "Implemented" when complete
    - UPDATE apps/{slug}/SPEC.md: Add File Locations section with actual paths
    - If implementation deviates from spec, document the changes in SPEC.md
    - If implementation deviates from UI Direction Brief, document the reason in the completion report
    - Add inline code comments for complex logic

    Return completion report:
    ## Programmer Completion Report

    **Files Created:**
    - [ ] apps/{slug}/index.php
    - [ ] public/assets/js/{slug}.js (if applicable)
    - [ ] public/assets/css/{slug}.css (if applicable)

    **Configuration Updated:**
    - [ ] config/apps.php - Entry added
    - [ ] Canonical slug source updated and config/slugs.php regenerated with supported locales (`en`, `es`, `pl`)
    - [ ] public/sitemap.xml - URL added
    - [ ] AppTranslationsTest.php - APP_TRANSLATION_KEYS updated

    **Features Implemented:**
    - [ ] Help section
    - [ ] Use cases (5)
    - [ ] Form security (if applicable)

    **Tests Added/Updated:**
    - [ ] Unit tests for scenarios + edge cases
    - [ ] Integration tests for scenarios + edge cases
    - [ ] E2E smoke plan reviewed with QA

    **Documentation Updated:**
    - [ ] SPEC.md status updated to "Implemented"
    - [ ] File Locations section added to SPEC.md

    **Notes:**
    {Any implementation notes}
```

### Expected Output
- App directory and files created
- All config files updated
- Completion report with checklist

---

## Phase 2b: Security Expert (Before Any Automated Tests)

### Spawn Security Expert Sub-Agent

```
Task tool:
  description: "Security review for {app-name}"
  subagent_type: "general"
  prompt: |
    You are the /security-expert specialist.
    Read the skill at: .agents/skills/security-expert/SKILL.md

    Work Item ID: {work-item-id}
    Context:
    - App name: {app-name}
    - Slug: {slug}
    - URL: http://localhost:8000/apps/{slug}
    - UI Direction Brief: {from Phase 1b if available}

    Tasks:
    1. Review input handling and server-side logic for OWASP Top 10 risks (XSS/CSRF/injection/SSRF/etc.)
    2. If the app contains forms, verify CSRF + honeypot + time validation patterns are implemented
    3. Identify vulnerabilities and required fixes (with file references)
    4. Confirm UI interaction patterns do not introduce security regressions
    5. Provide PASS/FAIL recommendation

    Documentation:
    - Document recurring patterns or project-wide fixes (if discovered)

    Return review report:
    ## Security Review Report

    **Status:** PASS / FAIL

    **Findings:**
    - {List issues with severity + file references}

    **Required Fixes:**
    - {Concrete fixes required before tests can run}

    **Recommendation:**
    PASS - Safe to proceed to automated tests
    or
    FAIL - {Reason}
```

### Expected Output
- PASS/FAIL report

---

## Phase 2c: i18n Manager (Verification)

### Spawn i18n Manager Sub-Agent

```
Task tool:
  description: "Verify translations for {app-name}"
  subagent_type: "general"
  prompt: |
    You are the /i18n-manager specialist.
    Read the skill at: .agents/skills/i18n-manager/SKILL.md

    Work Item ID: {work-item-id}
    Context:
    - App name: {app-name}
    - App slug: {slug}
    - Translation key: {appKey}
    - Note: Security review must PASS before running automated tests
    - UI Direction Brief: {from Phase 1b if available}

    Tasks:
    1. Verify translations exist in all 3 supported locale source files under:
       i18n/apps/{slug}/{locale}.json
       Use generated `public/assets/i18n/{locale}.json` only as a targeted last-resort verification step.
       Do not edit generated runtime bundles or any other aggregate cross-app translation file by hand; fix source files and regenerate.
    2. Verify required keys exist for {appKey} (plus any additional keys in English):
       - title, description
       - seoTitle, seoDescription
       - helpTitle, openHelp, closeHelp
       - useCasesTitle, useCasesIntro
       - useCase1Title/useCase1Desc ... useCase5Title/useCase5Desc
       - skipTo{AppNamePascalCase} (exact key name must match AppTranslationsTest.php)
       - Any app-specific UI strings
    3. Run translation tests:
       docker run --rm -v "$(pwd)":/app -w /app php:8.4-cli \
         php vendor/bin/phpunit tests/php/Unit/AppTranslationsTest.php --testdox
    4. Fix any failures
    5. Spot-check the 3 supported locales (`en`, `es`, `pl`) for untranslated text and layout issues
    6. Validate text expansion and locale-specific behavior against UI Direction Brief (if provided)

    Documentation:
    - If new i18n patterns are discovered, update docs/modules/i18n.md

    Return verification report:
    ## i18n Verification Report

    **Status:** PASS / FAIL

    **Automated Tests:**
    - Tests run: {count}
    - Tests passed: {count}
    - Tests failed: {count}

    **Manual Spot-Check:**
    - [ ] English (en) - Baseline copy verified
    - [ ] Spanish (es) - No English UI text
    - [ ] Polish (pl) - No English UI text, layout intact

    **Issues Found:**
    {List any issues and fixes applied}

    **Recommendation:**
    PASS - Ready for Phase 3
    or
    FAIL - {Reason}
```

### Expected Output
- All 3 supported locale files updated/verified
- Tests passing
- PASS/FAIL report

---

## Phase 3: Accessibility Expert

### Spawn Accessibility Expert Sub-Agent

```
Task tool:
  description: "Audit accessibility for {app-name}"
  subagent_type: "general"
  prompt: |
    You are the /accessibility-expert specialist.
    Read the skill at: .agents/skills/accessibility-expert/SKILL.md

    Work Item ID: {work-item-id}
    Context:
    - App URL: http://localhost:8000/apps/{slug}
    - App name: {app-name}
    - UI Direction Brief: {from Phase 1b if available}

    Tasks:
    1. Run Google Lighthouse accessibility audit
    2. Perform visual analysis for color contrast
    3. Check keyboard navigation (Tab, Enter, Escape)
    4. Verify focus indicators are visible
    5. Check ARIA labels for interactive elements
    6. Verify heading hierarchy (h1 -> h2 -> h3)
    7. Check screen reader compatibility
    8. Generate accessibility report
    9. Confirm UI Direction Brief recommendations do not conflict with WCAG requirements

    Documentation:
    - If recurring a11y patterns are found, document in skill file
    - If new WCAG best practices are discovered, update skill references
    - Document any app-specific a11y considerations in SPEC.md

    Return audit report:
    ## Accessibility Audit Report

    **Lighthouse Score:** {score}/100

    **CRITICAL Issues:**
    - {List any critical issues}

    **WARNING Issues:**
    - {List any warning issues}

    **Passed Checks:**
    - [ ] Keyboard navigation working
    - [ ] Focus indicators visible
    - [ ] Color contrast meets WCAG AA (4.5:1 text, 3:1 UI)
    - [ ] ARIA labels present
    - [ ] Heading hierarchy correct

    **Documentation Updated:**
    - [ ] Skill file (if new patterns found)

    **Recommendation:**
    PASS - Score 100/100 (required), no critical issues
    or
    FAIL - {Issues to fix}
```

### Expected Output
- Lighthouse score
- Issues list with severity
- PASS/FAIL recommendation

---

## Phase 4a: SEO Expert

### Spawn SEO Expert Sub-Agent

```
Task tool:
  description: "Audit SEO for {app-name}"
  subagent_type: "general"
  prompt: |
    You are the /seo-expert specialist.
    Read the skill at: .agents/skills/seo-expert/SKILL.md

    Work Item ID: {work-item-id}
    Context:
    - App URL: http://localhost:8000/apps/{slug}
    - App name: {app-name}
    - UI Direction Brief: {from Phase 1b if available}

    Tasks:
    1. Verify meta title (50-60 chars)
    2. Verify meta description (150-160 chars)
    3. Check Open Graph tags (og:title, og:description, og:type, og:url)
    4. Validate JSON-LD structured data
    5. Verify canonical URL
    6. Check semantic HTML structure
    7. Verify sitemap entry exists with priority 0.8
    8. Generate SEO report
    9. Confirm heading/content hierarchy aligns with UI Direction Brief intent (if provided)

    Documentation:
    - If new SEO patterns or best practices found, update skill file
    - Document any JSON-LD schema improvements in skill references
    - If meta tag length guidelines change, update quality-gates.md

    Return audit report:
    ## SEO Audit Report

    **Meta Tags:**
    - [ ] Title: {title} ({length} chars)
    - [ ] Description: {desc} ({length} chars)
    - [ ] Canonical URL: {url}

    **Open Graph:**
    - [ ] og:title present
    - [ ] og:description present
    - [ ] og:type: website
    - [ ] og:url present

    **Structured Data:**
    - [ ] JSON-LD SoftwareApplication schema
    - [ ] Valid JSON-LD (tested)

    **Sitemap:**
    - [ ] Entry exists in public/sitemap.xml
    - [ ] Priority: 0.8
    - [ ] Changefreq: monthly

    **Documentation Updated:**
    - [ ] Skill file (if new patterns found)

    **Issues:**
    - {List any issues}

    **Recommendation:**
    PASS - All requirements met
    or
    FAIL - {Issues to fix}
```

### Expected Output
- Complete SEO checklist
- PASS/FAIL recommendation

---

## Phase 4b: Performance Expert

### Spawn Performance Expert Sub-Agent

```
Task tool:
  description: "Audit performance for {app-name}"
  subagent_type: "general"
  prompt: |
    You are the /performance-expert specialist.
    Read the skill at: .agents/skills/performance-expert/SKILL.md

    Work Item ID: {work-item-id}
    Context:
    - App URL: http://localhost:8000/apps/{slug}
    - App name: {app-name}
    - UI Direction Brief: {from Phase 1b if available}

    Tasks:
    1. Run Google Lighthouse performance audit (target: 90+)
    2. Verify HTTP cache headers via curl -I
    3. Check GZIP compression is enabled
    4. Validate Core Web Vitals:
       - LCP < 2.5s
       - FID < 100ms
       - CLS < 0.1
    5. Verify asset cache busting works (?v=VERSION)
    6. Generate performance report
    7. Validate motion/visual choices from UI Direction Brief against performance budget (if provided)

    Documentation:
    - If caching configuration changes, update docs/infrastructure/docker.md
    - Document any performance optimizations in skill references
    - If new Core Web Vitals thresholds are adopted, update quality-gates.md

    Return audit report:
    ## Performance Audit Report

    **Lighthouse Score:** {score}/100

    **Core Web Vitals:**
    | Metric | Value | Status |
    |--------|-------|--------|
    | LCP | {value} | PASS/FAIL |
    | FID | {value} | PASS/FAIL |
    | CLS | {value} | PASS/FAIL |
    | TBT | {value} | PASS/FAIL |

    **Cache Headers:**
    - [ ] HTML: Cache-Control present
    - [ ] Static assets: max-age=31536000
    - [ ] Vary header present

    **Compression:**
    - [ ] GZIP enabled (Content-Encoding: gzip)

    **Documentation Updated:**
    - [ ] docs/infrastructure/ (if caching changes)

    **Issues:**
    - {List any issues}

    **Recommendation:**
    PASS - Score 90+, cache headers correct
    or
    FAIL - {Issues to fix}
```

### Expected Output
- Lighthouse score and Core Web Vitals
- Cache header verification
- PASS/FAIL recommendation

---

## Phase 5: Programmer Test Execution (Unit + Integration)

### Spawn Programmer Sub-Agent (Test Execution)

```
Task tool:
  description: "Run unit + integration tests for {app-name}"
  subagent_type: "general"
  prompt: |
   You are the /programmer specialist.
   Read the skill at: .agents/skills/programmer/SKILL.md

    Work Item ID: {work-item-id}
   Context:
   - App URL: http://localhost:8000/apps/{slug}
   - App name: {app-name}
   - Slug: {slug}

   Tasks:
   1. Confirm security review is PASS (gate before any automated tests)
   2. Run translation tests first (AppTranslationsTest.php) if not already completed
   3. Run PHPUnit Unit suite (tests/php/Unit)
   4. Run PHPUnit Integration suite (tests/php/Integration)
   5. Report PASS/FAIL and any failures
   6. Keep total runtime under 10 minutes (avoid unnecessary reruns)

   Return test report:
   ## Programmer Test Report

   **Unit Tests:** PASS / FAIL
   **Integration Tests:** PASS / FAIL
   **Translation Tests:** PASS / FAIL
   **Runtime:** {duration}
   **Failures:** {list or "None"}
```

### Expected Output
- Unit + integration test results
- PASS/FAIL recommendation

---

## Phase 5b: E2E Testing (Minimal Smoke)

### Spawn E2E Testing Sub-Agent

```
Task tool:
  description: "Run minimal E2E smoke for {app-name}"
  subagent_type: "general"
  prompt: |
   You are the /e2e-testing specialist.
   Read the skill at: .agents/skills/e2e-testing/SKILL.md

    Work Item ID: {work-item-id}
   Context:
   - App name: {app-name}
   - Slug: {slug}
  - Spanish slug: {spanish-slug} (from config/slugs.php)
  - Polish slug: {polish-slug} (from config/slugs.php)
   - App URL: http://localhost:8000/apps/{slug}
   - UI Direction Brief: {from Phase 1b if available}

   Tasks:
   0. Confirm unit + integration tests are PASS (programmer report)
   1. Run **minimal E2E smoke tests** (critical user journeys only)
   2. Verify the supported locales (`en`, `es`, `pl`) load without raw translation keys
   3. Confirm the implemented flows align with the UI Direction Brief intent where practical
   4. Report PASS/FAIL and any failures
   5. Keep E2E runtime minimal; overall test time target: < 10 minutes

   Return E2E report:
   ## E2E Smoke Report

   **App:** {app-name}
   **Status:** PASS / FAIL

   **Smoke Coverage:**
   - [ ] Primary happy path
   - [ ] Help/instructions path (if applicable)
   - [ ] Locale loading (`en`, `es`, `pl`)

   **Failures:**
   - {List any failures}

   **Recommendation:**
   PASS - No blocking smoke failures found
   or
   FAIL - Blocking smoke failures found: {list}
```

### Expected Output
- Minimal E2E smoke results
- PASS/FAIL recommendation

---

## Phase 5c: Playwright Suite Maintenance (Optional)

Use `/e2e-testing` when the E2E suite needs maintenance, optimization, or targeted debugging beyond the minimal QA smoke set.

---

## Phase 5d: UI Expert (UI Quality & Consistency)

### Spawn UI Expert Sub-Agent

```
Task tool:
  description: "UI audit for {app-name}"
  subagent_type: "general"
  prompt: |
    You are the /ui-expert specialist.
    Read the skill at: .agents/skills/ui-expert/SKILL.md

    Work Item ID: {work-item-id}
    Context:
    - App name: {app-name}
    - Slug: {slug}
    - CSS file: public/assets/css/{slug}.css
    - App URL: http://localhost:8000/apps/{slug}
    - UI Direction Brief: {from Phase 1b if available}
    - Prior reports: E2E + accessibility + SEO + performance outputs

    Tasks:
    0. Run **Audit Mode** explicitly
    1. Read and analyze the app CSS file
    2. Verify design system compliance:
       - All spacing uses --space-* variables
       - All colors use --color-* variables
       - All transitions use --transition-* variables
    3. Check component pattern consistency:
       - App container has margin: 0 auto
       - Buttons match design system
       - Form inputs match design system
    4. Assess visual hierarchy and polish:
       - Typography scale is logical
       - Interaction states present (hover, focus, active)
    5. Compare against existing apps (calculator, password-generator)
    6. If UI Direction Brief exists, audit implementation alignment and call out justified deviations
     7. Include cross-skill implications for programmer, i18n-manager, accessibility-expert, e2e-testing, and performance-expert
    8. Generate UI quality report

    Documentation:
    - If design system patterns need updating, update docs/ui/UI-GUIDELINES.md
    - Document new component patterns in skill file
    - If CSS variable conventions change, update relevant docs

    Return UI quality report:
    ## UI Quality Report

    **App:** {app-name}
    **Score:** {XX}/100
    **Status:** PASS / FAIL

    **Scores by Area:**
    | Area | Score |
    |------|-------|
    | Design System Compliance | {X}/20 |
    | Component Patterns | {X}/20 |
    | Visual Hierarchy | {X}/20 |
    | Visual Polish | {X}/20 |
    | Cross-App Consistency | {X}/20 |

    **CRITICAL Issues:**
    - {List any critical issues}

    **WARNING Issues:**
    - {List any warning issues}

    **Documentation Updated:**
    - [ ] docs/ui/UI-GUIDELINES.md (if patterns updated)

    **Recommendation:**
    PASS - Score 80+, no critical issues
    or
    FAIL - {Issues to fix}
```

### Expected Output
- UI quality score (0-100)
- Issues by severity
- PASS/FAIL recommendation (80+ = PASS)

---

## Validation After Sub-Agent Returns

After each sub-agent returns, the PM validates:

1. **Read the completion report**
2. **Verify files exist** (use Glob/Read tools)
3. **Check quality gate criteria**
4. **If PASS:** Update PM work log item state, then update generic PROJECT.md (app tasks only), proceed to next phase
5. **If FAIL:** Re-invoke sub-agent with specific feedback

### Re-Invocation Pattern

If a sub-agent reports FAIL or issues:

```
Task tool:
  description: "Fix {issue} for {app-name}"
  subagent_type: "general"
  prompt: |
    You are the /{skill-name} specialist.
    Read the skill at: .agents/skills/{skill-name}/SKILL.md

    Previous Issue:
    {description of what failed}

    Fix Required:
    {specific fix needed}

    Return updated report after fix is applied.
```

---

## Summary Table

| Phase | Skill | Sub-Agent Task | Expected Return |
|-------|-------|----------------|-----------------|
| 1 | product-owner | Gather requirements | SPEC.md + approval |
| 1b | ui-expert | Interface design direction (when UI scope is significant) | UI Direction Brief + cross-skill handoff notes |
| 2a | programmer | Implement app | Completion report |
| 2b | security-expert | Security review | PASS/FAIL report |
| 2c | i18n-manager | Verify translations | PASS/FAIL report |
| 3 | accessibility-expert | WCAG audit | Score + issues |
| 4a | seo-expert | SEO audit | Checklist + issues |
| 4b | performance-expert | Performance audit | Lighthouse score + cache verification |
| 5a | programmer | Unit + integration tests | PASS/FAIL report |
| 5b | e2e-testing | Minimal E2E smoke | Smoke report |
| 5c | e2e-testing | Playwright suite maintenance (optional) | Targeted debug report |
| 5d | ui-expert | UI quality & consistency (Audit Mode) | UI score + issues + cross-skill implications |
| Any | product-owner | Clarify requirements | Answer + updated criteria |

---

## Streamlined Workflow Patterns

These patterns are for tasks that don't require the full new-app orchestration workflow.

---

## Bug Fix Pattern

Use when something is broken, showing errors, or not working as expected.

### Step 1: Investigate (if needed)

```
Task tool:
  description: "Investigate {issue} in {app-name}"
  subagent_type: "explore"
  prompt: |
    Investigate the following issue in the {app-name} app.

    Issue: {description of the problem}
    Symptoms: {what the user is seeing}
    Expected: {what should happen}

    Find:
    - Relevant code files
    - The code path involved
    - Potential root causes
    - Any related issues

    Return: Investigation report with file references and analysis
```

### Step 2: Fix

```
Task tool:
  description: "Fix {issue} in {app-name}"
  subagent_type: "general"
  prompt: |
    You are the /programmer specialist.
    Read: AGENTS.md and .agents/skills/programmer/SKILL.md

    Bug Report:
    - App: {app-name}
    - Issue: {description of the bug}
    - Location: {file(s) affected - from investigation}
    - Expected behavior: {what should happen}
    - Actual behavior: {what is happening}
    - Root cause: {if identified during investigation}

    Tasks:
    1. Review the affected code
    2. Implement the fix
    3. Verify the fix works locally
    4. Ensure no regressions introduced

    Return:
    ## Bug Fix Report

    **Issue:** {description}
    **Root Cause:** {what caused it}
    **Fix Applied:** {what was changed}
    **Files Modified:**
    - {file1}
    - {file2}
    **Verification:** {how you verified it works}
```

### Step 3: Verify

```
Task tool:
  description: "Verify fix for {issue}"
  subagent_type: "general"
  prompt: |
    You are the /qa-expert specialist.
    Read: AGENTS.md and .agents/skills/qa-expert/SKILL.md

    Context:
    - App: {app-name}
    - Bug that was fixed: {description}
    - Files modified: {list from fix report}

    Tasks:
    1. Confirm unit + integration tests are PASS (programmer report)
    2. Run minimal E2E smoke tests for the fixed flow
    3. Verify the bug is fixed
    4. Check for regressions
    5. Capture screenshot showing fix works
    6. Keep runtime under 10 minutes

    Return: Verification report (PASS/FAIL)
```

---

## Single Audit Pattern

Use when user wants to check, verify, or audit a specific aspect.

```
Task tool:
  description: "Audit {aspect} for {app-name}"
  subagent_type: "general"
  prompt: |
    You are the /{expert-skill} specialist.
    Read: AGENTS.md and .agents/skills/{expert-skill}/SKILL.md

    Context:
    - App: {app-name}
    - Slug: {slug}
    - URL: http://localhost:8000/apps/{slug}
    - Specific concern: {user's concern if any, or "general audit"}

    Tasks:
    1. Run appropriate audit/analysis for your domain
    2. Identify all issues (CRITICAL, WARNING, INFO)
    3. Provide specific recommendations for each issue
    4. Summarize overall status

    Return:
    ## {Aspect} Audit Report

    **App:** {app-name}
    **Status:** PASS / FAIL

    **CRITICAL Issues:**
    - {issue with recommendation}

    **WARNING Issues:**
    - {issue with recommendation}

    **Recommendations:**
    - {general recommendations}

    **Next Steps:**
    - {what needs to happen to address issues}
```

### Expert Mapping

| Audit Type | Skill | Key Focus |
|------------|-------|-----------|
| Accessibility | `/accessibility-expert` | WCAG 2.1 AA, Lighthouse, keyboard nav |
| SEO | `/seo-expert` | Meta tags, JSON-LD, sitemap |
| Performance | `/performance-expert` | Lighthouse, Core Web Vitals, caching |
| Translations | `/i18n-manager` | 3 supported locales, test coverage, spot-checks |
| Visual bugs | `/qa-expert` | Screenshots, layout, themes, locale-specific text/layout |
| UI direction | `/ui-expert` | Interface direction brief, component/state strategy, anti-generic design |
| UI quality | `/ui-expert` | Design system consistency, polish, final UI gate |
| Functionality (smoke) | `/e2e-testing` | Minimal E2E smoke coverage |
| E2E suite maintenance | `/e2e-testing` | Playwright suite optimization/debug |

---

## Feature Addition Pattern

Use when adding new functionality to an existing app.

### Step 1: Clarify Requirements (if needed)

```
Task tool:
  description: "Clarify requirements for {feature}"
  subagent_type: "general"
  prompt: |
    You are the /product-owner specialist.
    Read: AGENTS.md and .agents/skills/product-owner/SKILL.md

    Context:
    - App: {app-name}
    - Existing SPEC: apps/{slug}/SPEC.md (if exists)
    - Feature request: {user's request}

    Tasks:
    1. Clarify any ambiguous requirements with the user
    2. Define acceptance criteria for the feature
    3. Consider edge cases
    4. Update SPEC.md with new feature details (if SPEC exists)

    Return:
    ## Feature Specification

    **Feature:** {name}
    **Description:** {what it does}

    **Acceptance Criteria:**
    - [ ] {criterion 1}
    - [ ] {criterion 2}
    - [ ] {criterion 3}

    **Edge Cases:**
    - {edge case and handling}

    **UI/UX Requirements:**
    - {any UI requirements}
```

### Step 2: Implement

```
Task tool:
  description: "Implement {feature} for {app-name}"
  subagent_type: "general"
  prompt: |
    You are the /programmer specialist.
    Read: AGENTS.md and .agents/skills/programmer/SKILL.md

    Context:
    - App: {app-name}
    - Slug: {slug}
    - Feature: {feature description}
    - Acceptance Criteria: {from step 1 or user request}

    Tasks:
    1. Implement the feature
    2. Add necessary translations to the 3 supported locale files (`en`, `es`, `pl`)
    3. Update any config files if needed
    4. Ensure AGENTS.md requirements are followed

    Return: Implementation report with files modified
```

### Step 3: Verify Translations (if UI changes)

```
Task tool:
  description: "Verify translations for {feature}"
  subagent_type: "general"
  prompt: |
    You are the /i18n-manager specialist.
    Read: AGENTS.md and .agents/skills/i18n-manager/SKILL.md

    Context:
    - App: {app-name}
    - Feature added: {feature}
    - New translation keys: {if known}

    Tasks:
    1. Verify all 3 supported locales have translations for new strings
    2. Run AppTranslationsTest.php
    3. Spot-check `en`, `es`, and `pl` for quality
    4. Fix any missing or incorrect translations

    Return: i18n verification report (PASS/FAIL)
```

### Step 4: Test

```
Task tool:
  description: "Test {feature} for {app-name}"
  subagent_type: "general"
  prompt: |
    You are the /qa-expert specialist.
    Read: AGENTS.md and .agents/skills/qa-expert/SKILL.md

    Context:
    - App: {app-name}
    - Feature: {feature}
    - Acceptance Criteria: {criteria to verify}

    Tasks:
    1. Confirm unit + integration tests are PASS (programmer report)
    2. Run minimal E2E smoke tests for the feature
    3. Verify feature works in multiple locales
    4. Capture screenshots
    5. Keep runtime under 10 minutes

    Return: Test report (PASS/FAIL)
```

---

## Improvement Pattern

Use when enhancing, optimizing, or refactoring existing functionality.

### Step 1: Analyze

```
Task tool:
  description: "Analyze {aspect} for improvement"
  subagent_type: "general"
  prompt: |
    You are the /{relevant-expert} specialist.
    Read: AGENTS.md and .agents/skills/{relevant-expert}/SKILL.md

    Context:
    - App: {app-name}
    - Improvement goal: {what user wants to improve}

    Tasks:
    1. Analyze the current state
    2. Identify specific improvement opportunities
    3. Prioritize by impact
    4. Provide concrete recommendations

    Return:
    ## Improvement Analysis

    **Current State:**
    - {metrics or observations}

    **Recommended Improvements:**
    1. {improvement} - Impact: HIGH/MEDIUM/LOW
    2. {improvement} - Impact: HIGH/MEDIUM/LOW

    **Implementation Notes:**
    - {technical details for programmer}
```

### Step 2: Implement

```
Task tool:
  description: "Implement improvements for {app-name}"
  subagent_type: "general"
  prompt: |
    You are the /programmer specialist.
    Read: AGENTS.md and .agents/skills/programmer/SKILL.md

    Context:
    - App: {app-name}
    - Improvements to implement: {from analysis}

    Tasks:
    1. Implement the recommended improvements
    2. Ensure no functionality is broken
    3. Follow AGENTS.md requirements

    Return: Implementation report
```

### Step 3: Verify Improvement

```
Task tool:
  description: "Verify improvements for {app-name}"
  subagent_type: "general"
  prompt: |
    You are the /{relevant-expert} specialist.
    Read: AGENTS.md and .agents/skills/{relevant-expert}/SKILL.md

    Context:
    - App: {app-name}
    - Improvements implemented: {list}
    - Previous metrics: {from analysis}

    Tasks:
    1. Re-run analysis/audit
    2. Compare before and after
    3. Verify improvements achieved

    Return: Verification report showing improvement
```

---

## Investigation Pattern

Use when user needs to understand something, find a root cause, or research.

### Step 1: Explore

```
Task tool:
  description: "Investigate {topic}"
  subagent_type: "explore"
  prompt: |
    Investigate: {what needs to be understood}

    Context: {any context provided by user}

    Find:
    - Relevant files and code
    - How the current implementation works
    - Key code paths and dependencies
    - Any potential issues or concerns

    Return:
    ## Investigation Report

    **Question:** {what was being investigated}

    **Findings:**
    - {finding 1 with file references}
    - {finding 2 with file references}

    **Key Files:**
    - {file:line} - {what it does}

    **Summary:**
    {brief summary answering the question}
```

### Step 2: Specialist Analysis (if needed)

If the exploration reveals issues that need expert analysis:

```
Task tool:
  description: "Analyze {specific issue}"
  subagent_type: "general"
  prompt: |
    You are the /{relevant-expert} specialist.
    Read: AGENTS.md and .agents/skills/{relevant-expert}/SKILL.md

    Context:
    - Investigation found: {findings from explore}
    - Specific question: {what needs expert analysis}

    Tasks:
    1. Analyze the specific issue
    2. Provide expert assessment
    3. Recommend next steps

    Return: Expert analysis report
```

---

## Summary: Streamlined Workflow Patterns

| Workflow | When to Use | Key Sub-Agents |
|----------|-------------|----------------|
| Bug Fix | Something broken | Explore -> programmer -> e2e-testing |
| Single Audit | Check/verify something | Relevant expert only |
| Feature Addition | New functionality | product-owner? -> programmer -> i18n-manager -> e2e-testing |
| Improvement | Optimize/enhance | Relevant expert -> programmer -> expert verify |
| Investigation | Understand/research | Explore -> expert analysis? |
