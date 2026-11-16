#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

echo "Setting up git"
git config --global color.ui true

github_username="${GIT_USER_NAME:-$(git config --global user.name || true)}"
if [[ -z "$github_username" ]] && [[ -t 0 ]]; then
	echo "Enter your GitHub username: "
	read -r github_username
fi
if [[ -n "$github_username" ]]; then
	git config --global user.name "$github_username"
fi

github_email="${GIT_USER_EMAIL:-$(git config --global user.email || true)}"
if [[ -z "$github_email" ]] && [[ -t 0 ]]; then
	echo "Enter your GitHub email: "
	read -r github_email
fi
if [[ -n "$github_email" ]]; then
	git config --global user.email "$github_email"
fi

if [[ ! -f "$HOME/.ssh/id_rsa" ]] && [[ -n "${github_email:-}" ]]; then
	mkdir -p "$HOME/.ssh"
	if [[ -t 0 ]]; then
		ssh-keygen -t rsa -b 4096 -C "$github_email"
	else
		ssh-keygen -t rsa -b 4096 -C "$github_email" -f "$HOME/.ssh/id_rsa" -N ""
	fi
fi

if [[ -f "$HOME/.ssh/id_rsa.pub" ]]; then
	cat "$HOME/.ssh/id_rsa.pub"
	echo "Copy the above ssh key and paste it at https://github.com/settings/keys"
fi
