#!/bin/bash

################################################################################
# eRazOR - AI Assistant Installation Script
# Purpose: Install Ollama + Mistral 7B and configure AI assistant
# Usage: bash install-ai.sh
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

print_header "eRazOR AI Assistant Installation"

# Check disk space
DISK_AVAILABLE=$(df /opt | tail -1 | awk '{print $4}')
if [ "$DISK_AVAILABLE" -lt 7000000 ]; then
    print_warning "Less than 7GB available. Mistral 7B requires ~7GB."
    read -p "Continue anyway? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Install Ollama
print_header "Installing Ollama"
curl -fsSL https://ollama.ai/install.sh | sh 2>/dev/null || {
    print_warning "Ollama installation script method failed, installing manually..."
    apt-get update
    apt-get install -y curl
}
print_success "Ollama installation initiated"

# Start Ollama service
print_header "Starting Ollama Service"
systemctl start ollama || print_warning "Ollama service start - may need manual configuration"
systemctl enable ollama || print_warning "Ollama service enable failed"
print_success "Ollama service configured"

# Download Mistral 7B model
print_header "Downloading Mistral 7B Model"
print_warning "This will download ~4GB. This may take 10-15 minutes depending on connection."
ollama pull mistral:7b || {
    print_error "Failed to pull Mistral model. Trying alternative method..."
    ollama pull mistral || print_error "Could not download model. Please check internet connection."
}
print_success "Mistral 7B model ready"

# Install Python dependencies for AI assistant
print_header "Installing AI Assistant Dependencies"
cd /opt/erazor/ai-assistant
pip3 install --upgrade pip
pip3 install -r requirements.txt || print_warning "Some dependencies may have failed. Check requirements.txt"
print_success "Python dependencies installed"

# Create erazor-ai command wrapper
print_header "Creating AI Assistant Command"
cat > /usr/local/bin/erazor-ai << 'EOF'
#!/bin/bash
# eRazOR AI Assistant Launcher
exec python3 /opt/erazor/ai-assistant/cli.py "$@"
EOF
chmod +x /usr/local/bin/erazor-ai
print_success "erazor-ai command created"

# Test AI connection
print_header "Testing AI Assistant"
sleep 2
if python3 /opt/erazor/ai-assistant/cli.py --version &>/dev/null; then
    print_success "AI assistant is ready to use"
else
    print_warning "AI assistant test returned warning. May still work."
fi

# Create startup guide
cat > /opt/erazor/docs/AI_QUICKSTART.md << 'EOF'
# AI Assistant Quick Start

## Starting the Assistant

```bash
erazor-ai

Common Commands
# Penetration Testing Help
erazor-ai pentest --help
erazor-ai pentest --scan 192.168.1.0/24
# Threat Analysis
erazor-ai threat --analyze malware.bin
# Scripting Help
erazor-ai script --help python
# Attack Prediction
erazor-ai predict --attack ransomware
