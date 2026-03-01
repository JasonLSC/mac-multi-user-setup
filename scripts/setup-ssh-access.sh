#!/bin/bash

# SSH Remote Access Setup Script
# Configures Mac mini for remote SSH access from external networks

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;36m'
NC='\033[0m'

print_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_step() {
    echo -e "${BLUE}[STEP]${NC} $1"
}

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    print_error "Please run as root (use sudo)"
    exit 1
fi

echo "================================"
echo "SSH Remote Access Setup"
echo "================================"
echo ""

# 1. Enable Remote Login (SSH)
print_step "1. Enabling SSH Remote Login..."
systemsetup -setremotelogin on
print_info "SSH service enabled"

# 2. Check SSH service status
print_step "2. Checking SSH service status..."
if launchctl list | grep -q "com.openssh.sshd"; then
    print_info "SSH service is running"
else
    print_warning "SSH service not running, attempting to start..."
    launchctl load -w /System/Library/LaunchDaemons/com.openssh.sshd.plist 2>/dev/null || true
fi

# 3. Configure SSH for security
print_step "3. Configuring SSH security settings..."

SSHD_CONFIG="/etc/ssh/sshd_config"
SSHD_CONFIG_BACKUP="/etc/ssh/sshd_config.backup.$(date +%Y%m%d_%H%M%S)"

# Backup original config
cp "$SSHD_CONFIG" "$SSHD_CONFIG_BACKUP"
print_info "Backed up SSH config to $SSHD_CONFIG_BACKUP"

# Create custom SSH config
cat > /etc/ssh/sshd_config.d/custom.conf << 'EOF'
# Custom SSH Configuration for Multi-User Setup

# Change default port (recommended for security)
# Port 2222

# Disable root login
PermitRootLogin no

# Enable public key authentication
PubkeyAuthentication yes

# Disable password authentication (uncomment after setting up SSH keys)
# PasswordAuthentication no

# Allow specific users (add your users here)
# AllowUsers user1 user2 user3

# Disable empty passwords
PermitEmptyPasswords no

# Enable strict mode
StrictModes yes

# Logging
SyslogFacility AUTH
LogLevel INFO

# Connection settings
MaxAuthTries 3
MaxSessions 10

# Keep alive
ClientAliveInterval 300
ClientAliveCountMax 2

# Disable X11 forwarding if not needed
X11Forwarding no

# Enable TCP keep alive
TCPKeepAlive yes
EOF

print_info "SSH security configuration created"

# 4. Get network information
print_step "4. Network Information..."
echo ""
echo "Local IP addresses:"
ifconfig | grep "inet " | grep -v 127.0.0.1 | awk '{print "  - " $2}'
echo ""

# 5. Check firewall status
print_step "5. Checking firewall status..."
FIREWALL_STATUS=$(defaults read /Library/Preferences/com.apple.alf globalstate 2>/dev/null || echo "0")

if [ "$FIREWALL_STATUS" = "0" ]; then
    print_warning "Firewall is disabled"
    echo "  Consider enabling it: System Settings > Network > Firewall"
else
    print_info "Firewall is enabled"
    # Add SSH to firewall exceptions
    /usr/libexec/ApplicationFirewall/socketfilterfw --add /usr/sbin/sshd 2>/dev/null || true
    /usr/libexec/ApplicationFirewall/socketfilterfw --unblockapp /usr/sbin/sshd 2>/dev/null || true
    print_info "SSH added to firewall exceptions"
fi

# 6. Restart SSH service
print_step "6. Restarting SSH service..."
launchctl unload /System/Library/LaunchDaemons/com.openssh.sshd.plist 2>/dev/null || true
launchctl load -w /System/Library/LaunchDaemons/com.openssh.sshd.plist 2>/dev/null || true
print_info "SSH service restarted"

# 7. Display connection information
echo ""
echo "================================"
echo "✅ SSH Remote Access Configured!"
echo "================================"
echo ""
echo "Connection Information:"
echo "----------------------"
echo "Local Network Access:"
ifconfig | grep "inet " | grep -v 127.0.0.1 | awk '{print "  ssh username@" $2}'
echo ""
echo "Default SSH Port: 22"
echo "  (Change in /etc/ssh/sshd_config.d/custom.conf if needed)"
echo ""
echo "Next Steps:"
echo "----------"
echo "1. Set up port forwarding on your router (if behind NAT)"
echo "2. Configure SSH keys for secure access"
echo "3. Consider changing the default SSH port"
echo "4. Update firewall rules if necessary"
echo ""
echo "For external access setup, see: docs/remote-access.md"
echo ""
