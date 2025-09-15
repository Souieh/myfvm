#!/bin/bash

# MyFVM - Flutter Version Manager
# Unified command-line interface

COMMAND=$1
shift  # Remove the first argument (command) from $@

# Get the directory where this script is located
# Handle symlinks properly
if [ -L "${BASH_SOURCE[0]}" ]; then
    SCRIPT_DIR="$(cd "$(dirname "$(readlink "${BASH_SOURCE[0]}")")" && pwd)"
else
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
fi

# Function to show help
show_help() {
    echo "🚀 MyFVM - Custom Flutter Version Manager"
    echo "=========================================="
    echo ""
    echo "Usage: myfvm <command> [options]"
    echo ""
    echo "📋 Available Commands:"
    echo ""
    echo "  📦 Installation:"
    echo "    install <version>     - Install a Flutter version"
    echo "    uninstall <version>  - Remove a Flutter version"
    echo ""
    echo "  🔄 Management:"
    echo "    switch <version>     - Switch to a version"
    echo "    list                 - List installed versions"
    echo "    current              - Show current version info"
    echo ""
    echo "  🔍 Information:"
    echo "    versions [version]   - Show available versions"
    echo "    cleanup              - Clean up incomplete installations"
    echo "    cache <command>      - Manage version cache"
    echo ""
    echo "  🛠️  Utility:"
    echo "    help                 - Show this help"
    echo "    version              - Show MyFVM version"
    echo "    status               - Check MyFVM status"
    echo "    update               - Update MyFVM to latest version"
    echo ""
    echo "📖 Examples:"
    echo "  myfvm install 3.24.5     # Install Flutter 3.24.5"
    echo "  myfvm switch 3.35.3      # Switch to Flutter 3.35.3"
    echo "  myfvm list               # List all installed versions"
    echo "  myfvm versions 3.24.5    # Validate version 3.24.5"
    echo "  myfvm cache clear        # Clear version cache"
    echo "  myfvm update             # Update MyFVM"
    echo ""
    echo "📁 Directory Structure:"
    echo "  ~/flutter/                 # Flutter versions storage"
    echo "  ~/.fvm/current            # Symlink to active version"
    echo ""
    echo "🔧 Configuration:"
    echo "  ~/.myfvmrc                # Configuration file"
}

# Function to show version
show_version() {
    # Get version from VERSION file
    local version_file="$(dirname "$0")/../VERSION"
    local myfvm_version="1.0.0"  # fallback
    
    if [ -f "$version_file" ]; then
        myfvm_version=$(cat "$version_file" | head -1 | tr -d '\n\r')
    fi
    
    echo "MyFVM version: $myfvm_version"
    echo "Flutter versions supported: 3.19.6+"
    
    # Show git info if available
    local git_dir="$(dirname "$0")/../.git"
    if [ -d "$git_dir" ]; then
        local git_commit=$(cd "$(dirname "$0")/.." && git rev-parse --short HEAD 2>/dev/null)
        local git_branch=$(cd "$(dirname "$0")/.." && git branch --show-current 2>/dev/null)
        if [ -n "$git_commit" ]; then
            echo "Git commit: $git_commit"
            echo "Git branch: $git_branch"
        fi
    fi
}

# Function to show status
show_status() {
    echo "🔍 MyFVM Status:"
    echo "================"
    echo ""
    
    # Check if Flutter directory exists
    if [ -d "$HOME/flutter" ]; then
        echo "✅ Flutter directory: $HOME/flutter"
    else
        echo "❌ Flutter directory: Not created yet"
    fi
    
    # Check if FVM directory exists
    if [ -d "$HOME/.fvm" ]; then
        echo "✅ FVM directory: $HOME/.fvm"
    else
        echo "❌ FVM directory: Not created yet"
    fi
    
    # Check current symlink
    if [ -L "$HOME/.fvm/current" ]; then
        current_path=$(readlink "$HOME/.fvm/current")
        current_version=$(basename "$current_path" | sed 's/flutter-//')
        echo "✅ Current version: $current_version"
        echo "📍 Location: $current_path"
    else
        echo "❌ Current version: None set"
    fi
    
    # Check PATH
    if echo "$PATH" | grep -q "\.fvm/current/bin"; then
        echo "✅ Flutter in PATH: Yes"
    else
        echo "❌ Flutter in PATH: No"
        echo "   Add to PATH: export PATH=\"\$HOME/.fvm/current/bin:\$PATH\""
    fi
}

