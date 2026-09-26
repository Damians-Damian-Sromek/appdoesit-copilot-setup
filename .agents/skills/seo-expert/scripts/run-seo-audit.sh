#!/bin/bash
# SEO Audit Script - Extracts SEO-relevant data from pages using Playwright
# Usage:
#   ./run-seo-audit.sh --app calculator
#   ./run-seo-audit.sh --url http://localhost:8000/apps/calculator
#   ./run-seo-audit.sh --all

set -e

# Colors for output
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
# Per-clone web port (multi-clone support): default to this clone's host port.
# shellcheck source=instance-env.sh
source "$PROJECT_ROOT/scripts/instance-env.sh"

# Default values
BASE_URL="${BASE_URL:-http://localhost:${WEB_PORT}}"
OUTPUT_DIR="var/tmp/seo"

# Default to the host network + this clone's web port (multi-clone safe).
# Passing --network <name> targets a specific Docker network instead; in that
# case the 'web' service alias is used (Docker resolves it on that network).
# No auto-detection: auto-detecting "any appdoesit network" could pick another
# clone's network when several run at once.
NETWORK_NAME="${NETWORK_NAME:-host}"

if [[ "$NETWORK_NAME" == "host" ]]; then
    INTERNAL_URL="${INTERNAL_URL:-$BASE_URL}"
else
    INTERNAL_URL="${INTERNAL_URL:-http://web}"
fi

# Parse arguments
APP_SLUG=""
URL=""
ALL_APPS=false
LOCALE=""

while [[ $# -gt 0 ]]; do
    case $1 in
        --app)
            APP_SLUG="$2"
            shift 2
            ;;
        --url)
            URL="$2"
            shift 2
            ;;
        --all)
            ALL_APPS=true
            shift
            ;;
        --locale)
            LOCALE="$2"
            shift 2
            ;;
        --base-url)
            BASE_URL="$2"
            shift 2
            ;;
        --output)
            OUTPUT_DIR="$2"
            shift 2
            ;;
        --network)
            NETWORK_NAME="$2"
            shift 2
            ;;
        --help)
            echo "SEO Audit Script"
            echo ""
            echo "Usage:"
            echo "  $0 --app <app-slug>     Audit a specific app"
            echo "  $0 --url <url>          Audit a specific URL"
            echo "  $0 --all                Audit all apps"
            echo ""
            echo "Options:"
            echo "  --locale <locale>       Specify locale (default: en)"
            echo "  --base-url <url>        Base URL (default: this clone's web port)"
            echo "  --network <name>        Docker network name (default: host)"
            echo "  --output <dir>          Output directory (default: seo-reports)"
            echo "  --help                  Show this help"
            exit 0
            ;;
        *)
            echo -e "${RED}Unknown option: $1${NC}"
            exit 1
            ;;
    esac
done

# Create output directory
mkdir -p "$OUTPUT_DIR"

echo -e "${BLUE}Using Docker network: ${NETWORK_NAME}${NC}"

# Determine URL to audit (internal Docker URL for Playwright)
if [[ -n "$APP_SLUG" ]]; then
    if [[ -n "$LOCALE" && "$LOCALE" != "en" ]]; then
        AUDIT_URL="$INTERNAL_URL/$LOCALE/apps/$APP_SLUG"
        DISPLAY_URL="$BASE_URL/$LOCALE/apps/$APP_SLUG"
    else
        AUDIT_URL="$INTERNAL_URL/apps/$APP_SLUG"
        DISPLAY_URL="$BASE_URL/apps/$APP_SLUG"
    fi
    OUTPUT_FILE="$OUTPUT_DIR/${APP_SLUG}-seo-audit.json"
elif [[ -n "$URL" ]]; then
    # For custom URLs, use as-is but try to convert localhost to internal
    AUDIT_URL=$(echo "$URL" | sed -E "s|http://localhost:[0-9]+|$INTERNAL_URL|")
    DISPLAY_URL="$URL"
    FILENAME=$(echo "$URL" | sed 's|.*/||' | sed 's|[^a-zA-Z0-9]|-|g')
    OUTPUT_FILE="$OUTPUT_DIR/${FILENAME}-seo-audit.json"
