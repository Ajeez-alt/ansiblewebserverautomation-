#!/bin/bash
# ==============================================================================
# Script: setup_nodes.sh
# Purpose: Configure SSH key-based access and permissions for Ansible Nodes
# Author: AJEEZ PRABU B (Roll No. 23bcs161)
# ==============================================================================

set -e

echo "=== [1/4] Checking and Generating SSH Key Pair ==="
if [ ! -f "$HOME/.ssh/id_ed25519" ]; then
    ssh-keygen -t ed25519 -f "$HOME/.ssh/id_ed25519" -N "" -C "ansible-control-node"
    echo "SSH key generated at ~/.ssh/id_ed25519"
else
    echo "SSH key already exists at ~/.ssh/id_ed25519"
fi

echo "=== [2/4] Authorizing Control Node Public Key for Local SSH Nodes ==="
mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"
cat "$HOME/.ssh/id_ed25519.pub" >> "$HOME/.ssh/authorized_keys"
sort -u "$HOME/.ssh/authorized_keys" -o "$HOME/.ssh/authorized_keys"
chmod 600 "$HOME/.ssh/authorized_keys"

echo "=== [3/4] Ensuring OpenSSH Server is Running ==="
sudo service ssh status >/dev/null 2>&1 || sudo service ssh start
echo "OpenSSH service is active on port 22."

echo "=== [4/4] Testing Direct SSH Connection to Managed Node ==="
ssh -o StrictHostKeyChecking=no -i "$HOME/.ssh/id_ed25519" -p 22 "$USER@127.0.0.1" "echo 'SSH Handshake Successful on Managed Node (127.0.0.1)'"

echo "=== Node Setup Complete! Control Node is ready to orchestrate managed nodes. ==="
