# ◉ MACHINE

**Complete macOS developer environment bootstrap** - One command to set up your entire development machine with modern tools, configurations, and applications.

## ➜ Quick Start

### ⚡ One-Line Installation

```bash
curl -fsSL https://raw.githubusercontent.com/kevbaker/machine/main/bootstrap.sh | bash
```

### ⚙ Manual Installation

```bash
git clone https://github.com/kevbaker/machine.git ~/.machine
cd ~/.machine
./bootstrap.sh
```

### ⚑ Non-Interactive Mode (CI/CD)

```bash
MACHINE_NON_INTERACTIVE=1 ./bootstrap.sh
```

## ◉ Interactive Setup

During installation, you'll be prompted to customize:

1. ✓ **Git Configuration** - Name, email, GPG signing
2. ✓ **SSH Key Generation** - Create and add to GitHub
3. ✓ **macOS System Preferences** - Developer-friendly defaults
4. ✓ **Optional Applications** - Choose GUI apps to install
5. ✓ **VS Code Extensions** - Essential dev extensions
6. ✓ **Docker Images** - Common containers (postgres, redis, nginx)

**Non-interactive mode** skips all prompts and uses defaults.

---

## ◉ What Gets Installed

### ⚙ CLI Tools

| Tool | Purpose |
|------|---------|
| **git** | Version control |
| **neovim** | Modern text editor |
| **golang** | Go programming language |
| **rust** | Rust programming language |
| **bun** | Fast JavaScript runtime & toolkit |
| **ripgrep** (rg) | Fast text search |
| **fd** | Fast file finder |
| **fzf** | Fuzzy finder |
| **starship** | Beautiful shell prompt |
| **zoxide** | Smart directory jumping |
| **atuin** | Enhanced shell history |
| **yazi** | Terminal file manager |
| **lazygit** | Git TUI |
| **zellij** | Terminal multiplexer |
| **gh** | GitHub CLI |
| **gum** | Shell script styling |
| **ollama** | Local LLM runtime |
| **awscli** | AWS command line tools |
| **bat** | Cat with syntax highlighting |
| **eza** | Modern ls replacement |

### ⚡ Development Tools

| Tool | Purpose |
|------|---------|
| **nvm** | Node.js version manager |
| **pyenv** | Python version manager |
| **Tauri CLI** | Cross-platform app framework |

### ♪ Developer Fonts

- **JetBrains Mono Nerd Font**
- **Fira Code Nerd Font**
- **Hack Nerd Font**

### ◉ Applications

#### ☺ Core (Always Installed)
- **Visual Studio Code** - Code editor with extensions
- **Ghostty** - Modern terminal emulator
- **Pixelmator Pro** - Image editor (requires App Store)
- **Rectangle** - Window management (snap windows with keyboard shortcuts)

#### ★ Optional (Interactive Prompt)
- **Google Chrome** - Web browser
- **Brave Browser** - Privacy-focused browser
- **OrbStack** - Fast Docker Desktop alternative
- **Tailscale** - VPN mesh network
- **Karabiner Elements** - Keyboard customization
- **Amphetamine** - Keep Mac awake utility
- **Bruno** - API client

> ✓ During interactive installation, you'll be asked if you want to install the optional applications.

---

## ◉ Configuration Files

The bootstrap script automatically links your dotfiles:

```
~/.machine/
├── bootstrap.sh           # Main installation script
├── shell/
│   └── zshrc             # → ~/.zshrc
├── git/
│   └── gitconfig         # → ~/.gitconfig
└── config/
    ├── nvim/             # → ~/.config/nvim/
    ├── zellij/           # → ~/.config/zellij/
    ├── ghostty/          # → ~/.config/ghostty/
    └── starship/
        └── starship.toml # → ~/.config/starship.toml
```

### ⚙ Customization

All configurations are stored in `~/.machine` and symlinked to their proper locations. To customize:

1. ✓ Edit files in `~/.machine/`
2. ✓ Changes take effect immediately (or after sourcing `~/.zshrc`)