elif [[ "$ALL_APPS" == true ]]; then
    echo -e "${BLUE}Discovering all apps...${NC}"
    # Will be handled below
else
    echo -e "${RED}Error: Please specify --app, --url, or --all${NC}"
    exit 1
fi

# Playwright script for SEO extraction
PLAYWRIGHT_SCRIPT=$(cat << 'ENDSCRIPT'
const { chromium } = require('playwright');

async function extractSEOData(url) {
    const browser = await chromium.launch({ headless: true });
    const context = await browser.newContext({
        userAgent: 'Mozilla/5.0 (compatible; SEOAuditBot/1.0; +https://appdoesit.com)'
    });
    const page = await context.newPage();

    const result = {
        url: url,
        timestamp: new Date().toISOString(),
        responseCode: null,
        responseHeaders: {},
        metaTags: {},
        openGraph: {},
        twitterCard: {},
        canonical: null,
        hreflang: [],
        headings: {
            h1: [],
            h2: [],
            h3: [],
            h4: [],
            h5: [],
            h6: []
        },
        jsonLd: [],
        images: [],
        internalLinks: [],
        externalLinks: [],
        contentStats: {
            wordCount: 0,
            hasUseCases: false,
            hasHelpModal: false
        },
        issues: {
            critical: [],
            warning: [],
            recommendation: []
        }
    };

    try {
        // Capture response
        const response = await page.goto(url, { waitUntil: 'networkidle', timeout: 30000 });
        result.responseCode = response.status();

        // Get response headers
        const headers = response.headers();
        result.responseHeaders = {
            'content-type': headers['content-type'] || null,
            'cache-control': headers['cache-control'] || null,
            'x-robots-tag': headers['x-robots-tag'] || null
        };

        // Wait for page to be fully loaded
        await page.waitForLoadState('domcontentloaded');

        // Extract meta tags
        result.metaTags = await page.evaluate(() => {
            const metas = {};
            document.querySelectorAll('meta').forEach(meta => {
                const name = meta.getAttribute('name') || meta.getAttribute('property') || meta.getAttribute('http-equiv');
                const content = meta.getAttribute('content');
                if (name && content) {
                    metas[name] = content;
                }
            });
            return metas;
        });

        // Extract title
        result.metaTags.title = await page.title();

        // Extract Open Graph
        result.openGraph = await page.evaluate(() => {
            const og = {};
            document.querySelectorAll('meta[property^="og:"]').forEach(meta => {
                const prop = meta.getAttribute('property').replace('og:', '');
                og[prop] = meta.getAttribute('content');
            });
            return og;
        });

        // Extract Twitter Card
        result.twitterCard = await page.evaluate(() => {
            const twitter = {};
            document.querySelectorAll('meta[name^="twitter:"]').forEach(meta => {
                const name = meta.getAttribute('name').replace('twitter:', '');
                twitter[name] = meta.getAttribute('content');
            });
            return twitter;
        });

        // Extract canonical
        result.canonical = await page.evaluate(() => {
            const link = document.querySelector('link[rel="canonical"]');
            return link ? link.getAttribute('href') : null;
        });

        // Extract hreflang
        result.hreflang = await page.evaluate(() => {
            const links = [];
            document.querySelectorAll('link[rel="alternate"][hreflang]').forEach(link => {
                links.push({
                    hreflang: link.getAttribute('hreflang'),
                    href: link.getAttribute('href')
                });
            });
            return links;
        });

        // Extract headings
        result.headings = await page.evaluate(() => {
            const headings = { h1: [], h2: [], h3: [], h4: [], h5: [], h6: [] };
            for (let i = 1; i <= 6; i++) {
                document.querySelectorAll(`h${i}`).forEach(h => {
                    headings[`h${i}`].push(h.textContent.trim());
                });
            }
            return headings;
        });

        // Extract JSON-LD
        result.jsonLd = await page.evaluate(() => {
            const scripts = [];
            document.querySelectorAll('script[type="application/ld+json"]').forEach(script => {
                try {
                    scripts.push(JSON.parse(script.textContent));
                } catch (e) {
                    scripts.push({ error: 'Invalid JSON', raw: script.textContent });
                }
            });
            return scripts;
        });

        // Extract images
        result.images = await page.evaluate(() => {
            const images = [];
            document.querySelectorAll('img').forEach(img => {
                images.push({
                    src: img.getAttribute('src'),
                    alt: img.getAttribute('alt'),
                    hasAlt: img.hasAttribute('alt') && img.getAttribute('alt').trim() !== ''
                });
            });
            return images;
        });

        // Extract links
        const links = await page.evaluate(() => {
            const internal = [];
            const external = [];
            const currentHost = window.location.host;
            document.querySelectorAll('a[href]').forEach(a => {
                const href = a.getAttribute('href');
                const text = a.textContent.trim().substring(0, 50);
                // Check if it's a relative link or same-host link
                if (href.startsWith('/') && !href.startsWith('//')) {
                    internal.push({ href, text });
                } else if (href.startsWith('http')) {
                    try {
                        const linkUrl = new URL(href);
                        // Check if same host (including localhost variations)
                        if (linkUrl.host === currentHost ||
                            linkUrl.host === 'localhost:${WEB_PORT}' ||
                            linkUrl.host.includes('appdoesit')) {
                            internal.push({ href, text });
                        } else {
                            external.push({ href, text, opensInNewTab: a.getAttribute('target') === '_blank' });
                        }
                    } catch (e) {
                        // Invalid URL, skip
                    }
                }
            });
            return { internal, external };
        });

        result.internalLinks = links.internal;
        result.externalLinks = links.external;

        // Content stats
        result.contentStats = await page.evaluate(() => {
            const bodyText = document.body.innerText || '';
            const wordCount = bodyText.split(/\s+/).filter(w => w.length > 0).length;

            // Check for use cases section (multiple possible selectors)
            const hasUseCases = !!(
                document.querySelector('.use-cases-section') ||
                document.querySelector('[data-section="use-cases"]') ||
                document.querySelector('#use-cases') ||
                document.querySelector('.use-cases') ||
                document.querySelector('section.use-cases') ||
                document.querySelector('[class*="use-case"]') ||
                // Also check for heading containing "use case"
                Array.from(document.querySelectorAll('h2, h3')).some(h =>
                    h.textContent.toLowerCase().includes('use case') ||
                    h.textContent.toLowerCase().includes('when to use') ||
                    h.textContent.toLowerCase().includes('perfect for')
                )
            );

            // Check for help modal (multiple possible selectors)
            const hasHelpModal = !!(
                document.querySelector('#help-modal') ||
                document.querySelector('[data-help-modal]') ||
                document.querySelector('.help-modal') ||
                document.querySelector('#help-toggle') ||
                document.querySelector('[aria-label*="help"]') ||
                document.querySelector('[aria-label*="Help"]') ||
                document.querySelector('button[class*="help"]') ||
                document.querySelector('.help-button') ||
                document.querySelector('[data-help]')
            );

            return { wordCount, hasUseCases, hasHelpModal };
        });

        // Analyze issues
        // CRITICAL issues
        if (!result.metaTags.title) {
            result.issues.critical.push('Missing title tag');
        }
        if (!result.canonical) {
            result.issues.critical.push('Missing canonical URL');
        }
        if (result.headings.h1.length === 0) {
            result.issues.critical.push('Missing H1 tag');
        }
        if (result.headings.h1.length > 1) {
            result.issues.critical.push(`Multiple H1 tags (${result.headings.h1.length} found)`);
        }
        if (result.hreflang.length === 0) {
            result.issues.critical.push('Missing hreflang tags for multi-locale site');
        }
        if (!result.contentStats.hasUseCases) {
            result.issues.critical.push('Missing use cases section (AGENTS.md requirement)');
        }
        if (!result.contentStats.hasHelpModal) {
            result.issues.critical.push('Missing help modal (AGENTS.md requirement)');
        }
        const imagesWithoutAlt = result.images.filter(img => !img.hasAlt);
        if (imagesWithoutAlt.length > 0) {
            result.issues.critical.push(`${imagesWithoutAlt.length} image(s) missing alt text`);
        }
        if (!result.metaTags.viewport) {
            result.issues.critical.push('Missing viewport meta tag');
        }
        if (result.responseCode >= 400) {
            result.issues.critical.push(`HTTP error: ${result.responseCode}`);
        }

        // WARNING issues
        if (result.metaTags.title && result.metaTags.title.length > 60) {
            result.issues.warning.push(`Title too long (${result.metaTags.title.length} chars, max 60)`);
        }
        if (result.metaTags.title && result.metaTags.title.length < 30) {
            result.issues.warning.push(`Title too short (${result.metaTags.title.length} chars, min 30)`);
        }
        if (!result.metaTags.description) {
            result.issues.warning.push('Missing meta description');
        } else if (result.metaTags.description.length > 160) {
            result.issues.warning.push(`Meta description too long (${result.metaTags.description.length} chars, max 160)`);
        } else if (result.metaTags.description.length < 70) {
            result.issues.warning.push(`Meta description too short (${result.metaTags.description.length} chars, min 70)`);
        }
        if (Object.keys(result.openGraph).length === 0) {
            result.issues.warning.push('Missing Open Graph tags');
        }
        if (Object.keys(result.twitterCard).length === 0) {
            result.issues.warning.push('Missing Twitter Card tags');
        }
        if (result.jsonLd.length === 0) {
            result.issues.warning.push('Missing JSON-LD structured data');
        }
        if (result.contentStats.wordCount < 300) {
            result.issues.warning.push(`Thin content (${result.contentStats.wordCount} words, min 300 recommended)`);
        }
        if (result.internalLinks.length < 2) {
            result.issues.warning.push('Few internal links (add links to related apps)');
        }

        // RECOMMENDATIONS
        const expectedHreflangCount = 4; // en, es, pl, x-default
        if (result.hreflang.length > 0 && result.hreflang.length < expectedHreflangCount) {
            result.issues.recommendation.push(`Incomplete hreflang (${result.hreflang.length}/${expectedHreflangCount} expected: en, es, pl, x-default)`);
        }
        if (result.hreflang.length > 0 && !result.hreflang.find(h => h.hreflang === 'x-default')) {
            result.issues.recommendation.push('Missing x-default hreflang');
        }
        if (result.jsonLd.some(j => j.error)) {
            result.issues.critical.push('Invalid JSON-LD syntax');
        }

    } catch (error) {
        result.error = error.message;
        result.issues.critical.push(`Page load error: ${error.message}`);
    } finally {
        await browser.close();
    }

    return result;
}

// Get URL from command line
const url = process.argv[2];
if (!url) {
    console.error('Usage: node script.js <url>');
    process.exit(1);
}

extractSEOData(url)
    .then(result => {
        console.log(JSON.stringify(result, null, 2));
    })
    .catch(error => {
        console.error('Error:', error);
        process.exit(1);
    });
ENDSCRIPT
)

