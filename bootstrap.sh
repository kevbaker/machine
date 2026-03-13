#!/usr/bin/env bash

# ███╗   ███╗ █████╗  ██████╗██╗  ██╗██╗███╗   ██╗███████╗
# ████╗ ████║██╔══██╗██╔════╝██║  ██║██║████╗  ██║██╔════╝
# ██╔████╔██║███████║██║     ███████║██║██╔██╗ ██║█████╗  
# ██║╚██╔╝██║██╔══██║██║     ██╔══██║██║██║╚██╗██║██╔══╝  
# ██║ ╚═╝ ██║██║  ██║╚██████╗██║  ██║██║██║ ╚████║███████╗
# ╚═╝     ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝╚══════╝
#
# MACHINE - macOS Developer Environment Bootstrap
# Version: 1.0.0
# Author: Kevin Baker
# One-liner: curl -fsSL https://raw.githubusercontent.com/kevbaker/machine/main/bootstrap.sh | bash

set -euo pipefail

readonly VERSION="1.0.0"
readonly REPO="https://github.com/kevbaker/machine.git"
readonly INSTALL_DIR="$HOME/.machine"
readonly LOG_FILE="$HOME/.machine-install-$(date +%Y%m%d_%H%M%S).log"

readonly BOLD='\033[1m'
readonly RESET='\033[0m'
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[0;33m'
readonly BLUE='\033[0;34m'

# Check if running non-interactively (piped from curl)
NON_INTERACTIVE=false
if [[ ! -t 0 ]] || [[ "${CI:-}" == "true" ]] || [[ -n "${MACHINE_NON_INTERACTIVE:-}" ]]; then
  NON_INTERACTIVE=true
fi

# Logging functions that write to both console and log file
log_to_file() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" >> "${LOG_FILE}"
}

log_info() { 
  echo -e "${BLUE}ℹ${RESET} $*"
  log_to_file "INFO: $*"
}

log_success() { 
  echo -e "${GREEN}✅${RESET} $*"
  log_to_file "SUCCESS: $*"
}

log_warning() { 
  echo -e "${YELLOW}⚠️${RESET} $*"
  log_to_file "WARNING: $*"
}

log_error() { 
  echo -e "${RED}❌${RESET} $*"
  log_to_file "ERROR: $*"
}

prompt_yes_no() {
  local prompt="$1"
  local response
  
  if [[ "${NON_INTERACTIVE}" == "true" ]]; then
    log_info "Non-interactive mode: defaulting to 'yes' for: ${prompt}"
    return 0
  fi
  
  while true; do
    echo -n "${prompt} (y/n): "
    read -r response
    case "${response}" in
      [Yy]|[Yy][Ee][Ss]) return 0 ;;
      [Nn]|[Nn][Oo]) return 1 ;;
      *) echo "Please answer y or n." ;;
    esac
  done
}

backup_if_exists() {
  local file="$1"
  if [[ -f "${file}" ]] || [[ -d "${file}" ]]; then
    local backup="${file}.backup.$(date +%Y%m%d_%H%M%S)"
    log_warning "Backing up existing ${file} to ${backup}"
    mv "${file}" "${backup}"
    return 1  # Indicate backup was created
  fi
  return 0  # No backup needed
}

check_command() {
  command -v "$1" >/dev/null 2>&1
}

# Map Homebrew formula names to their actual binary names
# when the two differ (e.g., neovim -> nvim)
formula_binary() {
  case "$1" in
    neovim)  echo "nvim"   ;;
    ripgrep) echo "rg"     ;;
    awscli)  echo "aws"    ;;
    golang)  echo "go"     ;;
    rust)    echo "rustc"  ;;
    *)       echo "$1"     ;;
  esac
}

verify_package() {
  local package="$1"
  local binary
  binary="$(formula_binary "${package}")"
  if ! check_command "${binary}"; then
    log_error "Failed to install ${package}"
    return 1
  fi
  log_success "${package} installed successfully"
}

# Main script - Initialize log file
echo "================================================" > "${LOG_FILE}"
echo "MACHINE Bootstrap Installation Log" >> "${LOG_FILE}"
echo "Started: $(date)" >> "${LOG_FILE}"
echo "Version: ${VERSION}" >> "${LOG_FILE}"
echo "================================================" >> "${LOG_FILE}"
echo "" >> "${LOG_FILE}"

