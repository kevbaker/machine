# AGENTS.md

Instructions for AI coding agents operating in this repository.

## Project Overview

MACHINE is a macOS developer environment bootstrap tool (dotfiles repo). It provisions
a complete dev environment via a single Bash script that installs tools, symlinks
configs, and sets macOS preferences. There is no application framework, no build
system, and no package manager (no package.json, no Cargo.toml, etc.).

**Primary language:** Bash (bootstrap.sh)
**Supporting languages:** Zsh (shell/zshrc), Lua (Neovim config), TOML (Starship), KDL (Zellij)

## Project Structure

```
machine/
├── bootstrap.sh              # Main installation script (~713 lines Bash)
├── shell/zshrc               # Zsh config (symlinked to ~/.zshrc)
├── git/gitconfig             # Git config (symlinked to ~/.gitconfig)
├── config/
│   ├── nvim/                 # Neovim config (Lua, lazy.nvim plugin manager)
│   │   ├── init.lua          # Neovim entry point
│   │   └── lua/plugins/      # Per-plugin config files
│   ├── starship/starship.toml
│   ├── zellij/config.kdl
│   └── ghostty/config
├── README.md
├── CHANGELOG.md
├── CONTRIBUTING.md
├── CODEOWNERS
└── LICENSE
```

## Build / Lint / Test Commands

There is no build system, no CI pipeline, and no automated test suite.

### Linting

```bash
# Lint the bootstrap script (recommended before any commit)
shellcheck bootstrap.sh

# Basic syntax validation
bash -n bootstrap.sh
```

Install shellcheck if needed: `brew install shellcheck`

### Running the Script

```bash
# Full interactive run
./bootstrap.sh

# Non-interactive mode (for CI or automated testing)
MACHINE_NON_INTERACTIVE=1 ./bootstrap.sh
```

### Manual Testing Checklist

There is no automated test suite. Manual testing is required:

1. Test on a clean macOS installation (VM recommended)
2. Test non-interactive mode: `MACHINE_NON_INTERACTIVE=1 ./bootstrap.sh`
3. Test idempotency: run the script twice -- second run should be a no-op
4. Verify the log file (`~/.machine-install-*.log`) for errors
5. Check that existing configs are backed up before overwrite

## Code Style Guidelines

### Bash (bootstrap.sh)

**Strict mode:** The script uses `set -euo pipefail` (line 15). Never remove this.

**Constants:** Use `readonly` with `UPPER_SNAKE_CASE`:
```bash
readonly VERSION="1.0.0"
readonly INSTALL_DIR="$HOME/.machine"
```

**Functions:** Use `snake_case` naming:
```bash
prompt_yes_no()
backup_if_exists()
check_command()
verify_package()
```

**Logging:** Always use the logging abstraction functions, never raw `echo` for
status messages:
```bash
log_info "Installing package..."
log_success "Package installed"
log_warning "Optional step skipped"
log_error "Failed to install"
```

**Guard-before-install pattern:** Always check before installing, verify after:
```bash
if ! check_command "${package}"; then
    log_info "Installing ${package}..."
    brew install "${package}"
    verify_package "${package}"
fi
```

**Variable quoting:** Always quote variables with braces: `"${variable}"`, not `$variable`.

**Error handling:** Never abort on a single package failure. Use conditional checks
with `log_error`/`log_warning` fallback so the script can continue.

**Idempotency:** Every operation must be safe to run multiple times.

### Zsh (shell/zshrc)

- Use `# ============` section separators with section titles
- Defensive tool loading: check `command -v toolname >/dev/null 2>&1` before `eval`
- Aliases: short, lowercase (`gs`, `ll`, `la`, `fm`)
- Functions: `snake_case` (`mkcd`, `update_all`)
- Support local overrides: `~/.zshrc.local` is sourced if present

### Lua (Neovim config)

- Each plugin file returns a table: `return { { "author/plugin", config = function() ... end } }`
- Assign requires to locals: `local lspconfig = require("lspconfig")`
- Indentation: 2 spaces, `expandtab = true` (per init.lua settings)
- File naming: `kebab-case.lua` or `lowercase.lua` in `lua/plugins/`

### General File Naming

| Location | Convention | Examples |
|----------|-----------|----------|
| Root docs | `UPPER_CASE.md` | `README.md`, `CHANGELOG.md` |
| Shell/git dirs | Bare name (no dot prefix) | `zshrc`, `gitconfig` |
| Neovim plugins | `kebab-case.lua` | `vim-tmux-navigator.lua`, `which-key.lua` |
| App config dirs | Standard tool config names | `starship.toml`, `config.kdl` |

## Commit Messages

- **Title:** Imperative mood, max 50 characters (e.g., "Add ripgrep to CLI tools")
- **Body:** Explain what and why, not how
- **References:** Include `Fixes #123` or `Closes #456` when applicable

## Adding a New Tool

1. Add to the appropriate section in `bootstrap.sh`
2. Use the guard-before-install pattern with `check_command` / `verify_package`
3. Update `README.md` documentation
4. Test installation on a clean system
5. Update `CHANGELOG.md`

## Adding a Configuration File

1. Place the config in the correct directory: `shell/`, `git/`, or `config/<app>/`
2. Add a symlink step in `bootstrap.sh`: `ln -sf "${INSTALL_DIR}/path/to/config" ~/.config/target`
3. Document in `README.md`

## Key Design Principles

1. **Idempotent** -- safe to run multiple times without side effects
2. **Logged** -- all operations written to timestamped log file
3. **Reversible** -- existing configs are backed up before overwrite
4. **Interactive** -- prompts for user preferences when run in a terminal
5. **Non-interactive compatible** -- works with `MACHINE_NON_INTERACTIVE=1` for automation
