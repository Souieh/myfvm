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

# Install bash completion
print_info "Installing bash completion..."
if [ -d "$INSTALL_DIR/completions" ]; then
    # Create completion directory if it doesn't exist
    mkdir -p "$HOME/.local/share/bash-completion/completions" 2>/dev/null || true
    
    # Copy completion file
    if [ -f "$INSTALL_DIR/completions/myfvm" ]; then
        cp "$INSTALL_DIR/completions/myfvm" "$HOME/.local/share/bash-completion/completions/"
        print_success "Bash completion installed"
    fi
fi

# Install man pages
print_info "Installing man pages..."
if [ -d "$INSTALL_DIR/man" ]; then
    # Create man directory if it doesn't exist
    mkdir -p "$HOME/.local/share/man/man1" 2>/dev/null || true
    
    # Copy man pages
    if [ -f "$INSTALL_DIR/man/myfvm.sh.1" ]; then
        cp "$INSTALL_DIR/man/"*.1 "$HOME/.local/share/man/man1/" 2>/dev/null || true
        print_success "Man pages installed"
    fi
fi

# Add MyFVM bin directory to PATH
print_info "Adding MyFVM to PATH..."

# Check if MyFVM bin directory is already in PATH
if ! echo "$PATH" | grep -q "$INSTALL_DIR/bin"; then
    # Try to detect shell and suggest the right file
    if [ -n "$ZSH_VERSION" ]; then
        SHELL_RC="$HOME/.zshrc"
    elif [ -n "$BASH_VERSION" ]; then
        SHELL_RC="$HOME/.bashrc"
    else
        SHELL_RC="$HOME/.profile"
    fi
    
    read -p "Do you want to add MyFVM to your PATH automatically? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "export PATH=\"$INSTALL_DIR/bin:\$PATH\"" >> "$SHELL_RC"
        print_success "Added MyFVM to PATH in $SHELL_RC"
        print_warning "Please run 'source $SHELL_RC' or restart your terminal"
    else
        print_warning "MyFVM bin directory is not in your PATH"
        echo ""
        echo "To add it manually, run:"
        echo "  echo 'export PATH=\"$INSTALL_DIR/bin:\$PATH\"' >> $SHELL_RC"
        echo "  source $SHELL_RC"
    fi
else
    print_success "MyFVM bin directory is already in PATH"
fi

# Test installation
print_info "Testing installation..."
if [ -f "$INSTALL_DIR/bin/myfvm.sh" ]; then
    print_success "MyFVM installed successfully!"
    echo ""
    echo "Installation details:"
    echo "  📁 Installation directory: $INSTALL_DIR"
    echo "  📋 Configuration file: $INSTALL_DIR/.myfvmrc"
    echo ""
    echo "Available commands:"
    echo "  myfvm.sh help              # Show help"
    echo "  myfvm.sh install 3.24.5    # Install Flutter 3.24.5"
    echo "  myfvm.sh list              # List installed versions"
    echo "  myfvm.sh status            # Check MyFVM status"
    echo ""
    echo "Direct script access:"
    echo "  flutter-install 3.24.5     # Install Flutter version"
    echo "  flutter-list               # List installed versions"
    echo "  flutter-switch 3.24.5      # Switch to version"
    echo "  flutter-current            # Show current version"
    echo "  flutter-versions           # Show available versions"
    echo "  flutter-cleanup             # Clean up incomplete installs"
    echo "  flutter-cache              # Manage version cache"
    echo ""
    echo "Documentation:"
    echo "  man myfvm.sh               # Manual page for MyFVM"
    echo "  man flutter-install        # Manual page for install command"
    echo "  Tab completion available   # Press Tab for command completion"
    echo ""
    echo "For more information, visit: https://github.com/$GITHUB_USER/$REPO_NAME"
else
    print_error "Installation failed - myfvm.sh not found"
    exit 1
fi
