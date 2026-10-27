# Module 02: Ansible Inventory Guide (INI vs YAML)

## 1. What is an Ansible Inventory?

The **Inventory** is Ansible's single source of truth for all target systems. It defines:
- The hosts (IP addresses or domain names) that Ansible automates.
- Logical grouping of hosts (e.g., `webservers`, `dbservers`, `loadbalancers`).
- Connection variables (SSH ports, private key paths, remote usernames).
- Operational variables passed into playbooks and Jinja2 templates.

---

## 2. INI Format vs YAML Format

Ansible natively parses inventories written in both **INI** and **YAML** formats.

### Comparison Table

| Feature | INI Format (`hosts.ini`) | YAML Format (`hosts.yaml`) |
| :--- | :--- | :--- |
| **Syntax Style** | Flat, bracketed section headers `[group]` | Strict hierarchical indentation (2 spaces) |
| **Readability for Small Setups** | Extremely fast to read and write | Clean and structured |
| **Complex Nested Data** | Clunky when passing nested lists or dicts | Native support for nested objects and arrays |
| **Variable Association** | Suffix syntax (`host var=val`) or `[group:vars]` | Structured key-value tree under `vars:` block |
| **Industry Adoption** | Traditional, widespread in legacy playbooks | Preferred for modern cloud-native & GitOps flows |

---

## 3. Inventory Hierarchy & Variable Precedence

Ansible allows variables to be declared in multiple places. When the same variable is defined in multiple layers, Ansible resolves conflicts using a strict **Variable Precedence**:

```
[Low Priority]
1. inventory/group_vars/all.yml      <-- Broadest scope (all servers)
2. inventory/group_vars/<group>.yml  <-- Group scope (e.g. webservers)
3. inventory/hosts.ini or hosts.yaml <-- Inventory-level declarations
4. inventory/host_vars/<host>.yml    <-- Host-specific overrides
5. Playbook vars: / vars_files:      <-- Task/Playbook definitions
6. Extra vars (-e "var=value")       <-- Highest priority (command-line override)
[High Priority]
```

### In Our Architecture:
- `all.yml`: Sets institution details, base log paths, and default SSH port.
- `webservers.yml`: Sets default Nginx port (80) and web root (`/var/www/html`).
- `host_vars/managed-node-1.yml`: Overrides `server_banner_color` to Blue and sets priority to Primary.
- `host_vars/managed-node-2.yml`: Overrides `server_banner_color` to Teal and sets priority to Secondary.

---

## 4. Useful Inventory Commands

```bash
# Graphically view inventory hierarchy and groupings
ansible-inventory -i inventory/hosts.ini --graph

# View inventory exported as parsed JSON
ansible-inventory -i inventory/hosts.ini --list

# View inventory using YAML format
ansible-inventory -i inventory/hosts.yaml --graph

# Verify host-specific variables resolved by Ansible
ansible-inventory -i inventory/hosts.ini --host managed-node-1
```
