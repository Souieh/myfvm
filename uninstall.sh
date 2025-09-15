#!/bin/bash

# MyFVM Uninstallation Script
# Removes MyFVM installation

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🗑️  MyFVM Uninstaller${NC}"
echo -e "${BLUE}=====================${NC}"
echo ""

# Function to print colored messages
print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

# Find MyFVM installation
myfvm_dir=""
if [ -L "$(which myfvm 2>/dev/null)" ]; then
    # If myfvm is a symlink, find the real path
    symlink_path=$(which myfvm)
    myfvm_dir=$(dirname "$(readlink "$symlink_path")")
    myfvm_dir=$(dirname "$myfvm_dir")  # Go up one level from bin/
elif [ -f "$HOME/.local/share/myfvm/bin/myfvm.sh" ]; then
    myfvm_dir="$HOME/.local/share/myfvm"
elif [ -f "$HOME/Projects/myfvm/bin/myfvm.sh" ]; then
    myfvm_dir="$HOME/Projects/myfvm"
else
    print_error "MyFVM installation not found"
    echo ""
    echo "MyFVM may not be installed or installed in a non-standard location."
    exit 1
fi

print_info "Found MyFVM installation at: $myfvm_dir"

# Confirm uninstallation
echo ""
print_warning "This will remove MyFVM and all its files, but will NOT remove:"
echo "  - Installed Flutter versions (~/flutter/)"
echo "  - Flutter symlinks (~/.fvm/)"
echo "  - Configuration files (~/.myfvmrc)"
echo ""
read -p "Are you sure you want to uninstall MyFVM? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    print_info "Uninstallation cancelled."
    exit 0
fi

# Remove symlink
if [ -L "$HOME/.local/bin/myfvm" ]; then
    print_info "Removing symlink..."
    rm -f "$HOME/.local/bin/myfvm"
    print_success "Symlink removed"
fi

# Remove installation directory
if [ -d "$myfvm_dir" ]; then
    print_info "Removing MyFVM installation directory..."
    rm -rf "$myfvm_dir"
    print_success "Installation directory removed"
fi

# Check if PATH needs to be cleaned up
if grep -q "$HOME/.local/bin" ~/.bashrc 2>/dev/null; then
    print_warning "Found $HOME/.local/bin in your ~/.bashrc"
    echo "You may want to remove it if you don't use other tools from there:"
    echo "  sed -i '/export PATH=\"\$HOME\/.local\/bin:\$PATH\"/d' ~/.bashrc"
fi

print_success "MyFVM uninstalled successfully!"
echo ""
echo "Note: Your Flutter installations and configuration are preserved."
echo "To reinstall MyFVM:"
echo "  curl -fsSL https://raw.githubusercontent.com/souieh/myfvm/main/install.sh | bash"
