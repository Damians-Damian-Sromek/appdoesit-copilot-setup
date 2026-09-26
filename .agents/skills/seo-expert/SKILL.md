---
name: seo-expert
description: SEO analysis and optimization for AppDoesIt apps and pages. Use when creating new apps, auditing existing pages, or optimizing for search engines. Analyzes meta tags, structured data, content quality, technical SEO, and provides prioritized recommendations with severity levels (CRITICAL, WARNING, RECOMMENDATION).
---

# SEO Expert Skill

Comprehensive SEO auditing workflow for AppDoesIt applications. Analyzes technical SEO, on-page optimization, structured data, and i18n implementation with clear severity-based prioritization.

## Severity Levels

Issues are classified into three severity levels for clear prioritization:

| Level | Impact | Action Required |
|-------|--------|-----------------|
| **CRITICAL** | Blocks indexing or severely harms ranking | Must fix immediately |
| **WARNING** | Significantly hurts SEO performance | Should fix soon |
| **RECOMMENDATION** | Optimization opportunity | Consider improving |

See [severity-guide.md](references/severity-guide.md) for detailed classification criteria.

## Source of Truth

**All SEO requirements are defined in [AGENTS.md](../../../AGENTS.md).**

Before auditing, read these AGENTS.md sections:
- `### SEO` - Core SEO requirements
- `### Sitemap Maintenance (MANDATORY)` - Sitemap requirements
- `### App Page Requirements (MANDATORY)` - Use cases section
- `### App Help/Instructions (MANDATORY)` - Help modal requirements
- `### i18n System` - 3 supported locales (`en`, `es`, `pl`)

**If requirements in this skill conflict with AGENTS.md, AGENTS.md takes precedence.**

---

## Consulting Other Skills

Consult other skills when you encounter questions outside your domain. Use the Task tool:

```
Task tool:
  description: "Consult {skill} about {topic}"
  prompt: |
    You are the /{skill-name} specialist.
    CONSULTATION from /seo-expert:
    Context: {what you're auditing}
    Question: {specific question}
    Provide a brief, actionable answer.
```

**When to consult:**

| Need | Consult |
|------|---------|
| Requirements unclear | `/product-owner` |
| Meta tag implementation | `/programmer` |
| Content quality questions | `/ui-expert` |
| Translation of SEO content | `/i18n-manager` |
| Performance impact | `/performance-expert` |

---

## When to Use This Skill

Trigger this skill when:
- After creating a new app (before deployment)
- When user mentions "SEO", "search engine", "ranking", "indexing"
- During site-wide SEO audits
- When optimizing existing pages for search
- Before major releases
- When debugging indexing issues

## SEO Audit Workflow

### Step 1: Identify Pages to Audit

Determine the scope of the audit:

**Single App:**
```bash
# Audit specific app
./.agents/skills/seo-expert/scripts/run-seo-audit.sh --app calculator
```

**All Apps:**
```bash
# Discover all apps from homepage
curl -s http://localhost:8000 | grep -oP 'data-app-slug="\K[^"]+' | sort -u
```

**Homepage and Static Pages:**
```bash
# Audit homepage
./.agents/skills/seo-expert/scripts/run-seo-audit.sh --url http://localhost:8000

# Audit category pages
./.agents/skills/seo-expert/scripts/run-seo-audit.sh --url http://localhost:8000/apps/productivity
```

### Step 2: Run Automated SEO Audit

Execute the Playwright-based SEO audit script:

```bash
# Run audit for a specific app
./.agents/skills/seo-expert/scripts/run-seo-audit.sh --app calculator

# Run audit for a URL
./.agents/skills/seo-expert/scripts/run-seo-audit.sh --url http://localhost:8000/apps/calculator

# Run audit for all apps
./.agents/skills/seo-expert/scripts/run-seo-audit.sh --all
```

The script extracts:
- All meta tags (title, description, viewport, robots)
- Open Graph and Twitter Card tags
- Canonical URL
- Hreflang tags
- Heading structure (H1-H6)
- JSON-LD structured data
- Images and alt text
- Internal and external links
- Response headers

Results are saved to `var/tmp/seo/{app-slug}-seo-audit.json`.

### Step 3: Technical SEO Analysis

Review the audit results for technical issues:

**CRITICAL Issues:**
- Missing `<title>` tag
- Missing canonical URL (`<link rel="canonical">`)
- Missing viewport meta tag
- Page blocked by robots.txt
- HTTP instead of HTTPS
- 4xx/5xx response codes
- Missing hreflang for multi-locale site

**WARNING Issues:**
- Title too long (>60 chars) or too short (<30 chars)
- Meta description too long (>160 chars) or too short (<70 chars)
- Missing Open Graph tags
- Missing Twitter Card tags
- Slow TTFB (>500ms)

**RECOMMENDATION:**
- Add more descriptive title
- Improve meta description click-through potential
- Add additional meta tags