# Function to update MyFVM
update_myfvm() {
    echo "🔄 Updating MyFVM..."
    echo ""
    
    # Find MyFVM installation directory
    local myfvm_dir=""
    if [ -L "$(which myfvm 2>/dev/null)" ]; then
        # If myfvm is a symlink, find the real path
        local symlink_path=$(which myfvm)
        myfvm_dir=$(dirname "$(readlink "$symlink_path")")
        myfvm_dir=$(dirname "$myfvm_dir")  # Go up one level from bin/
    elif [ -f "$HOME/.local/share/myfvm/bin/myfvm" ]; then
        myfvm_dir="$HOME/.local/share/myfvm"
    elif [ -f "$HOME/Projects/myfvm/bin/myfvm" ]; then
        myfvm_dir="$HOME/Projects/myfvm"
    else
        echo "❌ Could not find MyFVM installation directory"
        echo ""
        echo "Please run the installation script again:"
        echo "  curl -fsSL https://raw.githubusercontent.com/souieh/myfvm/main/install.sh | bash"
        exit 1
    fi
    
    echo "📍 MyFVM directory: $myfvm_dir"
    
    # Check if it's a git repository
    if [ -d "$myfvm_dir/.git" ]; then
        echo "🔄 Pulling latest changes..."
        cd "$myfvm_dir"
        
        # Check for updates
        git fetch origin main >/dev/null 2>&1
        local_behind=$(git rev-list --count HEAD..origin/main 2>/dev/null || echo "0")
        
        if [ "$local_behind" -gt 0 ]; then
            echo "📥 Found $local_behind new commits"
            git pull origin main
            
            # Make scripts executable
            chmod +x "$myfvm_dir/bin/"*
            
            echo "✅ MyFVM updated successfully!"
            echo ""
            echo "New version:"
            "$myfvm_dir/bin/myfvm.sh" version
        else
            echo "✅ MyFVM is already up to date!"
        fi
    else
        echo "❌ MyFVM installation is not a git repository"
        echo ""
        echo "Please reinstall MyFVM:"
        echo "  curl -fsSL https://raw.githubusercontent.com/souieh/myfvm/main/install.sh | bash"
        exit 1
    fi
}

# Function to run a subcommand script
run_subcommand() {
    local script_name="$1"
    shift  # Remove script_name from arguments
    local script_path="$SCRIPT_DIR/flutter-$script_name"
    
    if [ -f "$script_path" ]; then
        "$script_path" "$@"
    else
        echo "❌ Command '$script_name' not found"
        echo ""
        echo "Available commands: install, uninstall, switch, list, current, versions, cleanup, cache, update"
        exit 1
    fi
}

# Main command handling
case $COMMAND in
    install)
        run_subcommand "install" "$@"
        ;;
    uninstall)
        run_subcommand "uninstall" "$@"
        ;;
    switch)
        run_subcommand "switch" "$@"
        ;;
    list)
        run_subcommand "list" "$@"
        ;;
    current)
        run_subcommand "current" "$@"
        ;;
    versions)
        run_subcommand "versions" "$@"
        ;;
    cleanup)
        run_subcommand "cleanup" "$@"
        ;;
    cache)
        run_subcommand "cache" "$@"
        ;;
    update)
        update_myfvm
        ;;
    help|--help|-h)
        show_help
        ;;
    version|--version|-v)
        show_version
        ;;
    status)
        show_status
        ;;
    "")
        show_help
        ;;
    *)
        echo "❌ Unknown command: $COMMAND"
        echo ""
        echo "Available commands:"
        echo "  install, uninstall, switch, list, current, versions, cleanup, cache, update, help, version, status"
        echo ""
        echo "Use 'myfvm help' for detailed information"
        exit 1
        ;;
esac