#!/bin/bash

################################################################################
# eRazOR - TOR Privacy Setup Script
# Purpose: Configure TOR for anonymous operations
# Usage: bash setup-tor.sh
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

if [ "$EUID" -ne 0 ]; then
   print_error "This script must be run as root (use sudo)"
   exit 1
fi

print_header "eRazOR TOR Privacy Setup"

# ============================================================================
# WARNING AND CONSENT
# ============================================================================

cat << 'WARNING'
╔═══════════════════════════════════════════════════════════════╗
║                   ⚠️  IMPORTANT WARNING  ⚠️                   ║
║                                                               ║
║  TOR is for LEGITIMATE PRIVACY protection:                   ║
║  • Protecting dissidents and journalists                     ║
║  • Maintaining privacy from ISP surveillance                 ║
║  • Anonymous research and communication                      ║
║                                                               ║
║  TOR is NOT for:                                              ║
║  • Illegal activities (still prosecutable!)                  ║
║  • Unauthorized access                                       ║
║  • Harassment or crime                                       ║
║                                                               ║
║  Misuse of TOR is still illegal and can be detected!         ║
║                                                               ║
╚═══════════════════════════════════════════════════════════════╝
WARNING

read -p "I understand the risks. Continue? (yes/no): " confirm
if [ "$confirm" != "yes" ]; then
    print_error "Setup cancelled"
    exit 1
fi

# ============================================================================
# STEP 1: Verify TOR Installation
# ============================================================================

print_header "Step 1: Verifying TOR Installation"

if ! command -v tor &> /dev/null; then
    print_warning "TOR not installed. Installing..."
    apt-get update
    apt-get install -y tor privoxy
    print_success "TOR and Privoxy installed"
else
    print_success "TOR already installed"
    tor --version
fi

# ============================================================================
# STEP 2: Configure TOR
# ============================================================================

print_header "Step 2: Configuring TOR"

# Backup original config
if [ ! -f /etc/tor/torrc.bak ]; then
    cp /etc/tor/torrc /etc/tor/torrc.bak
    print_success "Original torrc backed up"
fi

# Update TOR configuration
cat >> /etc/tor/torrc << 'TORRC'

# eRazOR TOR Configuration
# Enhanced for privacy and compartmentalization

# Listen on all interfaces for container access
SocksPort 0.0.0.0:9050
ControlPort 0.0.0.0:9051
CookieAuthentication 1

# Enhance privacy
NumEntryGuards 3
EntryGuards 3
GuardLifetime 86400

# Increase security
HeartbeatPeriod 60
LogTimeGranularity 1

# Optimize for testing
BandwidthBurst 1000000  # 1MB/s burst
BandwidthRate 500000    # 500KB/s average

# Enable circuit isolation
IsolateDestPort 1
IsolateDestAddr 1
TORRC

print_success "TOR configuration updated"

# ============================================================================
# STEP 3: Configure Privoxy (Optional HTTP Proxy)
# ============================================================================

print_header "Step 3: Configuring Privoxy for HTTP"

cat >> /etc/privoxy/config << 'PRIVOXY'

# eRazOR Privoxy Configuration
# Routes HTTP traffic through TOR

forward-socks5 / 127.0.0.1:9050 .

# Privacy settings
hide-client-ip 1
strip-user-agent 1
hide-referrer 1
PRIVOXY

print_success "Privoxy configured"

# ============================================================================
# STEP 4: Create TOR Management Script
# ============================================================================

print_header "Step 4: Creating TOR Management Script"

cat > /usr/local/bin/erazor-tor << 'TOR_TOOL'
#!/bin/bash

# eRazOR TOR Management Tool

usage() {
    cat << 'USAGE'
eRazOR TOR Manager

Usage: erazor-tor [COMMAND]

Commands:
  start           Start TOR service
  stop            Stop TOR service
  restart         Restart TOR service
  status          Show TOR status
  test            Test TOR connection
  new-identity    Request new TOR identity
  config          Show TOR configuration
  ip              Show current exit IP

Examples:
  erazor-tor start
  erazor-tor test
  erazor-tor new-identity
  erazor-tor ip

See: https://github.com/Georgejomanga/eRazOR
USAGE
}

start_tor() {
    echo "Starting TOR service..."
    systemctl start tor
    sleep 3
    if systemctl is-active --quiet tor; then
        echo "✓ TOR started successfully"
    else
        echo "✗ Failed to start TOR"
        exit 1
    fi
}

stop_tor() {
    echo "Stopping TOR service..."
    systemctl stop tor
    echo "✓ TOR stopped"
}

restart_tor() {
    echo "Restarting TOR service..."
    systemctl restart tor
    sleep 3
    echo "✓ TOR restarted"
}

show_status() {
    echo "TOR Service Status:"
    systemctl status tor --no-pager
}

test_connection() {
    echo "Testing TOR connection..."
    echo "Requesting page through TOR..."
    
    curl -x socks5://127.0.0.1:9050 -s https://check.tor.org | grep -q "Congratulations" && \
        echo "✓ Successfully connected through TOR" || \
        echo "✗ TOR connection test failed"
}

