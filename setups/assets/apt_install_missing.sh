# shellcheck shell=bash
# Installs only the apt packages that are missing. Root is requested (sudo) only when
# something is actually missing, and not at all when already running as root.
apt_install_missing() {
	local missing=() pkg
	for pkg in "$@"; do
		if [[ "$(dpkg-query --show --showformat='${db:Status-Status}' "$pkg" 2>/dev/null)" != "installed" ]]; then
			missing+=("$pkg")
		fi
	done
	if [[ ${#missing[@]} -eq 0 ]]; then
		return 0
	fi
	echo "Missing apt packages, installing (needs root):" "${missing[@]}"
	if [[ "$EUID" -eq 0 ]]; then
		apt-get update -y
		apt-get install -y "${missing[@]}"
	else
		sudo apt-get update -y
		sudo apt-get install -y "${missing[@]}"
	fi
}
