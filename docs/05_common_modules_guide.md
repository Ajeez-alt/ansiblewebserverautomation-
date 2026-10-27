# Module 05: Common Ansible Modules Deep Dive

## 1. What is an Ansible Module?

An **Ansible Module** (also known as a task plugin or library) is a discreet unit of reusable code executed on managed target nodes. Each module is designed to be **idempotent**: running the same task multiple times ensures the system converges to the desired state without performing unnecessary changes.

---

## 2. Essential Modules Overview

### 1. `ansible.builtin.ping`
- **Purpose**: Verifies remote node reachability, SSH credentials, and Python runtime.
- **Key Characteristics**: Returns `"ping": "pong"` without modifying host state.

### 2. `ansible.builtin.apt` (Debian/Ubuntu) / `ansible.builtin.package` (Cross-Platform)
- **Purpose**: Manages system packages (install, update, remove).
- **Parameters**:
  - `name`: Package name (e.g., `nginx`, `curl`).
  - `state`: `present` (installed), `absent` (removed), `latest` (upgraded).
  - `update_cache`: `yes` / `no` (equivalent to `apt-get update`).

### 3. `ansible.builtin.file`
- **Purpose**: Sets attributes of files, symlinks, and directories, or removes them.
- **Parameters**:
  - `path`: Target file or directory path.
  - `state`: `directory`, `file`, `link`, `absent`.
  - `mode`: Octal permission string (e.g., `"0755"`, `"0644"`).
  - `owner` & `group`: POSIX user and group ownership.

### 4. `ansible.builtin.copy`
- **Purpose**: Copies a local file or inline string to the remote managed node.
- **Parameters**:
  - `src`: Local file path (relative or absolute).
  - `content`: Raw text string to create directly on target.
  - `dest`: Remote destination path.
  - `backup`: `yes` / `no` (creates timestamped backup if target changes).

### 5. `ansible.builtin.template`
- **Purpose**: Processes a dynamic Jinja2 template file on the control node and places the rendered output on the remote host.
- **Parameters**:
  - `src`: Path to `.j2` template file.
  - `dest`: Target destination path.
  - Supports loops (`{% for %}`), conditionals (`{% if %}`), and host variables.

### 6. `ansible.builtin.service` / `ansible.builtin.systemd`
- **Purpose**: Controls OS system services and daemons.
- **Parameters**:
  - `name`: Name of daemon (e.g., `nginx`, `ssh`).
  - `state`: `started`, `stopped`, `restarted`, `reloaded`.
  - `enabled`: `true` / `false` (boots on system startup).

### 7. `ansible.builtin.lineinfile`
- **Purpose**: Surgically adds, modifies, or removes a specific single line within a text file using regular expressions.
- **Parameters**:
  - `path`: Target file.
  - `regexp`: Python regex pattern to match and replace.
  - `line`: New replacement line.
  - `state`: `present` or `absent`.

### 8. `ansible.builtin.command` vs `ansible.builtin.shell`
- **`command`**: Directly executes binary without passing through a shell (prevents shell injection vulnerabilities).
- **`shell`**: Executes string inside `/bin/sh` on the remote target, allowing pipes (`|`), redirects (`>`), and environment variables (`$VAR`).

### 9. `ansible.builtin.debug`
- **Purpose**: Prints custom messages or variable contents to the console during execution.
- **Parameters**:
  - `msg`: String message with optional Jinja2 interpolation.
  - `var`: Direct variable name to dump structure.
