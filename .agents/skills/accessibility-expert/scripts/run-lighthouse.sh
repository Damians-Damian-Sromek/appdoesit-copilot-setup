#!/bin/bash
# Run Lighthouse accessibility audit for AppDoesIt apps
# Uses femtopixel/google-lighthouse Docker image
#
# Usage:
#   ./run-lighthouse.sh <url>                    # Audit single URL
#   ./run-lighthouse.sh <url> <output-dir>       # Custom output directory
#   ./run-lighthouse.sh --app <slug>             # Audit app by slug (uses Docker network)
#   ./run-lighthouse.sh --app <slug> <output>    # App with custom output
#
# Examples:
#   ./run-lighthouse.sh http://localhost:8000/apps/calculator
#   ./run-lighthouse.sh --app calculator
#   ./run-lighthouse.sh --app calculator ./reports
#   ./run-lighthouse.sh http://localhost:8000/apps/calculator ./reports

set -e

# Script directory (for relative paths)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
# Per-clone web port (multi-clone support): audit this clone's instance on its
# own host port instead of a shared/fixed Docker network.
# shellcheck source=instance-env.sh
source "$PROJECT_ROOT/scripts/instance-env.sh"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default values
OUTPUT_DIR="./var/tmp/accessibility"
NETWORK="host"
URL=""
APP_SLUG=""

# Parse arguments
if [[ "$1" == "--app" ]]; then
    if [[ -z "$2" ]]; then
        echo -e "${RED}Error: --app requires an app slug${NC}"
        echo "Usage: ./run-lighthouse.sh --app <slug>"
        exit 1
    fi
    APP_SLUG="$2"
    URL="http://localhost:${WEB_PORT}/apps/$APP_SLUG"
    NETWORK="host"
    if [[ -n "$3" ]]; then
        OUTPUT_DIR="$3"
    fi
elif [[ "$1" == "--help" || "$1" == "-h" ]]; then
    echo "Lighthouse Accessibility Audit Script"
    echo ""
    echo "Usage:"
    echo "  ./run-lighthouse.sh <url> [output-dir]"
    echo "  ./run-lighthouse.sh --app <slug> [output-dir]"
    echo ""
    echo "Options:"
    echo "  --app <slug>    Audit app by slug (uses this clone's web port)"
    echo "  --help, -h      Show this help message"
    echo ""
    echo "Examples:"
    echo "  ./run-lighthouse.sh http://localhost:8000/apps/calculator"
    echo "  ./run-lighthouse.sh --app calculator"
    echo "  ./run-lighthouse.sh --app calculator ./my-reports"
    exit 0
elif [[ -n "$1" ]]; then
    URL="$1"
    if [[ -n "$2" ]]; then
        OUTPUT_DIR="$2"
    fi
else
    echo -e "${RED}Error: URL or --app required${NC}"
    echo "Usage: ./run-lighthouse.sh <url> or ./run-lighthouse.sh --app <slug>"
    exit 1
fi

# Generate timestamp for unique filenames
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

# Create output directory
mkdir -p "$OUTPUT_DIR"

# Determine report name
if [[ -n "$APP_SLUG" ]]; then
    REPORT_NAME="a11y-${APP_SLUG}-${TIMESTAMP}"
else
    # Extract app name from URL if possible
    APP_FROM_URL=$(echo "$URL" | grep -oP '/apps/\K[^/]+' || echo "page")
    REPORT_NAME="a11y-${APP_FROM_URL}-${TIMESTAMP}"
