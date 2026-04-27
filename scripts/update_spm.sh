#!/usr/bin/env bash
set -euo pipefail

# Usage: ./scripts/update_spm.sh <af_version>
# Updates the AppsFlyerFramework-Static exact version pin in Package.swift.
AF_VERSION="$1"
[[ $# -eq 1 && -n "$AF_VERSION" ]] \
  || { echo "Usage: $0 <af_version>"; exit 1; }
PACKAGE_FILE="Package.swift"

sed -i.bak -E \
  "s|(\.package\(url: \"[^\"]+\", exact: \")([0-9]+\.[0-9]+\.[0-9]+)(\")|\1${AF_VERSION}\3|" \
  "${PACKAGE_FILE}"

rm "${PACKAGE_FILE}.bak"
