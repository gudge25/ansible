#!/bin/bash

# Config
SOURCE_LIST_CMD="fwconsole firewall list trusted"
SSH_KEY="/home/asterisk/.ssh/id_rsa"
SSH_OPTS=(-i "$SSH_KEY" -o StrictHostKeyChecking=no)

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
dest_trusted=$(ssh "${SSH_OPTS[@]}" "$DEST_HOST" "$SOURCE_LIST_CMD" | grep -v "trusted" | tr -d '\t')

# Convert to arrays
readarray -t source_entries <<< "$trusted_list"
readarray -t dest_entries <<< "$dest_trusted"

# Build lists for missing and extra entries
missing_ips=()
extra_ips=()

for src_ip in "${source_entries[@]}"; do
    if [[ ! " ${dest_entries[*]} " =~ " ${src_ip} " ]]; then
        missing_ips+=("$src_ip")
    fi
done

for dest_ip in "${dest_entries[@]}"; do
    if [[ ! " ${source_entries[*]} " =~ " ${dest_ip} " ]]; then
        extra_ips+=("$dest_ip")
    fi
done

# Sync: Add missing in one command
if [ ${#missing_ips[@]} -gt 0 ]; then
    echo "Adding missing IPs: ${missing_ips[*]}"
    ssh "${SSH_OPTS[@]}" "$DEST_HOST" "fwconsole firewall add trusted ${missing_ips[*]}"
fi

# Sync: Remove extra in one command
if [ ${#extra_ips[@]} -gt 0 ]; then
    echo "Removing extra IPs: ${extra_ips[*]}"
    ssh "${SSH_OPTS[@]}" "$DEST_HOST" "fwconsole firewall del trusted ${extra_ips[*]}"
fi

echo "Firewall trusted zone sync completed."