# SEO Audit Checklist

Complete checklist for auditing SEO on AppDoesIt pages. Each item is marked with its severity level.

## How to Use This Checklist

1. Run through each section systematically
2. Mark items as PASS, FAIL, or N/A
3. Note the severity level for failed items
4. Prioritize fixes by severity: CRITICAL > WARNING > RECOMMENDATION

**Severity Key:**
- CRITICAL - Must fix immediately
- WARNING - Should fix soon
- RECOMMENDATION - Consider improving

---

## Technical SEO (18 Checks)

### Meta Tags

| # | Check | Severity | Status | Notes |
|---|-------|----------|--------|-------|
| 1 | Title tag present | CRITICAL | | |
| 2 | Title tag 50-60 characters | WARNING | | Length: ___ chars |
| 3 | Title contains primary keyword | RECOMMENDATION | | Keyword: ___ |
| 4 | Meta description present | WARNING | | |
| 5 | Meta description 120-160 characters | WARNING | | Length: ___ chars |
| 6 | Meta description contains call-to-action | RECOMMENDATION | | |
| 7 | Viewport meta tag present | CRITICAL | | |
| 8 | Robots meta allows indexing | CRITICAL | | |

### URLs & Canonicalization

| # | Check | Severity | Status | Notes |
|---|-------|----------|--------|-------|
| 9 | Canonical URL present | CRITICAL | | |
| 10 | Canonical URL is absolute | WARNING | | |
| 11 | No duplicate URLs | WARNING | | |
| 12 | Clean URL structure (no params) | RECOMMENDATION | | |
| 13 | HTTPS enabled | CRITICAL | | |

### Social Meta Tags

| # | Check | Severity | Status | Notes |
|---|-------|----------|--------|-------|
| 14 | Open Graph: og:title | WARNING | | |
| 15 | Open Graph: og:description | WARNING | | |
| 16 | Open Graph: og:type | WARNING | | |
| 17 | Open Graph: og:url | WARNING | | |
| 18 | Open Graph: og:image | RECOMMENDATION | | |
| 19 | Twitter Card: twitter:card | WARNING | | |
| 20 | Twitter Card: twitter:title | WARNING | | |
| 21 | Twitter Card: twitter:description | WARNING | | |

### Crawlability

| # | Check | Severity | Status | Notes |
|---|-------|----------|--------|-------|
| 22 | Page in sitemap.xml | CRITICAL | | |
| 23 | robots.txt allows crawling | CRITICAL | | |
| 24 | No noindex tag (unless intended) | CRITICAL | | |
| 25 | Response code 200 | CRITICAL | | Code: ___ |
| 26 | No redirect chains | WARNING | | |
| 27 | TTFB < 500ms | WARNING | | TTFB: ___ms |

---

## On-Page SEO (15 Checks)

### Heading Structure

| # | Check | Severity | Status | Notes |
|---|-------|----------|--------|-------|
| 1 | Exactly one H1 tag | CRITICAL | | Count: ___ |
| 2 | H1 contains primary keyword | WARNING | | |
| 3 | Logical heading hierarchy (H1->H2->H3) | WARNING | | |
| 4 | No skipped heading levels | RECOMMENDATION | | |
| 5 | Headings are descriptive | RECOMMENDATION | | |

### Images

| # | Check | Severity | Status | Notes |
|---|-------|----------|--------|-------|
| 6 | All images have alt text | CRITICAL | | Missing: ___ |
| 7 | Alt text is descriptive | WARNING | | |
| 8 | Alt text not keyword-stuffed | WARNING | | |
| 9 | Images are optimized (WebP/compressed) | RECOMMENDATION | | |
| 10 | Images have width/height attributes | RECOMMENDATION | | |

### Links

| # | Check | Severity | Status | Notes |
|---|-------|----------|--------|-------|
| 11 | Internal links to related content | WARNING | | Count: ___ |
| 12 | No broken internal links | CRITICAL | | |
| 13 | External links open in new tab | RECOMMENDATION | | |
| 14 | Descriptive anchor text | RECOMMENDATION | | |
| 15 | No excessive linking | WARNING | | |

### Semantic HTML

| # | Check | Severity | Status | Notes |
|---|-------|----------|--------|-------|
| 16 | Uses semantic HTML5 elements | WARNING | | |
| 17 | `<main>` element present | RECOMMENDATION | | |
| 18 | `<article>` or `<section>` used appropriately | RECOMMENDATION | | |
| 19 | `<nav>` for navigation | RECOMMENDATION | | |
| 20 | `<header>` and `<footer>` present | RECOMMENDATION | | |

---

## Content Quality (10 Checks)

### Required Sections (AGENTS.md)

| # | Check | Severity | Status | Notes |
|---|-------|----------|--------|-------|
| 1 | Use cases section present | CRITICAL | | |
| 2 | At least 5 use cases | WARNING | | Count: ___ |
| 3 | Use cases have titles and descriptions | WARNING | | |
| 4 | Help modal/section present | CRITICAL | | |
| 5 | Help content is comprehensive | WARNING | | |

### Content Depth

| # | Check | Severity | Status | Notes |
|---|-------|----------|--------|-------|
| 6 | Minimum 300 words | WARNING | | Count: ___ |
| 7 | Content matches search intent | WARNING | | |
| 8 | Clear value proposition | WARNING | | |
| 9 | Scannable (lists, short paragraphs) | RECOMMENDATION | | |
| 10 | No spelling/grammar errors | RECOMMENDATION | | |

