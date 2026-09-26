# New App Checklist

Step-by-step checklist for adding a new app to AppDoesIt.

## Phase 0 PM Tracking (MANDATORY)

Before delegation, initialize PM tracking:

- Create or reuse a work log in `docs/work_logs/` using `YYYY-MM-DD_HHMM_task-slug.md`
- Add non-technical TODO assignments by specialist skill
- For app tasks, create/update a **generic** `apps/{slug}/PROJECT.md` that links to the work log

## Phase 1b UI Direction (RECOMMENDED FOR NEW UI)

Before Phase 2 implementation, run `/ui-expert` Interface Design Mode when:
- Building a net-new app UI
- Introducing major layout or interaction changes

Output required:
- UI Direction Brief (intent, component/state strategy, token usage guidance)
- Cross-skill handoff notes for programmer, i18n, accessibility, SEO, performance, QA

## Phase 2 Implementation Checklist

### 1. Create App Directory

```bash
mkdir -p apps/{slug}
```

Create these files:
- `apps/{slug}/index.php` - Main app template
- `apps/{slug}/PROJECT.md` - Generic app status summary (no detailed TODO tracking)
- `apps/{slug}/SPEC.md` - Product specification (from Phase 1)

Also create/update PM work log:
- `docs/work_logs/{YYYY-MM-DD_HHMM_task-slug}.md` - Authoritative PM TODO and status tracking

### 2. Register App in config/apps.php

**Location:** `config/apps.php`

Add entry (sorted alphabetically by key):

```php
'{slug}' => [
    'name' => 'App Name',
    'description' => 'Short description of the app',
    'icon' => 'icon-name',  // From icon set or 'calculator' as default
    'category' => 'tools',  // tools, games, converters, etc.
],
```

**Alphabetical sort example:**
```php
'age-calculator' => [...],
'alphabet-learning' => [...],
// <- Insert 'bmi-calculator' here
'calculator' => [...],
```

### 3. Update Canonical Slug Source and Regenerate config/slugs.php

**Output file:** `config/slugs.php`

Do not hand-edit `config/slugs.php`. Update the canonical slug source/workflow, then regenerate `config/slugs.php` so it includes an entry for `apps/{slug}` with the supported locales (`en`, `es`, `pl`):

```php
'apps/{slug}' => [
  'en' => 'apps/{slug}',
  'es' => 'apps/{spanish-slug}',
  'pl' => 'apps/{polish-slug}',
],
```

**Note:** Keep the generated output sorted alphabetically within the apps section.

### 4. Add Translations to All 3 Supported Locale Source Files

**Location:** `i18n/apps/{slug}/_meta.json` and `i18n/apps/{slug}/{locale}.json`

Files to update:
- `_meta.json`
- `en.json`, `es.json`, `pl.json`

After editing source files, run `npm run i18n:build` to regenerate `public/assets/i18n/{locale}.json`. Use the generated bundles only as a targeted last-resort verification step.

**Required structure for each locale source file:**

```json
{
  "title": "App Title",
  "description": "Short description for display",
  "seoTitle": "SEO Title - Site Name (50-60 chars)",
  "seoDescription": "SEO meta description (150-160 chars)",
  "helpTitle": "How to Use App Name",
  "openHelp": "Open help",
  "closeHelp": "Close help",
  "skipTo{AppNamePascalCase}": "Skip to App Name",
  "useCasesTitle": "When to Use This App",
  "useCasesIntro": "Short intro sentence for the use cases section",
  "useCase1Title": "Use Case 1 Title",
  "useCase1Desc": "Description of when and why to use this",
  "useCase2Title": "Use Case 2 Title",
  "useCase2Desc": "Description of when and why to use this",
  "useCase3Title": "Use Case 3 Title",
  "useCase3Desc": "Description of when and why to use this",
  "useCase4Title": "Use Case 4 Title",
  "useCase4Desc": "Description of when and why to use this",
  "useCase5Title": "Use Case 5 Title",
  "useCase5Desc": "Description of when and why to use this"
}
```

