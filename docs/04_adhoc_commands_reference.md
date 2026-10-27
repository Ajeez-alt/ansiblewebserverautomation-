# Module 04: Ansible Ad Hoc Commands Reference

## 1. What Are Ad Hoc Commands?

An **Ad Hoc Command** is a one-line Ansible operation executed directly from the terminal without creating an entire playbook file.

Ad hoc commands are ideal for:
- Quick administrative tasks (rebooting servers, rotating passwords).
- Instant health and connectivity checks (`ping`).
- On-demand telemetry gathering (disk usage, memory stats).
- Emergency service restarts (`service name=nginx state=restarted`).

### Basic Command Syntax:
```bash
ansible <target-pattern> -m <module-name> [-a "<module-arguments>"] [-b]
```
- `<target-pattern>`: Inventory host, group (`webservers`), or special selector (`all`).
- `-m <module-name>`: Name of the Ansible module to execute (default is `command`).
- `-a "<args>"`: Arguments or parameters passed to the selected module.
- `-b` / `--become`: Escalate privileges to root (sudo).

---

## 2. Core Ad Hoc Command Catalog

### A. Connectivity & Sanity Check (`ping`)
```bash
ansible all -m ping
```
*Note*: The `ping` module is NOT an ICMP network ping; it connects via SSH, verifies Python, and confirms Ansible execution permissions.

### B. Command Execution (`command` vs `shell`)
```bash
# Using 'command' (safe, avoids shell evaluation)
ansible webservers -m command -a "uptime"

# Using 'shell' (supports pipes, redirects, and environment variables)
ansible webservers -m shell -a "df -h / | awk 'NR==2 {print \$5}'"
```

### C. Package Management (`apt`)
```bash
# Update repository index and install curl
ansible webservers -m apt -a "name=curl state=present update_cache=yes" --become
```

### D. File Operations (`file` & `copy`)
```bash
# Create directory with strict permissions
ansible webservers -m file -a "path=/var/log/custom state=directory mode=0750" --become

# Copy raw string content directly to target
ansible webservers -m copy -a "content='System maintained by DevOps team\n' dest=/etc/motd" --become
```

### E. Service Orchestration (`service`)
```bash
# Check or start Nginx
ansible webservers -m service -a "name=nginx state=started enabled=yes" --become

# Trigger a configuration reload
ansible webservers -m service -a "name=nginx state=reloaded" --become
```

### F. Fact Gathering (`setup`)
```bash
# View all gathered system facts
ansible managed-node-1 -m setup

# Filter specific facts (e.g. OS version or IP addresses)
ansible webservers -m setup -a "filter=ansible_distribution*"
ansible webservers -m setup -a "filter=ansible_all_ipv4_addresses"
```