# Function to run SEO audit
run_audit() {
    local target_url="$1"
    local output_file="$2"
    local display_url="${3:-$target_url}"

    echo -e "${BLUE}Auditing: ${display_url}${NC}"
    echo -e "${BLUE}(Internal URL: ${target_url})${NC}"

    # Create temporary script file in var/tmp (git-ignored directory)
    mkdir -p "$(pwd)/var/tmp"
    TEMP_SCRIPT="$(pwd)/var/tmp/.seo-audit-temp.js"
    echo "$PLAYWRIGHT_SCRIPT" > "$TEMP_SCRIPT"

    # Run with Docker Playwright (uses existing node_modules/playwright)
    if [[ "$NETWORK_NAME" == "host" ]]; then
        docker run --rm \
            --network host \
            -v "$(pwd)":/app \
            -w /app \
            mcr.microsoft.com/playwright:v1.57.0-jammy \
            node var/tmp/.seo-audit-temp.js "$target_url" > "$output_file" 2>&1
    else
        docker run --rm \
            --network "$NETWORK_NAME" \
            -v "$(pwd)":/app \
            -w /app \
            mcr.microsoft.com/playwright:v1.57.0-jammy \
            node var/tmp/.seo-audit-temp.js "$target_url" > "$output_file" 2>&1
    fi

    local exit_code=$?

    # Clean up temp script
    rm -f "$TEMP_SCRIPT" 2>/dev/null

    # Check if output is valid JSON using Python (more reliable than jq)
    if ! python3 -c "import json, sys; json.load(open('$output_file'))" 2>/dev/null; then
        echo -e "${RED}Error running audit. Output:${NC}"
        cat "$output_file"
        return 1
    fi

    # Parse and display summary using Python (jq may not be installed)
    if [[ -f "$output_file" ]]; then
        local critical=$(python3 -c "import json; d=json.load(open('$output_file')); print(len(d.get('issues',{}).get('critical',[])))" 2>/dev/null || echo "0")
        local warning=$(python3 -c "import json; d=json.load(open('$output_file')); print(len(d.get('issues',{}).get('warning',[])))" 2>/dev/null || echo "0")
        local recommendation=$(python3 -c "import json; d=json.load(open('$output_file')); print(len(d.get('issues',{}).get('recommendation',[])))" 2>/dev/null || echo "0")

        echo -e "Results saved to: ${GREEN}$output_file${NC}"
        echo -e "  ${RED}CRITICAL: $critical${NC}"
        echo -e "  ${YELLOW}WARNING: $warning${NC}"
        echo -e "  ${BLUE}RECOMMENDATION: $recommendation${NC}"
        echo ""

        # Show critical issues
        if [[ "$critical" -gt 0 ]]; then
            echo -e "${RED}Critical Issues:${NC}"
            python3 -c "import json; [print('  \033[0;31m✗\033[0m', i) for i in json.load(open('$output_file')).get('issues',{}).get('critical',[])]" 2>/dev/null
            echo ""
        fi

        # Show warning issues
        if [[ "$warning" -gt 0 ]]; then
            echo -e "${YELLOW}Warnings:${NC}"
            python3 -c "import json; [print('  \033[1;33m⚠\033[0m', i) for i in json.load(open('$output_file')).get('issues',{}).get('warning',[])]" 2>/dev/null
            echo ""
        fi
    else
        echo -e "${RED}Error: Failed to generate audit report${NC}"
        return 1
    fi
}

