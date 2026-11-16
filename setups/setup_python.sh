#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

arch="$(uname -m)"
if [[ "$OSTYPE" == darwin* ]]; then
	echo "Detected macos"
	if [[ "$arch" == "arm64" ]] || [[ "$arch" == "aarch64" ]]; then
		miniconda_url="https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-arm64.sh"
	else
		miniconda_url="https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-x86_64.sh"
	fi
elif [[ "$OSTYPE" == linux* ]]; then
	echo "Detected linux"
	if [[ "$arch" == "arm64" ]] || [[ "$arch" == "aarch64" ]]; then
		miniconda_url="https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-aarch64.sh"
	else
		miniconda_url="https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh"
	fi
else
	echo "Unsupported OS: $OSTYPE" >&2
	exit 1
fi

installer="$(mktemp)"
trap 'rm -f "$installer"' EXIT

# Download official Miniconda3 latest installer from https://repo.anaconda.com/miniconda/
curl --fail --silent --show-error --location --output "$installer" "$miniconda_url"
bash "$installer" -b -u -p "$HOME/miniconda"
echo "Conda installed"

touch "$HOME/.bashrc"
if ! grep --fixed-strings --quiet "activate_conda" "$HOME/.bashrc"; then
	cat "$SCRIPT_DIR/assets/condaondemand.sh" >> "$HOME/.bashrc"
fi
if [[ -e "$HOME/.zshrc" ]] && ! grep --fixed-strings --quiet "activate_conda" "$HOME/.zshrc"; then
	cat "$SCRIPT_DIR/assets/condaondemand.sh" >> "$HOME/.zshrc"
fi

# shellcheck source=setups/assets/condaondemand.sh
source "$SCRIPT_DIR/assets/condaondemand.sh"
activate_conda
if ! conda env list | grep --extended-regexp --quiet '^dl[[:space:]]'; then
	conda create --yes --name dl python=3
fi
echo "Conda has been installed. It is disabled by default. To activate it in a terminal session, type 'dl'. You can configure this in the bashrc or zshrc file."
