# App Structure

Recommended structure and patterns for AppDoesIt apps.

## Directory Structure

### Minimal App (PHP Only)

```
apps/{slug}/
  index.php           # Main app template
```

### Full App (With JS/CSS)

```
apps/{slug}/
  index.php           # Main app template

public/assets/
  js/{slug}.js        # App JavaScript (optional)
  css/{slug}.css      # App CSS (optional)
```

---

## Variables Provided To Apps

The router injects these variables into every app template:

| Variable | Type | Description |
|----------|------|-------------|
| `$app` | array | App metadata from `config/apps.php` (name, description, categories, icon, keywords, etc.) |
| `$pageTitle` | string | SEO page title (localized) |
| `$pageDescription` | string | SEO meta description (localized) |
| `$canonicalUrl` | string | Full canonical URL |
| `$config` | array | Global configuration |

**Important:** The translation key (`appKey`) is not the same as `$app['name']`.
For app translations, use the camelCase version of the slug (example: `url-encoder-decoder` -> `urlEncoderDecoder`) and keep it in sync with `tests/php/Unit/AppTranslationsTest.php`.

---

## Recommended Implementation Pattern

1. **Mirror a recent existing app** in `apps/` for the `<head>` section (hreflang, OG tags, JSON-LD, etc.).
2. Prefer the shared header/footer partials for consistency:
   - `app/views/partials/app-header.php`
   - `app/views/partials/app-footer.php`
3. Implement the help panel and use cases section **inside the app file** (there are no shared help/use-cases partials).

### Header/Footer Partial Usage (Recommended)

Example body wiring (adapt IDs/keys to your app):

```php
<?php
// i18n helpers used by app-header.php
$i18n = I18n::getInstance();
$currentLocale = $i18n->getLocale();
$supportedLocales = $i18n->getSupportedLocales();

// App-specific skip link (required by AppTranslationsTest)
$skipLinkTarget = '{slug}';
$skipLinkLabel = '{appKey}.skipTo{AppNamePascalCase}';

// Help button wiring
$showHelpButton = true;
$helpAriaLabel = '{appKey}.openHelp';
$helpPanelId = 'help-panel';

require APP_PATH . '/views/partials/app-header.php';
?>

<main class="main-content app-page">
    <div class="app-container {prefix}-container">
        <div class="app-header">
            <h1><?= e(t('{appKey}.title')) ?></h1>
            <p class="app-description"><?= e(t('{appKey}.description')) ?></p>
        </div>

        <section id="{slug}" aria-label="<?= e(t('{appKey}.title')) ?>">
            <!-- App UI -->
        </section>

        <section class="use-cases" aria-labelledby="use-cases-title">
            <h2 id="use-cases-title"><?= e(t('{appKey}.useCasesTitle')) ?></h2>
            <p><?= e(t('{appKey}.useCasesIntro')) ?></p>
            <!-- Render 5 cases using useCase{1..5}Title/useCase{1..5}Desc -->
        </section>
    </div>
</main>

<aside id="help-panel" class="help-panel" hidden aria-labelledby="help-title" role="dialog" aria-modal="true">
    <h2 id="help-title"><?= e(t('{appKey}.helpTitle')) ?></h2>
    <!-- Help content using additional app keys (mirror English keys across locales) -->
</aside>

<?php require APP_PATH . '/views/partials/app-footer.php'; ?>
```

---

## Translation Key Patterns (Canonical)

Canonical translation source files live in `i18n/apps/{slug}/{locale}.json` (with shared keys in `i18n/common/{locale}.json`). The generated runtime bundles in `public/assets/i18n/{locale}.json` are last-resort verification only.

### Required Keys Per App (Minimum)

Inside each app source file (`i18n/apps/{slug}/{locale}.json`), every locale must include:

- `title`
- `description`
- `seoTitle`
- `seoDescription`
- `helpTitle`
- `openHelp`
- `closeHelp`
- `skipTo{AppNamePascalCase}` (exact key name must match `AppTranslationsTest.php`)
- `useCasesTitle`
- `useCasesIntro`
- `useCase1Title`, `useCase1Desc`
- `useCase2Title`, `useCase2Desc`
- `useCase3Title`, `useCase3Desc`
- `useCase4Title`, `useCase4Desc`
- `useCase5Title`, `useCase5Desc`

**Key parity rule:** `AppTranslationsTest.php` ultimately enforces that, once built, every non-English locale contains every key that exists in `i18n/apps/{slug}/en.json` for that app.

---

## Config File Updates (New Apps)

### config/apps.php

Add a new entry (alphabetically sorted by slug key):

```php
'my-new-app' => [
    'name' => 'My New App',
    'description' => 'Short description for the app registry.',
    'categories' => ['productivity'],
    'icon' => 'tool',
    'keywords' => ['keyword1', 'keyword2'],
    'featured' => false,
    'version' => '1.0.0',
],
```

### Canonical slug source -> config/slugs.php

`config/slugs.php` is treated as generated/derived output. Do not hand-edit it.
Update the canonical slug source/workflow, regenerate `config/slugs.php`, then verify the emitted entry for the supported locales (`en`, `es`, `pl`) is:

```php
'apps/my-new-app' => [
    'en' => 'apps/my-new-app',
    'es' => 'apps/mi-nueva-app',
    'pl' => 'apps/moja-nowa-aplikacja',
],
```

Keep the generated output alphabetically sorted.

---

## Assets

Most apps include assets explicitly:
- `assets/css/main.css` (always)
- `assets/css/{slug}.css` (if app-specific CSS exists)
- `assets/js/{slug}.js` (if app-specific JS exists)

Use the `asset()` helper to get cache-busted URLs.

---

## Security Gate (Before Tests)

Per `AGENTS.md`, a **/security-expert** review must PASS before running any automated tests (including `AppTranslationsTest.php`).
