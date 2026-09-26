#!/bin/bash
#
# Performance Audit Script using Google Lighthouse
# Usage: ./run-perf-audit.sh --app calculator [--url http://web]
#

set -e
set -o pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
# Per-clone web port (multi-clone support): default to this clone's host port.
# shellcheck source=instance-env.sh
source "$PROJECT_ROOT/scripts/instance-env.sh"

# Default values
APP=""
BASE_URL="http://localhost:${WEB_PORT}"
OUTPUT_DIR="var/tmp/performance"
NETWORK="host"

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --app)
            APP="$2"
            shift 2
            ;;
        --url)
            BASE_URL="$2"
            shift 2
            ;;
        --network)
            NETWORK="$2"
            shift 2
            ;;
        --output)
            OUTPUT_DIR="$2"
            shift 2
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

if [ -z "$APP" ]; then
    echo "Usage: $0 --app <app-slug> [--url <base-url>] [--network <docker-network>] [--output <output-dir>]"
    echo ""
    echo "Examples:"
    echo "  $0 --app calculator"
    echo "  $0 --app word-counter --url http://localhost:8000"
    exit 1
fi

# Create output directory
mkdir -p "$OUTPUT_DIR"

# Timestamp for unique filenames
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
REPORT_BASENAME="perf-${APP}-${TIMESTAMP}"
REPORT_PATH="/reports/${REPORT_BASENAME}"
RUN_LOG="${OUTPUT_DIR}/${REPORT_BASENAME}.run.log"
JSON_FILE="${OUTPUT_DIR}/${REPORT_BASENAME}.report.json"
HTML_FILE="${OUTPUT_DIR}/${REPORT_BASENAME}.report.html"

echo "Running Lighthouse performance audit for: ${APP}"
echo "URL: ${BASE_URL}/apps/${APP}"
echo "Output: ${OUTPUT_DIR}/"

# Ensure Docker network exists (dev compose uses custom network names).
if [ "$NETWORK" != "host" ]; then
    if ! docker network ls --format '{{.Name}}' 2>/dev/null | grep -qx "$NETWORK"; then
        echo "Warning: Docker network '${NETWORK}' not found. Trying to auto-detect..."
        DETECTED_NETWORK=$(docker network ls --format '{{.Name}}' 2>/dev/null | grep -i appdoesit | head -1)
        if [ -n "$DETECTED_NETWORK" ]; then
            echo "Using detected network: ${DETECTED_NETWORK}"
            NETWORK="$DETECTED_NETWORK"
        else
            echo "Error: Could not detect an AppDoesIt Docker network. Is the dev server running?"
            exit 1
        fi
    fi
fi

# Run Lighthouse in Docker (capture output for later inspection).
# Note: Lighthouse sometimes returns a non-zero exit code even when it writes reports.
LH_EXIT=0
set +e
docker run --rm \
    --user 0:0 \
    --network "$NETWORK" \
    -v "$(pwd)/${OUTPUT_DIR}":/reports \
    femtopixel/google-lighthouse \
    "${BASE_URL}/apps/${APP}" \
    --only-categories=performance \
    --output=json --output=html \
    --output-path="$REPORT_PATH" \
    --chrome-flags="--headless --no-sandbox --disable-dev-shm-usage" \
    --quiet \
    2>&1 | tee "$RUN_LOG"
LH_EXIT=${PIPESTATUS[0]}
set -e

if [ "$LH_EXIT" -ne 0 ]; then
    echo "Warning: Lighthouse exited with code ${LH_EXIT}. Will continue if reports were generated."
fi

echo ""
echo "=== PERFORMANCE AUDIT RESULTS ==="
echo ""

if [ ! -f "$JSON_FILE" ]; then
    echo "Error: Report file not found"
    echo "Expected: ${JSON_FILE}"
    echo "Run log: ${RUN_LOG}"
    exit 1
fi

# Parse performance score
if command -v jq >/dev/null 2>&1; then
    SCORE=$(cat "$JSON_FILE" | jq '.categories.performance.score * 100 | floor')
else
    SCORE=$(python3 -c "import json,math; d=json.load(open('${JSON_FILE}')); print(int(math.floor((d.get('categories',{}).get('performance',{}).get('score') or 0)*100)))" 2>/dev/null || echo "")
fi

if [ -z "$SCORE" ]; then
    echo "Error: Could not parse performance score from ${JSON_FILE}"
    echo "Run log: ${RUN_LOG}"
    exit 1
fi

echo "Performance Score: ${SCORE}/100"
echo ""

if [ "$SCORE" -ge 90 ]; then
    echo "Status: PASS"
else
    echo "Status: FAIL (requires 90+)"
fi

echo ""
echo "Core Web Vitals:"
if command -v jq >/dev/null 2>&1; then
    cat "$JSON_FILE" | jq -r '
        .audits |
        "  LCP: " + (.['"'"'largest-contentful-paint'"'"'].displayValue // "N/A") +
        "\n  FID: " + (.['"'"'max-potential-fid'"'"'].displayValue // "N/A") +
        "\n  CLS: " + (.['"'"'cumulative-layout-shift'"'"'].displayValue // "N/A") +
        "\n  TBT: " + (.['"'"'total-blocking-time'"'"'].displayValue // "N/A")
    '
else
    python3 - <<PY 2>/dev/null || true
import json
d=json.load(open("${JSON_FILE}"))
aud=d.get('audits',{})
def dv(k):
    return (aud.get(k, {}) or {}).get('displayValue') or 'N/A'
print(f"  LCP: {dv('largest-contentful-paint')}")
print(f"  FID: {dv('max-potential-fid')}")
print(f"  CLS: {dv('cumulative-layout-shift')}")
print(f"  TBT: {dv('total-blocking-time')}")
PY
fi

echo ""
echo "Reports saved to:"
echo "  JSON: ${JSON_FILE}"
echo "  HTML: ${HTML_FILE}"

# Fail CI/task if the score is below the required threshold.
if [ "$SCORE" -lt 90 ]; then
    exit 1
fi
