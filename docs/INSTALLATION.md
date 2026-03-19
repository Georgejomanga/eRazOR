# eRazOR Installation Guide

## Table of Contents
1. [Prerequisites](#prerequisites)
2. [Docker Installation](#docker-installation)
3. [Container Setup](#container-setup)
4. [Initial Configuration](#initial-configuration)
5. [Verification](#verification)
6. [Troubleshooting](#troubleshooting)

---

## Prerequisites

### System Requirements
- **OS**: Windows 10+, macOS 11+, or Linux (any distro)
- **RAM**: Minimum 4GB (8GB recommended)
- **Disk Space**: Minimum 20GB free
- **CPU**: 2+ cores
- **Internet**: Required for initial setup

### Required Software
- Docker Desktop (for Windows/macOS) or Docker Engine (for Linux)
- Git (optional, but recommended)
- Terminal/Command Prompt

---

## Docker Installation

### Windows 10/11
1. Download [Docker Desktop for Windows](https://www.docker.com/products/docker-desktop)
2. Run the installer
3. Follow the setup wizard
4. Restart your computer
5. Open PowerShell and verify:
   ```powershell
   docker --version
   ```

### macOS
1. Download [Docker Desktop for Mac](https://www.docker.com/products/docker-desktop)
2. Open the `.dmg` file
3. Drag Docker icon to Applications
4. Open Applications → Docker
5. Open Terminal and verify:
   ```bash
   docker --version
   ```

### Linux (Ubuntu/Debian)
```bash
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker $USER
newgrp docker
docker --version
```

---

## Container Setup

### Step 1: Clone eRazOR Repository
```bash
git clone https://github.com/Georgejomanga/eRazOR.git
cd eRazOR
```

### Step 2: Build the Docker Image
```bash
docker-compose build
```

This will:
- Download the Debian base image
- Install all core packages
- Setup the file structure
- Create the container image

**Time**: ~5-10 minutes depending on internet speed

### Step 3: Run the Container
```bash
docker-compose up -d
```

This starts eRazOR in the background.

### Step 4: Enter the Container
```bash
docker-compose exec erazor bash
```

You should now see a prompt like:
```
pentester@erazor:/data$
```

---

## Initial Configuration

### Inside the Container

Once you're inside the container, run the setup scripts in order:

#### 1. Install Base System
```bash
sudo bash /opt/erazor/scripts/install-base.sh
```

This installs:
- Core system utilities
- Python environment
- Essential networking tools

**Time**: ~2-3 minutes

#### 2. Install Security Tools
```bash
sudo bash /opt/erazor/scripts/install-tools.sh all
```

Or install specific categories:
```bash
sudo bash /opt/erazor/scripts/install-tools.sh reconnaissance
sudo bash /opt/erazor/scripts/install-tools.sh scanning
sudo bash /opt/erazor/scripts/install-tools.sh exploitation
sudo bash /opt/erazor/scripts/install-tools.sh post-exploitation
```

**Time**: ~5-10 minutes

#### 3. Install AI Assistant
```bash
sudo bash /opt/erazor/scripts/install-ai.sh
```

This:
- Installs Ollama
- Downloads Mistral 7B model (~4GB)
- Configures the AI assistant

**Time**: ~15-20 minutes (downloading model)

---

## Verification

### Check Installation
```bash
# Inside the container
erazor-ai --version
erazor-ai test
erazor-ai status
```

You should see:
```
✓ Configuration loaded
✓ Python environment OK
✓ Version: 0.1.0-alpha
✓ AI Assistant is ready!
```

### Test Security Tools
```bash
nmap --version
whois --version
netcat -h
```

---

## Post-Installation

### Create Your First Project
```bash
mkdir -p /data/projects/my-pentest
cd /data/projects/my-pentest
```

### Configure AI Assistant
Edit the configuration:
```bash
nano /opt/erazor/config/config.yaml
```

### Enable More Features
For advanced users, you can enable:
- Machine learning threat prediction
- Advanced logging
- Custom security policies

---

## Quick Start Commands

```bash
# Start eRazOR
docker-compose up -d

# Enter eRazOR
docker-compose exec erazor bash

# Get AI help
erazor-ai pentest scan --target 192.168.1.1

# Analyze threats
erazor-ai threat analyze --analyze sample.bin

# Generate scripts
erazor-ai script generate --language python --task "port scanner"

# Stop eRazOR
docker-compose down
```

---

## Directory Structure Inside Container

```
/data/                          # Your work directory
├── projects/                   # Store your projects
├── wordlists/                  # Security wordlists
└── payloads/                   # Payload storage

/opt/erazor/                    # eRazOR installation
├── bin/                        # Executable scripts
├── lib/                        # Libraries
├── scripts/                    # Setup scripts
├── ai-assistant/              # AI components
├── docs/                       # Documentation
└── config/                     # Configuration files
```

---

## Troubleshooting

### Docker Not Starting
**Error**: `Cannot connect to Docker daemon`
**Solution**: 
- Windows: Start Docker Desktop application
- macOS: Start Docker application
- Linux: `sudo systemctl start docker`

### Container Won't Start
**Error**: `docker: no such image`
**Solution**: Rebuild the image
```bash
docker-compose build --no-cache
```

### Out of Disk Space
**Error**: `no space left on device`
**Solution**: 
```bash
# Check disk usage
docker system df

# Clean up unused images
docker system prune -a
```

### AI Model Download Fails
**Error**: `Failed to pull Mistral model`
**Solution**:
- Check internet connection
- Increase available disk space (7GB minimum)
- Try again: `ollama pull mistral:7b`

### Permission Denied
**Error**: `Permission denied` when running scripts
**Solution**:
```bash
sudo bash /opt/erazor/scripts/install-base.sh
```

---

## Getting Help

1. Check [TROUBLESHOOTING.md](TROUBLESHOOTING.md)
2. Review [BEGINNERS_GUIDE.md](BEGINNERS_GUIDE.md)
3. Check [GitHub Issues](https://github.com/Georgejomanga/eRazOR/issues)
4. Read official docs in `/opt/erazor/docs/`

---

## Next Steps

After installation:
1. Read [BEGINNERS_GUIDE.md](BEGINNERS_GUIDE.md)
2. Review [SECURITY_BEST_PRACTICES.md](SECURITY_BEST_PRACTICES.md)
3. Start with `erazor-ai --help`
4. Join the community!

---

**Installation Complete!** 🎉

Your eRazOR system is now ready for advanced penetration testing and security analysis!
