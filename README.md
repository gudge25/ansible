# Ansible Playbooks Collection

A collection of useful Ansible playbooks for system configuration and management.

## Setup

### Prerequisites
- Ansible installed
- Python 3.x
- pip (Python package manager)

### Pre-commit Setup
1. Install pre-commit:
```bash
pip install pre-commit
```

2. Install the git hooks:
```bash
pre-commit install
```

### Configuration Files
- `.pre-commit-config.yaml`: Defines pre-commit hooks for code quality
- `.ansible-lint`: Ansible linting configuration
- `.yamllint`: YAML syntax checking configuration
- `ansible.cfg`: Ansible configuration file

## Linting Configuration

The project uses two different linting configurations:

### .yamllint
Handles generic YAML syntax and formatting:
- Indentation and spacing
- Line length
- Quote consistency
- Document structure
- Comments formatting

### .ansible-lint
Focuses on Ansible-specific best practices:
- Module usage and naming
- Task structure
- Security practices
- Role organization
- Variable naming conventions
- Deprecated feature detection

Together, these ensure both proper YAML formatting and Ansible best practices are followed.

## Available Playbooks

### System Information
- `getOS_name.yml`: Get OS distribution information
- `getOS_V2.yml`: Alternative version for OS information
- `local.yml`: Local system configuration

### Web Server
- `install-nginx.yaml`: Install and configure Nginx
- `install-default.yaml`: Default installation playbook

### Monitoring
- `install_zabbix_freepbx.yaml`: Zabbix installation for FreePBX
- `install_asternic.yaml`: Asternic installation

### Network
- `firewall_freepbx.yaml`: Firewall configuration for FreePBX
- `pjsip_numbers.yaml`: PJSIP configuration

## Usage

### Basic Commands
```bash
# Check hosts
ansible all --list-hosts
ansible-inventory --graph
ansible-inventory --graph --vars

# Ping test
ansible -m ping all

# Get server info
ansible web -m setup

# Run playbook
ansible-playbook playbook.yml

# Info from Servers(s)
ansible web -m setup

# Command on all (has limit  of using  other sub commands)
ansible all -m command -a "uptime"

# Shell command
ansible all -m shell -a "uptime"

# Copy file
ansible web -m copy -a "src=test.txt dest=/tmp"
(optional)    -b, --become  run operations with become (does not imply password prompting)

# Delete file
ansible web -m file  -a "path=/tmp/test.txt state=absent"

# Download from URL
ansible web -m get_url  -a "url=https://codeload.github.com/MidnightCommander/mc/zip/refs/heads/master dest=/tmp"

# Install/upgrade app with yum
ansible web -m yum  -a "name=mc state=latest"
# Remove app with yum
ansible web -m yum   -a "name=mc state=absent"

# Change Service state
ansible web -m service  -a "name=docker enabled=yes state=started"

# Verbose -v to -vvvv
ansible web -m yum  -a "name=mc state=absent" -v

# Limit ansible playbook execution ho host/group
ansible-playbook  getOS_name.yml --limit webservers
