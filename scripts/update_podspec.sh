#!/usr/bin/env bash
set -euo pipefail

# Usage: ./scripts/update_podspec.sh <version>
VERSION="$1"
PODSPEC="PurchaseConnector.podspec"

# 1) Bump main s.version
sed -i.bak -E 's|^([[:space:]]*s\.version[[:space:]]*=[[:space:]]*")[0-9]+\.[0-9]+\.[0-9]+(")|\1'"${VERSION}"'\2|' "$PODSPEC"
  
# 2) Bump all subspec dependency versions (Main, Dynamic, Strict)
sed -i.bak -E "s/^( *ss\.ios\.dependency '[^']+', *')[0-9]+\.[0-9]+\.[0-9]+(')/\1${VERSION}\2/" "$PODSPEC"

rm "${PODSPEC}.bak"
