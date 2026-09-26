# Common SEO Issues & Fixes

## Missing Canonical URL

**Issue:** No canonical URL specified
**Severity:** CRITICAL
**Fix:**
```php
<link rel="canonical" href="<?= e($canonicalUrl) ?>">
```

## Missing or Duplicate H1

**Issue:** Page has no H1 or multiple H1 tags
**Severity:** CRITICAL
**Fix:** Ensure exactly one `<h1>` per page containing the primary keyword

## Missing Hreflang Tags

**Issue:** Multi-locale site without hreflang
**Severity:** CRITICAL
**Fix:**
```php
<?php foreach ($supportedLocales as $locale): ?>
<link rel="alternate" hreflang="<?= $locale ?>" href="<?= getLocalizedUrl($locale) ?>">
<?php endforeach; ?>
<link rel="alternate" hreflang="x-default" href="<?= getDefaultUrl() ?>">
```

## Title Too Long

**Issue:** Title exceeds 60 characters
**Severity:** WARNING
**Fix:** Shorten title to 50-60 characters while keeping primary keyword

## Missing Open Graph Tags

**Issue:** No OG tags for social sharing
**Severity:** WARNING
**Fix:**
```html
<meta property="og:title" content="<?= e($pageTitle) ?>">
<meta property="og:description" content="<?= e($pageDescription) ?>">
<meta property="og:type" content="website">
<meta property="og:url" content="<?= e($canonicalUrl) ?>">
```

## Missing JSON-LD

**Issue:** No structured data
**Severity:** WARNING
**Fix:**
```php
<?php jsonLd([
    '@context' => 'https://schema.org',
    '@type' => 'SoftwareApplication',
    'name' => $app['name'],
    'description' => $pageDescription,
    'applicationCategory' => 'UtilitiesApplication',
    'operatingSystem' => 'Web Browser',
    'offers' => [
        '@type' => 'Offer',
        'price' => '0',
        'priceCurrency' => 'USD'
    ]
]); ?>
```

## Thin Content

**Issue:** Page has less than 300 words
**Severity:** WARNING
**Fix:** Add more descriptive content, expand use cases, add FAQ section

## Missing Alt Text

**Issue:** Images without alt attributes
**Severity:** CRITICAL
**Fix:**
```html
<img src="image.png" alt="Descriptive text about the image">
```

## Missing Use Cases Section

**Issue:** App page doesn't have use cases section
**Severity:** CRITICAL (AGENTS.md requirement)
**Fix:** Add use cases section with at least 5 use cases, translated for all 3 supported locales

## Missing Help Modal

**Issue:** App page doesn't have help modal
**Severity:** CRITICAL (AGENTS.md requirement)
**Fix:** Add help modal with step-by-step instructions, translated for all 3 supported locales

## Missing Sitemap Entry

**Issue:** App not in public/sitemap.xml
**Severity:** CRITICAL
**Fix:** Add entry with priority 0.8 and monthly changefreq
