# 15-Minute Live Presentation Script & Demonstration Walkthrough

## Session Details
- **Project Title:** Automated Web Server Infrastructure Deployment with Ansible
- **Total Duration:** 15 Minutes (+ 5 Minutes Q&A)
- **Speakers:**
  1. **AJEEZ PRABU B** (`00:00 - 04:30`)
  2. **ARON YUVARAJ J** (`04:30 - 09:30`)
  3. **ASHIQ RAHMAN B** (`09:30 - 15:00`)
  4. **All Members** (`15:00 - 20:00`): Q&A Session

---

## ⏱ Minute-by-Minute Schedule & Speaking Script

```
+-------------------------------------------------------------------------------+
|  TIME         | SPEAKER             | TOPIC & LIVE TERMINAL ACTION            |
+-------------------------------------------------------------------------------+
| 00:00 - 02:00 | AJEEZ PRABU B       | Project Overview & Ansible Architecture |
| 02:00 - 04:30 | AJEEZ PRABU B       | Control Node Setup, SSH Keys & Ping     |
| 04:30 - 07:00 | ARON YUVARAJ J    | Inventory Systems (INI & YAML) + Vars   |
| 07:00 - 09:30 | ARON YUVARAJ J    | YAML Basics & Core Syntax Deep Dive     |
| 09:30 - 12:00 | ASHIQ RAHMAN B             | Ad Hoc Commands & Common Modules Demo   |
| 12:00 - 14:00 | ASHIQ RAHMAN B             | Web Server Playbook & Handlers Execution|
| 14:00 - 15:00 | ASHIQ RAHMAN B             | Live Browser & HTTP Verification Output |
| 15:00 - 20:00 | ALL MEMBERS         | Q&A with Faculty / Evaluators           |
+-------------------------------------------------------------------------------+
```

---

### Segment 1: Introduction & Architecture Setup (`00:00 - 04:30`)
**Speaker:** AJEEZ PRABU B (Roll No. 23bcs161)

#### Verbal Presentation:
> "Good morning respected professors and evaluators. Today, our team is presenting our project on **Automated Infrastructure Deployment using Ansible**.
> 
> Configuration management in traditional IT often suffers from configuration drift and manual errors. Ansible solves this by being **completely agentless**. Unlike Puppet or Chef, which require background agents installed and managed on every server, Ansible operates purely over standard **OpenSSH** and **Python**.
> 
> As you can see on our architecture diagram, we have configured an **Ubuntu Control Node** running Ansible Core 2.20 with Python 3.14. Our Control Node orchestrates multiple managed targets—including `managed-node-1` connected over real OpenSSH with ED25519 key-pair cryptography on port 22, and `managed-node-2` running over Ansible's local transport socket.
> 
> Let me demonstrate the control node configuration and node bootstrapping live."

#### Live Terminal Actions (AJEEZ):
```bash
# 1. Show the Ansible and Python environment
ansible --version

# 2. Display the production configuration file
cat ansible.cfg

# 3. Demonstrate the automated node setup and SSH handshake
bash scripts/setup_nodes.sh

# 4. Perform an instant connectivity test across all nodes
ansible all -i inventory/hosts.ini -m ping
```

#### Explaining the Output:
> "Notice the response from Ansible: `managed-node-1 | SUCCESS => ping: pong`. This proves that our SSH cryptographic key handshake, Python interpreter discovery, and Ansible execution pipeline are fully functioning without prompting for passwords."

---

### Segment 2: Inventories & YAML Fundamentals (`04:30 - 09:30`)
**Speaker:** ARON YUVARAJ J (Roll No. 23bcs162)

#### Verbal Presentation:
> "Thank you, Ajeez. I will now explain how Ansible organizes target servers through **Inventories** and the fundamentals of **YAML syntax**.
> 
> An inventory is the single source of truth in Ansible. We implemented two industry formats:
> 1. **INI format** (`inventory/hosts.ini`): Traditional, section-based, great for concise grouping.
> 2. **YAML format** (`inventory/hosts.yaml`): Modern, hierarchical, preferred in GitOps workflows.
> 
> We have organized our servers into groups like `[control]`, `[webservers]`, and a parent group `[production:children]`.
> 
> Furthermore, we implemented **Variable Precedence**:
> - Global settings in `group_vars/all.yml`.
> - Group settings in `group_vars/webservers.yml`.
> - Host-specific overrides in `host_vars/managed-node-1.yml`.
> 
> Next, let's talk about **YAML basics**. YAML is strictly indentation-sensitive using **spaces, never tabs**. Everything in Ansible is represented as either:
> - Key-value pairs
> - Lists (hyphens)
> - Dictionaries (nested hashes)
> 
> Let me now show the inventory graphs and YAML validation."

#### Live Terminal Actions (SANTHANA PANDI):
```bash
# 1. Show the INI inventory file
cat inventory/hosts.ini

# 2. Display the inventory hierarchical graph
ansible-inventory -i inventory/hosts.ini --graph

# 3. Show the modern YAML inventory representation
cat inventory/hosts.yaml
ansible-inventory -i inventory/hosts.yaml --graph

# 4. Demonstrate variable inheritance for managed-node-1
ansible-inventory -i inventory/hosts.ini --host managed-node-1

# 5. Run Python YAML syntax verification across all project files
python3 -c "import yaml, glob; [yaml.safe_load(open(p)) for p in glob.glob('**/*.yml', recursive=True)]; print('All YAML files validated successfully!')"
```

