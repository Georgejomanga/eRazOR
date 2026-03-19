# eRazOR - Advanced Penetration Testing & Security Analysis Platform
# Dockerfile - Base Image Configuration
# Based on Debian for stability and compatibility

FROM debian:bookworm-slim

# Metadata
LABEL maintainer="eRazOR Project <support@erazor-project.com>"
LABEL description="eRazOR - Advanced Linux Distribution with AI Assistant"
LABEL version="0.1.0-alpha"

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=en_US.UTF-8
ENV PATH="/opt/erazor/bin:${PATH}"

# Update system and install essential packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    # Core utilities
    curl \
    wget \
    git \
    nano \
    vim \
    htop \
    tmux \
    build-essential \
    # Python and development tools
    python3 \
    python3-pip \
    python3-dev \
    python3-venv \
    # Networking tools
    net-tools \
    iputils-ping \
    dnsutils \
    whois \
    traceroute \
    # Security tools (basic)
    openssh-client \
    openssl \
    nmap \
    netcat-openbsd \
    # System tools
    sudo \
    systemctl \
    apt-utils \
    ca-certificates \
    # Localization
    locales \
    # Clean up
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Generate locale
RUN sed -i 's/^# en_US.UTF-8 UTF-8$/en_US.UTF-8 UTF-8/g' /etc/locale.gen && \
    locale-gen

# Create non-root user for security
RUN groupadd -r pentester && \
    useradd -r -g pentester -d /home/pentester -s /bin/bash -m pentester && \
    echo "pentester ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/pentester

# Create application directories
RUN mkdir -p /opt/erazor/bin && \
    mkdir -p /opt/erazor/lib && \
    mkdir -p /opt/erazor/config && \
    mkdir -p /data/projects && \
    mkdir -p /data/wordlists && \
    mkdir -p /data/payloads

# Copy scripts and configurations from repository
COPY scripts/ /opt/erazor/scripts/
COPY ai-assistant/ /opt/erazor/ai-assistant/
COPY configs/ /opt/erazor/config/
COPY docs/ /opt/erazor/docs/

# Set permissions
RUN chown -R pentester:pentester /opt/erazor && \
    chmod +x /opt/erazor/scripts/*.sh && \
    chown -R pentester:pentester /data

# Install Python dependencies for AI assistant
WORKDIR /opt/erazor/ai-assistant
RUN pip3 install --no-cache-dir -r requirements.txt 2>/dev/null || echo "requirements.txt not yet available"

# Set working directory
WORKDIR /data

# Switch to non-root user
USER pentester

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:8000/health || exit 1

# Entry point
ENTRYPOINT ["/bin/bash"]
CMD ["-i"]

# Expose ports (for future web interface)
EXPOSE 8000 8443 5000

# Volume mounts for data persistence
VOLUME ["/data", "/opt/erazor/config"]
