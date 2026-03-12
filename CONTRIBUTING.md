# Contributing to MACHINE

Thank you for your interest in contributing to MACHINE! This document provides guidelines and instructions for contributing.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [How to Contribute](#how-to-contribute)
- [Development Guidelines](#development-guidelines)
- [Pull Request Process](#pull-request-process)
- [Reporting Issues](#reporting-issues)

## Code of Conduct

This project follows a simple code of conduct: **Be respectful, be constructive, and be collaborative.**

## Getting Started

1. **Fork the repository** on GitHub
2. **Clone your fork** locally:
   ```bash
   git clone https://github.com/YOUR-USERNAME/machine.git
   cd machine
   ```
3. **Create a branch** for your changes:
   ```bash
   git checkout -b feature/your-feature-name
   ```

## How to Contribute

### Types of Contributions

We welcome various types of contributions:

- **Bug fixes** - Fix issues with the bootstrap script
- **New tools** - Add new CLI tools or applications
- **Configuration improvements** - Better dotfile configs
- **Documentation** - Improve README, add examples
- **macOS optimizations** - Additional system preferences
- **Testing** - Add test scripts or validation
- **Performance** - Speed up installation process

### Before You Start

- Check existing [Issues](https://github.com/kevbaker/machine/issues) and [Pull Requests](https://github.com/kevbaker/machine/pulls)
- For major changes, open an issue first to discuss
- Test your changes on a clean macOS installation (VM recommended)

## Development Guidelines

### Shell Script Style (bootstrap.sh)

Follow the patterns established in the codebase:

```bash
# Use logging functions
log_info "Installing package..."
log_success "Package installed"
log_warning "Optional step skipped"
log_error "Failed to install"

# Check before installing
if ! check_command package_name; then
  # Install only if missing
fi

# Verify after installing
verify_package "package_name"

# Use proper quoting
local file_path="${HOME}/.config/app"
```

### Key Principles

1. **Idempotent** - Safe to run multiple times
2. **Logged** - All operations written to log file
3. **Reversible** - Backup existing configs
4. **Interactive** - Prompt for user preferences
5. **Non-interactive compatible** - Work in CI/CD

### Adding a New Tool

When adding a new CLI tool or application:

1. Add to appropriate section in `bootstrap.sh`
2. Add verification step
3. Update README.md documentation
4. Test installation on clean system
5. Update CHANGELOG.md

Example:
```bash
# In bootstrap.sh
for package in git neovim NEW_TOOL; do
  if ! check_command "${package}"; then
    log_info "Installing ${package}..."
    brew install "${package}"
    verify_package "${package}"
  fi
done
```

### Adding Configuration Files

1. Add config file to appropriate directory:
   - `shell/` - Shell configs (zshrc, etc.)
   - `git/` - Git configs
   - `config/` - Application configs

2. Add symlink step in bootstrap.sh:
   ```bash
   ln -sf "${INSTALL_DIR}/path/to/config" ~/.config/target
   ```

3. Document in README.md

### Testing

While there's no automated test suite, manual testing is essential:

1. **Test on clean macOS** - VM or fresh install
2. **Test non-interactive mode**:
   ```bash
   MACHINE_NON_INTERACTIVE=1 ./bootstrap.sh
   ```
3. **Test idempotency** - Run script twice
4. **Verify log file** - Check for errors
5. **Check backups** - Ensure existing configs backed up

### Commit Messages

Use clear, descriptive commit messages:

```
Add ripgrep to CLI tools

- Adds ripgrep (rg) for fast text search
- Updates README documentation
- Adds shell alias 's' for quick searches
```

Format:
- **Title**: Imperative mood, max 50 chars
- **Body**: Explain what and why (not how)
- **Reference issues**: "Fixes #123" or "Closes #456"

## Pull Request Process

1. **Update documentation** - README, CHANGELOG, etc.
2. **Test thoroughly** - On clean macOS if possible
3. **Check syntax**: `bash -n bootstrap.sh`
4. **Update CHANGELOG.md** - Add under [Unreleased]
5. **Create pull request** with clear description

### PR Description Template

```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Documentation update
- [ ] Configuration improvement

## Testing
- [ ] Tested on macOS (version: ___)
- [ ] Tested non-interactive mode
- [ ] Tested idempotency (ran twice)
- [ ] Checked log output

## Checklist
- [ ] Updated README.md
- [ ] Updated CHANGELOG.md
- [ ] Syntax checked (`bash -n bootstrap.sh`)
- [ ] Follows code style guidelines
```

## Reporting Issues

### Bug Reports

Include:
- **macOS version** (e.g., macOS 14.3 Sonoma)
- **Chip architecture** (Intel or Apple Silicon)
- **Installation log** (`~/.machine-install-*.log`)
- **Error messages** (full output)
- **Steps to reproduce**

### Feature Requests

Include:
- **Use case** - Why is this needed?
- **Proposed solution** - How would it work?
- **Alternatives considered**
- **Additional context**

### Questions

For questions about usage:
- Check README.md first
- Search existing issues
- Open a new issue with "Question:" prefix

## Development Environment

Recommended setup for contributors:

```bash
# Install shellcheck for linting
brew install shellcheck

# Check shell script
shellcheck bootstrap.sh

# Test in VM (optional but recommended)
# UTM or Parallels for macOS VM
```

## Project Structure

```
machine/
├── bootstrap.sh           # Main installation script
├── shell/
│   └── zshrc             # Zsh configuration
├── git/
│   └── gitconfig         # Git configuration
├── config/
│   ├── nvim/             # Neovim config
│   ├── starship/         # Starship prompt
│   ├── zellij/           # Terminal multiplexer
│   └── ghostty/          # Terminal emulator
├── README.md             # Main documentation
├── CHANGELOG.md          # Version history
├── CONTRIBUTING.md       # This file
├── CODEOWNERS            # Code ownership
└── LICENSE               # MIT License
```

## Questions?

- Open an issue for discussion
- Tag @kevbaker for maintainer attention

## Thank You!

Your contributions help make MACHINE better for everyone. We appreciate your time and effort! 🙏
