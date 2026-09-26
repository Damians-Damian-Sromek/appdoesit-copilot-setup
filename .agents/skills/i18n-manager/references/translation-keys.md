# Required Translation Keys

Every app must have these translation keys in all 3 supported locale source files (`en`, `es`, `pl`).

> Note: `tests/php/Unit/AppTranslationsTest.php` enforces **key parity with English**.
> For each app key, every non-English locale must contain every key that exists in `en.json` (except a small allow-list).

## Key Structure

Translation keys follow camelCase convention:
- App slug: `bmi-calculator` (kebab-case)
- Translation key: `bmiCalculator` (camelCase)

## Required Keys Per App

### 1. Core Metadata (REQUIRED)

```json
{
  "appKey": {
    "title": "App Title",
    "description": "Short description displayed on homepage",
    "seoTitle": "SEO Title - AppDoesIt (50-60 chars)",
    "seoDescription": "Meta description for search engines (150-160 chars)"
  }
}
```

### 2. Help Section (REQUIRED)

```json
{
  "appKey": {
    "helpTitle": "How to Use [App Name]",
    "openHelp": "Open help",
    "closeHelp": "Close help"
  }
}
```

Many apps also include additional help content keys. Mirror the **English** structure exactly, for example:
```json
{
  "appKey": {
    "helpHowTo": "How to Use",
    "helpHowToStep1": "Step 1 ...",
    "helpHowToStep2": "Step 2 ...",
    "helpHowToStep3": "Step 3 ...",
    "helpHowToStep4": "Step 4 ...",
    "helpFeatures": "Features",
    "helpFeatureExample": "Example feature text",
    "helpTips": "Tips",
    "helpTip1": "Tip 1 ...",
    "helpTip2": "Tip 2 ..."
  }
}
```

### 3. Use Cases Section (REQUIRED - 5 Cases)

```json
{
  "appKey": {
    "useCasesTitle": "When to Use This App",
    "useCasesIntro": "Short intro sentence for the use cases section",
    "useCase1Title": "Use Case 1 Title",
    "useCase1Desc": "Use case 1 description",
    "useCase2Title": "Use Case 2 Title",
    "useCase2Desc": "Use case 2 description",
    "useCase3Title": "Use Case 3 Title",
    "useCase3Desc": "Use case 3 description",
    "useCase4Title": "Use Case 4 Title",
    "useCase4Desc": "Use case 4 description",
    "useCase5Title": "Use Case 5 Title",
    "useCase5Desc": "Use case 5 description"
  }
}
```

### 4. Skip-to Link (REQUIRED)

```json
{
  "appKey": {
    "skipTo{AppNamePascalCase}": "Skip to [App Name]"
  }
}
```

**Important:** The exact skip-to key name must match `AppTranslationsTest.php` (`testAllAppsHaveSkipToLinkInAllLocales`).

## Common UI Keys (App-Specific)

### Calculator Apps

```json
{
  "appKey": {
    "calculate": "Calculate",
    "clear": "Clear",
    "result": "Result",
    "error": "Error",
    "invalidInput": "Invalid input"
  }
}
```

### Converter Apps

```json
{
  "appKey": {
    "from": "From",
    "to": "To",
    "convert": "Convert",
    "swap": "Swap",
    "copy": "Copy",
    "copied": "Copied!"
  }
}
```

### Measurement Apps (BMI, etc.)

```json
{
  "appKey": {
    "unitSystem": "Unit System",
    "metric": "Metric",
    "imperial": "Imperial",
    "height": "Height",
    "weight": "Weight",
    "age": "Age",
    "sex": "Sex",
    "boy": "Boy",
    "girl": "Girl",
    "male": "Male",
    "female": "Female",
    "years": "Years",
    "months": "Months",
    "cm": "cm",
    "kg": "kg",
    "ft": "ft",
    "in": "in",
    "lbs": "lbs",
    "feet": "Feet",
    "inches": "Inches"
  }
}
```

## Keys That Are Often Left Untranslated

**Check these specifically:**

| Key | Issue | Example |
|-----|-------|---------|
| `metric` | Left as English "Metric" | Should be "Metrisch" (de), "メートル法" (ja) |
| `imperial` | Left as English "Imperial" | Should be "Angloamerikanisch" (de) |
| `height` | Left as English "Height" | Should be "Größe" (de), "身長" (ja) |
| `weight` | Left as English "Weight" | Should be "Gewicht" (de), "体重" (ja) |
| `feet` | Left as English "Feet" | Should be "Fuß" (de), "フィート" (ja) |
| `inches` | Left as English "Inches" | Should be "Zoll" (de), "インチ" (ja) |
| `age` | Left as English "Age" | Should be "Alter" (de), "年齢" (ja) |
| `sex` | Left as English "Sex" | Should be "Geschlecht" (de), "性別" (ja) |
| `boy` | Left as English "Boy" | Should be "Junge" (de), "男の子" (ja) |
| `girl` | Left as English "Girl" | Should be "Mädchen" (de), "女の子" (ja) |
| `years` | Left as English "Years" | Should be "Jahre" (de), "歳" (ja) |
| `months` | Left as English "Months" | Should be "Monate" (de), "ヶ月" (ja) |

## Test File Configuration

Translation tests are in: `tests/php/Unit/AppTranslationsTest.php`

### APP_TRANSLATION_KEYS Constant

Maps app slugs to translation keys:

```php
private const APP_TRANSLATION_KEYS = [
    'age-calculator' => 'ageCalculator',
    'bmi-calculator' => 'bmiCalculator',
    'calculator' => 'calculator',
    'kids-bmi-calculator' => 'kidsBmiCalculator',
    'word-counter' => 'wordCounter',
    // ... add new apps here (alphabetically sorted)
];
```

### When Adding a New App

1. Add entry to `APP_TRANSLATION_KEYS` (alphabetically)
2. Ensure all 3 supported locale source files have the app section
3. Run tests to verify completeness

## Validation Command

```bash
# Run translation tests
# CRITICAL: per AGENTS.md, only run automated tests after security review is complete.
docker run --rm -v "$(pwd)":/app -w /app php:8.4-cli \
  php vendor/bin/phpunit tests/php/Unit/AppTranslationsTest.php --testdox
```
