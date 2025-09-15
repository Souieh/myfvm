#!/bin/bash

# MyFVM Installation Script
# Installs MyFVM from GitHub repository

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
GITHUB_USER="souieh"
REPO_NAME="myfvm"
INSTALL_DIR="$HOME/.local/share/myfvm"
BIN_DIR="$HOME/.local/bin"

echo -e "${BLUE}🚀 MyFVM - Custom Flutter Version Manager${NC}"
echo -e "${BLUE}==========================================${NC}"
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

# Check if git is installed
if ! command -v git >/dev/null 2>&1; then
    print_error "Git is not installed. Please install git first."
    echo ""
    echo "Installation commands:"
    echo "  Ubuntu/Debian: sudo apt install git"
    echo "  macOS: brew install git"
    echo "  CentOS/RHEL: sudo yum install git"
    exit 1
fi

# Check if curl is installed
if ! command -v curl >/dev/null 2>&1; then
    print_error "curl is not installed. Please install curl first."
    echo ""
    echo "Installation commands:"
    echo "  Ubuntu/Debian: sudo apt install curl"
    echo "  macOS: brew install curl"
    echo "  CentOS/RHEL: sudo yum install curl"
    exit 1
fi

print_info "Checking system requirements..."

# Create directories
print_info "Creating installation directories..."
mkdir -p "$INSTALL_DIR"
mkdir -p "$BIN_DIR"

# Check if MyFVM is already installed
if [ -d "$INSTALL_DIR/.git" ]; then
    print_warning "MyFVM is already installed at $INSTALL_DIR"
    echo ""
    read -p "Do you want to update it? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        print_info "Updating MyFVM..."
        cd "$INSTALL_DIR"
        git pull origin main
        print_success "MyFVM updated successfully!"
    else
        print_info "Installation cancelled."
        exit 0
    fi
else
    # Clone the repository
    print_info "Cloning MyFVM from GitHub..."
    if git clone "https://github.com/$GITHUB_USER/$REPO_NAME.git" "$INSTALL_DIR"; then
        print_success "Repository cloned successfully!"
    else
        print_error "Failed to clone repository. Please check:"
        echo "  - Internet connection"
        echo "  - Repository URL: https://github.com/$GITHUB_USER/$REPO_NAME"
        echo "  - Repository exists and is public"
        exit 1
    fi
fi

# Make scripts executable
print_info "Setting up permissions..."
chmod +x "$INSTALL_DIR/bin/"*

# Create symlink to myfvm command
print_info "Creating symlink to myfvm command..."
ln -sf "$INSTALL_DIR/bin/myfvm" "$BIN_DIR/myfvm"

# Check if $BIN_DIR is in PATH
if ! echo "$PATH" | grep -q "$BIN_DIR"; then
    print_warning "$BIN_DIR is not in your PATH"
    echo ""
    echo "To add it to your PATH, run:"
    echo "  echo 'export PATH=\"$BIN_DIR:\$PATH\"' >> ~/.bashrc"
    echo "  source ~/.bashrc"
    echo ""
    echo "Or add it to your shell profile:"
    echo "  ~/.zshrc (for zsh)"
    echo "  ~/.profile (for other shells)"
    echo ""
    
    # Try to detect shell and suggest the right file
    if [ -n "$ZSH_VERSION" ]; then
        SHELL_RC="$HOME/.zshrc"
    elif [ -n "$BASH_VERSION" ]; then
        SHELL_RC="$HOME/.bashrc"
    else
        SHELL_RC="$HOME/.profile"
    fi
    
    read -p "Do you want to add $BIN_DIR to your PATH automatically? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "export PATH=\"$BIN_DIR:\$PATH\"" >> "$SHELL_RC"
        print_success "Added $BIN_DIR to PATH in $SHELL_RC"
        print_warning "Please run 'source $SHELL_RC' or restart your terminal"
    fi
fi

# Test installation
print_info "Testing installation..."
if [ -f "$BIN_DIR/myfvm" ]; then
    print_success "MyFVM installed successfully!"
    echo ""
    echo "Installation details:"
    echo "  📁 Installation directory: $INSTALL_DIR"
    echo "  🔗 Command symlink: $BIN_DIR/myfvm"
    echo "  📋 Configuration file: $INSTALL_DIR/.myfvmrc"
    echo ""
    echo "Usage:"
    echo "  myfvm help                 # Show help"
    echo "  myfvm install 3.24.5      # Install Flutter 3.24.5"
    echo "  myfvm list                # List installed versions"
    echo "  myfvm status              # Check MyFVM status"
    echo ""
    echo "For more information, visit: https://github.com/$GITHUB_USER/$REPO_NAME"
else
    print_error "Installation failed - myfvm command not found"
    exit 1
fi
