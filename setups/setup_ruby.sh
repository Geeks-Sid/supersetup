#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# Install rbenv and ruby-build
brew install rbenv

# Setup rbenv integration to your shell
rbenv init || true

# Verify rbenv installation with official rbenv-doctor script from rbenv-installer
curl --fail --silent --show-error --location https://github.com/rbenv/rbenv-installer/raw/master/bin/rbenv-doctor | bash
