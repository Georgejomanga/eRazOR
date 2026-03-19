# eRazOR Compartmentalization & Security Architecture

## Overview

eRazOR implements **QubesOS-inspired compartmentalization** for advanced security. This architecture isolates different security domains, making the system more resilient to compromise.

## Why Compartmentalization?

Traditional penetration testing environments treat the entire system as one security domain. eRazOR divides it into separate compartments, each with:

- **Isolated filesystems**
- **Separate network stacks** (optional)
- **Minimal cross-compartment communication**
- **Disposable templates** for high-risk operations

### Benefits

✅ **Damage Containment** - Compromise in one compartment doesn't spread  
✅ **Clear Separation** - Tools organized by security risk level  
✅ **Easy Recovery** - Disposable compartments can be discarded  
✅ **Compliance** - Meets security best practices  
✅ **Peace of Mind** - Know your environment is compartmentalized  

---

## Compartment Types

### 1. **Reconnaissance** (Low Risk)
**Purpose:** Passive information gathering  
**Security Level:** High (trusted)  
**Network Access:** Full  
**Risk:** Minimal

```bash
erazor-compartment create reconnaissance
# Use for:
# - DNS queries
# - WHOIS lookups
# - Passive reconnaissance
# - Open-source intelligence (OSINT)
```

### 2. **Scanning** (Medium Risk)
**Purpose:** Active vulnerability scanning  
**Security Level:** Medium  
**Network Access:** Full  
**Risk:** Moderate

```bash
erazor-compartment create scanning
# Use for:
# - Port scanning (nmap)
# - Service enumeration
# - Vulnerability scanning
# - Banner grabbing
```

### 3. **Exploitation** (High Risk)
**Purpose:** Exploitation testing  
**Security Level:** Low (untrusted)  
**Network Access:** Restricted  
**Risk:** High

```bash
erazor-compartment create exploitation
# Use for:
# - Exploit code testing
# - Vulnerability verification
# - Payload testing
# - High-risk operations
```

### 4. **Analysis** (Isolated)
**Purpose:** Malware and threat analysis  
**Security Level:** Quarantined  
**Network Access:** None (air-gapped)  
**Risk:** Very High

```bash
erazor-compartment create analysis
# Use for:
# - Malware analysis
# - Suspicious binary inspection
# - Behavioral analysis
# - NEVER connect to network!
```

### 5. **Disposable** (Temporary)
**Purpose:** One-time testing environments  
**Security Level:** Maximum isolation  
**Network Access:** None  
**Risk:** Assumed compromised

```bash
erazor-compartment dispose my-test
# Use for:
# - Untrusted tools
# - Uncertain operations
# - High-risk testing
# Auto-cleanup after use
```

### 6. **Workspace** (General)
**Purpose:** General work and staging  
**Security Level:** Standard  
**Network Access:** Full  
**Risk:** Low

```bash
# Default compartment for day-to-day work
```

---

## Using Compartmentalization

### List All Compartments

```bash
erazor-compartment list
```

Output:
```
eRazOR Compartments:
====================
reconnaissance
scanning
exploitation
analysis
workspace
disposable
```

### Create New Compartment

```bash
erazor-compartment create <name>
```

Example:
```bash
erazor-compartment create client-testing
```

### View Compartment Status

```bash
erazor-compartment status
```

Output:
```
eRazOR Compartment Status
=========================
reconnaissance: 4 files, 12MB
scanning: 15 files, 156MB
exploitation: 8 files, 89MB
analysis: 2 files, 5MB
workspace: 42 files, 234MB
disposable: 0 files, 0MB
```

### Access Specific Compartment

```bash
# Navigate to compartment
cd /opt/erazor/compartments/reconnaissance

# View isolation policy
cat compartment.conf

# List compartment data
ls -la data/
```

### Isolation Features

#### Network Isolation
```bash
# Each compartment can have its own network rules
cat /opt/erazor/compartments/firewall-rules.sh

# Run firewall rules
sudo bash /opt/erazor/compartments/firewall-rules.sh
```

#### Filesystem Isolation
```bash
# Compartments have separate data directories
/opt/erazor/compartments/exploitation/data/    # Isolated data
/opt/erazor/compartments/exploitation/scripts/ # Isolated scripts
/opt/erazor/compartments/exploitation/.isolated/ # Protected files
```

---

## Disposable Compartments

Disposable compartments are **temporary, auto-cleanup environments** perfect for high-risk testing.

### Create Disposable Environment

```bash
erazor-compartment dispose my-risky-test
```

This creates a new disposable at:
```
/opt/erazor/compartments/disposable/my-risky-test-<timestamp>
```

### Use Disposable

```bash
# Enter disposable environment
cd /opt/erazor/compartments/disposable/my-risky-test-*/

# Do testing...
# ...

# Auto-cleanup (24 hours) or manually cleanup
bash .cleanup
```

### Automatic Cleanup

Disposables are automatically cleaned up after **24 hours** via:
```bash
bash /opt/erazor/compartments/cleanup-all.sh
```

This runs as a cron job.

---

## Isolation Policies

Compartments follow strict isolation policies defined in:
```
/opt/erazor/compartments/isolation-policy.yaml
```

### Key Rules

**Data Flow:**
- Unidirectional (one-way) between compartments
- No cross-compartment data access
- Explicit sharing only

**Network Flow:**
- Compartment-restricted
- Firewalls between domains
- Controlled egress

**Privilege Escalation:**
- Prevented between compartments
- Minimal sudo usage
- User separation

### Custom Policies

Edit policies for your workflow:
```bash
sudo nano /opt/erazor/compartments/isolation-policy.yaml
```

---

## Security Best Practices

### ✅ DO

- ✅ Use appropriate compartment for each tool
- ✅ Keep exploitation in `exploitation` compartment
- ✅ Use disposables for uncertain operations
- ✅ Regularly cleanup disposables
- ✅ Document what you do in each compartment
- ✅ Assume compartments are isolated

### ❌ DON'T

- ❌ Share credentials between compartments
- ❌ Copy untrusted files out of analysis compartment
- ❌ Run networking tools from analysis compartment
- ❌ Connect analysis compartment to network
- ❌ Mix high-risk and low-risk in one compartment
- ❌ Ignore isolation policies

---

## Compartment Workflow

### Example: Authorized Penetration Test

```bash
# 1. Create test-specific compartment
erazor-compartment create acme-corp-test

# 2. Place tools and data in compartment
cp nmap-results.txt /opt/erazor/compartments/acme-corp-test/data/
cp exploit.py /opt
