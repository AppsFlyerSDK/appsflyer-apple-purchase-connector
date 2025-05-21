#!/usr/bin/env bash
set -euo pipefail

# Usage: scripts/update_readme.sh <version>
VERSION="$1"
README="README.md"

# 1) Update the bolded SDK version in the "Built for" section
#    Matches: iOS AppsFlyer SDK **x.y.z**
sed -i.bak -E \
  "s|(iOS AppsFlyer SDK \*\*)[0-9]+\.[0-9]+\.[0-9]+(\*\*)|\1${VERSION}\2|" \
  "$README"
  
# 2) Insert a new compatibility row after the last table row
#    Finds the last line starting with '|' and adds the new row + blank line
awk -v v="$VERSION" ' \
  { lines[NR] = $0 } \
  /^\|.*\|/ { last = NR } \
  END { \
    for (i = 1; i <= NR; i++) { \
      print lines[i]; \
      if (i == last) { \
        print "| " v "   |  " v " |"; \
      } \
    } \
  }' "$README" > "${README}.tmp" \
  && mv "${README}.tmp" "$README"

# Cleanup backup file
rm "${README}.bak"
