# eRazOR - Advanced Penetration Testing & Security Analysis Platform

![eRazOR](https://img.shields.io/badge/eRazOR-Advanced%20Security%20OS-blue)
![License](https://img.shields.io/badge/License-MIT-green)
![Status](https://img.shields.io/badge/Status-Development-yellow)

## Overview

**eRazOR** is an advanced, Debian-based Linux distribution designed for penetration testing, threat analysis, and cybersecurity research. It combines the ease of use from Kali Linux, the modularity and lightweight design of Black Arch, and integrates a powerful local AI assistant for intelligent security workflows.

### What Makes eRazOR Different?

✨ **Beginner-Friendly** - Comprehensive guides and safe defaults for users new to penetration testing
🤖 **AI-Powered Assistant** - Local LLM (Mistral 7B via Ollama) for penetration testing workflows, threat prediction, and counter-attack suggestions
⚡ **Lightweight & Modular** - Install only what you need, inspired by Black Arch's philosophy
🔒 **Security-First** - Hardened defaults, stability checks, and security warnings
📦 **Container-Based** - Easy deployment via Docker, perfect for VMs
🛠️ **Advanced Tool Categories** - Organized by reconnaissance, scanning, exploitation, and post-exploitation
🔄 **Automated Updates** - Keep your security tools current with minimal effort

---

## Quick Start

### Prerequisites
- Docker installed on your system ([Install Docker](https://docs.docker.com/get-docker/))
- At least 4GB RAM for VM
- 20GB disk space minimum

### Installation (Coming Soon)

```bash
# Clone the repository
git clone https://github.com/Georgejomanga/eRazOR.git
cd eRazOR

# Build the Docker image
docker build -f docker/Dockerfile -t erazor:latest .

# Run the container
docker-compose up -d
eRazOR/

## Project Structure
├── README.md                 # This file
├── ROADMAP.md               # Feature roadmap & timeline
├── docker/                  # Container definitions
│   ├── Dockerfile           # Main container build
│   ├── .dockerignore
│   └── docker-compose.yml   # Docker Compose configuration
├── scripts/                 # Installation & setup scripts
│   ├── install-base.sh      # Core system setup
│   ├── install-tools.sh     # Security tools installer
│   ├── install-ai.sh        # AI assistant setup
│   └── utils/
│       └── helper-functions.sh
├── ai-assistant/            # AI integration code
│   ├── cli.py               # Command-line interface
│   ├── config.yaml          # Configuration
│   ├── requirements.txt     # Python dependencies
│   └── modules/
│       ├── pen_testing.py   # Pen-testing workflows
│       ├── threat_analyzer.py
│       ├── attack_predictor.py
│       └── scripting_helper.py
├── docs/                    # Documentation
│   ├── INSTALLATION.md
│   ├── BEGINNERS_GUIDE.md
│   ├── SECURITY_BEST_PRACTICES.md
│   ├── AI_ASSISTANT_USAGE.md
│   └── TROUBLESHOOTING.md
├── configs/                 # System configurations
│   ├── security-hardening.conf
│   └── safe-defaults.conf
└── tools-catalog/           # Tool organization
    ├── reconnaissance.txt
    ├── vulnerability-scanning.txt
    ├── exploitation.txt
    └── post-exploitation.txt

Core Features
1. AI-Powered Security Assistant
Local inference (Ollama + Mistral 7B)
Penetration testing workflow guidance
Threat analysis and prediction
Counter-attack suggestions
Scripting assistance for security tasks
2. Modular Tool Management
Lightweight base installation
Selective tool installation by category
Automated tool updates
Dependency management
Tool version tracking
3. Beginner-Friendly Design
Interactive setup wizard
In-depth documentation
Safety warnings and best practices
Video tutorials (planned)
Community support
4. Security Hardening
Hardened system defaults
SELinux ready
Firewall configuration templates
Network isolation guides
Security audit tools pre-configured

Installation Methods
Method 1: Docker Container (Recommended)
docker-compose up -d
docker-compose exec erazor bash

Method 2: Manual Setup (Advanced)
Follow the Installation Guide
AI Assistant Usage
Start the AI Assistant
