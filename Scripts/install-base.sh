#!/bin/bash

################################################################################
# eRazOR - Base Installation Script
# Purpose: Install core system packages and setup
# Usage: bash install-base.sh
################################################################################

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Functions
print_header() {
    echo -e "\n${BLUE}============================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}============================================${NC}\n"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

# Check if running as root
if [ "$EUID" -ne 0 ]; then
   print_error "This script must be run as root (use sudo)"
   exit 1
fi

print_header "eRazOR Base Installation"

# Update system
print_header "Updating System Packages"
apt-get update
apt-get upgrade -y
print_success "System packages updated"

# Install essential tools
print_header "Installing Essential Tools"
apt-get install -y \
    build-essential \
    curl \
    wget \
    git \
    vim \
    nano \
    htop \
    tmux \
    net-tools \
    iputils-ping \
    dnsutils \
    whois \
    traceroute \
    openssh-client \
    openssl \
    nmap \
    netcat-openbsd
print_success "Essential tools installed"

# Install Python and dependencies
print_header "Installing Python Environment"
apt-get install -y \
    python3 \
    python3-pip \
    python3-dev \
    python3-venv
python3 -m pip install --upgrade pip setuptools wheel
print_success "Python environment installed"

# Create application structure
print_header "Creating Application Directory Structure"
mkdir -p /opt/erazor/bin
mkdir -p /opt/erazor/lib
mkdir -p /opt/erazor/config
mkdir -p /data/projects
mkdir -p /data/wordlists
mkdir -p /data/payloads
print_success "Directory structure created"

# Setup timezone
print_header "Configuring System Settings"
ln -sf /usr/share/zoneinfo/UTC /etc/localtime
print_success "Timezone set to UTC"

# Setup locale
locale-gen en_US.UTF-8
update-locale LANG=en_US.UTF-8
print_success "Locale configured"

# Security hardening - basic
print_header "Applying Basic Security Hardening"

# Disable unnecessary services
systemctl disable bluetooth.service 2>/dev/null || true
systemctl disable cups.service 2>/dev/null || true
print_success "Unnecessary services disabled"

# Create security notice
cat > /etc/motd << 'EOF'
╔═══════════════════════════════════════════════════════════════╗
║                                                               ║
║           Welcome to eRazOR - Advanced Security OS            ║
║                                                               ║
║  This system is for authorized security testing and          ║
║  penetration testing ONLY.                                   ║
║                                                               ║
║  Unauthorized access to computer systems is ILLEGAL.         ║
║  Always obtain proper authorization before testing.          ║
║                                                               ║
║  By using this system, you agree to all applicable laws      ║
║  and terms of service.                                       ║
║                                                               ║
╚═══════════════════════════════════════════════════════════════╝
EOF
print_success "Security notice created"

# Update package manager cache
apt-get update
print_success "Package cache updated"

# Final checks
print_header "Final System Check"
echo -e "${BLUE}System Information:${NC}"
echo "Hostname: $(hostname)"
echo "Kernel: $(uname -r)"
echo "Python: $(python3 --version)"
echo "Git: $(git --version)"
echo "Pip: $(pip3 --version)"

print_success "Base installation completed successfully!"
print_warning "Next: Run install-tools.sh to add security tools"
print_warning "Then: Run install-ai.sh to setup AI assistant"

echo -e "\n${GREEN}═════════════════════════════════════════════${NC}"
echo -e "${GREEN}eRazOR is ready for tool installation!${NC}"
echo -e "${GREEN}═════════════════════════════════════════════${NC}\n"
