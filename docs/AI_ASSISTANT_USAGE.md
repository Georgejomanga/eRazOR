# eRazOR AI Assistant Usage Guide

## Overview

The eRazOR AI Assistant is a local, **offline-first** intelligent helper powered by Mistral 7B running on Ollama. It helps you with:

- 🔍 Penetration testing workflows
- 🎯 Threat analysis and intelligence
- ⚔️ Attack prediction and counter-strategies
- 💻 Security scripting assistance
- 📚 Learning and understanding concepts

## Quick Start

### Start the Assistant

```bash
erazor-ai
```

Or with specific commands:

```bash
erazor-ai pentest scan --target 192.168.1.100
erazor-ai threat analyze --analyze sample.bin
erazor-ai script generate --language python --task "port scanner"
```

### Get Help

```bash
erazor-ai --help              # Show all commands
erazor-ai pentest --help      # Show pentest commands
erazor-ai threat --help       # Show threat commands
erazor-ai script --help       # Show script commands
```

---

## Command Reference

### 1. Penetration Testing (`pentest`)

#### Scan a Target

```bash
erazor-ai pentest scan --target <TARGET>
```

**Example:**
```bash
erazor-ai pentest scan --target 192.168.1.100
erazor-ai pentest scan --target example.com
erazor-ai pentest scan --target 192.168.1.0/24 --scan-type deep
```

**Options:**
- `--target, -t`: IP address, hostname, or network range (required)
- `--scan-type, -s`: quick (default) | deep | full

**What it does:**
- Suggests scanning tools
- Explains what each tool does
- Identifies potential vulnerabilities
- Recommends next steps

#### Exploitation Guidance

```bash
erazor-ai pentest exploit --vulnerability <CVE>
```

**Example:**
```bash
erazor-ai pentest exploit --vulnerability CVE-2021-44228
erazor-ai pentest exploit --vulnerability "SQL Injection"
erazor-ai pentest exploit --vulnerability "Remote Code Execution"
```

**Options:**
- `--vulnerability, -v`: CVE number or vulnerability name (required)

**What it does:**
- Explains the vulnerability
- Shows exploitation techniques
- Provides remediation advice
- Links to resources

---

### 2. Threat Analysis (`threat`)

#### Analyze Threats

```bash
erazor-ai threat analyze --analyze <TARGET> --type <TYPE>
```

**Example:**
```bash
erazor-ai threat analyze --analyze malware.exe --type malware
erazor-ai threat analyze --analyze shellcode.bin --type payload
erazor-ai threat analyze --analyze scan-results.txt --type network
```

**Options:**
- `--analyze, -a`: File path or sample name (required)
- `--type, -t`: malware | payload | script | network (default: malware)

**What it does:**
- Analyzes file/sample for threats
- Identifies malicious indicators
- Assesses risk level
- Suggests mitigation

#### Predict Attack Vectors

```bash
erazor-ai threat predict --attack <ATTACK_TYPE>
```

**Example:**
```bash
erazor-ai threat predict --attack ransomware
erazor-ai threat predict --attack privilege-escalation
erazor-ai threat predict --attack lateral-movement
erazor-ai threat predict --attack data-exfiltration
```

**Options:**
- `--attack, -a`: Attack type (required)

**What it does:**
- Predicts how attack could occur
- Shows common attack paths
- Suggests detection methods
- Recommends counter-measures

---

### 3. Scripting Help (`script`)

#### Generate Security Scripts

```bash
erazor-ai script generate --language <LANGUAGE> --task <TASK>
```

**Example:**
```bash
erazor-ai script generate --language python --task "port scanner"
erazor-ai script generate --language bash --task "automated nmap scan"
erazor-ai script generate --language powershell --task "network inventory"
erazor-ai script generate --language ruby --task "web vulnerability scanner"
```

**Options:**
- `--language, -l`: python | bash | powershell | ruby (required)
- `--task, -t`: Description of what to do (required)

**Supported Languages:**
- **Python**: Best for complex logic
- **Bash**: Best for system commands
- **PowerShell**: Best for Windows systems
- **Ruby**: Best for rapid development

**What it does:**
- Generates working code
- Includes error handling
- Adds explanatory comments
- Shows best practices

#### Explain Code

```bash
erazor-ai script explain --code <CODE>
```

**Example:**
```bash
erazor-ai script explain --code "nmap -sV -p 1-65535 192.168.1.1"
erazor-ai script explain --code "for i in {1..254}; do ping -c 1 192.168.1.$i; done"
```

**Options:**
- `--code, -c`: Code snippet or command (required)

**What it does:**
- Breaks down what code does
- Explains each component
- Shows security implications
- Suggests improvements

---

### 4. System Commands

#### Check Status

```bash
erazor-ai status
```

**Output shows:**
- AI Assistant status
- Version information
- Configuration status
- Module availability

#### Test Connectivity

```bash
erazor-ai test
```

**Tests:**
- Configuration loading
- Python environment
- Ollama connection
- Model availability

#### Show Help

```bash
erazor-ai help-info
```

