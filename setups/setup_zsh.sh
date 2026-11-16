#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=setups/assets/apt_install_missing.sh
source "$SCRIPT_DIR/assets/apt_install_missing.sh"

if [[ "$OSTYPE" == darwin* ]]; then
	echo "Detected macos"
	# brew install zsh
elif [[ "$OSTYPE" == linux* ]]; then
	echo "Detected linux"
	apt_install_missing zsh
fi

if [[ ! -e "$HOME/.zshrc" ]]; then
	echo "Zshrc not present, creating it"
	touch "$HOME/.zshrc"
fi
if ! grep --fixed-strings --quiet "source ~/.zsh_profile" "$HOME/.zshrc"; then
	cat "$SCRIPT_DIR/assets/zshrc_init.sh" >> "$HOME/.zshrc"
fi

if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
	# Download and run the official Oh My Zsh installer from upstream master
	sh -c "$(curl --fail --silent --show-error --location https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc
fi

if [[ "$OSTYPE" == darwin* ]]; then
	echo "Detected macos, running compaudit"
	zsh -ic 'compaudit | xargs chmod g-w,o-w' 2>/dev/null || true
fi

bash "$SCRIPT_DIR/zsh_plugin_install.sh"
