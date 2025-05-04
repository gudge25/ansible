#!/bin/bash
# Config
SOURCE_LIST_CMD="fwconsole firewall list trusted"
SSH_KEY="/home/asterisk/.ssh/id_rsa"

# Get current hostname (e.g. abc.pbx.gixo.co.uk)
current_host=$(hostname)

# Compute destination host (e.g. abc2.pbx.gixo.co.uk)
prefix="${current_host%%.*}"          # abc
suffix="${current_host#*.}"           # pbx.gixo.co.uk
DEST_HOST="root@${prefix}2.${suffix}" # root@abc2.pbx.gixo.co.uk

echo "Syncing trusted firewall list to: $DEST_HOST"

# Fetch trusted list from source
trusted_list=$(fwconsole firewall list trusted | grep -v "trusted" | tr -d '\t')

# Fetch trusted list from destination
dest_trusted=$(ssh -i "$SSH_KEY" "$DEST_HOST" "$SOURCE_LIST_CMD" | grep -v "trusted" | tr -d '\t')

# Convert to arrays
readarray -t source_entries <<< "$trusted_list"
readarray -t dest_entries <<< "$dest_trusted"



# Convert to sets for comparison
for src_ip in "${source_entries[@]}"; do
    if [[ ! " ${dest_entries[*]} " =~ " ${src_ip} " ]]; then
        echo "Adding missing $src_ip to $DEST_HOST"
        ssh -i "$SSH_KEY" "$DEST_HOST" "fwconsole firewall trust $src_ip"
    fi
done

for dest_ip in "${dest_entries[@]}"; do
    if [[ ! " ${source_entries[*]} " =~ " ${dest_ip} " ]]; then
        echo "Removing extra $dest_ip from $DEST_HOST"
        ssh -i "$SSH_KEY" "$DEST_HOST" "fwconsole firewall untrust $dest_ip"
    fi
done

echo "Firewall trusted zone sync completed."