#### Explaining the Output:
> "As you can see, Ansible merges our variables hierarchically. `managed-node-1` inherited the global department from `all.yml`, the Nginx package from `webservers.yml`, and its own custom banner color and priority from `host_vars`."

---

### Segment 3: Ad Hoc Commands, Playbooks & Live Web Server Demo (`09:30 - 15:00`)
**Speaker:** ASHIQ RAHMAN B (Roll No. 23bcs163)

#### Verbal Presentation:
> "Thank you, Aron Yuvaraj. Now I will demonstrate **Ad Hoc Commands**, our **Common Modules Playbook**, and finally execute our **Web Server Deployment Playbook**.
> 
> Ad hoc commands allow DevOps engineers to run one-off tasks across hundreds of servers simultaneously without writing playbooks. Let us execute our automated ad hoc suite."

#### Live Terminal Actions - Part A: Ad Hoc Commands (MOHAN):
```bash
# 1. Run the Ad Hoc demonstration suite
bash scripts/run_adhoc_commands.sh
```
> "Here, we demonstrated `ping`, `command` checking uptime, `shell` gathering memory statistics, `file` creating directories idempotently, and `setup` querying system facts.
> 
> Now, let us move to our centerpiece: **The Web Server Deployment Playbook** (`playbooks/deploy_webserver.yml`).
> This playbook does not just run shell commands; it follows complete DevOps best practices:
> 1. Pre-tasks verify target OS family compatibility.
> 2. Package management ensures Nginx is present.
> 3. File modules ensure permissions on `/var/www/html`.
> 4. Dynamic **Jinja2 templating** renders our landing page using real-time system facts gathered from the machine.
> 5. An **Ansible Handler** validates Nginx syntax with `nginx -t` and reloads the service only when the configuration actually changes.
> 6. Post-tasks perform automated HTTP smoke tests.
> 
> Let us run the playbook now."

#### Live Terminal Actions - Part B: Playbook Execution (MOHAN):
```bash
# 2. Check playbook syntax
ansible-playbook -i inventory/hosts.ini playbooks/deploy_webserver.yml --syntax-check

# 3. Execute the playbook
bash scripts/run_playbook.sh

# 4. Run the automated master test suite
bash scripts/verify_all.sh

# 5. Show live HTTP curl responses
curl -i http://127.0.0.1:80/
curl http://127.0.0.1:80/health
```

#### Explaining the Output:
> "As you can see on the terminal, all tasks completed with `ok` and `changed`, 0 failed, 0 unreachable.
> The smoke test returned HTTP 200 OK.
> When we curl the endpoint or open it in a browser, we see a modern styled landing page displaying the live hostname, OS version, RAM, CPU cores, and our group member details rendered dynamically by Ansible's Jinja2 template engine.
> 
> This concludes our live demonstration. We are now ready for your questions."

---

## 🎯 Anticipated Viva / Q&A Questions & Model Answers

### Q1: Why is Ansible called 'agentless', and how does it compare to Puppet or Chef?
**Answer (AJEEZ PRABU B):**  
"Puppet and Chef require an agent daemon installed, running, and listening on every managed node, which consumes memory and introduces another software package to patch and maintain. Ansible is agentless because it connects over existing standard OpenSSH (or WinRM on Windows), injects temporary Python execution modules into `/tmp`, executes them, collects the JSON result, and cleans itself up. There is zero background daemon overhead."

### Q2: What is Idempotence in Ansible, and why is it important?
**Answer (ASHIQ RAHMAN B):**  
"Idempotence means that running a task or playbook once, twice, or a hundred times yields the exact same final system state without producing unintended side effects. If Nginx is already installed and running with the correct configuration, Ansible detects this, reports `changed: false`, and skips re-installing or restarting the service. This prevents unnecessary downtime and configuration drift."

### Q3: How does variable precedence work in Ansible?
**Answer (ARON YUVARAJ J):**  
"Ansible has roughly 22 levels of variable precedence. In our project, we demonstrated the four most critical layers: `group_vars/all.yml` has the broadest scope, overridden by `group_vars/webservers.yml`, which is further overridden by `host_vars/managed-node-1.yml`. At runtime, command line extra variables passed with `-e` have the highest priority."

### Q4: What is the difference between the `command`, `shell`, and `raw` modules?
**Answer (AJEEZ PRABU B):**  
- `command`: Takes the command name and arguments directly without passing through a shell, preventing shell injection vulnerabilities. It does not support pipes (`|`) or redirects (`>`).
- `shell`: Executes commands through `/bin/sh`, allowing pipes, environment variables, and redirects.
- `raw`: Bypasses the Ansible module subsystem entirely and issues commands directly over SSH. Useful on minimalist systems where Python is not yet installed."

### Q5: What is the purpose of an Ansible Handler?
**Answer (ASHIQ RAHMAN B):**  
"Handlers are special tasks that only run when notified by another task that reported a `changed: true` state. For example, when our Nginx virtual host template is updated, it triggers `notify: Reload Nginx service`. If the template has not changed, the handler is not executed. Furthermore, handlers run once at the end of the play, preventing repeated unnecessary service restarts."
