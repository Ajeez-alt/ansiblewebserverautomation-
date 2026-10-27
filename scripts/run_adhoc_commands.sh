#!/bin/bash
# ==============================================================================
# Script: run_adhoc_commands.sh
# Purpose: Comprehensive demonstration of Ansible Ad Hoc Commands
# Author: AJEEZ PRABU B (Roll No. 23bcs161)
# ==============================================================================

set -e

# Set config path and inventory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
cd "$PROJECT_ROOT"
export ANSIBLE_CONFIG="$PROJECT_ROOT/ansible.cfg"

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo -e "${BLUE}==================================================================${NC}"
echo -e "${BLUE}          ANSIBLE AD HOC COMMANDS DEMONSTRATION SUITE             ${NC}"
echo -e "${BLUE}==================================================================${NC}"

run_demo() {
    local title="$1"
    local cmd="$2"
    echo -e "\n${YELLOW}>>> [STEP] $title${NC}"
    echo -e "${CYAN}$ $cmd${NC}"
    eval "$cmd"
}

# 1. Ping module: Verify node reachability
run_demo "1. Connectivity Verification (ping module)" \
    "ansible all -i inventory/hosts.ini -m ping"

# 2. Command module: System uptime
run_demo "2. Check System Uptime (command module)" \
    "ansible webservers -i inventory/hosts.ini -m command -a 'uptime'"

# 3. Shell module: Detailed Memory & Disk Usage
run_demo "3. Resource Telemetry (shell module with pipes)" \
    "ansible webservers -i inventory/hosts.ini -m shell -a 'free -h | grep Mem; df -h / | tail -n 1'"

# 4. Setup module: Fact Gathering (Filtering distribution)
run_demo "4. Target System Fact Gathering (setup module)" \
    "ansible webservers -i inventory/hosts.ini -m setup -a 'filter=ansible_distribution*'"

# 5. File module: Idempotent Directory Management
run_demo "5. Directory Creation & Permissions (file module)" \
    "ansible webservers -i inventory/hosts.ini -m file -a 'path=/tmp/ansible_demo_dir state=directory mode=0755 owner=ajeez' --become"

# 6. Copy module: Deploying Ad Hoc Content
run_demo "6. Direct Content Deployment (copy module)" \
    "ansible webservers -i inventory/hosts.ini -m copy -a 'content=\"Ansible Ad Hoc Automation verified at $(date)\n\" dest=/tmp/ansible_demo_dir/demo.txt mode=0644'"

# 7. Command module: Reading Remote Content
run_demo "7. Remote Content Verification (command module)" \
    "ansible webservers -i inventory/hosts.ini -m command -a 'cat /tmp/ansible_demo_dir/demo.txt'"

# 8. Service module: Checking Nginx Service Status
run_demo "8. Service State Inspection (service module)" \
    "ansible webservers -i inventory/hosts.ini -m service -a 'name=nginx state=started' --become"

echo -e "\n${GREEN}==================================================================${NC}"
echo -e "${GREEN}   All Ad Hoc Commands Executed Successfully with 0 Errors!       ${NC}"
echo -e "${GREEN}==================================================================${NC}"
