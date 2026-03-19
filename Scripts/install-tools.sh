#!/bin/bash

################################################################################
# eRazOR - Security Tools Installation Script
# Purpose: Install modular security tools from categories
# Usage: bash install-tools.sh [category]
# Categories: reconnaissance, scanning, exploitation, post-exploitation, all
################################################################################

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

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

# Check root
if [ "$EUID" -ne 0 ]; then
   print_error "This script must be run as root"
   exit 1
fi

print_header "eRazOR Security Tools Installation"

# Tool categories
RECONNAISSANCE_TOOLS=(
    "nmap"
    "whois"
    "curl"
    "wget"
    "host"
    "dig"
)

SCANNING_TOOLS=(
    "nmap"
    "netcat-openbsd"
    "tcpdump"
    "wireshark"
)

EXPLOITATION_TOOLS=(
    "metasploit-framework"
    "sqlmap"
)

POST_EXPLOITATION_TOOLS=(
    "enum4linux"
    "linpeas"
)

# Function to install tools from array
install_category() {
    local category=$1
    local -n tools=$2
    
    print_header "Installing $category Tools"
    
    for tool in "${tools[@]}"; do
        echo -e "${BLUE}Installing: $tool${NC}"
        if apt-get install -y "$tool" 2>/dev/null; then
            print_success "$tool installed"
        else
            print_warning "$tool not found or failed to install"
        fi
    done
}

# Installation based on argument
case "${1:-all}" in
    reconnaissance)
        install_category "Reconnaissance" RECONNAISSANCE_TOOLS
        ;;
    scanning)
        install_category "Scanning" SCANNING_TOOLS
        ;;
    exploitation)
        install_category "Exploitation" EXPLOITATION_TOOLS
        ;;
    post-exploitation)
        install_category "Post-Exploitation" POST_EXPLOITATION_TOOLS
        ;;
    all)
        print_header "Installing All Tool Categories"
        install_category "Reconnaissance" RECONNAISSANCE_TOOLS
        install_category "Scanning" SCANNING_TOOLS
        install_category "Exploitation" EXPLOITATION_TOOLS
        install_category "Post-Exploitation" POST_EXPLOITATION_TOOLS
        ;;
    *)
        print_error "Unknown category: $1"
        echo -e "${BLUE}Usage: $0 [category]${NC}"
        echo "Categories:"
        echo "  - reconnaissance"
        echo "  - scanning"
        echo "  - exploitation"
        echo "  - post-exploitation"
        echo "  - all (default)"
        exit 1
        ;;
esac

# Update tool cache
apt-get update
print_success "Tools installation completed!"

echo -e "\n${GREEN}═════════════════════════════════════════════${NC}"
echo -e "${GREEN}Security tools installed successfully!${NC}"
echo -e "${GREEN}═════════════════════════════════════════════${NC}\n"
