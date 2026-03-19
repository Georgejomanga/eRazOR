# eRazOR Troubleshooting Guide

## Common Issues & Solutions

### 1. Docker Issues

#### Problem: `docker: command not found`

**Cause**: Docker is not installed or not in PATH

**Solution**:
```bash
# Check if Docker is installed
docker --version

# If not installed, follow installation guide
# Windows: Download Docker Desktop
# macOS: brew install docker
# Linux: sudo apt-get install docker.io
```

---

#### Problem: `Cannot connect to Docker daemon`

**Cause**: Docker service is not running

**Solution**:
```bash
# Windows/macOS: Open Docker Desktop application

# Linux: Start Docker service
sudo systemctl start docker
sudo systemctl enable docker

# Verify
docker ps
```

---

#### Problem: `Permission denied while trying to connect to Docker daemon`

**Cause**: User is not in docker group

**Solution (Linux)**:
```bash
# Add current user to docker group
sudo usermod -aG docker $USER
newgrp docker

# Verify
docker ps
```

---

### 2. Container Issues

#### Problem: `docker-compose: command not found`

**Cause**: Docker Compose not installed

**Solution**:
```bash
# Check version
docker-compose --version

# If not found:
# Windows/macOS: Included with Docker Desktop

# Linux:
sudo apt-get install docker-compose
# Or
sudo curl -L "https://github.com/docker/compose/releases/download/v2.20.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```

---

#### Problem: `docker-compose exec erazor bash: Permission denied`

**Cause**: Container permission issue

**Solution**:
```bash
# Restart container
docker-compose down
docker-compose up -d

# Try again
docker-compose exec erazor bash

# If still fails:
docker-compose exec -u root erazor bash
sudo chown -R pentester:pentester /opt/erazor
```

---

#### Problem: Container exits immediately or won't start

**Cause**: Build error or configuration issue

**Solution**:
```bash
# Rebuild image
docker-compose down
docker-compose build --no-cache

# Restart
docker-compose up -d

# Check logs
docker-compose logs -f erazor
```

---

#### Problem: `Out of memory` error

**Cause**: Container resource limits

**Solution**:
```bash
# Check container resources
docker stats

# Increase Docker memory allocation:
# Windows/macOS: Docker Desktop → Settings → Resources
# Linux: Modify docker-compose.yml

# Check available system memory
free -h  # Linux/macOS: vm_stat
```

---

### 3. Installation Issues

#### Problem: `install-base.sh: Permission denied`

**Cause**: Script not executable

**Solution**:
```bash
# Make executable
chmod +x /opt/erazor/scripts/install-base.sh

# Run with bash
bash /opt/erazor/scripts/install-base.sh

# Or with sudo
sudo bash /opt/erazor/scripts/install-base.sh
```

---

#### Problem: `sudo: command not found`

**Cause**: Not in container or wrong user

**Solution**:
```bash
# Verify you're in container
whoami  # Should show: pentester

# Check if sudo installed
which sudo

# Install sudo if missing
apt-get update
apt-get install -y sudo
```

---

#### Problem: Installation script hangs

**Cause**: Network issue or large download

**Solution**:
```bash
# Press Ctrl+C to stop
# Check internet connection
ping google.com

# Retry installation
bash /opt/erazor/scripts/install-base.sh

# If still fails, install manually
apt-get update
apt-get install -y python3 python3-pip
```

---

### 4. AI Assistant Issues

#### Problem: `erazor-ai: command not found`

**Cause**: Not installed or not in PATH

**Solution**:
```bash
# Check if installed
which erazor-ai

# Install it
sudo bash /opt/erazor/scripts/install-ai.sh

# Verify
erazor-ai --version
```

---

#### Problem: `Ollama connection refused`

**Cause**: Ollama service not running

**Solution**:
```bash
# Check service status
sudo systemctl status ollama

# Start service
sudo systemctl start ollama

# Enable on boot
sudo systemctl enable ollama

# Verify
curl http://localhost:11434/api/tags
```

---

#### Problem: `Model not found` or `Failed to pull mistral:7b`

**Cause**: Model not downloaded or network issue

**Solution**:
```bash
# Check available models
ollama list

# Download model
ollama pull mistral:7b

# If download fails:
# 1. Check internet connection
ping google.com

# 2. Check disk space (need 7GB+)
df -h

# 3. Try again with verbose
ollama pull -v mistral:7b

# 4. Use alternative:
ollama pull llama:7b
```

---

#### Problem: AI responses are very slow

**Cause**: Running on CPU (normal) or system under load

**Solution**:
```bash
# Check system resources
htop

# This is normal:
# - First response: 30-60 seconds
# - Subsequent: 10-20 seconds

# Optimize:
# 1. Close other applications
# 2. Increase RAM allocation
# 3. Use GPU if available
# 4. Reduce context length in config
```

---

#### Problem: `Python module not found` or `ModuleNotFoundError`

**Cause**: Dependencies not installed

**Solution**:
```bash
# Reinstall dependencies
cd /opt/erazor/ai-assistant
pip3 install --upgrade pip
pip3 install -r requirements.txt

# Or install specific module
pip3 install requests pyyaml click
```

---

### 5. Scripting Issues

#### Problem: Nmap not found

**Cause**: Not installed

**Solution**:
```bash
# Install nmap
sudo apt-get update
sudo apt-get install -y nmap

# Verify
nmap --version
```

---

#### Problem: `Permission denied` when running tools

**Cause**: User lacks permissions