Displays detailed usage guide.

#### Version

```bash
erazor-ai --version
```

Shows current version.

---

## Use Case Examples

### Scenario 1: Authorized Network Penetration Test

**Step 1: Reconnaissance**
```bash
erazor-ai pentest scan --target 192.168.1.0/24 --scan-type quick
```

**Step 2: Analyze Results**
```bash
erazor-ai threat analyze --analyze scan-results.txt --type network
```

**Step 3: Test Vulnerabilities**
```bash
erazor-ai pentest exploit --vulnerability "Open SSH Service"
```

**Step 4: Generate Test Script**
```bash
erazor-ai script generate --language python --task "test detected vulnerability"
```

---

### Scenario 2: Malware Analysis

**Step 1: Analyze File**
```bash
erazor-ai threat analyze --analyze malware.exe --type malware
```

**Step 2: Understand Behavior**
```bash
erazor-ai threat predict --attack ransomware
```

**Step 3: Create Detection Script**
```bash
erazor-ai script generate --language bash --task "detect malware signatures"
```

---

### Scenario 3: Learning & Training

**Step 1: Learn About Vulnerability**
```bash
erazor-ai pentest exploit --vulnerability "SQL Injection"
```

**Step 2: Understand Attack**
```bash
erazor-ai threat predict --attack "SQL Injection Attack"
```

**Step 3: Practice Writing Script**
```bash
erazor-ai script generate --language python --task "SQL injection tester"
```

---

## Configuration

### Advanced Configuration

Edit the configuration file:

```bash
sudo nano /opt/erazor/config/config.yaml
```

### Key Settings

```yaml
# Temperature: 0.0-1.0
# Lower = more focused, Higher = more creative
ollama:
  temperature: 0.7

# How detailed should analysis be?
threat_analyzer:
  analysis_depth: "medium"  # low, medium, high

# Supported programming languages
scripting_helper:
  supported_languages:
    - python
    - bash
    - powershell
    - ruby
```

### Reset Configuration

```bash
cp /opt/erazor/config/config.yaml.bak /opt/erazor/config/config.yaml
```

---

## Tips & Tricks

### 1. Pipe Results to File

```bash
erazor-ai pentest scan --target 192.168.1.1 > scan-results.txt
```

### 2. Combine Commands

```bash
# Scan, then analyze
erazor-ai pentest scan --target 192.168.1.0/24 && \
erazor-ai threat analyze --analyze scan-results.txt
```

### 3. Save Common Scans

```bash
# Create reusable script
cat > my-scan.sh << 'EOF'
#!/bin/bash
erazor-ai pentest scan --target "$1" --scan-type deep
erazor-ai threat analyze --analyze scan-results.txt
EOF

chmod +x my-scan.sh
./my-scan.sh 192.168.1.0/24
```

### 4. Get Detailed Help

```bash
# Help for specific module
erazor-ai pentest --help
erazor-ai threat --help
erazor-ai script --help
```

---

## Troubleshooting

### AI Not Responding

```bash
# Check status
erazor-ai status

# Check Ollama service
systemctl status ollama

# Restart service
sudo systemctl restart ollama
```

### Model Not Loading

```bash
# Check if model is downloaded
ollama list

# Re-download model
ollama pull mistral:7b

# List available models
ollama show
```

### Slow Responses

```bash
# AI is running on CPU if GPU not available
# This is normal
# Increase wait time or:
# 1. Get GPU support
# 2. Use lighter model
# 3. Reduce context length
```

### Command Not Found

```bash
# Ensure you're in the eRazOR container
docker-compose exec erazor bash

# Check if AI is installed
which erazor-ai

# Verify PATH
echo $PATH
```

---

## Best Practices

### ✅ DO:

- ✅ Use for authorized testing only
- ✅ Document all recommendations
- ✅ Verify AI suggestions independently
- ✅ Keep security findings confidential
- ✅ Update your knowledge
- ✅ Get written authorization before testing
- ✅ Log all assessments

### ❌ DON'T:

- ❌ Test without authorization
- ❌ Trust AI 100% (always verify)
- ❌ Share confidential findings
- ❌ Access beyond authorized scope
- ❌ Use in illegal activities
- ❌ Ignore security warnings
- ❌ Leave systems in altered state

---

## Advanced Features (Coming Soon)

### Planned Enhancements:

- 🧠 Machine learning-based threat prediction
- 📊 Advanced analytics dashboard
- 🔗 Vulnerability database integration
- 👥 Team collaboration features
- 📈 Automated reporting
- 🌐 Web interface
- 🔐 Multi-user support

---

## Support & Resources

### Documentation

```bash
# In container
ls /opt/erazor/docs/

# View specific docs
cat /opt/erazor/docs/SECURITY_BEST_PRACTICES.md
```

### Get Help

```bash
# Command help
erazor-ai --help

# Show detailed guide
erazor-ai help-info

# Check GitHub
https://github.com/Georgejomanga/eRazOR/issues
```

---

**Last Updated:** 2026-03-19
**Version:** 0.1.0-alpha
