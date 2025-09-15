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
   git clone https://github.com/souieh/myfvm.git ~/.local/share/myfvm
   ```

2. Add to PATH:
   ```bash
   echo 'export PATH="$HOME/.local/share/myfvm/bin:$PATH"' >> ~/.bashrc
   source ~/.bashrc
   ```

3. Install Flutter versions:
   ```bash
   myfvm install 3.24.5
   myfvm install 3.35.3
   ```

### Update

To update MyFVM to the latest version:

```bash
myfvm update
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
rm -f ~/.local/bin/myfvm
```

**Note:** Uninstalling MyFVM will NOT remove your Flutter installations or configuration files.

## Usage

```bash
# Show help and available commands
myfvm help

# Install a Flutter version
myfvm install 3.24.5

# Switch to a version
myfvm switch 3.24.5

# List installed versions
myfvm list

# Check current version
myfvm current

# Show available versions
myfvm versions

# Uninstall a version
myfvm uninstall 3.24.5

# Clean up incomplete installations
myfvm cleanup

# Check MyFVM status
myfvm status

# Manage version cache
myfvm cache status
myfvm cache clear
myfvm cache refresh
```

## Directory Structure

```
~/flutter/
├── flutter-3.24.5/
├── flutter-3.35.3/
└── flutter-3.32.0/

~/.fvm/
└── current -> ~/flutter/flutter-3.24.5
```

## Commands

MyFVM uses a unified command structure: `myfvm <command> [options]`

### Core Commands
- `myfvm install <version>` - Install a new Flutter version
- `myfvm switch <version>` - Switch to an existing version
- `myfvm list` - List all installed versions
- `myfvm current` - Show current version info

### Management Commands
- `myfvm uninstall <version>` - Remove a Flutter version
- `myfvm versions [version]` - Show available versions and validate version strings
- `myfvm cleanup` - Clean up incomplete installations and broken symlinks

### Utility Commands
- `myfvm help` - Show detailed help
- `myfvm status` - Check MyFVM configuration and status
- `myfvm version` - Show MyFVM version information
- `myfvm cache <command>` - Cache management utility

## Enhanced Features

- 🎯 **Unified Command Interface** - Single `myfvm` command with subcommands
- ✅ **Version validation** - Validates version formats and availability
- 🧹 **Auto cleanup** - Removes incomplete installations
- 📋 **Comprehensive listing** - Shows installed and available versions
- ⚙️ **Configuration** - Customizable settings via `.myfvmrc`
- 🔍 **Status checking** - Monitor MyFVM health and configuration
- 🛡️ **Error handling** - Better error messages and recovery suggestions
- 🌐 **Dynamic version fetching** - Fetches latest versions from GitHub API
- 🗄️ **Smart caching** - Caches version data for faster access
- 🔄 **Cache management** - Clear and refresh version cache
