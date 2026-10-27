# Module 03: YAML Basics & Best Practices for Ansible

## 1. What is YAML?

**YAML** stands for **YAML Ain't Markup Language** (originally "Yet Another Markup Language"). It is a human-readable data serialization language widely adopted for modern DevOps tooling (Ansible, Kubernetes, GitHub Actions, Docker Compose).

Ansible playbooks, task lists, variable files, and role definitions are strictly structured using YAML.

---

## 2. Core Syntax Rules

1. **Indentation Matters**:
   - YAML uses spaces for indentation—**never tabs**!
   - Best practice: Standardize on **2 spaces per indentation level**.
2. **Document Markers**:
   - `---` (three hyphens) indicates the start of a YAML document.
   - `...` (three dots) optionally marks the end of a document.
3. **Case Sensitivity**:
   - All keys, variable names, and string literals are strictly case-sensitive.
4. **Comments**:
   - Any text following a `#` is treated as a comment and ignored by the parser.

---

## 3. Fundamental Data Structures in YAML

### A. Key-Value Pairs (Scalars / Mappings)
```yaml
web_service_name: nginx
http_port: 80
enable_ssl: false
cache_timeout_seconds: 3600
```

### B. Lists (Sequences)
Items in a list are designated with a hyphen followed by a space:
```yaml
packages_to_install:
  - nginx
  - curl
  - ufw
  - git
```

Inline JSON-style array syntax is also valid:
```yaml
packages_to_install: [nginx, curl, ufw, git]
```

### C. Dictionaries (Nested Hashes)
```yaml
server_configuration:
  hostname: web-01.local
  network:
    ip: 192.168.1.100
    netmask: 255.255.255.0
    gateway: 192.168.1.1
```

### D. List of Dictionaries (Standard Playbook Tasks)
Every Ansible playbook task list is formatted as a list of dictionaries:
```yaml
tasks:
  - name: Install Nginx Web Server
    ansible.builtin.apt:
      name: nginx
      state: present

  - name: Start and enable Nginx service
    ansible.builtin.service:
      name: nginx
      state: started
      enabled: true
```

### E. Multiline Strings (`|` and `>`)
- Literal block scalar (`|`): Preserves newlines exactly as written.
- Folded block scalar (`>`): Replaces single newlines with spaces (folds lines into a single paragraph).

```yaml
# Literal block scalar (preserves exact line breaks)
custom_banner: |
  =========================================
  WELCOME TO MEPCO SCHLENK WEB SERVER
  POWERED BY ANSIBLE AUTOMATION
  =========================================

# Folded block scalar (becomes one single continuous line)
description: >
  This web server was provisioned automatically
  using modern infrastructure as code principles
  and idempotent task execution.
```

---

## 4. Common YAML Gotchas in Ansible

| Gotcha | Example of Problem | Solution |
| :--- | :--- | :--- |
| **Colons without trailing space** | `key:value` (causes parse error) | Always include space: `key: value` |
| **Jinja2 curly braces at start of line** | `msg: {{ variable }}` (YAML parser treats `{` as hash start) | Quote the string: `msg: "{{ variable }}"` |
| **Tab indentation** | Using Tab key instead of space bar | Configure editor to replace tabs with 2 spaces |
| **Boolean representations** | `yes/no`, `true/false`, `on/off` | Use explicit standard `true` or `false` |
| **Leading zeros in numbers** | `file_mode: 0755` (interpreted as octal) | In Ansible file modules, pass modes as strings: `mode: "0755"` |

---

## 5. Validating YAML Files

You can test and lint YAML files quickly before executing Ansible:

```bash
# Check YAML syntax using Python's PyYAML parser:
python3 -c "import yaml, sys; yaml.safe_load(open('inventory/group_vars/all.yml'))"

# Validate Playbook syntax directly with Ansible:
ansible-playbook playbooks/deploy_webserver.yml --syntax-check
```