For local overrides, create `~/.zshrc.local` which will be sourced automatically.

## ◉ What Gets Configured

The bootstrap script goes beyond just installing tools - it sets up a complete development environment:

### ⚑ SSH & Git
- ✓ Generates SSH keys for GitHub authentication
- ✓ Configures Git with your name, email, and preferences
- ✓ Optionally sets up GPG commit signing

### ⚙ macOS Optimizations
- ✓ Shows hidden files in Finder
- ✓ Displays path bar and status bar
- ✓ Enables fast key repeat
- ✓ Tap to click on trackpad
- ✓ Disables auto-correct
- ✓ Screenshots save to Downloads

### ⚑ VS Code Extensions
- ✓ GitHub Copilot & Copilot Chat
- ✓ ESLint & Prettier
- ✓ Rust Analyzer
- ✓ Go extension
- ✓ Tauri VS Code extension
- ✓ Python & Pylance
- ✓ Vim keybindings
- ✓ Material Icon Theme
- ✓ GitLens

### ⚑ Docker Setup
- ✓ Pulls common images (postgres, redis, nginx)
- ✓ Configures for immediate use with OrbStack

### ⚡ Language Environments
- ✓ Node.js LTS via nvm
- ✓ Python 3.12 via pyenv
- ✓ Go toolchain
- ✓ Rust toolchain + Tauri CLI
- ✓ Bun runtime

### ☺ Window Management
- ✓ **Rectangle** installed and ready
- ✓ Launch from Applications to set up keyboard shortcuts
- ✓ Default shortcuts: ⌃⌥←→↑↓ for left/right/maximize/top-half
- ✓ Free alternative to Magnet with same features

---

## ◉ Installation Logging

The bootstrap script automatically creates a detailed log file during installation:

**Location:** `~/.machine-install-YYYYMMDD_HHMMSS.log`

**What's logged:**
- ✓ Timestamp for every operation
- ✓ All installations (packages, apps, tools)
- ✓ Configuration changes
- ✓ Errors and warnings
- ✓ SSH key generation
- ✓ macOS preference changes

**Useful for:**
- ✓ Troubleshooting if something goes wrong
- ✓ Reviewing what was installed
- ✓ Sharing with support/teammates
- ✓ Keeping a record of your setup

The log file path is displayed at the start and end of installation.

---

## ◉ Post-Installation

After running the bootstrap, complete these steps:

### ➜ 1. Restart Your Terminal

```bash
# Or source your new config
source ~/.zshrc
```

### ⚑ 2. Sign in to Apple Services

**iCloud & App Store:**
1. ✓ Open **System Settings** (⌘ + Space → "System Settings")
2. ✓ Click your name at the top (or "Sign In")
3. ✓ Sign in with your Apple ID
4. ✓ Enable **iCloud Drive** for document sync
5. ✓ Open **App Store** and sign in (same Apple ID)

**Why this matters:**
- ✓ Syncs your personal files via iCloud Drive
- ✓ Activates Pixelmator Pro license
- ✓ Enables app purchases and updates

### ⚑ 3. Authenticate with GitHub

```bash
gh auth login
```

### ⚑ 4. Configure AWS

```bash
aws configure
```

### ⚑ 5. Connect Tailscale

```bash
tailscale up
```

### ⚑ 6. Start Ollama (Optional)

```bash
ollama serve
# In another terminal:
ollama pull llama2
```

---

## ◉ Features

### ⚡ Modern Shell Experience

- ✓ **Starship Prompt**: Beautiful, informative prompt showing git status, language versions, and more
- ✓ **Zoxide**: Jump to frequently used directories with `cd` or `z`
- ✓ **Atuin**: Searchable shell history synced across machines
- ✓ **FZF**: Fuzzy search files, history, and command output

### ⚙ Enhanced Commands

