#!/usr/bin/env bash
set -euo pipefail

# Usage: ./scripts/update_carthage.sh <version>
VERSION="$1"
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

for VARIANT in dynamic static; do
  JSON_FILE="${REPO_ROOT}/Carthage/purchase-connector-${VARIANT}.json"
  NEW_URL="https://github.com/AppsFlyerSDK/appsflyer-apple-purchase-connector/releases/download/${VERSION}/purchase-connector-${VARIANT}.xcframework.zip"
  # Append new version entry
  jq --arg v "${VERSION}" --arg url "${NEW_URL}" \
     '. + {($v): $url}' \
     "${JSON_FILE}" > "${JSON_FILE}.tmp" \
  && mv "${JSON_FILE}.tmp" "${JSON_FILE}"
done
