#!/bin/bash

# MyFVM Release Script
# Helps create new releases with proper versioning

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Check if we're in a git repository
if [ ! -d ".git" ]; then
    print_error "Not in a git repository"
    exit 1
fi

# Check if VERSION file exists
if [ ! -f "VERSION" ]; then
    print_error "VERSION file not found"
    exit 1
fi

# Get current version
current_version=$(cat VERSION | head -1 | tr -d '\n\r')
print_info "Current version: $current_version"

# Get new version
echo ""
read -p "Enter new version (current: $current_version): " new_version

if [ -z "$new_version" ]; then
    print_error "Version cannot be empty"
    exit 1
fi

# Validate version format (basic semantic versioning)
if ! echo "$new_version" | grep -qE '^[0-9]+\.[0-9]+\.[0-9]+$'; then
    print_error "Invalid version format. Use semantic versioning (e.g., 1.2.3)"
    exit 1
fi

# Check if version already exists
if git tag | grep -q "v$new_version"; then
    print_error "Version v$new_version already exists"
    exit 1
fi

# Update VERSION file
echo "$new_version" > VERSION
print_success "Updated VERSION file to $new_version"

# Update CHANGELOG.md
print_info "Please update CHANGELOG.md with the new version details"
echo ""
echo "Add a new section like:"
echo "## [$new_version] - $(date +%Y-%m-%d)"
echo ""
read -p "Press Enter when CHANGELOG.md is updated..."

# Check for uncommitted changes
if ! git diff --quiet; then
    print_warning "You have uncommitted changes"
    git status
    echo ""
    read -p "Do you want to commit these changes? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        git add .
        git commit -m "Release v$new_version"
        print_success "Changes committed"
    else
        print_error "Please commit or stash changes before releasing"
        exit 1
    fi
fi

# Create and push tag
print_info "Creating tag v$new_version..."
git tag "v$new_version"
print_success "Tag v$new_version created"

# Push changes and tags
print_info "Pushing changes and tags..."
git push origin main
git push origin "v$new_version"
print_success "Release v$new_version pushed to GitHub"

echo ""
print_success "🎉 Release v$new_version completed!"
echo ""
echo "Release details:"
echo "  Version: $new_version"
echo "  Tag: v$new_version"
echo "  Branch: main"
echo ""
echo "Users can now install/update to v$new_version:"
echo "  curl -fsSL https://raw.githubusercontent.com/Souieh/myfvm/main/install.sh | bash"
echo "  myfvm.sh update"