```bash
# Modern replacements with better defaults
ls    # → eza with icons
cat   # → bat with syntax highlighting
cd    # → zoxide smart jumping

# File operations
fm    # → yazi file manager
f     # → fd file finder
s     # → ripgrep text search

# Git
lg    # → lazygit TUI

# npm shortcuts
ni    # → npm install
nid   # → npm install --save-dev
nr    # → npm run
ns    # → npm start
nt    # → npm test
nb    # → npm run build
npminit  # → npm init -y (quick setup)
```

### ☺ Productivity Tools

- ✓ **Zellij**: Modern terminal multiplexer (alternative to tmux)
- ✓ **Neovim**: Pre-configured with modern plugins
- ✓ **Yazi**: Powerful terminal file manager
- ✓ **Lazygit**: Beautiful git interface

### ⚡ Node.js/npm Workflow

Node.js is managed via **nvm** (Node Version Manager) for easy version switching:

```bash
# Check installed versions
nvm list

# Install a specific version
nvm install 18
nvm install 20

# Switch versions per project
nvm use 18

# Quick project setup with npm
npminit              # Creates package.json with defaults
ni express           # Install express
nid typescript       # Install typescript as dev dependency
nr dev               # Run your dev script
```

**npm is ready to use immediately** after bootstrap completes, with helpful aliases configured in your shell.

---

## ⚙ Updating

To update your machine configuration:

```bash
cd ~/.machine
git pull
./bootstrap.sh  # Re-run to update tools and relink configs
```

To update installed tools:

```bash
brew update && brew upgrade
```

---

## ◉ Uninstallation

To remove machine configurations:

```bash
# Remove symlinks (restore your original configs from .backup files)
rm ~/.zshrc ~/.gitconfig
rm -rf ~/.config/nvim ~/.config/zellij ~/.config/ghostty
rm ~/.config/starship.toml

# Remove the repository
rm -rf ~/.machine

# Optionally remove Homebrew packages
brew list | xargs brew uninstall --force
```

**Note**: Your original configurations are backed up with timestamps (`.backup.YYYYMMDD_HHMMSS`)

---

## ◉ Safety Features

- ✓ **Automatic Backups**: All existing configs are backed up before modification
- ✓ **Idempotent**: Safe to run multiple times
- ✓ **Non-Interactive Mode**: Perfect for automation and CI/CD
- ✓ **Error Handling**: Comprehensive error checking and reporting
- ✓ **Non-Destructive**: Never deletes user data

---

## ◉ Customization Examples

### ⚙ Add Custom Aliases

Edit `~/.machine/shell/zshrc` or create `~/.zshrc.local`:

```bash
# ~/.zshrc.local
alias myproject="cd ~/Projects/my-project"
export MY_VAR="value"
```

### ⚙ Customize Git Config

Edit `~/.machine/git/gitconfig`:

```ini
[user]
    name = Your Name
    email = your.email@example.com
```

### ⚙ Modify Starship Prompt

Edit `~/.machine/config/starship/starship.toml`:

```toml
[character]
success_symbol = "[➜](bold green)"
error_symbol = "[✗](bold red)"
```

---

## ♥ Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. ✓ Fork the repository
2. ✓ Create your feature branch: `git checkout -b feature/amazing-feature`
3. ✓ Commit your changes: `git commit -m 'Add amazing feature'`
4. ✓ Push to the branch: `git push origin feature/amazing-feature`
5. ✓ Open a Pull Request

---

## ☮ License

MIT License - See [LICENSE](LICENSE) for details.

---

## ♥ Acknowledgments

- [Homebrew](https://brew.sh/) - Package manager for macOS
- [Starship](https://starship.rs/) - Cross-shell prompt
- [Neovim](https://neovim.io/) - Hyperextensible Vim-based text editor
- [Zoxide](https://github.com/ajeetdsouza/zoxide) - Smarter cd command
- [Atuin](https://github.com/atuinsh/atuin) - Magical shell history
- [Zellij](https://zellij.dev/) - Terminal workspace
- [Yazi](https://github.com/sxyazi/yazi) - Blazing fast file manager

---

<div align="center">

**Made with ❤️ for developers who love their terminal**

🚀 **Happy Hacking!** 🚀

</div>
