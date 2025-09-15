# Changelog

All notable changes to MyFVM will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.2.0] - 2024-09-15

### Added
- **Default Flutter Installation**: Created `default/flutter` script that shows helpful message when no version is selected
- **Man Pages**: Complete documentation for all MyFVM commands (`man myfvm.sh`, `man flutter-install`, etc.)
- **Bash/Zsh Completion**: Tab completion for commands and Flutter versions
- **Automatic PATH Setup**: Both MyFVM commands and Flutter command added to PATH during installation
- **Version Control System**: Added `VERSION` file and enhanced version command with git info
- **Enhanced Documentation**: Updated README with completion examples and automatic PATH setup

### Changed
- **Installation Process**: Now creates `~/.fvm/default` and links `~/.fvm/current` to avoid broken symlinks
- **Command Structure**: Switched from symlinks to direct PATH approach for better transparency
- **Flutter Command Access**: Fixed `flutter: command not found` errors by adding `~/.fvm/current/bin` to PATH
- **Error Messages**: Enhanced error messages with better recovery suggestions

### Fixed
- **Symlink Resolution**: Fixed `SCRIPT_DIR` resolution when called via symlink
- **Flutter Version Display**: Fixed `flutter-switch` and `flutter-current` to show version properly
- **Update Command**: Fixed update command to call `myfvm.sh` instead of `myfvm`
- **Command Validation**: Fixed error message to include all available commands including `update`

### Technical Improvements
- **Direct PATH Access**: No symlinks, direct script access for better debugging
- **Multi-shell Support**: Completion works with both bash and zsh
- **Git Integration**: Version command shows git commit and branch information
- **Clean Uninstall**: Removes all PATH entries, completion, and man pages

## [1.1.0] - 2024-09-15

### Added
- **Unified Command Interface**: Single `myfvm.sh` command with subcommands
- **Dynamic Version Fetching**: Fetches Flutter versions from GitHub API
- **Smart Caching**: Caches version data for faster access (1 hour cache)
- **Cache Management**: `myfvm.sh cache` commands (status, clear, refresh)
- **Version Validation**: Validates Flutter version formats and availability
- **Installation Script**: `install.sh` for easy installation from GitHub
- **Uninstallation Script**: `uninstall.sh` for clean removal

### Changed
- **Command Structure**: Transitioned from individual `flutter-*` scripts to unified `myfvm.sh` interface
- **Version Source**: Switched from static version list to dynamic GitHub API fetching
- **Installation Method**: Added one-liner installation from GitHub

### Fixed
- **API Fallback**: Added fallback to known stable versions if GitHub API fails
- **Error Handling**: Improved error messages and recovery suggestions
- **Script Dependencies**: Fixed script calls to use full paths

## [1.0.0] - 2024-09-15

### Added
- **Core Flutter Version Management**: Install, uninstall, switch, list Flutter versions
- **Symlink-based Switching**: Fast version switching using symlinks
- **Version Listing**: List installed and available Flutter versions
- **Current Version Display**: Show currently active Flutter version
- **Cleanup Utility**: Clean up incomplete installations and broken symlinks
- **Configuration File**: `.myfvmrc` for customizable settings
- **Status Checking**: Monitor MyFVM health and configuration

### Features
- 🚀 **Fast switching** - Uses symlinks for instant version changes
- 📁 **Clean organization** - Versions stored in `~/flutter/`
- 🔧 **Simple scripts** - Easy to understand and modify
- 🎯 **No dependencies** - Pure bash scripts
- 💾 **Space efficient** - Reuses existing Flutter installations

---

## Installation & Usage

### Quick Install
```bash
curl -fsSL https://raw.githubusercontent.com/Souieh/myfvm/main/install.sh | bash
```

### Update
```bash
myfvm.sh update
```

### Uninstall
```bash
curl -fsSL https://raw.githubusercontent.com/Souieh/myfvm/main/uninstall.sh | bash
```

### Version Info
```bash
myfvm.sh version
```

---

## Breaking Changes

### v1.2.0
- **PATH Structure**: Now adds both MyFVM bin and Flutter bin to PATH
- **Default Installation**: Creates `~/.fvm/default` with helpful message script
- **Command Access**: Direct script access instead of symlinks

### v1.1.0
- **Command Interface**: Changed from individual scripts to unified `myfvm.sh` command
- **Installation Location**: Moved to `~/.local/share/myfvm` for better organization
