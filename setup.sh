#!/usr/bin/env bash

# machine-macos Setup Script
# Automates the setup of a new macOS development machine

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Helper functions
print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_info() {
    echo -e "${YELLOW}→ $1${NC}"
}

# Check if running on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    print_error "This script is designed for macOS only."
    exit 1
fi

print_info "Starting macOS machine setup..."

# Check for Xcode Command Line Tools
if ! xcode-select -p &> /dev/null; then
    print_info "Installing Xcode Command Line Tools..."
    xcode-select --install
    print_info "Please complete the Xcode Command Line Tools installation and run this script again."
    exit 0
else
    print_success "Xcode Command Line Tools already installed"
fi

# Check for Homebrew
if ! command -v brew &> /dev/null; then
    print_info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH for Apple Silicon Macs
    if [[ $(uname -m) == "arm64" ]]; then
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
    
    print_success "Homebrew installed"
else
    print_success "Homebrew already installed"
    print_info "Updating Homebrew..."
    brew update
fi

# Install packages from Brewfile
if [ -f "Brewfile" ]; then
    print_info "Installing packages from Brewfile..."
    brew bundle --file=Brewfile
    print_success "All packages installed"
else
    print_error "Brewfile not found"
    exit 1
fi

# Configure Git (optional - uncomment and customize)
# print_info "Configuring Git..."
# git config --global user.name "Your Name"
# git config --global user.email "your.email@example.com"
# git config --global init.defaultBranch main
# print_success "Git configured"

# Setup shell (optional - uncomment if using zsh)
# if [ ! -f ~/.zshrc ]; then
#     print_info "Creating .zshrc..."
#     touch ~/.zshrc
# fi

# Cleanup
print_info "Cleaning up..."
brew cleanup

print_success "Setup complete! 🎉"
print_info "You may need to restart your terminal or computer for all changes to take effect."
