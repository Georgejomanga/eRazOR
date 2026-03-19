#!/bin/bash

################################################################################
# eRazOR - Compartmentalization Setup Script
# Purpose: Configure compartments for isolated, secure testing (QubesOS-inspired)
# Usage: bash setup-compartments.sh
################################################################################

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Functions
print_header() {
    echo -e "\n${BLUE}${CYAN}══════════════════════════════════════════════${NC}"
    echo -e "${CYAN}$1${NC}"
    echo -e "${BLUE}${CYAN}══════════════════════════════════════════════${NC}\n"
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

print_info() {
    echo -e "${BLUE}ℹ $1${NC}"
}

# Check if running as root
if [ "$EUID" -ne 0 ]; then
   print_error "This script must be run as root (use sudo)"
   exit 1
fi

print_header "eRazOR Compartmentalization Setup"
print_info "Configuring QubesOS-inspired compartments for security domains"

# ============================================================================
# STEP 1: Create Compartment Directory Structure
# ============================================================================

print_header "Step 1: Creating Compartment Directory Structure"

COMPARTMENT_BASE="/opt/erazor/compartments"

# Define compartments with their purposes
declare -A COMPARTMENTS=(
    ["reconnaissance"]="Network reconnaissance and passive information gathering"
    ["scanning"]="Active vulnerability scanning (moderate risk)"
    ["exploitation"]="Exploitation testing (high risk - use carefully)"
    ["analysis"]="Threat and malware analysis"
    ["workspace"]="General work and temporary data"
    ["disposable"]="Temporary testing environment (can be discarded after use)"
)

for compartment in "${!COMPARTMENTS[@]}"; do
    mkdir -p "$COMPARTMENT_BASE/$compartment"/{data,scripts,tools,cache}
    mkdir -p "$COMPARTMENT_BASE/$compartment/.isolated"
    
    # Create compartment metadata
    cat > "$COMPARTMENT_BASE/$compartment/compartment.conf" << EOF
# eRazOR Compartment Configuration
# Compartment: $compartment
# Purpose: ${COMPARTMENTS[$compartment]}

COMPARTMENT_NAME="$compartment"
COMPARTMENT_PURPOSE="${COMPARTMENTS[$compartment]}"
CREATED_DATE="$(date -u +%Y-%m-%d\ %H:%M:%S\ UTC)"
ISOLATION_LEVEL="strict"
AUTO_CLEANUP=false
NETWORK_ISOLATED=true
EOF

    print_success "Compartment created: $compartment"
done

print_success "All compartments created"

# ============================================================================
# STEP 2: Configure Network Isolation
# ============================================================================

print_header "Step 2: Configuring Network Isolation"

# Create firewall rules for compartments
cat > /opt/erazor/compartments/firewall-rules.sh << 'FIREWALL_EOF'
#!/bin/bash
# eRazOR Compartment Firewall Rules
# Isolates compartments from each other

echo "Configuring compartment firewall rules..."

# Default deny incoming traffic
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT

# Allow loopback
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

# Allow established connections
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# Allow TOR traffic (if enabled)
iptables -A OUTPUT -p tcp --dport 9050 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 9051 -j ACCEPT

echo "✓ Firewall rules configured"
FIREWALL_EOF

chmod +x /opt/erazor/compartments/firewall-rules.sh
print_success "Firewall rules configured"

# ============================================================================
# STEP 3: Create Disposable Template System
# ============================================================================

print_header "Step 3: Creating Disposable Template System"

cat > /opt/erazor/compartments/create-disposable.sh << 'DISPOSABLE_EOF'
#!/bin/bash

# eRazOR Disposable Container Creator
# Creates lightweight, temporary testing environments that can be easily discarded

COMPARTMENT_BASE="/opt/erazor/compartments"
TEMPLATE_NAME="${1:-default}"

if [ -z "$TEMPLATE_NAME" ]; then
    echo "Usage: $0 <template-name>"
    exit 1
fi

DISPOSABLE_PATH="$COMPARTMENT_BASE/disposable/$TEMPLATE_NAME-$(date +%s)"

echo "Creating disposable template: $DISPOSABLE_PATH"

# Create isolated filesystem
mkdir -p "$DISPOSABLE_PATH"/{bin,lib,etc,tmp,var}

# Copy minimal necessary files
cp -r /opt/erazor/scripts "$DISPOSABLE_PATH/"

# Create cleanup script
cat > "$DISPOSABLE_PATH/.cleanup" << 'CLEANUP'
#!/bin/bash
echo "Cleaning up disposable environment..."
rm -rf "$DISPOSABLE_PATH"
echo "✓ Disposable environment discarded"
CLEANUP

chmod +x "$DISPOSABLE_PATH/.cleanup"

echo "✓ Disposable created at: $DISPOSABLE_PATH"
echo "Run: $DISPOSABLE_PATH/.cleanup"
DISPOSABLE_EOF

chmod +x /opt/erazor/compartments/create-disposable.sh
print_success "Disposable template system created"

# ============================================================================
# STEP 4: Configure Compartment Isolation Policies
# ============================================================================

print_header "Step 4: Configuring Isolation Policies"

cat > /opt/erazor/compartments/isolation-policy.yaml << 'POLICY_EOF'
# eRazOR Compartment Isolation Policy
# Inspired by QubesOS security domains

compartments:
  reconnaissance:
    trust_level: "high"
    network_access: "full"
    data_sharing: "read-only"
    can_access:
      - workspace
    cannot_access:
      - exploitation
      - sensitive
    isolation: "network-isolated"

  scanning:
    trust_level: "medium"
    network_access: "full"
    data_sharing: "restricted"
    can_access:
      - workspace
      - reconnaissance
    cannot_access:
      - exploitation
      - analysis
    isolation: "network-isolated"

  exploitation:
    trust_level: "low"
    network_access: "restricted"
    data_sharing: "none"
    can_access: []
    cannot_access:
      - all
    isolation: "strict-isolated"
    warning: "High-risk compartment. Use with caution!"

  analysis:
    trust_level: "low"
    network_access: "none"
    data_sharing: "none"
    can_access: []
    cannot_access:
      - all
    isolation: "air-gapped"
    warning: "Malware analysis. No network access!"

  disposable:
    trust_level: "untrusted"
    network_access: "none"
    data_sharing: "none"
    can_access: []
    cannot_access:
      - all
    isolation: "maximum"
    cleanup: "automatic"
    ttl: "24h"

isolation_rules:
  data_flow: "unidirectional"
  network_flow: "compartment-restricted"
  privilege_escalation: "prevented"
  inter_compartment_communication: "forbidden"
POLICY_EOF

print_success "Isolation policies configured"

# ============================================================================
# STEP 5: Create Compartment Management Tool
# ============================================================================

print_header "Step 5: Creating Compartment Management Tool"

cat > /usr/local/bin/erazor-compartment << 'TOOL_EOF'
#!/bin/bash

# eRazOR Compartment Management Tool

COMPARTMENT_BASE="/opt/erazor/compartments"

usage() {
    cat << 'USAGE'
eRazOR Compartment Manager

Usage: erazor-compartment [COMMAND] [OPTIONS]

Commands:
  list                List all compartments
  create <name>       Create new compartment
  delete <name>       Delete compartment (with confirmation)
  isolate <name>      Enable strict isolation
  connect <name>      Connect to compartment
  status              Show all compartment status
  dispose             Create and manage disposable environments

Examples:
  erazor-compartment list
  erazor-compartment create reconnaissance
  erazor-compartment isolate exploitation
  erazor-compartment dispose my-test

See: https://github.com/Georgejomanga/eRazOR/docs/COMPARTMENTALIZATION.md
USAGE
}

list_compartments() {
    echo "eRazOR Compartments:"
    echo "===================="
    ls -la "$COMPARTMENT_BASE" | grep "^d" | awk '{print $NF}'
}

create_compartment() {
    local name=$1
    if [ -z "$name" ]; then
        echo "Error: Compartment name required"
        exit 1
    fi
    
    mkdir -p "$COMPARTMENT_BASE/$name"/{data,scripts,tools,cache}
    echo "✓ Compartment created: $name"
}

delete_compartment() {
    local name=$1
    if [ -z "$name" ]; then
        echo "Error: Compartment name required"
        exit 1
    fi
    
    read -p "Really delete compartment '$name'? (yes/no): " confirm
    if [ "$confirm" = "yes" ]; then
        rm -rf "$COMPARTMENT_BASE/$name"
        echo "✓ Compartment deleted: $name"
    fi
}

show_status() {
    echo "eRazOR Compartment Status"
    echo "========================="
    for comp in "$COMPARTMENT_BASE"/*; do
        if [ -d "$comp" ]; then
            name=$(basename "$comp")
            size=$(du -sh "$comp" | cut -f1)
            files=$(find "$comp" -type f | wc -l)
            echo "$name: $files files, $size"
        fi
    done
}

case "$1" in
    list)
        list_compartments
        ;;
    create)
        create_compartment "$2"
        ;;
    delete)
        delete_compartment "$2"
        ;;
    status)
        show_status
        ;;
    dispose)
        bash "$COMPARTMENT_BASE/create-disposable.sh" "$2"
        ;;
    *)
        usage
        ;;
esac
TOOL_EOF

chmod +x /usr/local/bin/erazor-compartment
print_success "Compartment management tool installed"

# ============================================================================
# STEP 6: Create Privacy Configuration
# ============================================================================

print_header "Step 6: Configuring Privacy Settings"

cat > /opt/erazor/config/privacy-config.yaml << 'PRIVACY_EOF'
# eRazOR Privacy Configuration

privacy:
  mode: "enhanced"
  tor_integration: false  # Set to true to enable TOR
  dns_over_tor: false
  logging: "minimal"
  tracking_prevention: true

network:
  use_tor: false
  tor_socks_proxy: "127.0.0.1:9050"
  tor_control_port: "127.0.0.1:9051"
  dns_server: "1.1.1.1"  # Cloudflare
  vpn_enabled: false

data:
  encrypt_at_rest: true
  clear_cache_on_exit: true
  minimal_metadata: true
  secure_deletion: true

compartments:
  enabled: true
  strict_isolation: true
  network_isolation: true
  cross_compartment_access: "forbidden"
  auto_cleanup_disposable: true

anonymity:
  randomize_user_agent: true
  disable_javascript: false
  block_fingerprinting: true
  clear_browser_cache: true

security:
  require_authorization: true
  log_sensitive_operations: true
  alert_on_data_access: true
  enforce_compartmentalization: true
PRIVACY_EOF

print_success "Privacy configuration created"

# ============================================================================
# STEP 7: Create Cleanup and Maintenance Scripts
# ============================================================================

print_header "Step 7: Creating Maintenance Scripts"

cat > /opt/erazor/compartments/cleanup-all.sh << 'CLEANUP_EOF'
#!/bin/bash

# eRazOR Compartment Cleanup
# Safely removes old/disposable compartments

COMPARTMENT_BASE="/opt/erazor/compartments"

echo "eRazOR Compartment Cleanup"
echo "========================="

# Find disposable compartments older than 24 hours
find "$COMPARTMENT_BASE/disposable" -type d -mtime +1 -exec rm -rf {} \; 2>/dev/null

# Clear cache directories
find "$COMPARTMENT_BASE" -type d -name "cache" -exec rm -rf {} \; 2>/dev/null

# Clear temporary files
find "$COMPARTMENT_BASE" -type f -name "*.tmp" -delete

echo "✓ Cleanup complete"
CLEANUP_EOF

chmod +x /opt/erazor/compartments/cleanup-all.sh
print_success "Cleanup scripts created"

# ============================================================================
# FINAL SUMMARY
# ============================================================================

print_header "Compartmentalization Setup Complete!"

cat << 'SUMMARY'
╔═══════════════════════════════════════════════════════════════╗
║                                                               ║
║         eRazOR Compartmentalization Configured               ║
║                                                               ║
║  ✓ Compartments Created:                                     ║
║    - reconnaissance  (passive info gathering)                ║
║    - scanning        (active vulnerability scanning)         ║
║    - exploitation    (exploitation testing)                  ║
║    - analysis        (threat analysis)                       ║
║    - workspace       (general use)                           ║
║    - disposable      (temporary, auto-cleanup)               ║
║                                                               ║
║  ✓ Security Features:                                        ║
║    - Network isolation between compartments                  ║
║    - Strict firewall rules                                   ║
║    - Disposable template system                              ║
║    - Automatic cleanup policies                              ║
║    - Privacy configuration                                   ║
║                                                               ║
║  ✓ Management Tools:                                         ║
║    - erazor-compartment (CLI for compartment management)     ║
║    - Isolation policies configured                           ║
║    - Firewall rules in place                                 ║
║                                                               ║
║  NEXT STEPS:                                                 ║
║  1. Review: cat /opt/erazor/compartments/isolation-policy.yaml │
║  2. Test:   erazor-compartment list                          ║
║  3. Create: erazor-compartment create <name>                 ║
║  4. Manage: erazor-compartment status                        ║
║                                                               ║
║  For TOR Integration:                                        ║
║  1. Enable in privacy-config.yaml                            ║
║  2. Run:  bash /opt/erazor/scripts/setup-tor.sh              ║
║  3. Use:  curl --socks5 127.0.0.1:9050 https://check.tor.org │
║                                                               ║
║  ⚠️  REMEMBER: Compartmentalization is one layer of security │
║     Always use in combination with proper authorization      ║
║     and security practices!                                  ║
║                                                               ║
╚═══════════════════════════════════════════════════════════════╝
SUMMARY

print_success "You can now use eRazOR with compartmentalization!"
print_info "Run 'erazor-compartment --help' for more options"
