# MyFVM - Custom Flutter Version Manager

A lightweight Flutter version manager that uses symlinks for fast version switching.

## Features

- 🚀 **Fast switching** - Uses symlinks for instant version changes
- 📁 **Clean organization** - Versions stored in `~/flutter/`
- 🔧 **Simple scripts** - Easy to understand and modify
- 🎯 **No dependencies** - Pure bash scripts
- 💾 **Space efficient** - Reuses existing Flutter installations

## Installation

### Quick Install (Recommended)

One-liner installation from GitHub:

```bash
curl -fsSL https://raw.githubusercontent.com/Souieh/myfvm/main/install.sh | bash
```

### Manual Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/Souieh/myfvm.git ~/.local/share/myfvm
   ```

2. Add to PATH:
   ```bash
   echo 'export PATH="$HOME/.local/share/myfvm/bin:$PATH"' >> ~/.bashrc
   source ~/.bashrc
   ```

3. Install Flutter versions:
   ```bash
   myfvm.sh install 3.24.5
   myfvm.sh install 3.35.3
   ```

### Update

To update MyFVM to the latest version:

```bash
myfvm.sh update
```

Or manually:
```bash
cd ~/.local/share/myfvm && git pull origin main
```

### Uninstall

To uninstall MyFVM:

```bash
curl -fsSL https://raw.githubusercontent.com/Souieh/myfvm/main/uninstall.sh | bash
```

Or manually:
```bash
rm -rf ~/.local/share/myfvm
# Remove PATH entry from ~/.bashrc or ~/.zshrc if added
```

**Note:** Uninstalling MyFVM will NOT remove your Flutter installations or configuration files.

## Usage

### Unified Command Interface

```bash
# Show help and available commands
myfvm.sh help

# Install a Flutter version
myfvm.sh install 3.24.5

# Switch to a version
myfvm.sh switch 3.24.5

# List installed versions
myfvm.sh list

# Check current version
myfvm.sh current

# Show available versions
myfvm.sh versions

# Uninstall a version
myfvm.sh uninstall 3.24.5

# Clean up incomplete installations
myfvm.sh cleanup

# Check MyFVM status
myfvm.sh status

# Manage version cache
myfvm.sh cache status
myfvm.sh cache clear
myfvm.sh cache refresh
```

### Direct Script Access

You can also use the individual scripts directly:

```bash
# Install a Flutter version
flutter-install 3.24.5

# Switch to a version
flutter-switch 3.24.5

# List installed versions
flutter-list

# Check current version
flutter-current

# Show available versions
flutter-versions

# Uninstall a version
flutter-uninstall 3.24.5

# Clean up incomplete installations
flutter-cleanup

# Manage version cache
flutter-cache status
flutter-cache clear
flutter-cache refresh
```

## Directory Structure

```
~/flutter/
├── flutter-3.24.5/
├── flutter-3.35.3/
└── flutter-3.32.0/

~/.fvm/
└── current -> ~/flutter/flutter-3.24.5

PATH includes:
- ~/.local/share/myfvm/bin (MyFVM commands)
- ~/.fvm/current/bin (Flutter command)
```

## Commands

MyFVM provides both a unified command interface and direct script access.

### Unified Command Interface: `myfvm.sh <command> [options]`

#### Core Commands
- `myfvm.sh install <version>` - Install a new Flutter version
- `myfvm.sh switch <version>` - Switch to an existing version
- `myfvm.sh list` - List all installed versions
- `myfvm.sh current` - Show current version info

#### Management Commands
- `myfvm.sh uninstall <version>` - Remove a Flutter version
- `myfvm.sh versions [version]` - Show available versions and validate version strings
- `myfvm.sh cleanup` - Clean up incomplete installations and broken symlinks

#### Utility Commands
- `myfvm.sh help` - Show detailed help
- `myfvm.sh status` - Check MyFVM configuration and status
- `myfvm.sh version` - Show MyFVM version information
- `myfvm.sh cache <command>` - Cache management utility
- `myfvm.sh update` - Update MyFVM to latest version

### Direct Script Access

Individual scripts are also available directly:
- `flutter-install <version>` - Install Flutter version
- `flutter-switch <version>` - Switch to version
- `flutter-list` - List installed versions
- `flutter-current` - Show current version
- `flutter-versions` - Show available versions
- `flutter-uninstall <version>` - Remove version
- `flutter-cleanup` - Clean up installations
- `flutter-cache <command>` - Cache management

## Enhanced Features

- 🎯 **Unified Command Interface** - Single `myfvm.sh` command with subcommands
- ✅ **Version validation** - Validates version formats and availability
- 🧹 **Auto cleanup** - Removes incomplete installations
- 📋 **Comprehensive listing** - Shows installed and available versions
- ⚙️ **Configuration** - Customizable settings via `.myfvmrc`
- 🔍 **Status checking** - Monitor MyFVM health and configuration
- 🛡️ **Error handling** - Better error messages and recovery suggestions
- 🌐 **Dynamic version fetching** - Fetches latest versions from GitHub API
- 🗄️ **Smart caching** - Caches version data for faster access
- 🔄 **Cache management** - Clear and refresh version cache
- 📚 **Man pages** - Complete documentation for all commands
- ⌨️ **Bash completion** - Tab completion for commands and versions
- 🚀 **Direct PATH access** - No symlinks, direct script access

## Documentation & Completion

### Man Pages

Complete manual pages are available for all commands:

```bash
man myfvm.sh           # Main MyFVM manual
man flutter-install    # Install command manual
man flutter-list       # List command manual
man flutter-switch     # Switch command manual
man flutter-current    # Current command manual
man flutter-versions   # Versions command manual
man flutter-cache      # Cache command manual
```

### Bash Completion

Tab completion is available for commands and versions:

```bash
myfvm.sh <TAB>         # Shows: install, uninstall, switch, list, current, versions, cleanup, cache, help, version, status, update
myfvm.sh install <TAB>  # Shows: 3.24.5, 3.24.3, 3.24.1, 3.22.6, etc.
myfvm.sh cache <TAB>   # Shows: status, clear, refresh
flutter-install <TAB>  # Shows: 3.24.5, 3.24.3, 3.24.1, 3.22.6, etc.
```

Completion is automatically installed and configured during MyFVM installation.

### Automatic PATH Setup

MyFVM automatically sets up your PATH during installation:

1. **MyFVM Commands**: `~/.local/share/myfvm/bin` added to PATH
2. **Flutter Command**: `~/.fvm/current/bin` added to PATH

This means:
- ✅ `myfvm.sh` commands work immediately
- ✅ `flutter` command works after switching versions
- ✅ No manual PATH configuration needed
- ✅ Automatic Flutter command access
