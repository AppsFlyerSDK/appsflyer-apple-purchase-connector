#!/usr/bin/env bash
set -euo pipefail

# Usage: ./scripts/update_podspec.sh <pc_version> <af_version>
PC_VERSION="$1"
AF_VERSION="$2"
[[ $# -eq 2 && -n "$PC_VERSION" && -n "$AF_VERSION" ]] \
  || { echo "Usage: $0 <pc_version> <af_version>"; exit 1; }
PODSPEC="PurchaseConnector.podspec"

# Bump PurchaseConnector's own version
sed -i.bak -E \
  's|^([[:space:]]*s\.version[[:space:]]*=[[:space:]]*")[0-9]+\.[0-9]+\.[0-9]+(")|\1'"${PC_VERSION}"'\2|' \
  "$PODSPEC"

# Bump AppsFlyerFramework dependency version in all subspecs (Main, Dynamic, Strict)
sed -i.bak -E \
  "s/^( *ss\.ios\.dependency '[^']+', *')[0-9]+\.[0-9]+\.[0-9]+(')/\1${AF_VERSION}\2/" \
  "$PODSPEC"

rm "${PODSPEC}.bak"
