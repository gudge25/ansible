# ansible
ansible usefull 

# configs
/etc/ansible/ansible.cfg – Config file, used if present
~/.ansible.cfg – User config file, overrides the default config if present
./ansible.cfg -- Local config file (in current working directory) assumed to  be  'project
       specific' and overrides the rest if present.
# create  empty config  file in current/project directiry
ansible-config init --format ini  --disabled  > ansible.cfg

# aplly ansible.cfg as default (optional)
export ANSIBLE_CONFIG=ansible.cfg

# show hosts file  hosts
ansible all  --list-hosts
or
ansible-inventory --graph
ansible-inventory --graph  --vars

# ansible PING
ansible -m ping all

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