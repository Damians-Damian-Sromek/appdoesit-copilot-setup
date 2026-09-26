# Translation Validation Guide

Step-by-step guide for validating translations in AppDoesIt apps.

Use the canonical source files under `i18n/` for inspection and fixes. Avoid opening `public/assets/i18n/*.json` unless source review, rebuilds, and tests still leave a runtime mismatch unexplained.
If a generated runtime bundle appears wrong, regenerate and inspect only the smallest relevant snippet; do not repair the generated cross-app bundle by hand.

## Validation Workflow

### 1. Run Automated Tests

```bash
docker run --rm -v "$(pwd)":/app -w /app php:8.4-cli \
  php vendor/bin/phpunit tests/php/Unit/AppTranslationsTest.php --testdox
```

**Expected output (passing):**
```
OK (42 tests, 186 assertions)
```

**Expected output (failing):**
```
FAILURES!
Tests: 42, Assertions: 186, Failures: 3
```

### 2. Interpret Test Failures

#### Missing App Section
```
testAllLocalesHaveAllAppSections
Failed: Locale 'es' missing app section 'newApp'
```
**Fix:** Add the complete app section to `es.json`

#### Missing Required Keys
```
testAppHasRequiredMetadataKeys
Failed: App 'newApp' locale 'pl' missing key 'seoDescription'
```
**Fix:** Add the missing key to `pl.json`

#### Untranslated Strings
```
testAllAppStringsAreTranslated
Failed: Locale 'pl' app 'kidsBmiCalculator' has untranslated: metric, height, weight
```
**Fix:** Replace English values with Polish translations

### 3. Find Untranslated Strings

**Search source files for English in non-English locales:**

```bash
# Check for specific untranslated strings
grep -RIl '"metric": "Metric"' i18n/apps i18n/pages i18n/common

# Check a specific locale across app/page/common source files
grep -RIn '"height": "Height"' i18n/apps/*/pl.json i18n/pages/*/pl.json i18n/common/pl.json
```

**Visual inspection:**

```bash
# View a specific app source file in a specific locale
jq '.' i18n/apps/kids-bmi-calculator/pl.json | head -60
```

### 4. Fix Translations

**Edit the source JSON file directly** (for app-specific keys use `i18n/apps/{slug}/{locale}.json`; for shared UI labels use `i18n/common/{locale}.json`):

```json
// Before (English in Polish file)
"metric": "Metric",
"height": "Height",

// After (properly translated)
"metric": "metryczny",
"height": "Wzrost",
```

**Common translations reference:**

| Key | Spanish | Polish |
|-----|---------|--------|
| metric | Métrico | Metryczny |
| imperial | Imperial | Imperialny |
| height | Altura | Wzrost |
| weight | Peso | Waga |
| age | Edad | Wiek |
| sex | Sexo | Płeć |
| boy | Niño | Chłopiec |
| girl | Niña | Dziewczynka |
| years | Años | Lata |
| months | Meses | Miesiące |
| feet | Pies | Stopy |
| inches | Pulgadas | Cale |

### 5. Re-run Tests

After fixing, verify all tests pass:

```bash
docker run --rm -v "$(pwd)":/app -w /app php:8.4-cli \
  php vendor/bin/phpunit tests/php/Unit/AppTranslationsTest.php --testdox
```

### 6. Manual Spot-Check

Even with passing tests, verify the supported locales visually:

#### English (en) - Check for:
- Baseline copy is correct
- Reference layout is stable

#### Spanish (es) - Check for:
- All text is Spanish (no English UI labels)
- Accents and punctuation display correctly
- Text length doesn't break layout

#### Polish (pl) - Check for:
- All text is Polish (no English UI labels)
- Diacritics render correctly (`ą ć ę ł ń ó ś ź ż`)
- Longer labels do not overflow

### 7. Generate Verification Report

```markdown
## i18n Verification Report

**App:** [App Name]
**Date:** [Date]
**Verified by:** AI agent

### Automated Tests
- **Status:** PASS
- **Tests:** 42
- **Assertions:** 186

### Manual Spot-Check
- [x] English (en) - Baseline layout verified
- [x] Spanish (es) - All labels translated, no overflow
- [x] Polish (pl) - All labels translated, diacritics render correctly

### Issues Found
None

### Recommendation
PASS - i18n validation complete
```

## Troubleshooting

### Test hangs or times out

**Cause:** Docker issue or tests parsing large generated runtime bundles

**Fix:**
```bash
# Run with increased timeout
docker run --rm -v "$(pwd)":/app -w /app php:8.4-cli \
  php -d memory_limit=256M vendor/bin/phpunit tests/php/Unit/AppTranslationsTest.php --testdox
```

### JSON parse error

**Cause:** Malformed JSON (missing comma, unclosed quote)

**Fix:**
```bash
# Validate source JSON syntax
find i18n -name '*.json' -print0 | while IFS= read -r -d '' f; do
  python3 -m json.tool "$f" > /dev/null 2>&1 || echo "Invalid: $f"
done
```

### Test passes but UI shows English

**Cause:** Build output is stale, test has allowed exemptions, or key is not covered

**Fix:**
1. Run `npm run i18n:build`
2. Check if key is in `ALLOWED_IDENTICAL_KEYS` in test file
3. Manually verify the relevant source file under `i18n/`
4. Only if the mismatch persists, inspect the targeted generated bundle snippet as a last resort
5. Do not patch `public/assets/i18n/{locale}.json` directly; fix source files and rebuild again

### Localized text overflows

**Cause:** The layout does not account for longer translated labels

**Fix:**
1. Compare `en`, `es`, and `pl` screenshots side by side
2. Increase available width or allow text wrapping where appropriate
3. Re-run the visual spot-check after the layout change
