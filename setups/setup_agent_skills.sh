#!/usr/bin/env bash
# Installs the ponytail, i-have-adhd, and elephant-goldfish-model agent skill packs
# at user scope in each agent CLI on PATH: omp, Claude Code, Codex, Gemini CLI.
# Install-only: packs already installed are skipped. Update with each CLI's plugin commands.
# Upstream sources, tracked on default branches (no commit pins):
#   https://github.com/DietrichGebert/ponytail
#   https://github.com/ayghri/i-have-adhd
#   https://github.com/google/elephant-goldfish-model
set -euo pipefail
IFS=$'\n\t'

# "pack|owner/repo". Upstream marketplace and plugin names both equal the pack name.
readonly PACKS=(
    "ponytail|DietrichGebert/ponytail"
    "i-have-adhd|ayghri/i-have-adhd"
    "egm|google/elephant-goldfish-model"
)

# contains <haystack> <needle>: fixed-string match
contains() {
    grep --fixed-strings --quiet -- "$2" <<<"$1"
}

install_omp() {
    local entry name repo plugins marketplaces
    plugins="$(omp plugin list)"
    marketplaces="$(omp plugin marketplace list)"
    for entry in "${PACKS[@]}"; do
        IFS='|' read -r name repo <<<"$entry"
        if contains "$plugins" "$name@$name"; then
            echo "omp: $name already installed"
            continue
        fi
        # omp exits non-zero when the marketplace already exists, so only add when missing.
        if ! contains "$marketplaces" "$repo"; then
            omp plugin marketplace add "$repo"
        fi
        omp plugin install --scope user "$name@$name"
    done
}

install_claude() {
    local entry name repo plugins
    plugins="$(claude plugin list)"
    for entry in "${PACKS[@]}"; do
        IFS='|' read -r name repo <<<"$entry"
        if contains "$plugins" "$name@$name"; then
            echo "claude: $name already installed"
            continue
        fi
        claude plugin marketplace add "$repo"
        claude plugin install "$name@$name"
    done
}

install_codex() {
    local entry name repo plugins
    plugins="$(codex plugin list)"
    for entry in "${PACKS[@]}"; do
        IFS='|' read -r name repo <<<"$entry"
        if grep --extended-regexp --quiet -- "^${name}@${name}[[:space:]]+installed" <<<"$plugins"; then
            echo "codex: $name already installed"
            continue
        fi
        codex plugin marketplace add "$repo"
        codex plugin add "$name@$name"
        if [[ $name == ponytail ]]; then
            echo "codex: open /hooks, review and trust ponytail's two lifecycle hooks, then start a new thread"
        fi
    done
}

install_gemini() {
    local ponytail_dir="$HOME/.gemini/extensions/ponytail"
    local command_file="$HOME/.gemini/commands/i-have-adhd.toml"
    local tmp

    # ponytail: always-on extension from upstream default branch (unpinned).
    # Gemini exits non-zero when consent is declined, so the directory check below,
    # not the exit status, decides whether ponytail installed.
    if [[ -d $ponytail_dir ]]; then
        echo "gemini: ponytail already installed"
    else
        gemini extensions install "https://github.com/DietrichGebert/ponytail" || true
        if [[ ! -d $ponytail_dir ]]; then
            echo "gemini: ponytail was not installed (consent declined or no terminal); rerun from a terminal" >&2
            exit 1
        fi
    fi

    # i-have-adhd: opt-in custom command from upstream main (unpinned), its documented Gemini default.
    if [[ -f $command_file ]]; then
        echo "gemini: i-have-adhd command already installed"
    else
        mkdir -p "$HOME/.gemini/commands"
        tmp="$(mktemp)"
        curl --fail --silent --show-error --location --output "$tmp" \
            "https://raw.githubusercontent.com/ayghri/i-have-adhd/main/skills/i-have-adhd/agents/gemini.toml"
        mv "$tmp" "$command_file"
    fi

    # elephant-goldfish-model documents no Gemini CLI route; its skill-only copies break.
    echo "gemini: elephant-goldfish-model has no Gemini CLI install route; skipped"
}

main() {
    if command -v omp >/dev/null 2>&1; then install_omp; else echo "omp: not found, skipped"; fi
    if command -v claude >/dev/null 2>&1; then install_claude; else echo "claude: not found, skipped"; fi
    if command -v codex >/dev/null 2>&1; then install_codex; else echo "codex: not found, skipped"; fi
    if command -v gemini >/dev/null 2>&1; then install_gemini; else echo "gemini: not found, skipped"; fi
}

main
