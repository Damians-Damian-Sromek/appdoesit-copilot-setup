# Performance Audit Checklist

Use this checklist when auditing app performance.

## Pre-Audit Setup

- [ ] Docker environment running (`.\docker.ps1 up`)
- [ ] App accessible at `http://localhost:8000/apps/{slug}`
- [ ] `var/tmp/performance/` directory exists

---

## 1. Lighthouse Performance Audit

**Tool:** Google Lighthouse (via Docker)

```bash
./.agents/skills/performance-expert/scripts/run-perf-audit.sh --app {slug}
```

### Score Requirements

| Metric | Requirement | Status |
|--------|-------------|--------|
| **Performance Score** | >= 90 | [ ] PASS / [ ] FAIL |
| **LCP** (Largest Contentful Paint) | < 2.5s | [ ] PASS / [ ] FAIL |
| **FID** (First Input Delay) | < 100ms | [ ] PASS / [ ] FAIL |
| **CLS** (Cumulative Layout Shift) | < 0.1 | [ ] PASS / [ ] FAIL |
| **TBT** (Total Blocking Time) | < 200ms | [ ] PASS / [ ] FAIL |

### Extract from JSON Report

```bash
# Overall score
cat var/tmp/performance/perf-*.json | jq '.categories.performance.score * 100'

# Core Web Vitals
cat var/tmp/performance/perf-*.json | jq '.audits | {
  LCP: .["largest-contentful-paint"].numericValue,
  FID: .["max-potential-fid"].numericValue,
  CLS: .["cumulative-layout-shift"].numericValue,
  TBT: .["total-blocking-time"].numericValue
}'
```

---

## 2. HTTP Cache Headers

**Tool:** curl -I

### HTML Pages

```bash
curl -I http://localhost:8000/apps/{slug}
```

| Header | Expected Value | Status |
|--------|---------------|--------|
| Cache-Control | no-cache, must-revalidate | [ ] Present |
| Vary | Accept-Encoding, Accept-Language | [ ] Present |
| Content-Type | text/html; charset=UTF-8 | [ ] Present |

### Static Assets (CSS/JS)

```bash
curl -I http://localhost:8000/assets/css/main.css
curl -I http://localhost:8000/assets/js/main.js
```

| Header | Expected Value | Status |
|--------|---------------|--------|
| Cache-Control | public, max-age=31536000 | [ ] Present |
| Content-Type | text/css or application/javascript | [ ] Present |

### Images

```bash
curl -I http://localhost:8000/assets/images/{image}
```

| Header | Expected Value | Status |
|--------|---------------|--------|
| Cache-Control | public, max-age=31536000 | [ ] Present |

---

## 3. Compression

**Tool:** curl with Accept-Encoding

```bash
curl -H "Accept-Encoding: gzip" -I http://localhost:8000/apps/{slug}
```

| Check | Expected | Status |
|-------|----------|--------|
| Content-Encoding: gzip | Present | [ ] PASS / [ ] FAIL |

### Verify for Multiple Content Types

```bash
# HTML
curl -H "Accept-Encoding: gzip" -I http://localhost:8000/

# CSS
curl -H "Accept-Encoding: gzip" -I http://localhost:8000/assets/css/main.css

# JavaScript
curl -H "Accept-Encoding: gzip" -I http://localhost:8000/assets/js/main.js

# JSON
curl -H "Accept-Encoding: gzip" -I http://localhost:8000/assets/i18n/en.json
```

---

## 4. Asset Optimization

### Cache Busting

- [ ] VERSION file exists at project root
- [ ] `asset()` helper used for CSS/JS links
- [ ] Query string `?v=X.X.X` appears in HTML source

```bash
# Check VERSION file
cat VERSION

# Check HTML source for cache busting
curl -s http://localhost:8000/ | grep -o 'assets/[^"]*?v=[^"]*' | head -5
```

### Image Optimization

- [ ] Images use WebP format where possible
- [ ] Images have width/height attributes (prevents CLS)
- [ ] Large images use `loading="lazy"`

```bash
# Check for lazy loading
curl -s http://localhost:8000/apps/{slug} | grep -o 'loading="lazy"'

# Check for width/height on images
curl -s http://localhost:8000/apps/{slug} | grep -oP '<img[^>]+>' | head -3
```

### JavaScript Loading

- [ ] Non-critical scripts use `defer` attribute
- [ ] No render-blocking JavaScript

```bash
# Check for defer attribute
curl -s http://localhost:8000/apps/{slug} | grep -o '<script[^>]*defer[^>]*>'
```

---

## 5. Server Response

### Time to First Byte (TTFB)

```bash
# Measure TTFB
curl -o /dev/null -s -w "TTFB: %{time_starttransfer}s\n" http://localhost:8000/apps/{slug}
```

| Metric | Good | Status |
|--------|------|--------|
| TTFB | < 600ms | [ ] PASS / [ ] FAIL |

---

## Audit Summary Template

```markdown
## Performance Audit: {App Name}

**Date:** {YYYY-MM-DD}
**Auditor:** Performance Expert

### Lighthouse Results
- **Score:** {X}/100 {PASS/FAIL}
- **LCP:** {X}s {PASS/FAIL}
- **FID:** {X}ms {PASS/FAIL}
- **CLS:** {X} {PASS/FAIL}
- **TBT:** {X}ms {PASS/FAIL}

### Cache Headers
- [x] HTML: Cache-Control present
- [x] CSS/JS: max-age=31536000
- [x] Images: max-age=31536000
- [x] Vary header present

### Compression
- [x] GZIP enabled for all content types

### Asset Optimization
- [x] Cache busting working
- [x] Images optimized
- [x] Scripts deferred

### Issues Found
1. {Issue and fix}

### Overall Result: PASS/FAIL
```

---

## Common Issues Quick Reference

| Issue | Lighthouse Audit | Fix |
|-------|-----------------|-----|
| Slow LCP | largest-contentful-paint | Optimize hero image, use WebP |
| High CLS | cumulative-layout-shift | Add width/height to images |
| High TBT | total-blocking-time | Defer non-critical JS |
| No compression | uses-text-compression | Enable mod_deflate |
| No caching | uses-long-cache-ttl | Add Cache-Control headers |
| Large images | uses-optimized-images | Compress/resize images |
