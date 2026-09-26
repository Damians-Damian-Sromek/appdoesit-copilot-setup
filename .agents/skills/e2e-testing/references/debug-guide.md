# E2E Test Debug Guide

**Source of Truth: [AGENTS.md](../../../AGENTS.md)**

Common test failures and solutions, referencing AGENTS.md requirements.

---

## Translation Issues

### Raw Translation Keys Visible

**Symptom**: UI shows `wordCounter.title` instead of "Word Counter"

**Per AGENTS.md `### Translation Test Maintenance (MANDATORY)`**

Use app-specific source files in `i18n/apps/{slug}/{locale}.json` for app keys, and `i18n/common/{locale}.json` for shared labels. Inspect generated `public/assets/i18n/{locale}.json` only as a last resort if the build output seems out of sync.

**Causes & Solutions**:

1. **Missing translation key**
   ```bash
    # Check if an app-specific key exists in all 3 supported source locales
    for locale in en es pl; do
       echo "=== $locale ==="
       jq '.title' "i18n/apps/{slug}/$locale.json"
   done
   ```

2. **Wrong data-i18n attribute**
   ```html
   <!-- Wrong (lowercase) -->
   <span data-i18n="wordcounter.title">

   <!-- Correct (camelCase) -->
   <span data-i18n="wordCounter.title">
   ```

3. **i18n not initialized**
   ```javascript
   await AppDoesIt.i18n.init();
   ```

### English Text in Non-English Locales

**Symptom**: Spanish page shows "Calculate" instead of "Calcular"

**Solution**: Verify actual translations exist:
```bash
# Should show different values
diff <(jq '.title' i18n/apps/{slug}/en.json) \
    <(jq '.title' i18n/apps/{slug}/es.json)
```

---

## Help Modal Issues

**Per AGENTS.md `### App Help/Instructions (MANDATORY)`**

### Modal Doesn't Open

**Check**:
1. Button ID matches: `#help-toggle`
2. Modal element exists
3. JavaScript handler attached

### Missing ARIA Attributes

**Required per AGENTS.md accessibility standards**:
```html
<dialog id="help-modal"
        role="dialog"
        aria-modal="true"
        aria-labelledby="help-title">
```

---

## Use Cases Section Issues

**Per AGENTS.md `### App Page Requirements (MANDATORY)`**

### Wrong Number of Use Cases

**AGENTS.md requires exactly 5 use cases.**

Check translations:
```bash
jq 'keys | map(select(. == "useCasesTitle" or . == "useCasesIntro" or test("^useCase[1-5](Title|Desc)$")))' i18n/apps/{slug}/en.json
# Should show: case1, case2, case3, case4, case5, title
```

---

## Sitemap Issues

**Per AGENTS.md `### Sitemap Maintenance (MANDATORY)`**

### App Missing from Sitemap

Add to `public/sitemap.xml`:
```xml
<url>
    <loc>https://appdoesit.com/apps/my-app</loc>
    <changefreq>monthly</changefreq>
    <priority>0.8</priority>
    <!-- Add hreflang for all 3 supported locales -->
</url>
```

### Wrong hreflang

**Per AGENTS.md**: English URLs should NOT have `/en/` prefix:
```xml
<!-- WRONG -->
<xhtml:link hreflang="en" href="https://appdoesit.com/en/apps/..."/>

<!-- CORRECT -->
<xhtml:link hreflang="en" href="https://appdoesit.com/apps/..."/>
```

---

## Theme Issues

### Dark Theme Not Applied

**Symptom**: App stays in light theme even when dark mode is selected

**Causes & Solutions**:

1. **Theme attribute not set**
   ```javascript
   // Check if data-theme attribute exists
   document.documentElement.getAttribute('data-theme')
   // Should be 'light' or 'dark'
   ```

2. **CSS not using theme variables**
   ```css
   /* Wrong - hardcoded color */
   .my-element {
       background: #ffffff;
   }

   /* Correct - uses CSS variable */
   .my-element {
       background: var(--bg-primary);
   }
   ```

3. **localStorage not persisting**
   ```javascript
   // Check stored theme preference
   localStorage.getItem('appdoesit-theme')
   ```

### Hardcoded Colors Breaking Theme

**Symptom**: Some elements don't change color when switching themes

**Solution**: Replace hardcoded colors with CSS variables:
```css
/* Theme variables are defined in the root stylesheet */
--bg-primary, --bg-secondary, --bg-tertiary
--text-primary, --text-secondary
--border-color, --accent-color
```

### Poor Contrast in Dark Theme

**Symptom**: Text is hard to read in dark mode

**Solution**: Ensure proper contrast ratios:
- Text on backgrounds: minimum 4.5:1 (WCAG AA)
- Large text: minimum 3:1
- Use theme variables that are designed for contrast

### Theme Flash on Page Load

**Symptom**: Page briefly shows wrong theme before correcting

**Solution**: Theme should be set early in page load:
```javascript
// In <head> before styles load
const theme = localStorage.getItem('appdoesit-theme') || 'light';
document.documentElement.setAttribute('data-theme', theme);
```

---

## Layout Issues

### App Not Centered

Check CSS:
```css
.app-container {
    max-width: 900px;  /* Or app-specific */
    margin: 0 auto;
}
```

App-specific overrides:
- calculator: 500px
- password-generator: 600px
- unit-converter: 700px
- json-formatter: 1300px

---

## PHPUnit Translation Test Failures

**Per AGENTS.md `### Translation Test Maintenance (MANDATORY)`**

### App Not Registered

Add to `tests/php/Unit/AppTranslationsTest.php`:
```php
private const APP_TRANSLATION_KEYS = [
    'my-new-app' => 'myNewApp',  // Add this
];
```

### Missing Skip-to Link

Add to `$skipToKeys` in test file:
```php
$skipToKeys = [
    'myNewApp' => 'skipToMyNewApp',
];
```

---

## Quick Diagnostic Commands

```bash
# Check translation key exists
jq '.' i18n/apps/{slug}/en.json

# Check all 3 supported locales have app section
for locale in en es pl; do
    echo -n "$locale: "
    jq 'length' "i18n/apps/{slug}/$locale.json" 2>/dev/null || echo "MISSING"
done

# Check sitemap includes app
grep "my-app" public/sitemap.xml

# Run translation tests
docker run --rm -v "$(pwd)":/app -w /app php:8.4-cli \
  php vendor/bin/phpunit tests/php/Unit/AppTranslationsTest.php --testdox
```

---

## Updating This Guide

When AGENTS.md changes:

1. Check for new error patterns related to new requirements
2. Update references to AGENTS.md sections
3. Add new diagnostic commands if needed
