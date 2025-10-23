# Contributing to machine-macos

Thank you for your interest in contributing to machine-macos! We welcome contributions from the community.

## How to Contribute

### Reporting Bugs

If you find a bug, please open an issue with:
- A clear, descriptive title
- Steps to reproduce the issue
- Expected behavior
- Actual behavior
- Your macOS version
- Screenshots if applicable

### Suggesting Enhancements

We welcome suggestions for new features or improvements. Please open an issue with:
- A clear, descriptive title
- Detailed description of the enhancement
- Why this enhancement would be useful
- Examples of how it would work

### Pull Requests

1. **Fork the repository** and create your branch from `main`:
   ```bash
   git checkout -b feature/my-new-feature
   ```

2. **Make your changes**:
   - Follow the existing code style
   - Add or update documentation as needed
   - Test your changes on a fresh macOS installation if possible

3. **Commit your changes**:
   ```bash
   git commit -m "Add feature: description of changes"
   ```
   
   Use clear, descriptive commit messages:
   - `Add`: for new features
   - `Update`: for changes to existing features
   - `Fix`: for bug fixes
   - `Remove`: for removing features or code

4. **Push to your fork**:
   ```bash
   git push origin feature/my-new-feature
   ```

5. **Open a Pull Request** with:
   - Clear title and description
   - Reference to any related issues
   - Screenshots or examples if applicable

### Adding New Packages

When adding new Homebrew packages or casks:

1. Verify the package exists and is maintained:
   ```bash
   brew search package-name
   brew info package-name
   ```

2. Add packages to the appropriate section in the Brewfile
3. Test the installation on a clean system if possible
4. Update the README.md to document the new package

### Code Style

- Use clear, descriptive variable names
- Comment complex sections of code
- Follow shell scripting best practices
- Use consistent indentation (2 spaces)

### Testing

Before submitting a pull request:

1. Test your changes on macOS
2. Ensure all scripts run without errors
3. Verify that existing functionality still works
4. Test on a clean macOS installation if adding major changes

## Development Setup

1. Fork and clone the repository
2. Create a test environment (virtual machine recommended)
3. Make your changes
4. Test thoroughly
5. Submit your pull request

## Community Guidelines

- Be respectful and inclusive
- Follow our [Code of Conduct](CODE_OF_CONDUCT.md)
- Help others in discussions and issues
- Be patient with maintainers and contributors

## Questions?

Feel free to open an issue for any questions about contributing!

## License

By contributing to machine-macos, you agree that your contributions will be licensed under the MIT License.
