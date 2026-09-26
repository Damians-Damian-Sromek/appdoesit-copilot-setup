---
name: performance-expert
description: Performance auditing and optimization for AppDoesIt apps using Google Lighthouse. Use when creating new apps, auditing performance, optimizing load times, or configuring HTTP caching. Covers Core Web Vitals, cache headers, compression, and asset optimization. Automatically invoked by project-manager as Phase 4b.
---

# Performance Expert Skill

## MANDATORY: Lighthouse Audit Required

**CRITICAL: Performance verification is NOT complete without running Google Lighthouse.**

A performance audit MUST include:
1. **Lighthouse performance audit** (MANDATORY - non-negotiable)
2. HTTP cache header verification via `curl -I`
3. Compression validation

**Do NOT consider performance testing complete if Lighthouse has not been run.**

### Required Score: 90+

**The app MUST achieve a Lighthouse performance score of 90 or higher.**

- Score of 90+: PASS
- Score below 90: FAIL - Must fix all reported issues

---

## Consulting Other Skills

Consult other skills when you encounter questions outside your domain. Use the Task tool:

```
Task tool:
  description: "Consult {skill} about {topic}"
  prompt: |
    You are the /{skill-name} specialist.
    CONSULTATION from /performance-expert:
    Context: {what you're auditing}
    Question: {specific question}
    Provide a brief, actionable answer.
```

**When to consult:**

| Need | Consult |
|------|---------|
| Requirements unclear | `/product-owner` |
| Code optimization needed | `/programmer` |
| Asset optimization | `/ui-expert` |
| Accessibility trade-offs | `/accessibility-expert` |
| SEO impact | `/seo-expert` |

---

## When to Use This Skill

This skill should be triggered:
- After creating a new app (Phase 4b in project lifecycle)
- When user mentions "performance", "speed", "caching", "slow"
- When auditing existing apps for performance
- When configuring HTTP cache headers
- During final verification before deployment

---

## Performance Audit Workflow

### Step 1: Identify App to Audit

Determine the app URL(s) to audit:
- From conversation context (app just created/modified)
- From user specification
- All apps (for comprehensive audit)

```bash
# Get list of all apps
curl -s http://localhost:8000 | grep -oP 'data-app-slug="\K[^"]+' | sort -u
```

### Step 2: Run Lighthouse Performance Audit

```bash
# Using the provided script (recommended)
./.agents/skills/performance-expert/scripts/run-perf-audit.sh --app calculator
```

Manual Docker fallback: the canonical `femtopixel/google-lighthouse` command (with per-clone network/port notes) is documented in `.agents/skills/accessibility-expert/references/lighthouse-guide.md` — run it with `--only-categories=performance`.

### Step 3: Parse Lighthouse Results

```bash
# Read the JSON report
cat var/tmp/performance/perf-*.report.json | jq '.categories.performance.score * 100'

# Get Core Web Vitals
cat var/tmp/performance/perf-*.report.json | jq '
  .audits | {
    LCP: .["largest-contentful-paint"].displayValue,
    FID: .["max-potential-fid"].displayValue,
    CLS: .["cumulative-layout-shift"].displayValue,
    TBT: .["total-blocking-time"].displayValue
  }
'
```

**Score interpretation:**
- **90-100: PASS** - Excellent performance
- **50-89: FAIL** - Needs optimization
- **0-49: FAIL** - Serious performance issues

### Step 4: Verify HTTP Cache Headers

```bash
# Check response headers for an app page
curl -I http://localhost:8000/apps/calculator

# Check static asset headers
curl -I http://localhost:8000/assets/css/main.css
curl -I http://localhost:8000/assets/js/main.js
```

**Required headers for HTML pages:**
```
Cache-Control: no-cache, must-revalidate
Vary: Accept-Encoding, Accept-Language
```

**Required headers for static assets (CSS/JS/images):**
```
Cache-Control: public, max-age=31536000
```

### Step 5: Verify Compression

```bash
# Check if GZIP is enabled
curl -H "Accept-Encoding: gzip" -I http://localhost:8000/apps/calculator | grep -i content-encoding
# Should show: Content-Encoding: gzip
```