# Run audits
if [[ "$ALL_APPS" == true ]]; then
    # Discover all apps from localhost
    echo -e "${BLUE}Discovering apps from homepage...${NC}"

    APPS=$(curl -s "$BASE_URL" 2>/dev/null | grep -oP 'data-app-slug="\K[^"]+' | sort -u)

    if [[ -z "$APPS" ]]; then
        echo -e "${RED}Error: Could not discover any apps from $BASE_URL${NC}"
        exit 1
    fi

    echo -e "${GREEN}Found apps:${NC} $APPS"
    echo ""

    for app in $APPS; do
        audit_url="$INTERNAL_URL/apps/$app"
        display_url="$BASE_URL/apps/$app"
        output="$OUTPUT_DIR/${app}-seo-audit.json"
        run_audit "$audit_url" "$output" "$display_url"
    done

    # Generate summary
    echo -e "\n${GREEN}=== SEO Audit Summary ===${NC}"
    echo -e "Reports saved to: $OUTPUT_DIR/"

    total_critical=0
    total_warning=0

    for file in "$OUTPUT_DIR"/*-seo-audit.json; do
        if [[ -f "$file" ]]; then
            c=$(python3 -c "import json; d=json.load(open('$file')); print(len(d.get('issues',{}).get('critical',[])))" 2>/dev/null || echo "0")
            w=$(python3 -c "import json; d=json.load(open('$file')); print(len(d.get('issues',{}).get('warning',[])))" 2>/dev/null || echo "0")
            total_critical=$((total_critical + c))
            total_warning=$((total_warning + w))
        fi
    done

    echo -e "Total ${RED}CRITICAL${NC} issues: $total_critical"
    echo -e "Total ${YELLOW}WARNING${NC} issues: $total_warning"

else
    # Single URL audit
    run_audit "$AUDIT_URL" "$OUTPUT_FILE" "$DISPLAY_URL"
fi

echo -e "\n${GREEN}SEO audit complete!${NC}"