```bash
# Check meta tags from audit results
cat var/tmp/seo/calculator-seo-audit.json | jq '.metaTags'

# Check response headers
cat var/tmp/seo/calculator-seo-audit.json | jq '.responseHeaders'
```

### Step 4: On-Page SEO Analysis

Analyze content structure and optimization:

**CRITICAL Issues:**
- Multiple H1 tags or no H1
- Missing alt text on images
- Missing use cases section (AGENTS.md requirement)
- Missing help section (AGENTS.md requirement)
- Not in sitemap.xml

**WARNING Issues:**
- H1 doesn't contain target keyword
- Poor heading hierarchy (skipping levels)
- Thin content (<300 words)
- No internal links
- Keyword stuffing

**RECOMMENDATION:**
- Add more descriptive headings
- Improve content depth
- Add internal links to related apps

```bash
# Check heading structure
cat var/tmp/seo/calculator-seo-audit.json | jq '.headings'

# Check images and alt text
cat var/tmp/seo/calculator-seo-audit.json | jq '.images'

# Check internal links
cat var/tmp/seo/calculator-seo-audit.json | jq '.internalLinks'
```

**Verify use cases and help sections (AGENTS.md requirements):**
```javascript
// Playwright check for required sections
const useCases = await page.$('.use-cases-section, [data-section="use-cases"]');
const helpModal = await page.$('#help-modal, [data-help-modal]');

if (!useCases) console.log('CRITICAL: Missing use cases section');
if (!helpModal) console.log('CRITICAL: Missing help modal');
```

### Step 5: Validate Structured Data (Google Rich Results Test)

Verify JSON-LD structured data is valid and complete:

**Extract JSON-LD:**
```bash
cat var/tmp/seo/calculator-seo-audit.json | jq '.jsonLd'
```

**Validate with Google Rich Results Test:**

1. Go to: https://search.google.com/test/rich-results
2. Enter the page URL or paste the JSON-LD
3. Check for errors and warnings

**CRITICAL Issues:**
- Invalid JSON syntax
- Missing required properties (name, description)
- Incorrect @type for content

**WARNING Issues:**
- Missing recommended properties
- Schema type could be more specific

**Required Schema for Apps (SoftwareApplication):**
```json
{
    "@context": "https://schema.org",
    "@type": "SoftwareApplication",
    "name": "Calculator",
    "description": "Free online calculator...",
    "applicationCategory": "UtilitiesApplication",
    "operatingSystem": "Web Browser",
    "offers": {
        "@type": "Offer",
        "price": "0",
        "priceCurrency": "USD"
    }
}
```

### Step 6: Check Performance Impact (PageSpeed Insights)

Core Web Vitals affect SEO rankings. Check performance:

**Use PageSpeed Insights:**

1. Go to: https://pagespeed.web.dev/
2. Enter the page URL
3. Review Core Web Vitals:
   - **LCP** (Largest Contentful Paint): < 2.5s
   - **FID** (First Input Delay): < 100ms
   - **CLS** (Cumulative Layout Shift): < 0.1

**WARNING Issues:**
- LCP > 2.5s
- FID > 100ms
- CLS > 0.1
- Performance score < 90

**Common Performance Issues Affecting SEO:**
- Unoptimized images
- Render-blocking CSS/JS
- No caching headers
- Large JavaScript bundles

---

## Performance Requirements (per AGENTS.md)

Per AGENTS.md `### Performance`, every app must meet these requirements:

### Asset Optimization

| Requirement | How to Verify | Fix |
|-------------|---------------|-----|
| CSS/JS minified in production | Check file sizes | Use build tool or manual minification |
| Images optimized | Check image file sizes | Compress with ImageOptim, TinyPNG |
| Lazy loading for images | Check `loading="lazy"` attribute | Add `loading="lazy"` to below-fold images |
| Cache busting | Check URLs use `asset()` helper | Use `asset()` for all CSS/JS includes |

### Core Web Vitals Targets

Use the canonical targets from `.agents/skills/performance-expert/SKILL.md` (LCP < 2.5s, FID < 100ms, CLS < 0.1, Performance score >= 90). Do not duplicate the metric tables here; cite that file when reporting.

### Performance Checklist

**CRITICAL Issues:**
- [ ] No large uncompressed images (> 500KB)
- [ ] No render-blocking resources without async/defer

**WARNING Issues:**
- [ ] CSS/JS files not minified
- [ ] Missing cache headers
- [ ] Images without explicit dimensions (causes CLS)
- [ ] Large JavaScript bundles (> 200KB uncompressed)

**RECOMMENDATIONS:**
- [ ] Use lazy loading for below-fold images
- [ ] Preload critical assets
- [ ] Use appropriate image formats (WebP for photos)

### Cache Busting with asset() Helper

