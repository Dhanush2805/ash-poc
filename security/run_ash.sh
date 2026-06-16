#!/bin/bash

set -e

echo "Running ASH AWS Security Scan (Local Mode)..."

ash --mode local

if [ $? -ne 0 ]; then
    echo "Security scan failed."

    REPORT_PATH=".ash/ash_output/reports/ash.html"

    if [ -f "$REPORT_PATH" ]; then
        echo "Opening report is not supported in CI. Uploading artifact instead."
    fi

    exit 1
fi

exit 0
