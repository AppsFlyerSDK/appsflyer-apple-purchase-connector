# Release workflow

## Overview

The release process uses two GitHub Actions workflows. A new version moves through three phases: **prepare** (automated, fires on branch push), **review and merge** (manual), and **publish** (automated, fires on PR merge).

## .release-variables — version source of truth

A permanent file at the repo root controls both versions for every release:

```
purchase_connector_version=6.18.0
appsflyer_framework_version=6.18.0
```

Update both values before pushing a release branch. The CI workflow reads exclusively from this file — the branch name is convention only. If `appsflyer_framework_version` differs from `purchase_connector_version`, the podspec and SPM dependency pin use the AF version while the connector's own version uses the PC value (e.g., release `6.18.1` that still depends on AppsFlyerFramework `6.18.0`).

## Local setup (run once after cloning)

```bash
make setup
```

This configures git to use the repo's hook directory. After setup, pushing to `releases/**` without updating `.release-variables` blocks locally with a clear error.

## Triggering a release

1. Update `.release-variables` with the new versions.
2. Commit the XCFrameworks and `.release-variables`: `git commit -m "Bump vX.Y.Z"`
3. Push a branch named `releases/{major}.x.x/{major}.{minor}.x/{version}_rc{N}`.

The branch name format is a routing convention — it triggers the prepare workflow and signals the release version to reviewers. The actual versions used come from `.release-variables`.

## Prepare release

**Workflow:** `.github/workflows/prepare-release.yml` — runs on `macos-latest`.

1. Validates `.release-variables` has a diff vs `origin/main` — fails immediately if stale.
2. Reads `purchase_connector_version` and `appsflyer_framework_version` from the file; validates both are `X.Y.Z` format.
3. Validates both XCFramework directories exist.
4. Runs update scripts:
   - `update_carthage.sh $PC_VERSION` — adds new entry to Carthage JSON files
   - `update_podspec.sh $PC_VERSION $AF_VERSION` — bumps `s.version` and all `AppsFlyerFramework` dependency lines
   - `update_spm.sh $AF_VERSION` — updates the `AppsFlyerFramework-Static` exact version pin
   - `update_readme.sh $PC_VERSION $AF_VERSION` — updates prose version and compatibility table row
5. Commits all changes with message `chore: bump version to $PC_VERSION` and pushes the branch.
6. Creates git tag `$PC_VERSION` on the bump commit and pushes the tag.
7. Opens a pull request from the release branch to `main` with title `chore: release $PC_VERSION`.

## Approval gate

No automated environment protection. A team member reviews the auto-generated PR, confirms the version bump diff across all five files is correct, and merges it. Merging is the sole trigger for the publish workflow. Closing without merging leaves the release prepared but unpublished.

## Publish release

**Workflow:** `.github/workflows/publish-release.yml` — fires when a `releases/**` PR is merged into `main`.

1. Re-extracts the PC version from the merged branch name and verifies the tag exists.
2. Runs `scripts/zip_artifacts.sh` to produce `purchase-connector-static.xcframework.zip` and `purchase-connector-dynamic.xcframework.zip`.
3. Creates a GitHub release at the existing tag and attaches both zips.
4. Publishes to CocoaPods trunk via `pod trunk push PurchaseConnector.podspec`. Non-blocking (`continue-on-error: true`).
5. Checks out `AppsFlyerSDK/PurchaseConnector-Dynamic`, downloads the dynamic zip, computes its checksum, updates `Package.swift`, tags the companion repo, and opens a PR there.

## Full lifecycle diagram

```
Update .release-variables → commit XCFrameworks + file → push releases/6.x.x/6.18.x/6.18.1_rc1
          │
          ├─ [pre-push hook] .release-variables diff vs main? → block if stale
          │
          ▼
[prepare-release.yml]
  1. CI validates .release-variables diff vs origin/main
  2. Read PC_VERSION + AF_VERSION from file
  3. Validate XCFrameworks present
  4. Run update scripts (5 files updated)
  5. Commit "chore: bump version to $PC_VERSION" + push branch
  6. Create tag $PC_VERSION on bump commit + push tag
  7. Open PR: releases/… → main
          │
          ▼
[Human: review & merge PR]
  Confirm version bump diff, merge into main
          │
          ▼
[publish-release.yml]
  1. Verify tag exists
  2. Zip XCFrameworks (static + dynamic)
  3. Create GitHub release, attach zips
  4. Publish to CocoaPods trunk (non-blocking)
  5. Update PurchaseConnector-Dynamic repo (Package.swift + PR)
          │
          ▼
Release live on GitHub, CocoaPods, and Swift Package Manager
```
