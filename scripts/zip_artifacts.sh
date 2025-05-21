#!/usr/bin/env bash
set -euo pipefail

# Run from repo root. Zips PurchaseConnector.xcframework and Dynamic/PurchaseConnector.xcframework

# 1) static
zip -r purchase-connector-static.xcframework.zip PurchaseConnector.xcframework

# 2) dynamic
zip -r purchase-connector-dynamic.xcframework.zip Dynamic/PurchaseConnector.xcframework