**Translation key naming:**
- Use camelCase: `wordCounter`, `bmiCalculator`, `ageCalculator`
- Must match entry in `APP_TRANSLATION_KEYS`

### 5. Update Test File

**Location:** `tests/php/Unit/AppTranslationsTest.php`

Add to `APP_TRANSLATION_KEYS` constant (sorted alphabetically):

```php
private const APP_TRANSLATION_KEYS = [
    'age-calculator' => 'ageCalculator',
    // <- Insert new entry here alphabetically
    'word-counter' => 'wordCounter',
];
```

Also update `testAllAppsHaveSkipToLinkInAllLocales` if your app has a specific skip-to key pattern.

### 6. Update Sitemap

**Location:** `public/sitemap.xml`

Add entry:

```xml
<url>
    <loc>https://appdoesit.com/apps/{slug}</loc>
    <changefreq>monthly</changefreq>
    <priority>0.8</priority>
</url>
```

### 7. Implement App Template

**Location:** `apps/{slug}/index.php`

Required sections:
- Header with app title
- Main app functionality
- Help section (collapsible/modal)
- Use cases section
- Proper semantic HTML structure

**Template structure:**
```php
<?php
// App variables are passed: $app, $pageTitle, $pageDescription, $canonicalUrl, $config
?>

<main class="app-container">
    <!-- Skip link target -->
    <h1 id="app-name"><?= e($pageTitle) ?></h1>

    <!-- App functionality -->
    <section class="app-main">
        <!-- Main app UI -->
    </section>

    <!-- Help section -->
    <section class="help-section" aria-labelledby="help-title">
        <h2 id="help-title" data-i18n="appKey.helpTitle"></h2>
        <!-- Help content -->
    </section>

    <!-- Use cases section -->
    <section class="use-cases" aria-labelledby="use-cases-title">
        <h2 id="use-cases-title" data-i18n="appKey.useCases.title"></h2>
        <!-- 5 use cases -->
    </section>
</main>
```

### 8. Create CSS (if needed)

**Location:** `public/assets/css/{slug}.css`

- Use CSS custom properties for theming
- Support light and dark themes
- Mobile-first responsive design
- Max-width constraint (typically 900px)

### 9. Create JavaScript (if needed)

**Location:** `public/assets/js/{slug}.js`

- Use IIFE pattern
- Use `AppDoesIt.i18n.t('key')` for translations
- No external dependencies
- ES6+ syntax

---

## Verification Commands

After completing the checklist, run these commands:

**CRITICAL:** Per `AGENTS.md`, complete a security review before running any automated tests (including `AppTranslationsTest.php`).

```bash
# Verify routes and slugs
docker run --rm -v "$(pwd)":/app -w /app php:8.4-cli \
  php vendor/bin/phpunit tests/php/Unit/RoutesTest.php --testdox

# Verify translations
docker run --rm -v "$(pwd)":/app -w /app php:8.4-cli \
  php vendor/bin/phpunit tests/php/Unit/AppTranslationsTest.php --testdox

# Verify alphabetical ordering
docker run --rm -v "$(pwd)":/app -w /app php:8.4-cli \
  php vendor/bin/phpunit tests/php/Unit/AlphabeticalOrderTest.php --testdox

# Run all tests
.\docker.ps1 test
```

---

## Common Issues

### Test Failure: App not found in APP_TRANSLATION_KEYS
**Fix:** Add the app to the `APP_TRANSLATION_KEYS` constant in `AppTranslationsTest.php`

### Test Failure: Missing locale in slugs
**Fix:** Update the canonical slug source/workflow, regenerate `config/slugs.php`, and confirm the supported locales (`en`, `es`, `pl`) are present in the emitted output

### Test Failure: Missing translation keys
**Fix:** Add all required keys to each locale JSON file

### Test Failure: Alphabetical order
**Fix:** Re-sort entries in config files alphabetically by key

### App not appearing on homepage
**Fix:** Ensure the app is added to `config/apps.php` with correct category

### Translations not loading
**Fix:** Verify the translation key in JSON matches the `data-i18n` attribute
