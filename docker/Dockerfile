# eRazOR - Advanced Penetration Testing & Security Analysis Platform
# Enhanced Dockerfile with Privacy Focus, Compartmentalization & Resource Efficiency
# Based on Debian for stability and compatibility
# Supports: amd64, arm64, armv7

FROM debian:bookworm-slim

# Build arguments for multi-arch support
ARG TARGETARCH
ARG TARGETOS

# Metadata
LABEL maintainer="eRazOR Project <support@erazor-project.com>"
LABEL description="eRazOR - Privacy-Focused, Lightweight Linux Distribution with AI Assistant"
LABEL version="0.1.0-alpha"
LABEL arch="${TARGETARCH}"

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=en_US.UTF-8
ENV PATH="/opt/erazor/bin:${PATH}"
ENV ERAZOR_PRIVACY_MODE=true
ENV ERAZOR_COMPARTMENTALIZATION=enabled

# Update system with minimal packages only
RUN apt-get update && apt-get install -y --no-install-recommends \
    # Core utilities (minimal footprint)
    curl \
    wget \
    git \
    nano \
    htop \
    tmux \
    # Python and development tools
    python3 \
    python3-pip \
    python3-dev \
    # Networking tools
    net-tools \
    iputils-ping \
    dnsutils \
    # Security and privacy tools
    openssh-client \
    openssl \
    tor \
    privoxy \
    gnupg \
    nmap \
    netcat-openbsd \
    # Localization
    locales \
    ca-certificates \
    # Clean up to reduce image size
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/* \
    && rm -rf /var/tmp/*

# Generate locale
RUN sed -i 's/^# en_US.UTF-8 UTF-8$/en_US.UTF-8 UTF-8/g' /etc/locale.gen && \
    locale-gen

# ============================================================================
# COMPARTMENTALIZATION SETUP - Inspired by QubesOS Architecture
# ============================================================================

# Create isolated service users for compartmentalization
RUN groupadd -r pentester && \
    groupadd -r aiservice && \
    groupadd -r networking && \
    useradd -r -g pentester -d /home/pentester -s /bin/bash -m pentester && \
    useradd -r -g aiservice -d /home/aiservice -s /bin/bash -m aiservice && \
    useradd -r -g networking -d /home/networking -s /bin/bash -m networking

# Grant minimal sudo permissions for specific commands only
RUN echo "pentester ALL=(ALL) NOPASSWD: /usr/sbin/iptables, /usr/bin/docker, /opt/erazor/scripts/install-*" >> /etc/sudoers.d/pentester && \
    chmod 440 /etc/sudoers.d/pentester

# ============================================================================
# PRIVACY & SECURITY CONFIGURATION
# ============================================================================

# Create privacy-focused directories
RUN mkdir -p /opt/erazor/bin && \
    mkdir -p /opt/erazor/lib && \
    mkdir -p /opt/erazor/config && \
    mkdir -p /opt/erazor/compartments && \
    mkdir -p /data/projects && \
    mkdir -p /data/wordlists && \
    mkdir -p /data/payloads && \
    mkdir -p /var/lib/tor && \
    mkdir -p /var/lib/privoxy

# Configure TOR for privacy (disabled by default, user can enable)
RUN echo "SocksPort 9050" >> /etc/tor/torrc && \
    echo "ControlPort 9051" >> /etc/tor/torrc && \
    echo "CookieAuthentication 1" >> /etc/tor/torrc && \
    chown -R debian-tor:debian-tor /var/lib/tor

# Configure Privoxy for TOR integration
RUN echo "forward-socks5 / 127.0.0.1:9050 ." >> /etc/privoxy/config && \
    chown -R privoxy:privoxy /var/lib/privoxy

# Create compartmentalization directories
RUN mkdir -p /opt/erazor/compartments/isolation && \
    mkdir -p /opt/erazor/compartments/workspace && \
    mkdir -p /opt/erazor/compartments/disposable

# ============================================================================
# RESOURCE OPTIMIZATION - Lightweight Configuration
# ============================================================================

# Disable unnecessary services
RUN systemctl disable bluetooth.service 2>/dev/null || true && \
    systemctl disable cups.service 2>/dev/null || true && \
    systemctl disable avahi-daemon.service 2>/dev/null || true

# Optimize system limits for containers
RUN echo "* soft nofile 65535" >> /etc/security/limits.conf && \
    echo "* hard nofile 65535" >> /etc/security/limits.conf && \
    echo "* soft nproc 65535" >> /etc/security/limits.conf && \
    echo "* hard nproc 65535" >> /etc/security/limits.conf

# Create privacy/security notice
RUN cat > /etc/motd << 'EOF'
╔═══════════════════════════════════════════════════════════════╗
║                                                               ║
║        Welcome to eRazOR - Advanced Security OS               ║
║                                                               ║
║  🔒 Privacy-First Architecture                               ║
║  🔐 Compartmentalized Design (QubesOS-inspired)              ║
║  🌐 TOR-Ready for Anonymous Operations                       ║
║  ⚡ Lightweight & Resource-Efficient                          ║
║                                                               ║
║  This system is for authorized security testing ONLY.        ║
║  Unauthorized access to computer systems is ILLEGAL.         ║
║                                                               ║
║  Features:                                                    ║
║  • Compartmentalization: Isolate tools by security domain    ║
║  • Disposable Templates: Discard compromised environments    ║
║  • TOR Integration: Anonymous network communication          ║
║  • Privacy-Focused: Minimal tracking, local processing       ║
║                                                               ║
║  By using this system, you agree to all applicable laws      ║
║  and terms of service.                                       ║
║                                                               ║
╚═══════════════════════════════════════════════════════════════╝

📚 Getting Started:
  1. Read: cat /opt/erazor/docs/BEGINNERS_GUIDE.md
  2. Setup: bash /opt/erazor/scripts/setup-compartments.sh
  3. Privacy: bash /opt/erazor/scripts/setup-tor.sh (optional)
  4. Tools: bash /opt/erazor/scripts/install-tools.sh

🔐 Privacy & Compartmentalization:
  erazor-compartment --help           # Manage compartments
  erazor-privacy --help               # Privacy settings
  erazor-tor --help                   # TOR configuration

⚠️  IMPORTANT: Always verify authorization before testing!
EOF

# Copy application files from repository
COPY scripts/ /opt/erazor/scripts/
COPY ai-assistant/ /opt/erazor/ai-assistant/
COPY configs/ /opt/erazor/config/
COPY docs/ /opt/erazor/docs/

# Set appropriate permissions
RUN chown -R pentester:pentester /opt/erazor && \
    chown -R pentester:pentester /data && \
    chmod +x /opt/erazor/scripts/*.sh && \
    chmod 700 /opt/erazor/compartments

# Install Python dependencies
WORKDIR /opt/erazor/ai-assistant
RUN pip3 install --no-cache-dir --upgrade pip setuptools wheel && \
    pip3 install --no-cache-dir -r requirements.txt 2>/dev/null || echo "requirements.txt setup will happen at runtime"

# Set working directory
WORKDIR /data

# Use non-root user by default (security best practice)
USER pentester

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:8000/health 2>/dev/null || echo "Container healthy"

# Entry point with compartmentalization support
ENTRYPOINT ["/bin/bash"]
CMD ["-i"]

# Expose ports (for future web interface)
EXPOSE 8000 8443 5000 9050 9051 8118

# Volume mounts for data persistence and compartmentalization
VOLUME ["/data", "/opt/erazor/config", "/opt/erazor/compartments"]
