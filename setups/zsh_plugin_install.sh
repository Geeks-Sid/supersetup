#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

omz_bundle() {
	local owner repo target_dir
	IFS='/' read -r owner repo <<<"$1"
	target_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/$repo"
	if [[ -d "$target_dir" ]]; then
		echo "Plugin $repo already installed at $target_dir, skipping"
		return 0
	fi
	# Clone Oh My Zsh custom plugin from GitHub repository
	git clone "https://github.com/${owner}/${repo}" "$target_dir"
}

omz_bundle_theme() {
	local owner repo target_dir
	IFS='/' read -r owner repo <<<"$1"
	target_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/$repo"
	if [[ -d "$target_dir" ]]; then
		echo "Theme $repo already installed at $target_dir, skipping"
		return 0
	fi
	# Clone Oh My Zsh custom theme from GitHub repository
	git clone "https://github.com/${owner}/${repo}" "$target_dir"
}

omz_bundle 'zsh-users/zsh-autosuggestions'
omz_bundle 'z-shell/F-Sy-H'
omz_bundle 'Valiev/almostontop'
omz_bundle 'esc/conda-zsh-completion'
omz_bundle 'changyuheng/zsh-interactive-cd'
#omz_bundle 'denysdovhan/spaceship-prompt'
omz_bundle_theme 'romkatv/powerlevel10k'
