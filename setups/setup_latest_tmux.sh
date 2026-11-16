#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=setups/assets/apt_install_missing.sh
source "$SCRIPT_DIR/assets/apt_install_missing.sh"

# Builds tmux 2.9a and installs it under ~/.local so no root is needed for the install itself
apt_install_missing git automake build-essential pkg-config libevent-dev libncurses5-dev byacc

tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT

# Clone official tmux repository pinned to release tag 2.9a
git clone --branch 2.9a --depth 1 https://github.com/tmux/tmux.git "$tmp_dir/tmux"
(cd "$tmp_dir/tmux" && sh autogen.sh && ./configure --prefix="$HOME/.local" && make && make install)

if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
	echo "tmux installed to $HOME/.local/bin, which is not on PATH yet; add it or log in again" >&2
fi
