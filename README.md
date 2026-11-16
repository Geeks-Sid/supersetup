# Unix installation scripts
Scripts that install various software and config files.

## Setup
`./setup` installs core programs, shells, dotfiles, plugins, and agent skills. It supports both an interactive menu and non-interactive CLI arguments for automation or AI agents.

### Interactive usage
```bash
./setup
```
When run without arguments, `./setup` displays an interactive menu where you can enter comma-separated component numbers.

### Non-interactive / CLI usage
List available components and options:
```bash
./setup --help
./setup --list
```

Run specific components by ID or name (comma- or space-separated), or run everything with `--all` / `all`:
```bash
./setup 3,9
./setup 3 9
./setup dotfiles agent-skills
./setup --all
```

Pass `GIT_USER_NAME` and `GIT_USER_EMAIL` to configure Git non-interactively during component `1` (`core`):
```bash
GIT_USER_NAME="Jane Doe" GIT_USER_EMAIL="jane@example.com" ./setup 1
```

| ID | Name | Description |
|----|------|-------------|
| `1` | `core` | Initial environment setup and core programs (`git`, `neovim`, `xclip`, `tmux`, `ranger`) |
| `2` | `zsh` | Install `zsh`, `zplugin`, and Roboto Mono Nerd Font |
| `3` | `dotfiles` | Setup dotfiles via `./setup_dotfiles` |
| `4` | `python` | Install Python (Miniconda) |
| `5` | `tmux-plugins` | Install tmux plugin manager (`tpm`) |
| `6` | `vim-plugins` | Install `vim-plug` and Vim plugins |
| `8` | `macos-apps` | Install macOS auxiliary casks and `fzf` |
| `9` | `agent-skills` | Install agent skill packs (`omp`, Claude Code, Codex, Gemini CLI) |
| — | `all` / `--all` | Run all components in order |

## Dotfile setup
Run `./setup_dotfiles` (or `./setup dotfiles`) from any working directory to force hard-link dotfiles from `dotfiles/` into `$HOME`, configure `$HOME/.zshrc` or `$HOME/.bashrc` to source the profile and add `dotfiles/commands` to `PATH`, and link iTerm2 profiles and MailMate config on macOS:
```bash
./setup_dotfiles
```
To test dotfile linking in an isolated temporary home directory:
```bash
HOME="$(mktemp -d)" ./setup_dotfiles
```

On macOS the iTerm2 profiles (`supersetup: Default`, `supersetup: Hotkey Window`, `supersetup: Comic sans`) are installed as [Dynamic Profiles](https://iterm2.com/documentation-dynamic-profiles.html) at `~/Library/Application Support/iTerm2/DynamicProfiles/supersetup.json`. Your own iTerm2 profiles, default profile and preferences are not modified; pick a `supersetup:` profile in iTerm2 to use it. Dynamic profiles are read-only in the iTerm2 UI: edit `dotfiles/iterm2_profiles.json` and re-run `./setup_dotfiles`.

## Root / sudo
Nothing in `./setup` runs as root unless it has to. On Linux, apt packages are checked first (`setups/assets/apt_install_missing.sh`) and `sudo` is used only when a package is missing (never when already root). tmux is built into `~/.local` and installed without `sudo`; make sure `~/.local/bin` is on `PATH`. Still needing root: `setups/setup_docker.sh` (system apt repos and `systemctl`), `dotfiles/.config/yabai/yabairc` (`yabai --load-sa`), and Homebrew's own installer on first run.

## Agent skill packs
Menu item `9` (`agent-skills`) runs `setups/setup_agent_skills.sh`, which installs the [ponytail](https://github.com/DietrichGebert/ponytail), [i-have-adhd](https://github.com/ayghri/i-have-adhd), and [elephant-goldfish-model](https://github.com/google/elephant-goldfish-model) packs at user scope in each agent CLI on `PATH`: omp, Claude Code, Codex, and Gemini CLI.

- Install-only: packs already installed are skipped. Sources track each upstream's default branch with no commit pin.
- Updates use each CLI's own commands, then restart the agent. omp: `omp plugin marketplace update <pack>` and `omp plugin upgrade --scope user <pack>@<pack>`. Claude Code: `claude plugin marketplace update <pack>` and `claude plugin update <pack>@<pack>`. Codex: `codex plugin marketplace upgrade <pack>`, then `codex plugin remove <pack>` and `codex plugin add <pack>@<pack>`. Gemini: `gemini extensions update ponytail`; to refresh i-have-adhd's command file, delete `~/.gemini/commands/i-have-adhd.toml` and re-run the script.
- Prerequisites and one-time steps: ponytail's Claude Code and Codex hooks need `node` on `PATH`. Gemini asks for consent before installing ponytail, so run the script from a terminal. In Codex, open `/hooks`, review, and trust ponytail's two lifecycle hooks, then start a new thread.
- Activation: ponytail is always-on at its default `full` level. i-have-adhd stays off until invoked: `/i-have-adhd` in omp, Claude Code, and Gemini, `$i-have-adhd` in Codex. elephant-goldfish-model has no Gemini CLI route upstream, so Gemini skips it.
