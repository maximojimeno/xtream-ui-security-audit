# 🔐 Xtream UI Security Audit & Exploitation Framework

[![Python 3.x](https://img.shields.io/badge/python-3.x-blue.svg)](https://www.python.org/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Security Research](https://img.shields.io/badge/Research-Security-red.svg)](https://github.com)

**Complete security audit and penetration testing toolkit for Xtream UI/Xtream Codes IPTV panel installations.**

> ⚠️ **DISCLAIMER**: This tool is for educational and authorized security testing purposes ONLY. Unauthorized access to computer systems is illegal. Use responsibly.

---

## 📋 Overview

This repository contains a comprehensive security audit of the Xtream UI installer, including:

- **15+ Critical Vulnerabilities** identified and documented
- **Proof-of-Concept (PoC) exploits** for each vulnerability
- **Automated vulnerability scanners**
- **Detailed remediation guides**
- **Executive summary reports**

### 🎯 Key Features

- ✅ **Multi-Port Scanner** - Automatically scans all known Xtream UI ports
- ✅ **Credential Decryptor** - Recovers MySQL credentials from weak XOR encryption
- ✅ **Command Injection PoC** - Demonstrates RCE vulnerabilities
- ✅ **SQL Injection PoC** - Shows database exploitation techniques
- ✅ **Full Exploit Chain** - Complete attack path from recon to root access
- ✅ **Comprehensive Documentation** - Technical reports and remediation guides

---

## 📊 Vulnerability Summary

| Severity | Count | CVE/CWE |
|----------|-------|---------|
| 🔴 **CRITICAL** | 4 | CWE-78, CWE-89, CWE-327, CWE-798 |
| 🟠 **HIGH** | 3 | CWE-494, CWE-250, CWE-732 |
| 🟡 **MEDIUM** | 8+ | Various |

**Overall CVSS Score**: 9.8/10 (Critical)

### Top Vulnerabilities

1. **Command Injection (CVSS 9.8)** - Remote Code Execution as root
2. **SQL Injection (CVSS 9.1)** - Full database compromise
3. **Weak Encryption (CVSS 8.9)** - MySQL credentials in plaintext
4. **Hardcoded Credentials (CVSS 9.8)** - Default admin/admin access

---

## 🚀 Quick Start

### Prerequisites

- Python 3.6 or higher
- Linux/macOS environment (or WSL on Windows)
- Authorized access to target systems

### Installation

```bash
# Clone the repository
git clone https://github.com/YOUR_USERNAME/xtream-ui-security-audit.git
cd xtream-ui-security-audit

# Make scripts executable
chmod +x exploits/*.py demo.sh

# Verify installation
python3 exploits/security_scanner.py --help
```

### Basic Usage

#### 1. Automated Multi-Port Scan

```bash
# Scan all known Xtream UI ports automatically
python3 exploits/multi_port_scanner.py TARGET_IP

# Add custom ports
python3 exploits/multi_port_scanner.py TARGET_IP 8080,9000
```

#### 2. Single Port Scan

```bash
# Scan specific port
python3 exploits/security_scanner.py TARGET_IP 25500
```

#### 3. Decrypt Configuration

```bash
# Recover MySQL credentials
python3 exploits/decrypt_config.py /path/to/config
```

#### 4. View All Demos

```bash
# Interactive demonstration
./demo.sh
```

---

## 📁 Repository Structure

```
xtream-ui-security-audit/
├── README.md                      # This file
├── SECURITY_AUDIT_README.md       # Detailed audit documentation
├── EXECUTIVE_SUMMARY.md           # Executive summary (Spanish)
├── VULNERABILITIES_REPORT.md      # Technical vulnerability report
├── PORTS_GUIDE.md                 # Complete ports & services guide
├── PYTHON3_READY.md               # Python 3 compatibility info
│
├── exploits/                      # Exploitation scripts
│   ├── README.md                  # Exploits usage guide
│   ├── multi_port_scanner.py      # ⭐ Multi-port vulnerability scanner
│   ├── security_scanner.py        # Single-port scanner
│   ├── decrypt_config.py          # Config decryption tool
│   ├── command_injection_poc.py   # Command injection PoC
│   ├── sql_injection_poc.py       # SQL injection PoC
│   ├── full_exploit_chain.py      # Complete exploitation chain
│   └── security_scanner.py        # Automated scanner
│
├── files/                         # Original installer files
│   ├── GeoLite2.mmdb
│   ├── panel_api.php
│   ├── pid_monitor.php
│   ├── player_api.php
│   └── release_22f.zip
│
├── install.py                     # Original vulnerable installer
├── balancer.py                    # Load balancer installer
├── demo.sh                        # Interactive demo script
└── LICENSE                        # MIT License
```

---

## 🔍 Detailed Documentation

### For Security Researchers

- 📖 **[VULNERABILITIES_REPORT.md](VULNERABILITIES_REPORT.md)** - Technical analysis of all vulnerabilities
- 🔧 **[exploits/README.md](exploits/README.md)** - How to use exploitation scripts
- 🌐 **[PORTS_GUIDE.md](PORTS_GUIDE.md)** - Complete guide to Xtream UI ports and services

### For Management/Executives

- 📊 **[EXECUTIVE_SUMMARY.md](EXECUTIVE_SUMMARY.md)** - Business impact and recommendations (Spanish)

### For Developers/Defenders

- 🛡️ **[SECURITY_AUDIT_README.md](SECURITY_AUDIT_README.md)** - Complete security audit index
- 🐍 **[PYTHON3_READY.md](PYTHON3_READY.md)** - Python 3 compatibility notes

---

## 🎯 Use Cases

### ✅ Authorized Use

- Security audits with written authorization
- Penetration testing as part of security assessments
- Educational research in controlled environments
- Bug bounty programs (if applicable)
- Internal security testing of your own systems

### ❌ Unauthorized Use

- Attacking systems without explicit permission
- Unauthorized access to data or systems
- Malicious use of exploits
- Any illegal activities

**Violating these guidelines may result in criminal prosecution.**

---

## 🛠️ Tools Overview

### Multi-Port Scanner ⭐

Automatically scans all known Xtream UI ports and detects vulnerabilities.

**Ports Scanned**:

- 25500 (Admin Panel)
- 25461 (HTTP Streaming API)
- 25462 (RTMP Streaming)
- 25463 (HTTPS Streaming)
- 7999 (MySQL Database)
- 22 (SSH)
- Custom ports (optional)

### Config Decryptor

Reverses the weak XOR encryption used to protect MySQL credentials in the config file.

### Exploit PoCs

Demonstrates exploitation techniques for:

- Command Injection → RCE as root
- SQL Injection → Database compromise
- Default Credentials → Admin access
- Complete attack chains

---

## 🔒 Security Recommendations

### For System Administrators

1. **Immediate Actions**:
   - Change default credentials (admin/admin)
   - Restrict MySQL port (7999) to localhost only
   - Update to latest patched version
   - Implement firewall rules

2. **Long-term Improvements**:
   - Migrate to Python 3
   - Use prepared statements for SQL queries
   - Implement proper encryption (AES-256, not XOR)
   - Add two-factor authentication
   - Regular security audits

### Firewall Configuration Example

```bash
# Block MySQL from external access
iptables -A INPUT -p tcp --dport 7999 -s 127.0.0.1 -j ACCEPT
iptables -A INPUT -p tcp --dport 7999 -j DROP

# Restrict admin panel to specific IPs
iptables -A INPUT -p tcp --dport 25500 -s YOUR_IP -j ACCEPT
iptables -A INPUT -p tcp --dport 25500 -j DROP

# Save rules
iptables-save > /etc/iptables/rules.v4
```

---

## 📖 Example Workflow

### Complete Security Assessment

```bash
# 1. Reconnaissance
python3 exploits/multi_port_scanner.py target.example.com

# 2. If admin panel found, test default credentials
# Browser: http://target.example.com:25500
# Try: admin/admin

# 3. If SSH access available, decrypt config
ssh user@target.example.com
python3 decrypt_config.py /home/xtreamcodes/iptv_xtream_codes/config

# 4. Generate comprehensive report
cat VULNERABILITIES_REPORT.md
cat EXECUTIVE_SUMMARY.md
```

---

## 🤝 Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/NewExploit`)
3. Commit your changes (`git commit -am 'Add new exploit'`)
4. Push to the branch (`git push origin feature/NewExploit`)
5. Open a Pull Request

---

## 📜 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

```
MIT License

Copyright (c) 2026 Security Research Team

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software...
```

---

## ⚠️ Legal Disclaimer

**IMPORTANT**: This software is provided for educational and authorized security testing purposes only.

- ✅ Use ONLY on systems you own or have explicit written permission to test
- ❌ Unauthorized access to computer systems is ILLEGAL
- ⚖️ Violations may result in criminal prosecution under:
  - Computer Fraud and Abuse Act (CFAA) - USA
  - Computer Misuse Act - UK
  - Similar laws in other jurisdictions

**The authors assume NO liability for misuse of this software.**

---

## 📞 Contact & Support

- **Issues**: [GitHub Issues](https://github.com/YOUR_USERNAME/xtream-ui-security-audit/issues)
- **Security Vulnerabilities**: Please report responsibly via private disclosure

---

## 🙏 Acknowledgments

- Original Xtream UI installer analysis
- Security research community
- OWASP Top 10 project
- CWE/CVE databases

---

## 📊 Statistics

- **Vulnerabilities Found**: 15+
- **Exploits Developed**: 6
- **Documentation Pages**: 10+
- **Lines of Code**: ~2000+
- **CVSS Score**: 9.8/10

---

## 🔗 Related Resources

- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [CWE Top 25](https://cwe.mitre.org/top25/)
- [CVSS Calculator](https://www.first.org/cvss/calculator/3.1)

---

**Made with 🔐 for the security community**

*Last Updated: January 29, 2026*
