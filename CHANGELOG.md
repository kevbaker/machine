# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-03-13

### 🎉 Initial Release

Complete macOS developer environment bootstrap with one-line installation.

### Added

#### Core Features
- **One-line installation** via curl piping from GitHub
- **Interactive setup** with customizable prompts
- **Non-interactive mode** for CI/CD and automation
- **Comprehensive logging** with timestamped log files
- **Automatic backups** of existing configurations
- **Idempotent operations** (safe to run multiple times)

#### Languages & Runtimes
- **Go** - Go programming language
- **Rust** - Rust toolchain with cargo
- **Bun** - Fast JavaScript runtime
- **Node.js** - via nvm (Node Version Manager) with LTS
- **Python 3.12** - via pyenv (Python version manager)
- **Tauri CLI** - Cross-platform app framework

#### CLI Tools (21 packages)
- git, neovim, ripgrep, fd, fzf
- starship, zoxide, atuin
- yazi, lazygit, zellij
- gh, gum, ollama, awscli
- bat, eza

#### GUI Applications
**Core (Always Installed):**
- Visual Studio Code with 14 extensions
- Ghostty terminal emulator
- Pixelmator Pro image editor
- Rectangle window management

**Optional (User Choice):**
- Google Chrome, Brave Browser
- OrbStack (Docker alternative)
- Tailscale VPN
- Karabiner Elements keyboard customization
- Amphetamine keep-awake utility
- Bruno API client

#### Developer Fonts
- JetBrains Mono Nerd Font
- Fira Code Nerd Font
- Hack Nerd Font

#### Automated Configuration
- **SSH Key Generation** - Creates keys and integrates with GitHub
- **Git Configuration** - Name, email, GPG signing setup
- **macOS Preferences** - Developer-friendly system settings
  - Show hidden files in Finder
  - Fast key repeat
  - Tap to click
  - Screenshots to Downloads
  - And more...
- **VS Code Extensions** - 14 essential extensions:
  - GitHub Copilot & Copilot Chat
  - ESLint, Prettier
  - Rust Analyzer, Go
  - Tauri VS Code extension
  - Python & Pylance
  - Vim keybindings
  - Material Icons, GitHub theme
  - GitLens

#### Shell Configuration
- **Zsh** with modern tooling
- **Starship prompt** with custom config
- **Useful aliases** for modern CLI tools
- **npm shortcuts** - ni, nid, nr, ns, nt, nb, npminit
- **Git aliases** - g, gs, ga, gc, gp, gl, lg
- **Directory navigation** - .., ..., ....
- **Functions** - mkcd, f, s, update_all, npminit

#### Docker Setup
- Pulls common images (postgres, redis, nginx)
- Configured for immediate use with OrbStack

#### Dotfiles Management
- **Centralized** in `~/.machine` directory
- **Symlinked** to proper locations
- **Version controlled** via Git
- Configs for: zsh, git, neovim, starship, zellij, ghostty

### Documentation
- Comprehensive README with installation guide
- Post-installation checklist
- Customization examples
- Feature overview with tables
- Troubleshooting section

### Technical Details
- **Bash script** with proper error handling (`set -euo pipefail`)
- **Logging functions** (info, success, warning, error)
- **Progress indicators** with emoji and colors
- **Backup system** with timestamps
- **macOS detection** (exits on non-macOS)
- **Homebrew integration** for package management

### Installation Time
- **Estimated:** 60-75 minutes (mostly automated)
- **Manual steps:** ~15 minutes (GitHub auth, iCloud sign-in)

---

## Release Notes

This is the first stable release of MACHINE - a comprehensive macOS developer environment bootstrap system. It's been designed for developers who want to get up and running quickly on a new Mac with all their tools, configurations, and workflows ready to go.

### One-Liner Installation

```bash
curl -fsSL https://raw.githubusercontent.com/kevbaker/machine/main/bootstrap.sh | bash
```

### What Makes This Special

- **Zero to Productive** - One command gets you a fully configured dev environment
- **Safe & Reversible** - Automatic backups, idempotent operations
- **Well Documented** - Comprehensive logging shows exactly what was installed
- **Customizable** - Interactive prompts let you choose what you want
- **Modern Stack** - Latest tools and best practices

Perfect for:
- Setting up new laptops
- Onboarding new team members
- Standardizing dev environments
- Personal backup/restore workflows

[1.0.0]: https://github.com/kevbaker/machine/releases/tag/v1.0.0
