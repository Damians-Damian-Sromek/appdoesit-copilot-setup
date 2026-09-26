# SEO Audit Report Template

## Template

```markdown
## SEO Audit Report: [App/Page Name]

**Audit Date**: [Date]
**URL Audited**: [URL]
**Overall SEO Score**: [X/100]

### Audit Completion Checklist

| Check | Completed | Evidence |
|-------|-----------|----------|
| Automated audit executed | YES/NO | var/tmp/seo/{app}-seo-audit.json |
| Technical SEO reviewed | YES/NO | See Technical SEO section |
| On-page SEO reviewed | YES/NO | See On-Page SEO section |
| Structured data validated | YES/NO | Rich Results Test: [PASS/FAIL] |
| Performance checked | YES/NO | PageSpeed score: [X] |
| i18n verified | YES/NO | [X]/3 locales pass |

---

### CRITICAL Issues (Must Fix Immediately)

| Issue | Element | Impact | How to Fix |
|-------|---------|--------|------------|
| [Issue description] | [selector/element] | [Impact on SEO] | [Fix instructions] |

**Example:**
| Missing canonical URL | `<head>` | Duplicate content risk | Add `<link rel="canonical" href="...">` |

---

### WARNING Issues (Should Fix Soon)

| Issue | Element | Impact | How to Fix |
|-------|---------|--------|------------|
| [Issue description] | [selector/element] | [Impact on SEO] | [Fix instructions] |

**Example:**
| Title too long (72 chars) | `<title>` | Truncated in SERPs | Shorten to 50-60 characters |

---

### RECOMMENDATIONS (Optimization Opportunities)

| Recommendation | Current State | Suggested Improvement | Expected Impact |
|----------------|---------------|----------------------|-----------------|
| [Recommendation] | [Current] | [Suggested] | [Impact] |

**Example:**
| Improve meta description | Generic description | Add call-to-action, USP | Higher CTR |

---

### Passing Checks

| Category | Checks Passed |
|----------|---------------|
| Technical SEO | 15/18 |
| On-Page SEO | 12/15 |
| Content Quality | 9/10 |
| Structured Data | 7/8 |
| i18n SEO | 3/3 |
| Performance | 4/5 |

---

### Detailed Findings

#### Technical SEO
[Detailed technical findings...]

#### On-Page SEO
[Detailed on-page findings...]

#### Structured Data
[JSON-LD validation results...]

#### Performance
[PageSpeed Insights results...]

#### i18n Implementation
[Locale-by-locale results...]

---

### Priority Action Items

1. **[CRITICAL]** Fix [issue] - [brief instruction]
2. **[CRITICAL]** Fix [issue] - [brief instruction]
3. **[WARNING]** Improve [issue] - [brief instruction]
4. **[RECOMMENDATION]** Consider [improvement]

---

### Re-Audit Instructions

After fixes are applied:
```bash
./.agents/skills/seo-expert/scripts/run-seo-audit.sh --app [app-slug]
```

**Target: Zero CRITICAL issues, minimal WARNINGs**
```
