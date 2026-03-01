#!/bin/bash

# Setup SSH Keys for User
# This script helps users set up SSH key authentication

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;36m'
NC='\033[0m'

print_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_step() {
    echo -e "${BLUE}[STEP]${NC} $1"
}

echo "================================"
echo "SSH Key Setup for User"
echo "================================"
echo ""

# Check if SSH directory exists
if [ ! -d "$HOME/.ssh" ]; then
    print_step "Creating .ssh directory..."
    mkdir -p "$HOME/.ssh"
    chmod 700 "$HOME/.ssh"
fi

# Check if keys already exist
if [ -f "$HOME/.ssh/id_ed25519" ] || [ -f "$HOME/.ssh/id_rsa" ]; then
    print_warning "SSH keys already exist"
    echo "Existing keys:"
    ls -la "$HOME/.ssh/" | grep -E "id_.*\.pub"
    echo ""
    read -p "Do you want to create new keys? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_info "Using existing keys"
        exit 0
    fi
fi

# Generate SSH key
print_step "Generating SSH key pair..."
echo ""
echo "Choose key type:"
echo "1) Ed25519 (recommended, modern)"
echo "2) RSA 4096 (compatible with older systems)"
read -p "Enter choice (1 or 2): " key_type

case $key_type in
    1)
        print_info "Generating Ed25519 key..."
        ssh-keygen -t ed25519 -C "$USER@$(hostname)"
        KEY_FILE="$HOME/.ssh/id_ed25519"
        ;;
    2)
        print_info "Generating RSA 4096 key..."
        ssh-keygen -t rsa -b 4096 -C "$USER@$(hostname)"
        KEY_FILE="$HOME/.ssh/id_rsa"
        ;;
    *)
        print_warning "Invalid choice, using Ed25519"
        ssh-keygen -t ed25519 -C "$USER@$(hostname)"
        KEY_FILE="$HOME/.ssh/id_ed25519"
        ;;
esac

# Set correct permissions
chmod 600 "$KEY_FILE"
chmod 644 "$KEY_FILE.pub"

# Create authorized_keys if it doesn't exist
if [ ! -f "$HOME/.ssh/authorized_keys" ]; then
    touch "$HOME/.ssh/authorized_keys"
    chmod 600 "$HOME/.ssh/authorized_keys"
fi

echo ""
print_info "✅ SSH key pair generated successfully!"
echo ""
echo "Your public key:"
echo "==============="
cat "$KEY_FILE.pub"
echo ""
echo "Key location: $KEY_FILE"
echo "Public key location: $KEY_FILE.pub"
echo ""
echo "Next steps:"
echo "----------"
echo "1. Copy your public key to remote servers:"
echo "   ssh-copy-id user@remote-server"
echo ""
echo "2. Or manually add it to remote ~/.ssh/authorized_keys"
echo ""
echo "3. Test connection:"
echo "   ssh user@remote-server"
echo ""
