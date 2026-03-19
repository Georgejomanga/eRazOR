# eRazOR Beginner's Guide

Welcome to eRazOR! This guide will help you get started with no prior experience.

## Table of Contents
1. [What is eRazOR?](#what-is-erazor)
2. [Important Concepts](#important-concepts)
3. [Your First Steps](#your-first-steps)
4. [Understanding Tools](#understanding-tools)
5. [Using the AI Assistant](#using-the-ai-assistant)
6. [Common Tasks](#common-tasks)
7. [Safety & Ethics](#safety--ethics)

---

## What is eRazOR?

eRazOR is a **secure Linux operating system** designed specifically for:
- 🔍 **Penetration Testing** - Finding security weaknesses
- 🛡️ **Security Research** - Understanding how attacks work
- 🤖 **Learning Security** - With AI-powered assistance
- 💡 **Threat Analysis** - Understanding security threats

Think of it as a **toolbox** for authorized security professionals and researchers.

---

## Important Concepts

### 1. What is Penetration Testing?
Authorized security testing to find vulnerabilities BEFORE hackers do.

### 2. Container vs Virtual Machine
eRazOR runs in a **Docker container** (lightweight, fast) instead of a full VM.

### 3. Command Line Basics
You'll use text commands instead of clicking buttons. Example:
```bash
erazor-ai pentest scan --target 192.168.1.1
```

### 4. The AI Assistant
Your personal security expert available 24/7 to:
- Guide you through scans
- Explain vulnerabilities
- Suggest next steps
- Help write scripts

---

## Your First Steps

### Step 1: Open Terminal
- **Windows**: Open PowerShell
- **macOS**: Open Terminal (Cmd + Space → Terminal)
- **Linux**: Open Terminal

### Step 2: Start eRazOR
```bash
cd /path/to/eRazOR
docker-compose up -d
docker-compose exec erazor bash
```

You should see:
```
pentester@erazor:/data$
```

### Step 3: Check Everything Works
```bash
erazor-ai status
```

You should see green checkmarks (✓).

### Step 4: Get Help
```bash
erazor-ai --help
```

This shows all available commands.

---

## Understanding Tools

eRazOR comes with **security tools** organized by category:

### 🔍 Reconnaissance Tools
Learn about a target before testing:
```bash
whois example.com          # Who owns this domain?
nmap example.com          # What services are running?
```

### 🔎 Scanning Tools
Look for vulnerabilities:
```bash
nmap -sV example.com      # What versions are running?
```

### ⚔️ Exploitation Tools
Practice safe testing (with permission):
```bash
erazor-ai pentest exploit --vulnerability CVE-2021-12345
```

### 🔐 Post-Exploitation Tools
What happens after successful access:
```bash
erazor-ai threat predict --attack privilege-escalation
```

---

## Using the AI Assistant

### Command Structure
```bash
erazor-ai [CATEGORY] [COMMAND] --[OPTION] [VALUE]
```

### Examples

#### Getting Pen-Testing Help
```bash
# Quick help
erazor-ai pentest --help

# Scan a target
erazor-ai pentest scan --target 192.168.1.100

# Get exploitation guidance
erazor-ai pentest exploit --vulnerability 'Remote Code Execution'
```

#### Threat Analysis
```bash
# Analyze a suspicious file
erazor-ai threat analyze --analyze suspicious-file.bin

# Predict attack methods
erazor-ai threat predict --attack ransomware
```

#### Scripting Help
```bash
# Generate a Python security script
erazor-ai script generate --language python --task 'network scanner'

# Get help with Bash
erazor-ai script explain --code 'nmap -sV 192.168.1.0/24'
```

#### System Status
```bash
erazor-ai status           # Show system status
erazor-ai test             # Test connections
```

---

## Common Tasks

### Task 1: Scan a Local Network (WITH PERMISSION)

```bash
# First, identify your network
ifconfig
# Look for inet address (like 192.168.1.x)

# Ask the AI for guidance
erazor-ai pentest scan --target 192.168.1.0/24

# The AI will suggest:
# - What the scan does
# - What tools to use
# - How to interpret results
```

### Task 2: Learn About a Vulnerability

```bash
erazor-ai pentest exploit --vulnerability 'SQL Injection'

# Returns:
# - What SQL Injection is
# - How attackers exploit it
# - How to defend against it
```

### Task 3: Analyze a Security Issue

```bash
erazor-ai threat analyze --analyze malware-sample.exe --type malware

# Shows:
# - What the threat does
# - Risk level
# - How to mitigate
```

### Task 4: Write a Pen-Testing
