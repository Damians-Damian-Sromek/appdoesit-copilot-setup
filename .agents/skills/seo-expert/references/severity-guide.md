# SEO Issue Severity Classification Guide

This guide explains how to classify SEO issues by severity level, helping prioritize fixes effectively.

## Severity Levels Overview

| Level | Meaning | Timeline |
|-------|---------|----------|
| **CRITICAL** | Blocks indexing or severely harms ranking | Fix immediately, before deployment |
| **WARNING** | Significantly hurts SEO performance | Fix within 1-2 days |
| **RECOMMENDATION** | Optimization opportunity | Consider in next iteration |

---

## CRITICAL Issues

**Definition:** Issues that prevent pages from being indexed, cause severe ranking penalties, or violate core SEO requirements.

**Action Required:** Must be fixed before deployment. Do not approve pages with CRITICAL issues.

### Indexing Blockers

| Issue | Why It's Critical | Example | Fix |
|-------|-------------------|---------|-----|
| **Missing title tag** | Google can't understand page topic | `<head>` has no `<title>` | Add descriptive `<title>` tag |
| **Page blocked by robots.txt** | Crawlers can't access page | `Disallow: /apps/` | Update robots.txt |
| **noindex meta tag** | Page explicitly excluded | `<meta name="robots" content="noindex">` | Remove noindex |
| **HTTP 4xx/5xx errors** | Page returns error | 404 Not Found | Fix broken link or server issue |
| **Missing canonical URL** | Duplicate content risk | No `<link rel="canonical">` | Add canonical tag |

### Content Issues

| Issue | Why It's Critical | Example | Fix |
|-------|-------------------|---------|-----|
| **No H1 tag** | No primary heading for topic | Page has no `<h1>` | Add single descriptive H1 |
| **Multiple H1 tags** | Confuses topic hierarchy | Two `<h1>` elements | Keep only one H1 |
| **Images missing alt text** | Accessibility + SEO failure | `<img src="..." alt="">` | Add descriptive alt |
| **Missing use cases section** | AGENTS.md requirement | No use cases on app page | Add use cases per requirements |
| **Missing help modal** | AGENTS.md requirement | No help section | Add help modal per requirements |

### i18n Issues

| Issue | Why It's Critical | Example | Fix |
|-------|-------------------|---------|-----|
| **Missing hreflang tags** | Wrong language shown in SERPs | No `<link rel="alternate" hreflang="">` | Add hreflang for all 3 supported locales |
| **Untranslated title/description** | Same English text for all locales | Spanish page has English title | Translate meta tags |
| **Content not translated** | Duplicate content across locales | Polish URL shows English | Provide translations |

### Technical Issues

| Issue | Why It's Critical | Example | Fix |
|-------|-------------------|---------|-----|
| **Not in sitemap.xml** | Crawlers may not find page | App missing from sitemap | Add to public/sitemap.xml |
| **Missing viewport meta** | Mobile-unfriendly | No `<meta name="viewport">` | Add viewport meta tag |
| **Invalid JSON-LD syntax** | Structured data fails | Malformed JSON | Fix JSON syntax |
| **HTTP not HTTPS** | Security warning, ranking penalty | `http://` URLs | Implement HTTPS |

### Indicators of CRITICAL

Ask yourself:
1. Will this prevent Google from indexing the page? -> CRITICAL
2. Will this cause a significant ranking penalty? -> CRITICAL
3. Does this violate AGENTS.md MANDATORY requirements? -> CRITICAL
4. Will users be unable to access the page? -> CRITICAL

---

## WARNING Issues

**Definition:** Issues that hurt SEO performance but don't completely block indexing or cause severe penalties.

**Action Required:** Should be fixed within 1-2 days. Acceptable to deploy with WARNING issues if planned for quick fix.

### Meta Tag Issues

| Issue | Why It's Warning | Example | Fix |
|-------|------------------|---------|-----|
| **Title too long (>60 chars)** | Truncated in SERPs | "This Is A Very Long Title That Will Get Cut Off In Search Results And Look Bad" (78 chars) | Shorten to 50-60 chars |
| **Title too short (<30 chars)** | Missed keyword opportunity | "Calculator" (10 chars) | Expand with keywords |
| **Meta description too long** | Truncated, wastes space | 200+ character description | Limit to 150-160 chars |
| **Meta description missing** | Google generates snippet | No `<meta name="description">` | Add compelling description |
| **Missing Open Graph tags** | Poor social sharing | No og:title, og:description | Add OG meta tags |
| **Missing Twitter Cards** | Poor Twitter sharing | No twitter:card | Add Twitter meta tags |

### Content Issues

| Issue | Why It's Warning | Example | Fix |
|-------|------------------|---------|-----|
| **Thin content (<300 words)** | Lacks depth for ranking | Page has 150 words | Expand content, add details |
| **Poor heading hierarchy** | Confusing structure | H1 -> H4 (skipping H2, H3) | Use sequential heading levels |
| **Few internal links** | Poor site structure | Only 1 internal link | Add links to related apps |
| **Missing JSON-LD** | No structured data | No schema markup | Add SoftwareApplication schema |
| **H1 lacks keyword** | Missed ranking signal | H1: "Welcome" vs "Free Calculator" | Include target keyword |

### Performance Issues

| Issue | Why It's Warning | Example | Fix |
|-------|------------------|---------|-----|
| **Core Web Vitals failing** | Ranking factor | LCP > 2.5s, CLS > 0.1 | Optimize performance |
| **Slow page load (>3s)** | User experience, bounce rate | 5 second load time | Optimize assets, reduce requests |
| **High TTFB (>500ms)** | Server response slow | 800ms TTFB | Optimize server, add caching |

