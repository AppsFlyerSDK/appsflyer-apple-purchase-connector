#!/usr/bin/env bash
set -euo pipefail

# Usage: scripts/update_readme.sh <pc_version> <af_version>
PC_VERSION="$1"
AF_VERSION="$2"
[[ $# -eq 2 && -n "$PC_VERSION" && -n "$AF_VERSION" ]] \
  || { echo "Usage: $0 <pc_version> <af_version>"; exit 1; }
README="README.md"

# Update the AF SDK version in the "Built for" line
sed -i.bak -E \
  "s|(iOS AppsFlyer SDK \*\*)[0-9]+\.[0-9]+\.[0-9]+(\*\*)|\1${AF_VERSION}\2|" \
  "$README"

# Append a new compatibility row: | PC_VERSION | AF_VERSION |
# Skip if this PC_VERSION row already exists (idempotent on re-runs)
if ! grep -qF "| $PC_VERSION" "$README"; then
  awk -v pc="$PC_VERSION" -v af="$AF_VERSION" '
    { lines[NR] = $0 }
    /^\|.*\|/ { last = NR }
    END {
      for (i = 1; i <= NR; i++) {
        print lines[i];
        if (i == last) {
          print "| " pc "   |  " af " |";
        }
      }
    }' "$README" > "${README}.tmp" \
    && mv "${README}.tmp" "$README"
fi

rm "${README}.bak"
