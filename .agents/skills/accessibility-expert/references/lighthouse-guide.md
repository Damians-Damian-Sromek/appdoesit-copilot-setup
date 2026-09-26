# Lighthouse Accessibility Audit Guide

Reference for running Google Lighthouse accessibility audits in the AppDoesIt project.

---

## Quick Start

### Comprehensive Testing with Active State (Recommended)

Use the comprehensive test script that tests apps in their **active state** (with user interaction and results visible):

```bash
# Test single app with Playwright + Lighthouse (active state)
./.agents/skills/accessibility-expert/scripts/run-a11y-test.sh --app calculator

# Test with screenshots for visual verification
./.agents/skills/accessibility-expert/scripts/run-a11y-test.sh --app calculator --screenshots

# Test all apps
./.agents/skills/accessibility-expert/scripts/run-a11y-test.sh --all

# Test using Docker network (when app runs in Docker)
./.agents/skills/accessibility-expert/scripts/run-a11y-test.sh --app calculator --docker
```

### Lighthouse-Only Script

For quick Lighthouse-only audits (tests initial page load only):

```bash
# Audit an app by slug (recommended - uses Docker network)
./.agents/skills/accessibility-expert/scripts/run-lighthouse.sh --app calculator

# Audit a specific URL
./.agents/skills/accessibility-expert/scripts/run-lighthouse.sh http://localhost:8000/apps/calculator

# Custom output directory
./.agents/skills/accessibility-expert/scripts/run-lighthouse.sh http://localhost:8000 ./my-reports
```

---

## Active State Testing

**IMPORTANT:** For thorough accessibility testing, apps should be tested in their **active state** - after user interaction with results visible.

### Why Active State Matters

Lighthouse tests the page as it loads, but many accessibility issues only appear when:
- The user has entered data (forms, calculators)
- Results or output are displayed
- Error messages are shown
- Dynamic content has loaded

### What Active State Testing Does

1. **Waits for full page render** (`networkidle`, `domcontentloaded`)
2. **Interacts with the app** (fills inputs, clicks buttons)
3. **Shows results/output** (calculation results, converted values)
4. **Then runs accessibility tests** on the complete UI

### App-Specific Interactions

Each app type has specific interactions to reach active state:

| App | Interaction | Active State |
|-----|-------------|--------------|
| Calculator | Click 7 + 3 = | Display shows "10" |
| Word Counter | Fill textarea | Statistics visible |
| Password Generator | Click Generate | Password displayed |
| JSON Formatter | Paste JSON, click Format | Formatted output visible |
| Unit Converter | Enter value | Conversion result shown |
| BMI Calculator | Enter height/weight | BMI result displayed |
| Age Calculator | Enter birth date | Age calculation shown |
| Time Zone Converter | Select zones | Converted time visible |

### Manual Docker Command

```bash
# For apps running in Docker (uses internal network)
docker run --rm \
  --network appdoesit_default \
  -v "$(pwd)/var/tmp/accessibility":/reports \
  femtopixel/google-lighthouse \
  http://web/apps/calculator \
  --only-categories=accessibility \
  --output=json --output=html \
  --output-path=/reports/a11y-report \
  --chrome-flags="--headless --no-sandbox --disable-dev-shm-usage"

# For localhost testing (uses host network)
docker run --rm \
  --network host \
  -v "$(pwd)/var/tmp/accessibility":/reports \
  femtopixel/google-lighthouse \
  http://localhost:8000/apps/calculator \
  --only-categories=accessibility \
  --output=json --output=html \
  --output-path=/reports/a11y-report \
  --chrome-flags="--headless --no-sandbox --disable-dev-shm-usage"
```

---

## Command Options

### Categories

```bash
--only-categories=accessibility          # Accessibility only (fastest)
--only-categories=accessibility,seo      # Multiple categories
```

Available categories:
- `accessibility` - WCAG compliance
- `performance` - Page speed
- `seo` - Search engine optimization
- `best-practices` - Web best practices
- `pwa` - Progressive Web App

