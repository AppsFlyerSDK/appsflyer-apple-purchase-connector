#!/usr/bin/env bash
set -euo pipefail

# Usage: ./scripts/update_spm.sh <version>
VERSION="$1"
PACKAGE_FILE="Package.swift"

# Update exact version in SPM dependency
sed -i.bak -E \
  "s|(\.package\(url: \"[^\"]+\", exact: \")([0-9]+\.[0-9]+\.[0-9]+)(\")|\1${VERSION}\3|" \
  "${PACKAGE_FILE}"

rm "${PACKAGE_FILE}.bak"
