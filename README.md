# Automated Web Server Infrastructure Deployment with Ansible

[![Ansible](https://img.shields.io/badge/Ansible-2.20%2B-red.svg)](https://www.ansible.com/)
[![Ubuntu](https://img.shields.io/badge/Ubuntu-26.04%20LTS-E95420.svg)](https://ubuntu.com/)
[![Python](https://img.shields.io/badge/Python-3.14-blue.svg)](https://www.python.org/)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

An enterprise-ready Infrastructure-as-Code (IaC) project demonstrating the complete lifecycle of **Ansible Control Node & Managed Node architecture**, **Inventory Systems (INI & YAML)**, **Ad Hoc Commands**, **YAML syntax fundamentals**, **Core Modules**, and an **Automated Nginx Web Server Playbook** with dynamic Jinja2 templating, handlers, and automated health checks.

---

## 📋 Table of Contents

1. [Project Overview](#-project-overview)
2. [Architecture Diagram](#-architecture-diagram)
3. [Repository Structure](#-repository-structure)
4. [Prerequisites & System Setup](#-prerequisites--system-setup)
5. [Step-by-Step Execution Guide](#-step-by-step-execution-guide)
   - [A. Control Node & SSH Setup](#a-control-node--ssh-setup)
   - [B. Inventory Demonstration](#b-inventory-demonstration)
   - [C. Ad Hoc Commands Suite](#c-ad-hoc-commands-suite)
   - [D. Common Modules Demonstration](#d-common-modules-demonstration)
   - [E. Web Server Playbook Execution](#e-web-server-playbook-execution)
   - [F. Reusable Modular Role Execution](#f-reusable-modular-role-execution)
   - [G. Automated End-to-End Verification](#g-automated-end-to-end-verification)
6. [YAML Basics & Best Practices](#-yaml-basics--best-practices)
7. [Common Ansible Modules Reference](#-common-ansible-modules-reference)
8. [Live Demo Guide (15-Minute Presentation)](#-live-demo-guide-15-minute-presentation)
9. [Team Contribution Statement](#-team-contribution-statement)

---

## 🚀 Project Overview

Modern DevOps relies on idempotent, declaratively defined infrastructure. This project automates the deployment of a high-performance web cluster using Ansible.

### Key Capabilities Demonstrated:
- **Agentless Orchestration**: Control node managing nodes over standard OpenSSH (ED25519) and local loopback transport.
- **Dual Inventory Systems**: Full demonstration of both INI and YAML inventory formats, nested groups, and hierarchical variable precedence (`group_vars` and `host_vars`).
- **Live Ad Hoc Operations**: One-liner system administration for diagnostics, telemetry, directory state, and remote process checks.
- **Idempotent Playbooks**: Deterministic Nginx web server installation, configuration templating, handler-based reloads, and HTTP smoke testing.
- **Dynamic Templating**: Jinja2-powered HTML landing page rendering target host architecture, kernel version, IP address, RAM, vCPUs, and academic credits.

---

## 🏛 Architecture Diagram

```
+-------------------------------------------------------------+
|                 ANSIBLE CONTROL NODE                        |
|                                                             |
|  - Host: Ubuntu 26.04 LTS (WSL2 / Linux Kernel 6.6+)        |
|  - Engine: Ansible Core 2.20.1                              |
|  - Runtime: Python 3.14 + PyYAML 6.0.3 + Jinja2 3.1.6       |
|  - Config: ansible.cfg                                      |
|  - Inventories: inventory/hosts.ini & hosts.yaml            |
|  - Private Key: ~/.ssh/id_ed25519                           |
+-------------------------------------------------------------+
         |                                           |
         | SSH (Port 22)                             | Local Socket / Loopback
         | ED25519 Public Key Auth                   | ansible_connection=local
         v                                           v
+-------------------------------+           +-------------------------------+
|     MANAGED NODE 1            |           |     MANAGED NODE 2            |
| (managed-node-1)              |           | (managed-node-2)              |
|                               |           |                               |
| Target: 127.0.0.1:22          |           | Target: Localhost Runtime     |
| Group: [webservers]           |           | Group: [webservers]           |
| Role: Primary Web Server      |           | Role: Secondary Staging Node  |
| Service: Nginx HTTP Server    |           | Service: Nginx HTTP Server    |
| Port: 80 / HTTP               |           | Port: 80 / HTTP               |
+-------------------------------+           +-------------------------------+
```

---

## 📂 Repository Structure

```
ansible-webserver-automation/
├── .gitignore                          # Git ignore rules for cache & logs
├── README.md                           # Master project documentation
├── CONTRIBUTING.md                     # Group contribution statement
├── PRESENTATION_SCRIPT.md              # 15-minute live presentation speaking script & Q&A
├── VIDEO_RECORDING_GUIDE.md            # Detailed screen recording guide for submission
├── ansible.cfg                         # Production-grade Ansible configuration
├── inventory/
│   ├── hosts.ini                       # INI-formatted inventory with groups & host vars
│   ├── hosts.yaml                      # YAML-formatted hierarchical inventory
│   ├── group_vars/
│   │   ├── all.yml                     # Global variables applied to all nodes
│   │   └── webservers.yml              # Variables scoped to webservers group
│   └── host_vars/
│       ├── managed-node-1.yml          # Host-specific overrides for Primary node
│       └── managed-node-2.yml          # Host-specific overrides for Secondary node
├── docs/
│   ├── 01_architecture_setup.md        # Architecture overview & setup manual
│   ├── 02_inventory_guide.md           # Deep dive into inventory syntax & hierarchy
│   ├── 03_yaml_basics_guide.md         # YAML syntax tutorial & best practices
│   ├── 04_adhoc_commands_reference.md  # Comprehensive ad hoc commands catalog
│   └── 05_common_modules_guide.md      # Reference guide for core Ansible modules
├── playbooks/
│   ├── 01_test_connectivity.yml       # Sanity check playbook using ping and debug
│   ├── 02_common_modules_demo.yml      # Demonstration of file, copy, lineinfile, apt, etc.
│   ├── deploy_webserver.yml            # Main playbook for Nginx web server deployment
│   └── deploy_webserver_role.yml       # Role-based web server deployment playbook
├── roles/
│   └── webserver/                      # Standard modular Ansible Role structure
│       ├── defaults/main.yml
│       ├── handlers/main.yml
│       ├── meta/main.yml
│       ├── tasks/main.yml
│       ├── templates/
│       │   ├── index.html.j2
│       │   └── nginx.conf.j2
│       └── vars/main.yml
├── templates/
│   ├── index.html.j2                   # Jinja2 dynamic HTML template with live facts
│   └── nginx_vhost.conf.j2             # Jinja2 Nginx virtual host template
└── scripts/
    ├── setup_nodes.sh                  # Bootstrap SSH keys and node authentication
    ├── run_adhoc_commands.sh           # Automated interactive ad hoc commands demo
    ├── run_playbook.sh                 # Playbook executor with syntax checks
    └── verify_all.sh                   # Master test verification suite (7/7 tests)
```

---

## ⚙ Prerequisites & System Setup

### Environment
- **Operating System:** Linux (Ubuntu 22.04 / 24.04 / 26.04) or Windows with WSL2 (Ubuntu).
- **Python:** Python 3.9 or higher.
- **Ansible:** Ansible Core 2.12 or higher (tested on 2.20.1).

### Quick Install (Ubuntu / Debian / WSL)
```bash
sudo apt-get update
sudo apt-get install -y ansible python3 python3-pip openssh-server curl
```

---

## 🏃 Step-by-Step Execution Guide

### A. Control Node & SSH Setup
Run the automated bootstrapping script to generate ED25519 SSH keys and authorize the Control Node to access managed nodes:
```bash
bash scripts/setup_nodes.sh
```

### B. Inventory Demonstration
Inspect the inventory structure using Ansible's built-in inventory graph tool:
```bash
# View INI inventory hierarchy
ansible-inventory -i inventory/hosts.ini --graph

# View YAML inventory hierarchy
ansible-inventory -i inventory/hosts.yaml --graph

# Inspect variables resolved for a specific host
ansible-inventory -i inventory/hosts.ini --host managed-node-1
```

### C. Ad Hoc Commands Suite
Run the automated ad hoc command suite demonstrating 8 essential operations:
```bash
bash scripts/run_adhoc_commands.sh
```

Or run individual commands:
```bash
# 1. Connectivity test
ansible all -i inventory/hosts.ini -m ping

# 2. System uptime
ansible webservers -i inventory/hosts.ini -m command -a "uptime"

# 3. Memory & disk check
ansible webservers -i inventory/hosts.ini -m shell -a "free -h; df -h /"

# 4. Filter OS facts
ansible webservers -i inventory/hosts.ini -m setup -a "filter=ansible_distribution*"
```

### D. Common Modules Demonstration
Execute the dedicated playbook demonstrating `file`, `copy`, `lineinfile`, `stat`, `apt`, `service`, and `debug`:
```bash
ansible-playbook -i inventory/hosts.ini playbooks/02_common_modules_demo.yml
```

### E. Web Server Playbook Execution
Run the complete Nginx web server deployment playbook:
```bash
bash scripts/run_playbook.sh
```
Or execute directly:
```bash
ansible-playbook -i inventory/hosts.ini playbooks/deploy_webserver.yml
```

### F. Reusable Modular Role Execution
To demonstrate enterprise modular roles:
```bash
ansible-playbook -i inventory/hosts.ini playbooks/deploy_webserver_role.yml
```

### G. Automated End-to-End Verification
Run the master test suite that validates every component (7/7 tests):
```bash
bash scripts/verify_all.sh
```

---

## 🌐 Deployed Output Preview

Once deployed, the web server serves a live responsive dashboard displaying real-time system telemetry and project credits:

```
+------------------------------------------------------------------+
|                   PROVISIONED BY ANSIBLE                         |
|             Intelligent Web Server Infrastructure                |
|      Automated Deployment Powered by Ansible Configuration       |
+------------------------------------------------------------------+
| HOSTNAME: managed-node-1          | ROLE: Primary Production Node|
| OS: Ubuntu 26.04                  | PORT: 80                     |
| MEMORY: 7700 MB RAM               | CPU: 12 vCPUs (x86_64)       |
+------------------------------------------------------------------+
| PROJECT TEAM:                                                    |
| - AJEEZ PRABU B    (Reg. No. 23bcs161) - Control Node & SSH |
| - ARON YUVARAJ J (Roll No. 23bcs162) - Inventories & YAML |
| - ASHIQ RAHMAN B          (Reg. No. 23bcs163) - Playbooks & Testing|
+------------------------------------------------------------------+
```

Verify directly via terminal:
```bash
curl http://127.0.0.1:80/
curl http://127.0.0.1:80/health
```

---

## 📜 YAML Basics & Best Practices

All playbooks strictly follow YAML best practices:
1. **2-space indentation** (no tabs).
2. **`---`** header at the start of every document.
3. **Quoted Jinja2 interpolations**: `msg: "{{ dynamic_var }}"`.
4. **Idempotent tasks**: Every task brings the target to the desired state without repeated changes.
5. Refer to [docs/03_yaml_basics_guide.md](docs/03_yaml_basics_guide.md) for full syntax breakdown.

---

## 👥 Team Contribution Statement

| Member Name | Register Number | Core Contributions | Commits |
| :--- | :--- | :--- | :--- |
| **AJEEZ PRABU B** | **23bcs161** | Control node architecture, `ansible.cfg`, SSH key-pair setup automation, Ad Hoc command suite, core modules demo. | `feat(core)`, `feat(modules)` |
| **ARON YUVARAJ J** | **23bcs162** | INI & YAML inventories, `group_vars`, `host_vars`, YAML syntax tutorial, modular Ansible Role implementation. | `feat(inventory)`, `feat(roles)` |
| **ASHIQ RAHMAN B** | **23bcs163** | Nginx web server playbook, dynamic Jinja2 templating, virtual host configuration, handlers, automated test verification suite. | `feat(playbook)`, `test(verification)` |

*(For full details, please refer to [CONTRIBUTING.md](CONTRIBUTING.md) and [PRESENTATION_SCRIPT.md](PRESENTATION_SCRIPT.md)).*
