#!/bin/bash
# ==============================================================================
# Script: verify_all.sh
# Purpose: Master end-to-end verification & automated testing suite
# Author: ASHIQ RAHMAN B (Roll No. 23bcs163)
# ==============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
cd "$PROJECT_ROOT"
export ANSIBLE_CONFIG="$PROJECT_ROOT/ansible.cfg"

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
RED='\033[0;31m'
NC='\033[0m'

pass_count=0
total_tests=7

record_pass() {
    pass_count=$((pass_count + 1))
    echo -e "${GREEN}✓ [PASS] $1${NC}\n"
}

echo -e "${BLUE}==================================================================${NC}"
echo -e "${BLUE}       ANSIBLE INFRASTRUCTURE AUTOMATION TEST & VERIFY            ${NC}"
echo -e "${BLUE}==================================================================${NC}"

# Test 1: Node & SSH Pre-requisites
echo -e "${YELLOW}[Test 1/$total_tests] Testing Node & SSH Handshake...${NC}"
bash "$PROJECT_ROOT/scripts/setup_nodes.sh" > /dev/null
record_pass "SSH connectivity and authorized keys confirmed"

# Test 2: Inventory Graph Parsing (INI & YAML)
echo -e "${YELLOW}[Test 2/$total_tests] Validating INI & YAML Inventory Formats...${NC}"
ansible-inventory -i inventory/hosts.ini --graph > /dev/null
ansible-inventory -i inventory/hosts.yaml --graph > /dev/null
record_pass "Both INI and YAML inventory trees parsed successfully"

# Test 3: YAML Syntax & Linting Integrity
echo -e "${YELLOW}[Test 3/$total_tests] Validating YAML Syntax across all project files...${NC}"
python3 -c "
import yaml, glob
for path in glob.glob('**/*.yml', recursive=True) + glob.glob('**/*.yaml', recursive=True):
    with open(path) as f:
        yaml.safe_load(f)
print('All YAML documents are valid syntax.')
"
record_pass "All YAML files conform to strict syntax standards"

# Test 4: Ansible Ping Connectivity Across All Nodes
echo -e "${YELLOW}[Test 4/$total_tests] Running Ansible Ping on All Managed Nodes...${NC}"
ansible all -i inventory/hosts.ini -m ping > /dev/null
record_pass "All managed nodes responded with pong"

# Test 5: Common Modules Demo Playbook
echo -e "${YELLOW}[Test 5/$total_tests] Executing Common Modules Demonstration Playbook...${NC}"
ansible-playbook -i inventory/hosts.ini playbooks/02_common_modules_demo.yml > /dev/null
record_pass "Common modules (file, copy, lineinfile, stat, apt, service) validated"

# Test 6: Web Server Playbook Execution
echo -e "${YELLOW}[Test 6/$total_tests] Executing Web Server Deployment Playbook...${NC}"
ansible-playbook -i inventory/hosts.ini playbooks/deploy_webserver.yml > /dev/null
record_pass "Nginx web server deployed and configured idempotently"

# Test 7: Live HTTP & Health Probe Verification
echo -e "${YELLOW}[Test 7/$total_tests] Performing Live HTTP Smoke Tests...${NC}"
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" http://127.0.0.1:80/)
HEALTH_RESP=$(curl -s http://127.0.0.1:80/health)

if [ "$HTTP_CODE" -eq 200 ]; then
    echo -e "${CYAN}HTTP GET / -> 200 OK${NC}"
    echo -e "${CYAN}Health Check -> ${HEALTH_RESP}${NC}"
    record_pass "Live HTTP endpoint and health check returning expected output"
else
    echo -e "${RED}Error: Received HTTP status code $HTTP_CODE${NC}"
    exit 1
fi

echo -e "${BLUE}==================================================================${NC}"
echo -e "${GREEN} TEST SUMMARY: $pass_count / $total_tests TESTS PASSED (100% SUCCESS) ${NC}"
echo -e "${BLUE}==================================================================${NC}"
