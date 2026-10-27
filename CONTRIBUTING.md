# Group Contribution Statement

## Project: Automated Web Server Infrastructure Deployment with Ansible
**Institution:** Mepco Schlenk Engineering College  
**Department:** Department of Computer Science and Engineering  
**Academic Year:** 2026-2027  

---

### Team Members & Register Numbers

1. **AJEEZ PRABU B** — Reg. No. `23bcs161`
2. **ARON YUVARAJ J** — Reg. No. `23bcs162`
3. **ASHIQ RAHMAN B** — Reg. No. `23bcs163`

---

### Detailed Breakdown of Responsibilities

#### 1. AJEEZ PRABU B (Roll No. 23bcs161)
- **Role:** Control Node Architect & Automation Operations Lead
- **Key Contributions:**
  - Designed and configured the Ansible Control Node on Ubuntu Linux / WSL2.
  - Authored the root configuration file `ansible.cfg` optimizing pipelining, callback formatting, and privilege escalation rules.
  - Developed `scripts/setup_nodes.sh` to automate ED25519 SSH cryptographic key generation and target authorization.
  - Implemented the comprehensive Ad Hoc command automation suite `scripts/run_adhoc_commands.sh`.
  - Authored `playbooks/01_test_connectivity.yml` and `playbooks/02_common_modules_demo.yml` showcasing core Ansible modules (`file`, `copy`, `lineinfile`, `command`, `shell`, `stat`, `apt`, `service`).
  - Authored documentation: `docs/01_architecture_setup.md` and `docs/04_adhoc_commands_reference.md`.
- **Git Commits:**
  - `feat(core): setup ansible control node, ansible.cfg, and node bootstrapping script`
  - `feat(modules): add ad hoc suite, common modules demo playbook, and documentation`

---

#### 2. ARON YUVARAJ J (Roll No. 23bcs162)
- **Role:** Inventory Specialist & YAML Systems Architect
- **Key Contributions:**
  - Structured both INI-format (`inventory/hosts.ini`) and YAML-format (`inventory/hosts.yaml`) inventory files.
  - Designed hierarchical variable management across `inventory/group_vars/all.yml`, `inventory/group_vars/webservers.yml`, and host-specific files (`inventory/host_vars/managed-node-1.yml`, `inventory/host_vars/managed-node-2.yml`).
  - Authored educational guides on YAML fundamentals: `docs/02_inventory_guide.md` and `docs/03_yaml_basics_guide.md`.
  - Developed the modular, reusable Ansible Role `roles/webserver/` with dedicated directories (`tasks`, `handlers`, `vars`, `defaults`, `templates`, `meta`) conforming to Ansible Galaxy industry standards.
  - Created `playbooks/deploy_webserver_role.yml` demonstrating role invocation with variable overrides.
- **Git Commits:**
  - `feat(inventory): add INI/YAML inventories, group/host vars, and YAML syntax guide`
  - `feat(roles): implement reusable modular webserver role and role-based playbook`

---

#### 3. ASHIQ RAHMAN B (Roll No. 23bcs163)
- **Role:** Playbook Lead & Quality Assurance Engineer
- **Key Contributions:**
  - Engineered the master enterprise playbook `playbooks/deploy_webserver.yml` for end-to-end Nginx installation, configuration, and verification.
  - Designed the dynamic Jinja2 web template `templates/index.html.j2` which pulls live facts from managed nodes (OS, IP, memory, vCPUs, architecture) and renders a responsive modern dashboard.
  - Created custom Nginx virtual host template `templates/nginx_vhost.conf.j2` with health-check endpoints and custom security headers.
  - Configured Ansible handlers (`notify`) for zero-downtime Nginx syntax validation and service reloading.
  - Created automated execution runner `scripts/run_playbook.sh` and master testing verification suite `scripts/verify_all.sh` (validating 7/7 tests with exit code 0).
  - Authored `docs/05_common_modules_guide.md` and co-authored `VIDEO_RECORDING_GUIDE.md`.
- **Git Commits:**
  - `feat(playbook): add Nginx web server deployment playbook, Jinja2 dynamic template, and runner script`
  - `test(verification): add automated end-to-end testing and health check verification suite`

---

### Collaborative Deliverables
All three group members contributed jointly to:
- Final repository polishing and `README.md` authoring.
- Designing the 15-minute live demo schedule and Q&A preparation in `PRESENTATION_SCRIPT.md`.
- Rehearsing and producing the final screen-recorded video walkthrough.
