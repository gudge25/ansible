# XCP-ng Zabbix Ansible Role
This role installs and configures the Zabbix Agent on XCP-ng.

## Usage
```yaml
- hosts: xcp-ng-hosts
  roles:
    - xcp-ng-zabbix-agent
```

## Variables
- `zabbix_server`: Zabbix server address.
- `ZABBIX_AGENT_VERSION`: Version of the Zabbix agent to install.