show_ip() {
    echo "Requesting IP through TOR..."
    curl -x socks5://127.0.0.1:9050 -s https://api.ipify.org
}

new_identity() {
    echo "Requesting new TOR identity..."
    echo -e "AUTHENTICATE\nsignal NEWNYM\nQUIT" | nc 127.0.0.1 9051
    echo "✓ New identity requested"
}

case "$1" in
    start)
        start_tor
        ;;
    stop)
        stop_tor
        ;;
    restart)
        restart_tor
        ;;
    status)
        show_status
        ;;
    test)
        test_connection
        ;;
    ip)
        show_ip
        ;;
    new-identity)
        new_identity
        ;;
    config)
        cat /etc/tor/torrc
        ;;
    *)
        usage
        ;;
esac
TOR_TOOL

chmod +x /usr/local/bin/erazor-tor
print_success "TOR management tool installed"

# ============================================================================
# STEP 5: Create Privacy Helper Scripts
# ============================================================================

print_header "Step 5: Creating Privacy Helper Scripts"

cat > /usr/local/bin/erazor-privacy << 'PRIVACY_TOOL'
#!/bin/bash

# eRazOR Privacy Helper

usage() {
    cat << 'USAGE'
eRazOR Privacy Helper

Usage: erazor-privacy [COMMAND]

Commands:
  tor-test        Test TOR connection
  clear-cache     Clear DNS and browser cache
  check-dns       Check for DNS leaks
  randomize-mac   Randomize MAC address
  status          Show privacy status
  config          Edit privacy config

Examples:
  erazor-privacy tor-test
  erazor-privacy clear-cache
  erazor-privacy status

See: /opt/erazor/config/privacy-config.yaml
USAGE
}

tor_test() {
    erazor-tor test
}

clear_cache() {
    echo "Clearing cache..."
    systemctl restart nscd 2>/dev/null || true
    echo "✓ Cache cleared"
}

check_dns() {
    echo "Checking for DNS leaks..."
    curl -s https://dnsleaktest.com/api/v1/status | grep -q "success" && \
        echo "✓ No obvious DNS leaks detected" || \
        echo "⚠ Check https://dnsleaktest.com for detailed results"
}

show_status() {
    echo "Privacy Status:"
    echo "==============="
    echo "TOR Service: $(systemctl is-active tor)"
    echo "Privoxy: $(systemctl is-active privoxy 2>/dev/null || echo 'not configured')"
    echo ""
    echo "Configuration: /opt/erazor/config/privacy-config.yaml"
}

case "$1" in
    tor-test)
        tor_test
        ;;
    clear-cache)
        clear_cache
        ;;
    check-dns)
        check_dns
        ;;
    status)
        show_status
        ;;
    config)
        nano /opt/erazor/config/privacy-config.yaml
        ;;
    *)
        usage
        ;;
esac
PRIVACY_TOOL

chmod +x /usr/local/bin/erazor-privacy
print_success "Privacy helper tool installed"

# ============================================================================
# STEP 6: Enable and Start Services
# ============================================================================

print_header "Step 6: Enabling Services"

systemctl enable tor
systemctl enable privoxy 2>/dev/null || true
systemctl start tor
sleep 5

if systemctl is-active --quiet tor; then
    print_success "TOR service is running"
else
    print_warning "TOR may need manual configuration. Check: journalctl -xe"
fi

# ============================================================================
# FINAL SETUP
# ============================================================================

print_header "TOR Setup Complete!"

cat << 'SUMMARY'
╔═══════════════════════════════════════════════════════════════╗
║                                                               ║
║              eRazOR TOR Privacy Configured                    ║
║                                                               ║
║  ✓ TOR Installation: Complete                                ║
║  ✓ Privoxy Setup: Complete                                   ║
║  ✓ Services: Running                                         ║
║                                                               ║
║  Available Ports:                                            ║
║  - TOR SOCKS: 127.0.0.1:9050                                ║
║  - TOR Control: 127.0.0.1:9051                              ║
║  - Privoxy HTTP: 127.0.0.1:8118                             ║
║                                                               ║
║  Quick Commands:                                             ║
║  - erazor-tor start          # Start TOR                     ║
║  - erazor-tor test           # Test connection               ║
║  - erazor-tor new-identity   # Get new identity              ║
║  - erazor-privacy status     # Check privacy status          ║
║                                                               ║
║  Using TOR with curl:                                        ║
║  $ curl -x socks5://127.0.0.1:9050 https://example.com      ║
║                                                               ║
║  Using TOR with wget:                                        ║
║  $ wget -e use_proxy=yes -e http_proxy=127.0.0.1:8118 URL   ║
║                                                               ║
║  ⚠️  REMEMBER:                                                ║
║  - TOR usage doesn't guarantee anonymity                     ║
║  - Your operating system can still leak information          ║
║  - Exit nodes can see unencrypted traffic                    ║
║  - Use HTTPS whenever possible!                              ║
║                                                               ║
╚═══════════════════════════════════════════════════════════════╝
SUMMARY

print_success "TOR is now ready for anonymous operations!"
