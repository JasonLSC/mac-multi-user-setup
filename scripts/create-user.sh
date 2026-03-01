#!/bin/bash

# Mac Multi-User Setup Script
# This script sets up a complete development environment for a new user

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored messages
print_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    print_error "Please run as root (use sudo)"
    exit 1
fi

# Get username
if [ -z "$1" ]; then
    print_error "Usage: sudo ./create-user.sh <username> [api_key]"
    exit 1
fi

USERNAME=$1
API_KEY=$2
USER_HOME="/Users/$USERNAME"

print_info "Creating user: $USERNAME"

# Create user account
if id "$USERNAME" &>/dev/null; then
    print_warning "User $USERNAME already exists"
else
    # Create user with sysadminctl
    sysadminctl -addUser "$USERNAME" -fullName "$USERNAME" -password - -admin
    print_info "User $USERNAME created successfully"
fi

# Wait for home directory to be created
sleep 2

# Switch to user context for installations
print_info "Setting up development environment for $USERNAME..."

# Function to run commands as the target user
run_as_user() {
    sudo -u "$USERNAME" bash -c "$1"
}

# 1. Install Homebrew (if not already installed system-wide)
print_info "Checking Homebrew installation..."
if ! command -v brew &> /dev/null; then
    print_info "Installing Homebrew..."
    run_as_user 'NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'

    # Add Homebrew to PATH
    if [[ $(uname -m) == 'arm64' ]]; then
        run_as_user 'echo "eval \"\$(/opt/homebrew/bin/brew shellenv)\"" >> ~/.zprofile'
        run_as_user 'eval "$(/opt/homebrew/bin/brew shellenv)"'
    else
        run_as_user 'echo "eval \"\$(/usr/local/bin/brew shellenv)\"" >> ~/.zprofile'
    fi
fi

# 2. Install essential packages
print_info "Installing essential packages..."
run_as_user 'brew install tmux git curl wget zsh'

# 3. Install Oh My Zsh
print_info "Installing Oh My Zsh..."
run_as_user 'sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended'

# 4. Install Powerlevel10k theme
print_info "Installing Powerlevel10k theme..."
run_as_user 'git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k'

# 5. Install Zsh plugins
print_info "Installing Zsh plugins..."
run_as_user 'git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions'
run_as_user 'git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting'
run_as_user 'git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-completions'

# 6. Copy configuration templates
print_info "Copying configuration files..."
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATE_DIR="$SCRIPT_DIR/../templates"

cp "$TEMPLATE_DIR/.zshrc" "$USER_HOME/.zshrc"
cp "$TEMPLATE_DIR/.tmux.conf" "$USER_HOME/.tmux.conf"
chown "$USERNAME:staff" "$USER_HOME/.zshrc" "$USER_HOME/.tmux.conf"

# 7. Install Claude Code
print_info "Installing Claude Code..."
run_as_user 'brew install claude'

# 8. Configure Claude Code API key
if [ -n "$API_KEY" ]; then
    print_info "Configuring Claude Code API key..."
    run_as_user "mkdir -p ~/.claude"
    run_as_user "echo '{\"apiKey\": \"$API_KEY\"}' > ~/.claude/config.json"
    print_info "API key configured"
else
    print_warning "No API key provided. User will need to configure manually with: claude config"
fi

# 9. Set Zsh as default shell
print_info "Setting Zsh as default shell..."
chsh -s /bin/zsh "$USERNAME"

# 10. Create a welcome message
cat > "$USER_HOME/.welcome" << 'EOF'
Welcome to your development environment!

Quick start:
- Claude Code: Run 'claude' to start
- Tmux: Run 'tmux' to start a session
- Aliases: 'cc' for claude, 'ta' for tmux attach

Configuration files:
- ~/.zshrc - Shell configuration
- ~/.tmux.conf - Tmux configuration
- ~/.claude/ - Claude Code settings

For help: https://github.com/your-repo/mac-multi-user-setup
EOF

chown "$USERNAME:staff" "$USER_HOME/.welcome"

# Add welcome message to .zshrc
run_as_user 'echo "\n# Display welcome message on first login" >> ~/.zshrc'
run_as_user 'echo "if [ -f ~/.welcome ]; then cat ~/.welcome; fi" >> ~/.zshrc'

print_info "✅ Setup complete for user: $USERNAME"
print_info "User can now log in and start using the environment"
print_info ""
print_info "Next steps:"
print_info "1. User should log in: su - $USERNAME"
print_info "2. Configure Claude Code (if API key not provided): claude config"
print_info "3. Start tmux session: tmux new -s main"
print_info "4. Start Claude Code: claude"
