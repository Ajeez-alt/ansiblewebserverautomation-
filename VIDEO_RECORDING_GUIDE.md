# Screen-Recorded Video Guide: Ansible Automated Deployment

## Objective
This guide outlines the step-by-step recording plan to create a clear, high-quality 5 to 10-minute screen recording of the working demo for project submission.

---

## 🛠 Recommended Recording Setup

1. **Software:**
   - **Windows Game Bar:** Press `Win + Alt + R` to start/stop screen recording instantly without installing extra software.
   - **OBS Studio (Free & Open Source):** Recommended for crystal-clear resolution (1080p, 60fps), audio capture, and window cropping.
2. **Terminal Setup:**
   - Font: JetBrains Mono / Cascadia Code / Consolas, size 16-18 for crisp readability on video.
   - Clean background, dark theme preferred.
3. **Audio:**
   - Record voice narration explaining each step, or add text captions / subtitles.

---

## 🎬 Step-by-Step Recording Timeline (Scene by Scene)

```
+----------------------------------------------------------------------------------+
| SCENE | DURATION | ACTION ON SCREEN                                              |
+----------------------------------------------------------------------------------+
| 01    | 00:00-01:00 | Project overview, folder structure, git log with 3 members |
| 02    | 01:00-02:00 | Control Node setup, ansible.cfg & setup_nodes.sh execution |
| 03    | 02:00-03:30 | Inventory demonstration (INI, YAML, graph views)          |
| 04    | 03:30-05:00 | Live Ad Hoc Commands execution & common modules demo       |
| 05    | 05:00-07:30 | Web server playbook execution & handlers in action         |
| 06    | 07:30-09:00 | Final verification suite & live browser/curl output        |
+----------------------------------------------------------------------------------+
```

---

### Scene 1: Project Introduction & Git Contribution History (`00:00 - 01:00`)
- **Screen Display:** Open VS Code or terminal in `ansible-webserver-automation`.
- **Action:**
  ```bash
  cd ansible-webserver-automation
  ls -la
  git log --graph --pretty=format:'%h - %an (%ar): %s' -n 10
  ```
- **Narration:**
  > "Welcome to our demonstration of Automated Web Server Deployment using Ansible. Here is our project workspace. As shown in our Git commit log, all three group members—Ajeez Prabu, Aron Yuvaraj, and Ashiq Rahman—have contributed distinct modules to this repository."

---

### Scene 2: Control Node & Architecture Setup (`01:00 - 02:00`)
- **Action:**
  ```bash
  ansible --version
  cat ansible.cfg
  bash scripts/setup_nodes.sh
  ```
- **Narration:**
  > "Here is our Ansible Control Node running on Ubuntu Linux with Python 3.14. Our `ansible.cfg` configures our default inventory, SSH pipelining, and privilege escalation rules. Running `setup_nodes.sh` generates our ED25519 cryptographic key pair, starts the OpenSSH service, and verifies the SSH handshake to our managed targets."

---

### Scene 3: Inventories & YAML Demonstrations (`02:00 - 03:30`)
- **Action:**
  ```bash
  cat inventory/hosts.ini
  ansible-inventory -i inventory/hosts.ini --graph
  cat inventory/hosts.yaml
  ansible-inventory -i inventory/hosts.yaml --graph
  ansible-inventory -i inventory/hosts.ini --host managed-node-1
  ```
- **Narration:**
  > "Next, we demonstrate our inventory systems. We implemented both INI and YAML formats with host groups and nested production hierarchies. Notice how running `ansible-inventory --host managed-node-1` shows variables resolved from `group_vars` and overridden by `host_vars`."

---

### Scene 4: Ad Hoc Commands in Action (`03:30 - 05:00`)
- **Action:**
  ```bash
  bash scripts/run_adhoc_commands.sh
  ```
- **Narration:**
  > "Now, we execute our Ad Hoc Commands demonstration script. In real time, Ansible executes ping tests, queries system uptime, inspects memory with shell pipelines, idempotently manages directories with the file module, and queries hardware facts with the setup module."

---

### Scene 5: Web Server Playbook Execution (`05:00 - 07:30`)
- **Action:**
  ```bash
  # First show the playbook structure
  head -n 45 playbooks/deploy_webserver.yml
  
  # Execute the playbook runner
  bash scripts/run_playbook.sh
  ```
- **Narration:**
  > "Here is our main playbook: `deploy_webserver.yml`. It handles package installation, directory setup, virtual host templating, dynamic HTML rendering via Jinja2, service management, and handler-triggered reloads. Running `run_playbook.sh` first performs a syntax check, lists planned tasks, and executes the play against our managed nodes. Every task completes with ok and changed, zero failures."

---

### Scene 6: End-to-End Verification & Final Output (`07:30 - 09:00`)
- **Action:**
  ```bash
  # Run the master automated test suite
  bash scripts/verify_all.sh

  # Check the live web server response
  curl -i http://127.0.0.1:80/
  curl http://127.0.0.1:80/health
  ```
- **Browser Showcase (Optional):**
  Open a browser to `http://localhost/` (or display the rendered HTML file) showing the modern dashboard with system telemetry (CPU cores, RAM, OS, hostname) and academic credits for AJEEZ PRABU B, ARON YUVARAJ J, and ASHIQ RAHMAN B.
- **Narration:**
  > "To guarantee production reliability, our automated verification script tests all 7 stages—from SSH handshakes and YAML linting to HTTP smoke tests—resulting in a 100% success rate. The live Nginx web server returns 200 OK along with our dynamic dashboard. This concludes our video demonstration."

---

## 📦 Video Submission Checklist
- [x] Video resolution is at least 720p or 1080p.
- [x] Audio/narration is loud and clear (or readable subtitles included).
- [x] Git log showing commits from all group members is visible in the video.
- [x] Terminal commands and JSON outputs are sharp and readable.
- [x] Web server output (HTTP 200 OK / Browser view) is clearly shown.
