# machine-macos

🚀 Automated macOS machine setup using Homebrew and Homebrew Cask

## Overview

This repository contains scripts and configuration for setting up a new macOS development machine. It automates the installation of essential tools, applications, and configurations using Homebrew and Homebrew Cask.

## Prerequisites

- macOS 10.15 (Catalina) or later
- Command Line Tools for Xcode
- Administrator access to your Mac

## Quick Start

1. **Install Xcode Command Line Tools** (if not already installed):
   ```bash
   xcode-select --install
   ```

2. **Install Homebrew** (if not already installed):
   ```bash
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```

3. **Clone this repository**:
   ```bash
   git clone https://github.com/kevbaker/machine-macos.git
   cd machine-macos
   ```

4. **Run the setup script**:
   ```bash
   ./setup.sh
   ```

## What Gets Installed

### Development Tools
- Git
- Node.js and npm
- Python 3
- Docker
- Visual Studio Code

### Productivity Apps
- Google Chrome
- Slack
- Zoom
- 1Password

### Utilities
- iTerm2
- Rectangle (window management)
- Alfred (productivity)

## Customization

You can customize the installation by editing the following files:
- `Brewfile` - List of Homebrew packages and casks to install
- `setup.sh` - Main setup script with additional configurations

## Usage

### Installing Specific Categories

Install only development tools:
```bash
brew bundle --file=Brewfile.dev
```

Install only applications:
```bash
brew bundle --file=Brewfile.apps
```

### Updating Packages

Keep all installed packages up to date:
```bash
brew update && brew upgrade && brew upgrade --cask
```

## Troubleshooting

### Homebrew Installation Issues

If you encounter issues with Homebrew:
```bash
brew doctor
```

### Permission Issues

If you get permission errors, ensure your user has admin rights and try:
```bash
sudo chown -R $(whoami) /usr/local/Cellar /usr/local/Homebrew
```

### Cask Installation Failures

Some casks require manual intervention (like granting permissions). Follow the on-screen instructions during installation.

## Contributing

Contributions are welcome! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for details.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- [Homebrew](https://brew.sh/) - The missing package manager for macOS
- [Homebrew Cask](https://github.com/Homebrew/homebrew-cask) - Install macOS apps from the command line

## Support

If you encounter any issues or have questions, please [open an issue](https://github.com/kevbaker/machine-macos/issues).