### Link Issues

| Issue | Why It's Warning | Example | Fix |
|-------|------------------|---------|-----|
| **Broken internal links** | Poor UX, wasted crawl budget | Link to deleted page | Fix or remove broken links |
| **No internal links out** | Isolated page | Page doesn't link anywhere | Add relevant internal links |
| **Excessive external links** | Dilutes page authority | 50+ external links | Reduce or nofollow |

### Indicators of WARNING

Ask yourself:
1. Will this noticeably reduce click-through rate? -> WARNING
2. Will this make the page rank lower (but still rank)? -> WARNING
3. Does this hurt user experience significantly? -> WARNING
4. Is this a missed optimization that affects rankings? -> WARNING

---

## RECOMMENDATION Issues

**Definition:** Opportunities for optimization that won't significantly harm SEO if left unfixed, but could improve performance.

**Action Required:** Consider in next iteration. Nice to have but not blocking.

### Content Improvements

| Issue | Potential Benefit | Example | Fix |
|-------|-------------------|---------|-----|
| **Title could be more compelling** | Higher CTR | "Calculator" -> "Free Online Calculator - Quick & Easy" | Rewrite with power words |
| **Meta description lacks CTA** | Higher CTR | Describes but doesn't invite action | Add "Try it now", "Calculate instantly" |
| **Content could be deeper** | Better rankings | 350 words -> 600 words | Expand with more details, FAQ |
| **More use cases** | Better engagement | 5 use cases -> 7 use cases | Add 2 more relevant use cases |

### Technical Improvements

| Issue | Potential Benefit | Example | Fix |
|-------|-------------------|---------|-----|
| **Add more schema types** | Rich snippets | Only SoftwareApplication | Add BreadcrumbList, FAQ |
| **Optimize images further** | Faster load | PNG images | Convert to WebP |
| **Add lazy loading** | Faster initial load | Images load immediately | Add `loading="lazy"` |
| **Minify CSS/JS** | Faster load | Unminified assets | Minify in production |

### Link Improvements

| Issue | Potential Benefit | Example | Fix |
|-------|-------------------|---------|-----|
| **More internal linking** | Better page authority | 3 internal links | Add 2-3 more relevant links |
| **External links new tab** | Keep users on site | Links open in same tab | Add `target="_blank"` |
| **Better anchor text** | Semantic relevance | "Click here" -> "Try the calculator" | Use descriptive anchors |

### i18n Improvements

| Issue | Potential Benefit | Example | Fix |
|-------|-------------------|---------|-----|
| **Missing x-default hreflang** | Better fallback | Only locale-specific hreflang | Add x-default |
| **Improve localized URLs** | Better local SEO | `/es/apps/calculator` -> `/es/apps/calculadora` | Use translated slugs |

### Indicators of RECOMMENDATION

Ask yourself:
1. Would this be nice to have but not essential? -> RECOMMENDATION
2. Is this an optimization beyond best practices? -> RECOMMENDATION
3. Would fixing this provide marginal improvement? -> RECOMMENDATION
4. Is this about polish rather than functionality? -> RECOMMENDATION

---

## Decision Tree

Use this checklist to classify issues:

```
Is the page blocked from indexing?
- Yes -> CRITICAL
- No -> next question

Does it violate an AGENTS.md MANDATORY requirement?
- Yes -> CRITICAL
- No -> next question

Will it cause a significant ranking drop?
- Yes -> WARNING (or CRITICAL if it prevents indexing)
- No -> next question

Does it noticeably hurt user experience or CTR?
- Yes -> WARNING
- No -> next question

Is it an optimization opportunity?
- Yes -> RECOMMENDATION
- No -> Not an issue
```

---

## Examples by Page Type

### App Page (e.g., /apps/calculator)

| Check | Typical Severity |
|-------|-----------------|
| Title tag present | CRITICAL |
| Canonical URL | CRITICAL |
| Single H1 | CRITICAL |
| Use cases section | CRITICAL (AGENTS.md) |
| Help modal | CRITICAL (AGENTS.md) |
| In sitemap | CRITICAL |
| Hreflang tags (3 supported locales) | CRITICAL |
| JSON-LD SoftwareApplication | WARNING |
| Meta description | WARNING |
| 300+ words content | WARNING |
| Open Graph tags | WARNING |

### Homepage

| Check | Typical Severity |
|-------|-----------------|
| Title tag present | CRITICAL |
| Canonical URL | CRITICAL |
| Single H1 | CRITICAL |
| In sitemap | CRITICAL |
| Hreflang tags | CRITICAL |
| JSON-LD WebSite | WARNING |
| Links to all apps | WARNING |

### Category Page (e.g., /apps/productivity)

| Check | Typical Severity |
|-------|-----------------|
| Title tag with category | CRITICAL |
| Canonical URL | CRITICAL |
| Single H1 | CRITICAL |
| In sitemap | CRITICAL |
| Hreflang tags | CRITICAL |
| Links to apps in category | WARNING |
| Category description | WARNING |

---

## Prioritization Matrix

When multiple issues exist, prioritize using this matrix:

| Priority | Severity | Count | Example |
|----------|----------|-------|---------|
| 1 (Highest) | CRITICAL | Any | Fix all CRITICAL first |
| 2 | WARNING | > 5 | Many warnings compound |
| 3 | WARNING | 1-5 | Fix soon after CRITICAL |
| 4 (Lowest) | RECOMMENDATION | Any | Address as time permits |

**Rule of thumb:** Never deploy with CRITICAL issues. WARNINGs are acceptable if tracked for quick resolution. RECOMMENDATIONs are nice-to-have.