fi

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}Lighthouse Accessibility Audit${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""
echo -e "${YELLOW}URL:${NC} $URL"
echo -e "${YELLOW}Network:${NC} $NETWORK"
echo -e "${YELLOW}Output:${NC} $OUTPUT_DIR"
echo ""

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo -e "${RED}Error: Docker is not running${NC}"
    exit 1
fi

# Check if network exists (for app mode)
if [[ "$NETWORK" == "appdoesit_default" ]]; then
    if ! docker network ls | grep -q "$NETWORK"; then
        echo -e "${YELLOW}Warning: Network '$NETWORK' not found.${NC}"
        echo -e "${YELLOW}Make sure the app is running with: .\\docker.ps1 up${NC}"
        echo ""
        echo -e "Trying to detect correct network..."

        # Try to find the correct network
        DETECTED_NETWORK=$(docker network ls --format '{{.Name}}' | grep -i appdoesit | head -1)
        if [[ -n "$DETECTED_NETWORK" ]]; then
            echo -e "${GREEN}Found network: $DETECTED_NETWORK${NC}"
            NETWORK="$DETECTED_NETWORK"
        else
            echo -e "${RED}No AppDoesIt network found. Exiting.${NC}"
            exit 1
        fi
    fi
fi

echo -e "${GREEN}Running Lighthouse audit...${NC}"
echo ""

# Run Lighthouse in Docker
docker run --rm \
    --network "$NETWORK" \
    -v "$(pwd)/$OUTPUT_DIR":/reports \
    femtopixel/google-lighthouse \
    "$URL" \
    --only-categories=accessibility \
    --output=json --output=html \
    --output-path="/reports/${REPORT_NAME}" \
    --chrome-flags="--headless --no-sandbox --disable-dev-shm-usage --disable-gpu"

# Check if reports were generated
JSON_REPORT="$OUTPUT_DIR/${REPORT_NAME}.report.json"
HTML_REPORT="$OUTPUT_DIR/${REPORT_NAME}.report.html"

if [[ -f "$JSON_REPORT" ]]; then
    # Extract and display score (use structured parsing; report JSON contains nested objects).
    SCORE=""
    SCORE_INT=""

    if command -v jq >/dev/null 2>&1; then
        SCORE=$(jq -r '.categories.accessibility.score // empty' "$JSON_REPORT" 2>/dev/null || echo "")
    fi

    if [[ -z "$SCORE" ]] && command -v python3 >/dev/null 2>&1; then
        SCORE=$(python3 - <<PY 2>/dev/null || echo ""
import json
import sys
try:
    d=json.load(open("$JSON_REPORT"))
    v=(d.get('categories',{}).get('accessibility',{}) or {}).get('score', None)
    if v is None:
        sys.exit(1)
    print(v)
except Exception:
    sys.exit(1)
PY
)
    fi

    if [[ -z "$SCORE" ]]; then
        echo -e "${RED}Error: Could not parse accessibility score from report${NC}"
        echo -e "${YELLOW}Tip:${NC} Install 'jq' or ensure python3 is available."
        exit 1
    fi

    # Lighthouse scores are 0..1 floats; round to nearest int so 0.999 -> 100.
    if command -v python3 >/dev/null 2>&1; then
        SCORE_INT=$(python3 -c "import math; s=float('${SCORE}'); print(int(math.floor(s*100+0.5)))" 2>/dev/null || echo "")
    else
        SCORE_INT=$(awk -v s="$SCORE" 'BEGIN { printf("%d", int(s*100+0.5)) }' 2>/dev/null || echo "")
    fi

    if [[ -z "$SCORE_INT" ]]; then
        echo -e "${RED}Error: Could not convert accessibility score to integer${NC}"
        exit 1
    fi

    echo ""
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}Audit Complete!${NC}"
    echo -e "${BLUE}========================================${NC}"
    echo ""

    # Score must be 100 to pass
    if [[ "$SCORE_INT" -eq 100 ]]; then
        echo -e "Accessibility Score: ${GREEN}${SCORE_INT}/100${NC} - PASS"
        echo -e "${GREEN}All accessibility criteria met.${NC}"
    else
        echo -e "Accessibility Score: ${RED}${SCORE_INT}/100${NC} - FAIL"
        echo -e "${RED}Required score: 100/100. Must fix all violations.${NC}"
        echo ""
        echo -e "${YELLOW}========================================${NC}"
        echo -e "${YELLOW}VIOLATIONS FOUND - Must be fixed:${NC}"
        echo -e "${YELLOW}========================================${NC}"
        echo ""

        # Extract and display violations using jq if available
        if command -v jq &> /dev/null; then
            jq -r '
                .audits | to_entries[] |
                select(.value.score != null and .value.score < 1) |
                "  \u274C \(.key)\n     Issue: \(.value.title)\n     Elements: \([.value.details.items[]?.node.selector // .value.details.items[]?.node.snippet // \"N/A\"][0:3] | join(\", \\))\n"
            ' "$JSON_REPORT" 2>/dev/null || echo "  (Install jq for detailed violation output)"
        else
            echo -e "  ${YELLOW}Install 'jq' to see detailed violations, or check the HTML report.${NC}"
        fi

        echo ""
        echo -e "${RED}ACTION REQUIRED: Fix all violations and re-run audit.${NC}"
    fi

    echo ""
    echo -e "${GREEN}Reports generated:${NC}"
    echo -e "  JSON: $JSON_REPORT"
    echo -e "  HTML: $HTML_REPORT"
    echo ""

    if [[ "$SCORE_INT" -ne 100 ]]; then
        echo -e "${YELLOW}To see all violations with details:${NC}"
        echo -e "  cat $JSON_REPORT | jq '.audits | to_entries[] | select(.value.score != null and .value.score < 1) | {id: .key, title: .value.title, elements: [.value.details.items[]?.node.selector]}'"
        echo ""
    fi

    echo -e "${YELLOW}Tip:${NC} Open the HTML report in a browser for detailed analysis"

    # Exit with error if score is not 100
    if [[ "$SCORE_INT" -ne 100 ]]; then
        exit 1
    fi
else
    echo -e "${RED}Error: Reports not generated${NC}"
    exit 1
fi