The `asset()` helper adds cache-busting query strings:

```php
// Correct - uses cache busting
<link rel="stylesheet" href="<?= asset('css/app.css') ?>">
<script src="<?= asset('js/app.js') ?>"></script>

// Incorrect - no cache busting
<link rel="stylesheet" href="/assets/css/app.css">
```

**Verify all asset URLs use the helper:**
```bash
# Find assets NOT using asset() helper
grep -r 'href="/assets\|src="/assets' apps/ app/views/
```

### Lazy Loading Implementation

```html
<!-- Below-fold images should use lazy loading -->
<img src="image.jpg" alt="Description" loading="lazy" width="800" height="600">

<!-- Above-fold images (hero, logo) should NOT be lazy loaded -->
<img src="hero.jpg" alt="Hero" width="1200" height="400">
```

### Step 7: i18n SEO Verification (3 Locales)

Verify SEO implementation across all locales:

**All Supported Locales:**
```
en, es, pl
```

**CRITICAL Issues:**
- Missing hreflang tags
- Hreflang URLs not absolute
- Missing x-default hreflang
- Localized URLs not in sitemap
- Title/description not translated

**WARNING Issues:**
- Same meta description across locales
- Non-localized URL slugs where localized version exists

**Verification Script:**
```bash
# Check hreflang implementation for all supported locales
for locale in en es pl; do
    url=$([ "$locale" = "en" ] && echo "/apps/calculator" || echo "/$locale/apps/calculator")
    echo "Checking: $url"
    ./.agents/skills/seo-expert/scripts/run-seo-audit.sh --url "http://localhost:8000$url" --locale $locale
done
```

**Hreflang Format:**
```html
<link rel="alternate" hreflang="en" href="https://appdoesit.com/apps/calculator" />
<link rel="alternate" hreflang="es" href="https://appdoesit.com/es/apps/calculadora" />
<link rel="alternate" hreflang="pl" href="https://appdoesit.com/pl/apps/kalkulator" />
<link rel="alternate" hreflang="x-default" href="https://appdoesit.com/apps/calculator" />
```

### Step 8: Generate Prioritized Report

Use the template from [report-template.md](references/report-template.md) to compile findings.

**Report requirements:**
- Categorize by severity (CRITICAL, WARNING, RECOMMENDATION)
- Include evidence and fix instructions
- Target: Zero CRITICAL issues, minimal WARNINGs

## Common Issues

See [common-issues.md](references/common-issues.md) for fixes to:
- Missing canonical URL
- Missing/duplicate H1
- Missing hreflang tags
- Title length issues
- Missing Open Graph tags
- Missing JSON-LD
- Thin content
- Missing alt text

## AppDoesIt-Specific SEO Requirements

Per AGENTS.md, every app MUST have:

1. **Use Cases Section** (CRITICAL)
   - At least 5 use cases with titles and descriptions
   - Translated for all 3 supported locales
   - Semantic HTML structure

2. **Help Modal** (CRITICAL)
   - Step-by-step instructions
   - All features documented
   - Translated for all 3 supported locales

3. **Sitemap Entry** (CRITICAL)
   - App must be in `public/sitemap.xml`
   - Priority 0.8 for apps
   - Monthly changefreq

4. **JSON-LD Structured Data**
   - SoftwareApplication schema
   - Valid and error-free

5. **Localized URLs**
   - Slugs defined in `config/slugs.php`
   - All 3 supported locales covered
   - Hreflang tags for all supported locales

## Reference Files

- [seo-checklist.md](references/seo-checklist.md) - Complete SEO audit checklist
- [severity-guide.md](references/severity-guide.md) - Issue severity classification
- [report-template.md](references/report-template.md) - Audit report template
- [common-issues.md](references/common-issues.md) - Common issues and fixes

## External Validation Tools

### Google Rich Results Test
- URL: https://search.google.com/test/rich-results
- Purpose: Validate JSON-LD structured data
- Requirement: Zero errors, minimal warnings

### PageSpeed Insights
- URL: https://pagespeed.web.dev/
- Purpose: Check Core Web Vitals and performance
- Target: 90+ performance score

## Updating This Skill

When AGENTS.md SEO requirements change:

```bash
# Check for changes
grep -A 20 "### SEO" AGENTS.md
grep -A 30 "### Sitemap" AGENTS.md
```

Update this skill to reflect any new requirements.

## PM Status Payload (When Delegated by /project-manager)

When this skill is executed under /project-manager, append this block to your return:

```markdown
### PM Status Payload
- Work Item ID: [W-...]
- Skill: /seo-expert
- Status: TODO|IN_PROGRESS|BLOCKED|DONE|CANCELLED
- Progress Summary: [non-technical summary]
- Blocker: [None or blocker]
- Next Owner: [/seo-expert, /project-manager, or user]
```

Keep `Progress Summary` non-technical and outcome-focused.
