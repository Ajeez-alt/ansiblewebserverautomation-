#!/bin/bash
# ==============================================================================
# Script: run_playbook.sh
# Purpose: Execute and validate the Web Server deployment playbook
# Author: ASHIQ RAHMAN B (Roll No. 23bcs163)
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
NC='\033[0m'

echo -e "${BLUE}==================================================================${NC}"
echo -e "${BLUE}       ANSIBLE WEB SERVER PLAYBOOK AUTOMATION RUNNER              ${NC}"
echo -e "${BLUE}==================================================================${NC}"

# Step 1: Syntax Check
echo -e "\n${YELLOW}[Step 1/3] Validating Playbook Syntax...${NC}"
ansible-playbook -i inventory/hosts.ini playbooks/deploy_webserver.yml --syntax-check
echo -e "${GREEN}Syntax Validation Passed!${NC}"

# Step 2: List Tasks and Target Hosts
echo -e "\n${YELLOW}[Step 2/3] Inspecting Planned Tasks and Target Hosts...${NC}"
ansible-playbook -i inventory/hosts.ini playbooks/deploy_webserver.yml --list-hosts --list-tasks

# Step 3: Execute Playbook
echo -e "\n${YELLOW}[Step 3/3] Executing Web Server Deployment Playbook...${NC}"
ansible-playbook -i inventory/hosts.ini playbooks/deploy_webserver.yml -v

echo -e "\n${GREEN}==================================================================${NC}"
echo -e "${GREEN}      Web Server Deployment and Verification Complete!            ${NC}"
echo -e "${GREEN}==================================================================${NC}"