### Step 6: Generate Performance Report

Use the template from [performance-checklist.md](references/performance-checklist.md).

---

## Core Web Vitals Targets

| Metric | Good | Needs Improvement | Poor |
|--------|------|-------------------|------|
| **LCP** (Largest Contentful Paint) | < 2.5s | 2.5s - 4.0s | > 4.0s |
| **FID** (First Input Delay) | < 100ms | 100ms - 300ms | > 300ms |
| **CLS** (Cumulative Layout Shift) | < 0.1 | 0.1 - 0.25 | > 0.25 |
| **TBT** (Total Blocking Time) | < 200ms | 200ms - 600ms | > 600ms |

---

## HTTP Cache Strategy

See [cache-header-guide.md](references/cache-header-guide.md) for detailed guidance.

### Quick Reference

| Content Type | Cache-Control | Max-Age |
|-------------|---------------|---------|
| HTML pages | no-cache, must-revalidate | 0 |
| CSS/JS files | public, max-age=31536000 | 1 year |
| Images | public, max-age=31536000 | 1 year |
| Fonts | public, max-age=31536000 | 1 year |
| JSON data | no-cache | 0 |
| i18n files | public, max-age=86400 | 1 day |

### Adding Cache Headers in PHP

```php
// In public/index.php for HTML responses
header('Cache-Control: no-cache, must-revalidate');
header('Vary: Accept-Encoding, Accept-Language');
```

---

## Common Performance Issues & Fixes

### 1. Large Images
**Issue:** Unoptimized images slowing page load.
**Fix:** Use WebP format, lazy loading, and appropriate sizing.

```html
<img src="image.webp" loading="lazy" width="400" height="300" alt="Description">
```

### 2. Render-Blocking Resources
**Issue:** CSS/JS blocking initial render.
**Fix:** Defer non-critical scripts, inline critical CSS.

```html
<script defer src="/assets/js/app.js"></script>
```

### 3. Missing Cache Headers
**Issue:** Browser re-downloads assets on every visit.
**Fix:** Configure `.htaccess` or add PHP headers.

### 4. No Compression
**Issue:** Large response sizes.
**Fix:** Enable mod_deflate in `.htaccess` (already configured).

### 5. Slow Server Response (TTFB)
**Issue:** Server takes too long to respond.
**Fix:** Enable OPcache, optimize PHP code.

---

## OVH Shared Hosting Constraints

When optimizing for OVH shared hosting:

1. **No Redis/Memcached** - Use file-based caching
2. **Limited PHP settings** - OPcache managed by OVH
3. **No CDN by default** - Consider Cloudflare if needed
4. **mod_deflate available** - Already configured in .htaccess
5. **mod_expires available** - Already configured in .htaccess

---

## Reference Files

- [cache-header-guide.md](references/cache-header-guide.md) - HTTP caching reference
- [performance-checklist.md](references/performance-checklist.md) - Audit checklist

---

## Output Format

Return a performance report:

```markdown
## Performance Audit Report: {App Name}

**Date:** {date}
**Lighthouse Score:** {score}/100

### Core Web Vitals
| Metric | Value | Status |
|--------|-------|--------|
| LCP | {value} | PASS/FAIL |
| FID | {value} | PASS/FAIL |
| CLS | {value} | PASS/FAIL |
| TBT | {value} | PASS/FAIL |

### Cache Headers
- [ ] HTML: Cache-Control present
- [ ] Static assets: max-age=31536000
- [ ] Vary header present

### Compression
- [ ] GZIP enabled

### Issues Found
1. {Issue description and fix}

### Result: PASS/FAIL
```

## PM Status Payload (When Delegated by /project-manager)

When this skill is executed under /project-manager, append this block to your return:

```markdown
### PM Status Payload
- Work Item ID: [W-...]
- Skill: /performance-expert
- Status: TODO|IN_PROGRESS|BLOCKED|DONE|CANCELLED
- Progress Summary: [non-technical summary]
- Blocker: [None or blocker]
- Next Owner: [/performance-expert, /project-manager, or user]
```

Keep `Progress Summary` non-technical and outcome-focused.
