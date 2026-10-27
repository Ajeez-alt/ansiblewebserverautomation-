# Module 01: Ansible Architecture & Node Setup

## 1. Overview of Ansible Architecture

Ansible is an **agentless**, open-source automation engine used for configuration management, application deployment, intraservice orchestration, and cloud provisioning.

Unlike traditional configuration management tools (such as Puppet or Chef) that require continuous background daemons ("agents") running on every managed target, Ansible operates over standard **SSH** (for Linux/Unix) or **WinRM** (for Windows) using standard Python execution.

```
+-------------------------------------------------------------+
|                 ANSIBLE CONTROL NODE                        |
|                                                             |
|  - Host: Ubuntu 26.04 LTS (WSL2 / Linux Kernel 6.6+)        |
|  - Engine: Ansible Core 2.20.1                              |
|  - Runtime: Python 3.14 + PyYAML 6.0.3 + Jinja2 3.1.6       |
|  - Config: ansible.cfg                                      |
|  - Inventories: hosts.ini & hosts.yaml                      |
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
| OS: Ubuntu Linux              |           | OS: Ubuntu Linux              |
| Service: Nginx Web Server     |           | Service: Nginx Web Server     |
| Target Port: 80 / HTTP        |           | Target Port: 80 / HTTP        |
+-------------------------------+           +-------------------------------+
```

---

## 2. Key Components of the Architecture

### A. The Control Node
- The system from which all Ansible CLI tools (`ansible`, `ansible-playbook`, `ansible-inventory`, `ansible-galaxy`) are executed.
- Requirements: Unix-like environment (Linux, macOS, or Windows Subsystem for Linux), Python 3.9+, and OpenSSH client.
- In our project, the Control Node runs on an **Ubuntu 26.04 LTS** instance running under WSL2 with Python 3.14.

### B. Managed Nodes (Target Hosts)
- The remote servers or virtual machines configured by the Control Node.
- Requirements: No agent software needed! Requires only Python 3 and OpenSSH server.
- In our project, we showcase two deployment topologies:
  1. `managed-node-1`: Authenticated over true **OpenSSH (ED25519 key-pair)** on port 22.
  2. `managed-node-2` & `control-node`: Interfacing through Ansible's optimized local transport engine (`ansible_connection=local`).

### C. Connection & Authentication Mechanism
1. **Cryptographic Key-Pair (ED25519)**:
   - Generated using `ssh-keygen -t ed25519 -N ""` on the Control Node.
   - Public key is authorized in `~/.ssh/authorized_keys` on managed nodes.
2. **Passwordless Sudo Escalation**:
   - Automated via `/etc/sudoers.d/ajeez` with `NOPASSWD: ALL` permissions, allowing Ansible's `become: true` privilege escalation without prompt delays during playbook automation.

---

## 3. Setup Commands

To bootstrap the Control Node and Managed Nodes environment:

```bash
# 1. Update system repositories and install essential packages
sudo apt-get update && sudo apt-get install -y openssh-server python3 python3-pip curl nginx

# 2. Run the automated node setup script
bash scripts/setup_nodes.sh

# 3. Verify that Ansible recognizes all inventory targets
ansible all -m ping
```

---

## 4. Verification

When testing connectivity, Ansible transmits the Python `ping` module over the SSH transport, evaluates Python execution on the target, and returns structured JSON:

```json
managed-node-1 | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
```

The `"changed": false` indicator confirms that the node was inspected without mutating its state—a core tenet of Ansible's idempotent philosophy.
