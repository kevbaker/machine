# machine-macos
New machine setup for a MacOS

## Usage

Run the setup script to configure your macOS machine:

```bash
./setup.sh
```

Or specify a custom Brewfile:

```bash
./setup.sh /path/to/custom/Brewfile
```

## What It Does

1. **Xcode Command Line Tools** - Installs if not present
2. **Homebrew** - Installs and updates the package manager
3. **Brewfile** - Installs all packages from the Brewfile
4. **Node.js** - Sets up nvm and installs LTS version
5. **Python** - Installs Python 3.12.6 via pyenv
6. **Global Tools** - Installs npm packages (TypeScript, ESLint, etc.) and Python tools (Poetry, Black, etc.)
7. **Podman** - Initializes Podman machine as Docker alternative

## Brewfile

Edit `Brewfile` to customize the packages and applications installed on your system.

## Requirements

- macOS (Apple Silicon or Intel)
- Internet connection