echo -e "${BOLD}"
cat <<'EOF'
███╗   ███╗ █████╗  ██████╗██╗  ██╗██╗███╗   ██╗███████╗
████╗ ████║██╔══██╗██╔════╝██║  ██║██║████╗  ██║██╔════╝
██╔████╔██║███████║██║     ███████║██║██╔██╗ ██║█████╗  
██║╚██╔╝██║██╔══██║██║     ██╔══██║██║██║╚██╗██║██╔══╝  
██║ ╚═╝ ██║██║  ██║╚██████╗██║  ██║██║██║ ╚████║███████╗
╚═╝     ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝╚══════╝

      macOS Developer Environment Bootstrap v${VERSION}
EOF
echo -e "${RESET}"
echo
log_info "Installation log: ${LOG_FILE}"
echo

# OS Detection
if [[ "$OSTYPE" != "darwin"* ]]; then
  log_error "This script is designed for macOS only."
  exit 1
fi

# Prevent running as root
if [[ "$EUID" -eq 0 ]]; then
  log_error "Please run without sudo."
  exit 1
fi

echo
echo "▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓"
echo "🛠️  INSTALLING XCODE COMMAND LINE TOOLS"
echo "▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓"
echo

if ! xcode-select -p >/dev/null 2>&1; then
  log_info "Installing Xcode Command Line Tools..."
  xcode-select --install || true
  if [[ "${NON_INTERACTIVE}" == "false" ]]; then
    log_warning "Press enter after installation finishes..."
    read -r
  else
    log_info "Waiting for Xcode tools installation..."
    until xcode-select -p >/dev/null 2>&1; do
      sleep 5
    done
  fi
else
  log_success "Xcode Command Line Tools already installed"
fi

echo
echo "▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓"
echo "🍺 INSTALLING HOMEBREW"
echo "▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓"
echo

