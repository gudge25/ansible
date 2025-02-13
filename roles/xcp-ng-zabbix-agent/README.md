# XCP-ng Zabbix Ansible Role
This role installs and configures the Zabbix Agent on XCP-ng.
Also it creates a Zabbix host in Zabbix Server.

## Usage
```yaml
- hosts: xcp-ng-hosts
  roles:
    - xcp-ng-zabbix-agent

## Variables
- `ZABBIX_SERVER`: Zabbix server address.
- `ZABBIX_AGENT_VERSION`: Version of the Zabbix agent to install. e.g. "50".
- `ZABBIX_USER`: Username to access Zabbix Server API.
- `ZABBIX_PASSWORD`: Password to access Zabbix Server API.
