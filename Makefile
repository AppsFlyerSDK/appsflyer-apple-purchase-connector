.PHONY: help setup

## help: show this help message
help:
	@echo "Usage: make <target>"
	@echo ""
	@grep -E '^## [a-zA-Z_-]+:' Makefile | sed 's/## /  /' | column -t -s ':'

## setup: configure local git hooks (run once after cloning)
setup:
	git config --local core.hooksPath .github/hooks
	chmod +x .github/hooks/pre-push
	@echo "✅ Git hooks configured. Pre-push protection is active for releases/* branches."