### Content Uniqueness

| # | Check | Severity | Status | Notes |
|---|-------|----------|--------|-------|
| 11 | No duplicate content on site | WARNING | | |
| 12 | Content not copied from competitors | CRITICAL | | |
| 13 | Unique meta title/description | WARNING | | |

---

## Structured Data (8 Checks)

### JSON-LD Presence

| # | Check | Severity | Status | Notes |
|---|-------|----------|--------|-------|
| 1 | JSON-LD script present | WARNING | | |
| 2 | Valid JSON syntax | CRITICAL | | |
| 3 | Correct @context (schema.org) | WARNING | | |

### Schema Completeness (SoftwareApplication)

| # | Check | Severity | Status | Notes |
|---|-------|----------|--------|-------|
| 4 | @type is SoftwareApplication | WARNING | | |
| 5 | Required: name | CRITICAL | | |
| 6 | Required: description | WARNING | | |
| 7 | Recommended: applicationCategory | RECOMMENDATION | | |
| 8 | Recommended: operatingSystem | RECOMMENDATION | | |
| 9 | Recommended: offers (with price) | RECOMMENDATION | | |

### Validation

| # | Check | Severity | Status | Notes |
|---|-------|----------|--------|-------|
| 10 | No errors in Rich Results Test | CRITICAL | | Errors: ___ |
| 11 | No warnings in Rich Results Test | WARNING | | Warnings: ___ |
| 12 | Schema type matches page content | WARNING | | |

---

## i18n SEO (10 Checks)

### Hreflang Implementation

| # | Check | Severity | Status | Notes |
|---|-------|----------|--------|-------|
| 1 | Hreflang x-default present | WARNING | | |
| 2 | Hreflang for all 3 supported locales | CRITICAL | | Count: ___/3 |
| 3 | Correct hreflang format (lang or lang-REGION) | WARNING | | |
| 4 | Hreflang URLs are absolute | WARNING | | |
| 5 | Return links present (reciprocal) | WARNING | | |

### Localized Content

| # | Check | Severity | Status | Notes |
|---|-------|----------|--------|-------|
| 6 | Title translated per locale | CRITICAL | | |
| 7 | Meta description translated | CRITICAL | | |
| 8 | Content translated (not just English) | CRITICAL | | |
| 9 | Localized URL slugs | WARNING | | |
| 10 | No mixed language content | WARNING | | |

### All 3 Supported Locales Checklist

| Locale | Hreflang | Title | Description | Content |
|--------|----------|-------|-------------|---------|
| en | | | | |
| de | | | | |
| es | | | | |
| fr | | | | |
| ar | | | | |
| ru | | | | |
| uk | | | | |
| ja | | | | |
| zh | | | | |
| ko | | | | |
| hi | | | | |
| it | | | | |
| pt | | | | |
| nl | | | | |
| pl | | | | |
| tr | | | | |
| vi | | | | |
| id | | | | |
| bn | | | | |
| th | | | | |

---

## Performance Impact on SEO (5 Checks)

### Core Web Vitals

| # | Check | Severity | Target | Actual | Status |
|---|-------|----------|--------|--------|--------|
| 1 | LCP (Largest Contentful Paint) | WARNING | < 2.5s | | |
| 2 | FID (First Input Delay) | WARNING | < 100ms | | |
| 3 | CLS (Cumulative Layout Shift) | WARNING | < 0.1 | | |

### Performance Metrics

| # | Check | Severity | Target | Actual | Status |
|---|-------|----------|--------|--------|--------|
| 4 | PageSpeed Insights score | WARNING | > 90 | | |
| 5 | Total page load time | WARNING | < 3s | | |
| 6 | No render-blocking resources | RECOMMENDATION | | | |
| 7 | Images lazy-loaded | RECOMMENDATION | | | |
| 8 | CSS/JS minified | RECOMMENDATION | | | |

---

## Mobile SEO (5 Checks)

| # | Check | Severity | Status | Notes |
|---|-------|----------|--------|-------|
| 1 | Mobile-friendly (responsive) | CRITICAL | | |
| 2 | Touch targets adequate (44x44px) | WARNING | | |
| 3 | No horizontal scroll | WARNING | | |
| 4 | Text readable without zoom | WARNING | | |
| 5 | Viewport configured correctly | CRITICAL | | |

---

## Quick Reference: Severity Summary

### CRITICAL Issues (Block Deployment)

1. Missing title tag
2. Missing canonical URL
3. Missing/duplicate H1
4. Missing hreflang (multi-locale)
5. Page not in sitemap
6. Images missing alt text
7. Missing use cases section
8. Missing help modal
9. HTTP 4xx/5xx errors
10. robots.txt blocking
11. Not mobile-friendly
12. Invalid JSON-LD syntax
13. Missing viewport meta

### WARNING Issues (Fix Soon)

1. Title too long/short
2. Meta description issues
3. Missing Open Graph tags
4. Missing Twitter Cards
5. Missing JSON-LD
6. Thin content (<300 words)
7. Poor heading hierarchy
8. Few internal links
9. Core Web Vitals failing
10. Slow page load

### RECOMMENDATIONS (Optimize)

1. Improve title compelling-ness
2. Add call-to-action to description
3. Optimize images further
4. Add more structured data
5. Improve content depth
6. Add more internal links