### Output Formats

```bash
--output=json                    # Machine-readable JSON
--output=html                    # Human-readable HTML report
--output=json --output=html      # Both formats
--output-path=/reports/report    # Output location (without extension)
```

### Chrome Flags

```bash
--chrome-flags="--headless"                    # Run headless (no UI)
--chrome-flags="--no-sandbox"                  # Required for Docker
--chrome-flags="--disable-dev-shm-usage"       # Prevent memory issues
--chrome-flags="--window-size=1280,720"        # Set viewport
```

### Form Factor

```bash
--preset=desktop                 # Desktop viewport and throttling
--preset=mobile                  # Mobile viewport (default)
--form-factor=desktop            # Just change form factor
```

---

## Reading Results

### JSON Report Structure

```json
{
  "categories": {
    "accessibility": {
      "score": 0.92,           // 0-1 scale (92/100)
      "auditRefs": [...]       // List of audits run
    }
  },
  "audits": {
    "color-contrast": {
      "id": "color-contrast",
      "title": "Background and foreground colors have sufficient contrast ratio",
      "score": 0,              // 0 = fail, 1 = pass, null = N/A
      "scoreDisplayMode": "binary",
      "details": {
        "items": [
          {
            "node": {
              "selector": "button.primary",
              "snippet": "<button class=\"primary\">Submit</button>"
            },
            "contrastRatio": 3.2,
            "requiredRatio": 4.5
          }
        ]
      }
    }
  }
}
```

### Extracting Key Data with jq

```bash
# Get overall score (0-100)
cat report.json | jq '.categories.accessibility.score * 100'

# Get all failing audits
cat report.json | jq '.audits | to_entries[] | select(.value.score == 0) | .key'

# Get details for specific audit
cat report.json | jq '.audits["color-contrast"]'

# Get all elements with contrast issues
cat report.json | jq '.audits["color-contrast"].details.items[].node.selector'

# Count issues by audit
cat report.json | jq '.audits | to_entries[] | select(.value.score == 0) | {audit: .key, count: (.value.details.items | length)}'
```

---

## Accessibility Audits

Lighthouse runs these accessibility checks:

### Critical (High Impact)

| Audit ID | What it Checks |
|----------|----------------|
| `color-contrast` | Text contrast ratio |
| `image-alt` | Images have alt text |
| `label` | Form inputs have labels |
| `button-name` | Buttons have accessible names |
| `link-name` | Links have accessible names |
| `document-title` | Page has title |
| `html-has-lang` | HTML has lang attribute |
| `bypass` | Skip link or landmarks exist |

### Moderate Impact

| Audit ID | What it Checks |
|----------|----------------|
| `aria-required-attr` | ARIA attributes complete |
| `aria-valid-attr` | ARIA attributes valid |
| `aria-roles` | ARIA roles valid |
| `heading-order` | Headings in sequence |
| `list` | Lists properly structured |
| `tabindex` | No tabindex > 0 |

### Lower Impact

| Audit ID | What it Checks |
|----------|----------------|
| `duplicate-id` | No duplicate IDs |
| `frame-title` | Iframes have titles |
| `meta-viewport` | Viewport allows zoom |
| `valid-lang` | Lang attribute valid |

---

## Score Interpretation

| Score | Rating | Action |
|-------|--------|--------|
| 90-100 | Excellent | Minor tweaks only |
| 70-89 | Good | Address moderate issues |
| 50-69 | Needs Work | Significant issues present |
| 0-49 | Poor | Critical barriers exist |

**Scoring formula:**
- Each audit has a weight
- Failed audits reduce score proportionally
- Score = weighted average of passing audits

---

## Common Issues & Fixes

### Color Contrast (color-contrast)

**Problem:** Text doesn't meet 4.5:1 contrast ratio

