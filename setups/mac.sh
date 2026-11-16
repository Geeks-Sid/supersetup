#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

if ! command -v brew >/dev/null 2>&1; then
  # Official Homebrew installation script (HEAD)
  /bin/bash -c "$(curl --fail --silent --show-error --location https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

xcode-select --install || true

# TODO - Complete install script