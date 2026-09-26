#!/bin/bash
# E2E Test Runner for AppDoesIt
#
# Usage:
#   ./run-tests.sh              # Run all tests
#   ./run-tests.sh calculator   # Run tests matching "calculator"
#   ./run-tests.sh --file app-layout.spec.js  # Run specific file

set -e

cd "$(dirname "$0")/../../../.."

if [[ "$1" == "--file" && -n "$2" ]]; then
    echo "Running test file: $2"
    ./docker.ps1 test -- tests/e2e/"$2"
elif [[ -n "$1" ]]; then
    echo "Running tests matching: $1"
    ./docker.ps1 test -- --grep "$1"
else
    echo "Running all E2E tests..."
    ./docker.ps1 test
fi