if ! check_command brew; then
  log_info "Installing Homebrew..."
  if [[ "${NON_INTERACTIVE}" == "true" ]]; then
    export NONINTERACTIVE=1
  fi
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  
  # Add Homebrew to PATH for Apple Silicon and Intel Macs
  if [[ -d "/opt/homebrew/bin" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -d "/usr/local/bin" ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
else
  log_success "Homebrew already installed"
fi

log_info "Updating Homebrew..."
brew update

echo
echo "▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓"
echo "📦 INSTALLING CLI TOOLS"
echo "▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓"
echo

log_info "Installing essential CLI tools..."
for package in git neovim ripgrep fd fzf starship zoxide atuin yazi lazygit zellij gh gum ollama awscli bat eza golang rust bun; do
  binary="$(formula_binary "${package}")"
  if ! check_command "${binary}"; then
    log_info "Installing ${package}..."
    if ! brew install "${package}"; then
      log_error "Failed to install ${package}"
    else
      verify_package "${package}"
    fi
  else
    log_success "${package} already installed"
  fi
done

# Install fzf keybindings
log_info "Installing fzf keybindings..."
if [[ -f "$(brew --prefix)/opt/fzf/install" ]]; then
  "$(brew --prefix)/opt/fzf/install" --all --no-bash --no-fish || true
  log_success "fzf keybindings installed"
fi

echo
echo "▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓"
echo "🔤 INSTALLING DEVELOPER FONTS"
echo "▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓"
echo

log_info "Installing Nerd Fonts..."
for font in font-jetbrains-mono-nerd-font font-fira-code-nerd-font font-hack-nerd-font; do
  if ! brew list --cask "${font}" >/dev/null 2>&1; then
    log_info "Installing ${font}..."
    if ! brew install --cask "${font}"; then
      log_warning "Failed to install ${font}"
    else
      log_success "${font} installed"
    fi
  else
    log_success "${font} already installed"
  fi
done

echo
echo "▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓"
echo "🖥️  INSTALLING GUI APPLICATIONS"
echo "▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓"
echo

# Define core and optional applications
CORE_APPS="visual-studio-code ghostty pixelmator-pro rectangle"
OPTIONAL_APPS="google-chrome brave-browser orbstack tailscale karabiner-elements amphetamine bruno"

# Install core applications
log_info "Installing essential applications..."
for app in ${CORE_APPS}; do
  if ! brew list --cask "${app}" >/dev/null 2>&1; then
    log_info "Installing ${app}..."
    if ! brew install --cask "${app}"; then
      log_warning "Failed to install ${app} (may require manual installation)"
    else
      log_success "${app} installed"
    fi
  else
    log_success "${app} already installed"
  fi
done

# Ask about optional applications
if [[ "${NON_INTERACTIVE}" == "false" ]]; then
  echo
  log_info "The following optional applications are available:"
  echo "  • google-chrome - Google's web browser"
  echo "  • brave-browser - Privacy-focused browser"
  echo "  • orbstack - Fast Docker Desktop alternative"
  echo "  • tailscale - VPN mesh network"
  echo "  • karabiner-elements - Keyboard customization"
  echo "  • amphetamine - Keep Mac awake utility"
  echo "  • bruno - API client"
  echo
  
  if prompt_yes_no "Install all optional applications?"; then
    for app in ${OPTIONAL_APPS}; do
      if ! brew list --cask "${app}" >/dev/null 2>&1; then
        log_info "Installing ${app}..."
        if ! brew install --cask "${app}"; then
          log_warning "Failed to install ${app} (may require manual installation)"
        else
          log_success "${app} installed"
        fi
      else
        log_success "${app} already installed"
      fi
    done
  else
    log_info "Skipping optional applications (you can install them later with: brew install --cask <app-name>)"
  fi
else
  # Non-interactive mode: install all
  log_info "Installing optional applications..."
  for app in ${OPTIONAL_APPS}; do
    if ! brew list --cask "${app}" >/dev/null 2>&1; then
      log_info "Installing ${app}..."
      if ! brew install --cask "${app}"; then
        log_warning "Failed to install ${app} (may require manual installation)"
      else
        log_success "${app} installed"
      fi
    else
      log_success "${app} already installed"
    fi
  done
fi

echo
echo "▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓"
echo "🐍 INSTALLING LANGUAGE VERSION MANAGERS"
echo "▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓"
echo

# Install nvm (Node Version Manager)
if [[ ! -d "$HOME/.nvm" ]]; then
  log_info "Installing nvm (Node Version Manager)..."
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  log_success "nvm installed"
  
  log_info "Installing Node.js LTS..."
  nvm install --lts
  nvm use --lts
  log_success "Node.js $(node --version) installed"
  
  # Set up global npm packages
  log_info "Installing global npm packages..."
  npm install -g npm@latest
  log_success "npm updated to latest version"
else
  log_success "nvm already installed"
  # Ensure nvm is loaded for this session
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
fi

# Install pyenv (Python Version Manager)
if ! check_command pyenv; then
  log_info "Installing pyenv (Python Version Manager)..."
  brew install pyenv pyenv-virtualenv
  log_success "pyenv installed"
  
  log_info "Installing Python 3.12..."
  pyenv install 3.12
  pyenv global 3.12
  log_success "Python $(pyenv version | awk '{print $1}') installed"
else
  log_success "pyenv already installed"
fi

# Install Tauri CLI (requires Rust)
if check_command cargo; then
  if ! cargo install --list | grep -q "tauri-cli"; then
    log_info "Installing Tauri CLI..."
    cargo install tauri-cli
    log_success "Tauri CLI installed"
  else
    log_success "Tauri CLI already installed"
  fi
fi

echo
echo "▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓"
echo "📂 CLONING MACHINE REPOSITORY"
echo "▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓"
echo

if [[ ! -d "${INSTALL_DIR}" ]]; then
  log_info "Cloning machine repository to ${INSTALL_DIR}..."
  git clone "${REPO}" "${INSTALL_DIR}"
  log_success "Repository cloned"
else
  log_success "Machine repository already exists at ${INSTALL_DIR}"
  log_info "Pulling latest changes..."
  cd "${INSTALL_DIR}"
  git pull origin main || log_warning "Could not pull latest changes"
fi

cd "${INSTALL_DIR}"

echo
echo "▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓"
echo "⚙️  CONFIGURATION SETUP"
echo "▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓"
echo

if [[ "${NON_INTERACTIVE}" == "false" ]]; then
  log_info "Let's customize your git configuration..."
  echo
  
  # Get git user name
  echo -n "Enter your full name (for git commits): "
  read -r GIT_USER_NAME
  
  # Get git email
  echo -n "Enter your email (for git commits): "
  read -r GIT_USER_EMAIL
  
  # Ask about GPG signing
  echo
  if prompt_yes_no "Do you want to enable GPG commit signing?"; then
    echo -n "Enter your GPG key ID: "
    read -r GPG_KEY_ID
    USE_GPG_SIGNING=true
  else
    USE_GPG_SIGNING=false
  fi
  
  # Update git config with user values
  if [[ -f "${INSTALL_DIR}/git/gitconfig" ]]; then
    log_info "Updating git configuration with your details..."
    
    # Create temporary config with user's values
    sed -e "s/name = Kevin Baker/name = ${GIT_USER_NAME}/" \
        -e "s/email = your-email@example.com/email = ${GIT_USER_EMAIL}/" \
        "${INSTALL_DIR}/git/gitconfig" > "${INSTALL_DIR}/git/gitconfig.tmp"
    
    if [[ "${USE_GPG_SIGNING}" == "true" ]]; then
      sed -e "s/# signingkey = YOUR_GPG_KEY/signingkey = ${GPG_KEY_ID}/" \
          -e "s/# gpgSign = true/gpgSign = true/" \
          "${INSTALL_DIR}/git/gitconfig.tmp" > "${INSTALL_DIR}/git/gitconfig.tmp2"
      mv "${INSTALL_DIR}/git/gitconfig.tmp2" "${INSTALL_DIR}/git/gitconfig.tmp"
    fi
    
    mv "${INSTALL_DIR}/git/gitconfig.tmp" "${INSTALL_DIR}/git/gitconfig"
    log_success "Git configuration updated"
  fi
  
  echo
else
  log_warning "Non-interactive mode: Using default git configuration"
  log_warning "Please edit ~/.machine/git/gitconfig to customize"
fi

echo
echo "▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓"
echo "🔗 LINKING CONFIGURATION FILES"
echo "▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓"
echo

mkdir -p ~/.config

# Link shell configuration
if [[ -f "${INSTALL_DIR}/shell/zshrc" ]]; then
  backup_if_exists ~/.zshrc
  ln -sf "${INSTALL_DIR}/shell/zshrc" ~/.zshrc
  log_success "Linked ~/.zshrc"
fi

# Link git configuration
if [[ -f "${INSTALL_DIR}/git/gitconfig" ]]; then
  backup_if_exists ~/.gitconfig
  ln -sf "${INSTALL_DIR}/git/gitconfig" ~/.gitconfig
  log_success "Linked ~/.gitconfig"
fi

# Link config directories
for config_dir in nvim zellij ghostty; do
  if [[ -d "${INSTALL_DIR}/config/${config_dir}" ]]; then
    backup_if_exists ~/.config/"${config_dir}"
    ln -sf "${INSTALL_DIR}/config/${config_dir}" ~/.config/"${config_dir}"
    log_success "Linked ~/.config/${config_dir}"
  fi
done

# Link starship config
if [[ -f "${INSTALL_DIR}/config/starship/starship.toml" ]]; then
  backup_if_exists ~/.config/starship.toml
  ln -sf "${INSTALL_DIR}/config/starship/starship.toml" ~/.config/starship.toml
  log_success "Linked ~/.config/starship.toml"
fi

echo
echo "▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓"
echo "🔐 SSH KEY SETUP"
echo "▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓"
echo

if [[ ! -f "$HOME/.ssh/id_ed25519" ]] && [[ ! -f "$HOME/.ssh/id_rsa" ]]; then
  if [[ "${NON_INTERACTIVE}" == "false" ]]; then
    echo
    if prompt_yes_no "Generate SSH key for GitHub/Git?"; then
      log_info "Generating SSH key..."
      ssh-keygen -t ed25519 -C "${GIT_USER_EMAIL:-your-email@example.com}" -f "$HOME/.ssh/id_ed25519" -N ""
      
      # Start ssh-agent and add key
      eval "$(ssh-agent -s)" >/dev/null
      ssh-add "$HOME/.ssh/id_ed25519" 2>/dev/null
      
      log_success "SSH key generated at ~/.ssh/id_ed25519"
      
      # Copy public key to clipboard
      pbcopy < "$HOME/.ssh/id_ed25519.pub"
      log_success "Public key copied to clipboard!"
      echo
      echo "  Add this key to GitHub:"
      echo "  ${BLUE}https://github.com/settings/ssh/new${RESET}"
      echo "  Or run: ${BLUE}gh ssh-key add ~/.ssh/id_ed25519.pub${RESET}"
      echo
    fi
  else
    log_info "SSH key generation skipped (non-interactive mode)"
  fi
else
  log_success "SSH key already exists"
fi

echo
echo "▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓"
echo "⚙️  macOS SYSTEM PREFERENCES"
echo "▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓"
echo

if [[ "${NON_INTERACTIVE}" == "false" ]]; then
  if prompt_yes_no "Apply recommended macOS settings?"; then
    log_info "Configuring macOS preferences..."
    
    # Finder: show hidden files
    defaults write com.apple.finder AppleShowAllFiles -bool true
    
    # Finder: show path bar
    defaults write com.apple.finder ShowPathbar -bool true
    
    # Finder: show status bar
    defaults write com.apple.finder ShowStatusBar -bool true
    
    # Show all filename extensions
    defaults write NSGlobalDomain AppleShowAllExtensions -bool true
    
    # Disable warning when changing file extensions
    defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
    
    # Set fast key repeat rate
    defaults write NSGlobalDomain KeyRepeat -int 2
    defaults write NSGlobalDomain InitialKeyRepeat -int 15
    
    # Enable tap to click
    defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
    defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
    
    # Disable auto-correct
    defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
    
    # Require password immediately after sleep
    defaults write com.apple.screensaver askForPassword -int 1
    defaults write com.apple.screensaver askForPasswordDelay -int 0
    
    # Show battery percentage
    defaults write com.apple.menuextra.battery ShowPercent -string "YES"
    
    # Set screenshot location to Downloads
    defaults write com.apple.screencapture location -string "${HOME}/Downloads"
    
    # Disable screenshot shadow
    defaults write com.apple.screencapture disable-shadow -bool true
    
    log_success "macOS preferences configured"
    log_info "Note: Some changes require logout/restart to take effect"
  fi
else
  log_info "macOS preferences skipped (non-interactive mode)"
fi

echo
echo "▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓"
echo "🍎 CHECKING APPLE SERVICES"
echo "▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓"
echo

# Check if iCloud is signed in
ICLOUD_ACCOUNT=$(defaults read MobileMeAccounts Accounts 2>/dev/null | grep AccountID | awk -F'"' '{print $2}' | head -1)

if [[ -n "${ICLOUD_ACCOUNT}" ]]; then
  log_success "iCloud signed in as: ${ICLOUD_ACCOUNT}"
  
  # Check iCloud Drive status
  if defaults read com.apple.bird ubiquity-account-status &>/dev/null; then
    log_success "iCloud Drive is enabled"
  else
    log_warning "iCloud Drive may not be enabled"
  fi
else
  log_warning "iCloud is not signed in"
  echo
  echo "  To sign in to iCloud:"
  echo "  1. Open System Settings (⌘ + Space, type 'System Settings')"
  echo "  2. Click on your name at the top (or 'Sign in' if not logged in)"
  echo "  3. Sign in with your Apple ID"
  echo "  4. Enable iCloud Drive and other services you need"
  echo
fi

# Check App Store sign-in
if [[ -n "$(mas account 2>/dev/null)" ]] || [[ -f ~/Library/Preferences/com.apple.commerce.plist ]]; then
  APP_STORE_EMAIL=$(defaults read com.apple.commerce AppleID 2>/dev/null || echo "signed in")
  if [[ -n "${APP_STORE_EMAIL}" ]]; then
    log_success "App Store signed in"
  else
    log_warning "App Store sign-in status unknown"
  fi
else
  log_warning "App Store is not signed in"
  echo
  echo "  To sign in to App Store:"
  echo "  1. Open App Store application"
  echo "  2. Click 'Sign In' button"
  echo "  3. Sign in with your Apple ID"
  echo "  4. This allows Pixelmator Pro and other apps to sync licenses"
  echo
fi

echo
echo "▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓"
echo "🧩 VS CODE EXTENSIONS"
echo "▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓"
echo

if check_command code; then
  if [[ "${NON_INTERACTIVE}" == "false" ]]; then
    if prompt_yes_no "Install recommended VS Code extensions?"; then
      log_info "Installing VS Code extensions..."
      
      # Essential extensions
      code --install-extension github.copilot
      code --install-extension github.copilot-chat
      code --install-extension dbaeumer.vscode-eslint
      code --install-extension esbenp.prettier-vscode
      code --install-extension rust-lang.rust-analyzer
      code --install-extension golang.go
      code --install-extension tauri-apps.tauri-vscode
      code --install-extension bradlc.vscode-tailwindcss
      code --install-extension ms-python.python
      code --install-extension ms-python.vscode-pylance
      code --install-extension vscodevim.vim
      code --install-extension PKief.material-icon-theme
      code --install-extension GitHub.github-vscode-theme
      code --install-extension eamodio.gitlens
      
      log_success "VS Code extensions installed"
    fi
  else
    log_info "VS Code extensions skipped (non-interactive mode)"
  fi
else
  log_warning "VS Code not found, skipping extensions"
fi

echo
echo "▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓"
echo "🐳 DOCKER/ORBSTACK SETUP"
echo "▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓"
echo

if check_command docker; then
  log_success "Docker/OrbStack is available"
  
  if [[ "${NON_INTERACTIVE}" == "false" ]]; then
    if prompt_yes_no "Pull common Docker images? (postgres, redis, nginx)"; then
      log_info "Pulling common Docker images..."
      docker pull postgres:16-alpine
      docker pull redis:7-alpine
      docker pull nginx:alpine
      log_success "Docker images pulled"
    fi
  fi
else
  log_info "Docker/OrbStack not installed or not running"
  log_info "If you installed OrbStack, launch it from Applications to enable Docker"
fi

echo
echo "▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓"
echo "🎉 SETUP COMPLETE!"
echo "▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓"
echo

# Write completion to log
log_to_file "================================================"
log_to_file "Installation completed successfully"
log_to_file "Finished: $(date)"
log_to_file "================================================"

log_success "Your macOS development environment is ready!"
echo
echo -e "${BOLD}⚡ Next steps:${RESET}"
echo "  1. Restart your terminal or run: ${BLUE}source ~/.zshrc${RESET}"
echo "  2. ${YELLOW}Sign in to iCloud & App Store${RESET} (System Settings → Apple ID)"
echo "  3. Launch ${BLUE}Pixelmator Pro${RESET} from Applications to activate your license"
echo "  4. Authenticate with GitHub: ${BLUE}gh auth login${RESET}"
echo "  5. Configure AWS credentials: ${BLUE}aws configure${RESET}"
echo "  6. Connect Tailscale: ${BLUE}tailscale up${RESET}"
echo "  7. Start Ollama service: ${BLUE}ollama serve${RESET}"
echo
echo -e "${BOLD}📚 Installed tools:${RESET}"
echo "  • Languages: ${BLUE}Node.js (nvm), Python (pyenv), Go, Rust, Bun${RESET}"
echo "  • Frameworks: ${BLUE}Tauri CLI${RESET}"
echo "  • Terminal: ${BLUE}zellij (multiplexer), yazi (file manager)${RESET}"
echo "  • Git: ${BLUE}lazygit (TUI), gh (CLI)${RESET}"
echo "  • Search: ${BLUE}fzf (fuzzy), fd (files), rg (text)${RESET}"
echo "  • Utils: ${BLUE}bat (cat), eza (ls), starship (prompt)${RESET}"
echo "  • Navigation: ${BLUE}zoxide (smart cd), atuin (history)${RESET}"
echo "  • Dev fonts: ${BLUE}JetBrains Mono, Fira Code, Hack Nerd Fonts${RESET}"
echo
echo -e "${BOLD}🎨 Configured:${RESET}"
echo "  • SSH keys generated and ready for GitHub"
echo "  • macOS defaults optimized for development"
echo "  • VS Code extensions installed"
echo "  • Shell (zsh) with modern tools integrated"
echo
echo -e "${BOLD}📋 Installation Log:${RESET}"
echo "  ${LOG_FILE}"
echo "  Review this file if you need to see what was installed"
echo
log_success "Happy hacking! 🚀"