**Solution**:
```bash
# Check current user
whoami

# Some tools need root
sudo nmap -sV 192.168.1.1

# Or add sudo permissions
echo "pentester ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/pentester
```

---

#### Problem: Scans take too long

**Cause**: Deep scans or many targets

**Solution**:
```bash
# Use quick scan
erazor-ai pentest scan --target 192.168.1.1 --scan-type quick

# Or use specific port ranges
nmap -p 1-1000 192.168.1.1

# Or scan fewer hosts
nmap 192.168.1.1
```

---

### 6. Network Issues

#### Problem: Can't reach target IP

**Cause**: Network connectivity or firewall

**Solution**:
```bash
# Test connectivity
ping 192.168.1.1

# Check routing
traceroute 192.168.1.1

# Check firewall
sudo iptables -L

# Verify network interface
ifconfig

# Test from different port
nmap -p 80,443 192.168.1.1
```

---

#### Problem: No internet in container

**Cause**: Docker network configuration

**Solution**:
```bash
# Test inside container
ping 8.8.8.8

# Check network settings
cat /etc/resolv.conf

# Restart container
docker-compose down
docker-compose up -d

# Or recreate network
docker network prune
docker-compose up -d
```

---

### 7. Disk Space Issues

#### Problem: `No space left on device`

**Cause**: Disk full

**Solution**:
```bash
# Check usage
df -h

# See large files
du -sh /data/*
du -sh /opt/erazor/*

# Clean up:
# Remove old projects
rm -rf /data/projects/old-project

# Clean Docker
docker system prune -a

# Check model size
du -sh /var/lib/ollama/

# Move to larger disk if available
# Or increase VM disk in settings
```

---

#### Problem: Docker image build fails

**Cause**: Insufficient disk space

**Solution**:
```bash
# Clean Docker system
docker system prune -a -f

# Free up space
df -h

# Try building again
docker-compose build --no-cache

# Check build logs
docker-compose build --progress=plain
```

---

### 8. Performance Issues

#### Problem: System is slow

**Cause**: Resource constraints

**Solution**:
```bash
# Check resources
docker stats

# Check system load
top -b -n 1 | head -20

# Reduce running services
docker-compose down  # Stop container when not using

# Increase VM resources (if using VM):
# - RAM: at least 4GB, prefer 8GB
# - CPU: at least 2 cores
# - Disk: SSD if possible
```

---

#### Problem: Container is taking too much memory

**Cause**: Memory leak or resource limit

**Solution**:
```bash
# Check which process uses memory
top

# Restart container
docker-compose restart erazor

# Limit memory in docker-compose.yml
# deploy:
#   resources:
#     limits:
#       memory: 4G
```

---

### 9. Configuration Issues

#### Problem: Config file not found

**Cause**: File missing or wrong path

**Solution**:
```bash
# Find config
find /opt/erazor -name "*.yaml" -o -name "*.yml"

# Check path
ls -la /opt/erazor/config/

# Create if missing
touch /opt/erazor/config/config.yaml
```

---

#### Problem: Invalid configuration syntax

**Cause**: YAML format error

**Solution**:
```bash
# Validate YAML
python3 -m yaml /opt/erazor/config/config.yaml

# Or use online validator
# Visit: https://www.yamllint.com/

# Common errors:
# - Missing colons
# - Inconsistent indentation
# - Wrong quotes
```

---

### 10. Security Issues

#### Problem: Sensitive data exposure in logs

**Cause**: Logging enabled with sensitive data

**Solution**:
```bash
# Disable verbose logging
sudo nano /opt/erazor/config/config.yaml
# Set: logging.level: WARNING

# Clear old logs
sudo rm -f /var/log/erazor-ai.log*

# Check for credentials
grep -r "password" /var/log/
grep -r "api_key" /var/log/
```

---

#### Problem: Container running as root

**Cause**: Security risk

**Solution**:
```bash
# Check user
whoami

# Should show: pentester

# If running as root:
docker-compose down
docker-compose exec -u pentester erazor bash
```

---

## Getting Additional Help

### Check Documentation

```bash
# View documentation
cat /opt/erazor/docs/INSTALLATION.md
cat /opt/erazor/docs/BEGINNERS_GUIDE.md
cat /opt/erazor/docs/SECURITY_BEST_PRACTICES.md
```

### Check Logs

```bash
# eRazOR logs
sudo tail -f /var/log/erazor-ai.log

# Docker logs
docker-compose logs -f erazor

# System logs (Linux)
sudo journalctl -xe
```

### Search for Solution

```bash
# Search documentation
grep -r "keyword" /opt/erazor/docs/

# Search common issues
grep -r "error" /var/log/
```

### Report Issue

If you can't find a solution:

1. **Check GitHub Issues**: https://github.com/Georgejomanga/eRazOR/issues
2. **Search existing issues** for similar problem
3. **Create new issue** with:
   - Clear title
   - Error message
   - Steps to reproduce
   - Your system (Windows/macOS/Linux)
   - Docker version
   - Output of `docker --version` and `docker-compose --version`

---

## Quick Reference

| Issue | Quick Fix |
|-------|-----------|
| Docker not found | Install Docker Desktop or docker.io |
| Can't connect to daemon | Start Docker service |
| Container won't start | `docker-compose build --no-cache` |
| Ollama not working | `sudo systemctl restart ollama` |
| Model not downloading | Check disk space and internet |
| No space left | `docker system prune -a` |
| Slow responses | Normal, give it time or upgrade VM |
| Tool not found | Run install script again |

---

**Last Updated:** 2026-03-19
**Version:** 1.0