**Fix:**
```css
/* Use theme variables */
.text {
    color: var(--text-primary);    /* Ensure sufficient contrast */
    background: var(--bg-primary);
}

/* For light theme */
:root {
    --text-primary: #1a1a1a;       /* Dark text */
    --bg-primary: #ffffff;         /* Light background */
}

/* For dark theme */
[data-theme="dark"] {
    --text-primary: #e5e5e5;       /* Light text */
    --bg-primary: #1a1a1a;         /* Dark background */
}
```

### Missing Labels (label)

**Problem:** Form inputs without labels

**Fix:**
```html
<!-- Option 1: Explicit label -->
<label for="email">Email address</label>
<input type="email" id="email" name="email">

<!-- Option 2: Wrapped label -->
<label>
    Email address
    <input type="email" name="email">
</label>

<!-- Option 3: ARIA label -->
<input type="email" aria-label="Email address" name="email">
```

### Button Names (button-name)

**Problem:** Icon-only buttons without names

**Fix:**
```html
<!-- Option 1: aria-label -->
<button aria-label="Close dialog">
    <svg><!-- X icon --></svg>
</button>

<!-- Option 2: Visually hidden text -->
<button>
    <svg aria-hidden="true"><!-- X icon --></svg>
    <span class="visually-hidden">Close dialog</span>
</button>
```

### Link Names (link-name)

**Problem:** Links with generic text

**Fix:**
```html
<!-- Bad -->
<a href="/docs">Click here</a>

<!-- Good -->
<a href="/docs">Read the documentation</a>

<!-- Good with context -->
<a href="/docs" aria-label="Read the full documentation">Learn more</a>
```

### Heading Order (heading-order)

**Problem:** Skipped heading levels

**Fix:**
```html
<!-- Bad: Skips h2 -->
<h1>Page Title</h1>
<h3>Subsection</h3>

<!-- Good: Sequential -->
<h1>Page Title</h1>
<h2>Section</h2>
<h3>Subsection</h3>
```

### Bypass Blocks (bypass)

**Problem:** No skip link

**Fix:**
```html
<body>
    <a href="#main-content" class="skip-link">Skip to main content</a>
    <nav><!-- Navigation --></nav>
    <main id="main-content">
        <!-- Main content -->
    </main>
</body>

<style>
.skip-link {
    position: absolute;
    top: -40px;
    left: 0;
    padding: 8px;
    background: #000;
    color: #fff;
    z-index: 100;
}
.skip-link:focus {
    top: 0;
}
</style>
```

---

## Docker Troubleshooting

### Network Issues

```bash
# Check if app container is running
docker ps | grep appdoesit

# Get network name
docker network ls | grep appdoesit

# Test connectivity from Lighthouse container
docker run --rm --network appdoesit_default alpine ping -c 1 web
```

### Memory Issues

```bash
# Increase shared memory
docker run --rm --shm-size=2g ...

# Disable GPU
--chrome-flags="--disable-gpu"
```

### Permission Issues

```bash
# Ensure output directory exists
mkdir -p var/tmp/accessibility

# Check permissions
ls -la var/tmp/accessibility/
```

---

## Batch Auditing

Audit multiple apps:

```bash
#!/bin/bash
APPS=("calculator" "json-formatter" "four-in-a-row")
OUTPUT_DIR="./var/tmp/accessibility"

for app in "${APPS[@]}"; do
    echo "Auditing: $app"
    ./.agents/skills/accessibility-expert/scripts/run-lighthouse.sh --app "$app" "$OUTPUT_DIR"
done

echo "All audits complete. Reports in: $OUTPUT_DIR"
```

---

## Viewing HTML Reports

Open the HTML report in a browser:

```bash
# On Windows (WSL)
explorer.exe var/tmp/accessibility/a11y-report.report.html

# On Linux
xdg-open var/tmp/accessibility/a11y-report.report.html

# Or use Python HTTP server
python -m http.server 8080 -d var/tmp/accessibility
# Then open http://localhost:8080/a11y-report.report.html
```
