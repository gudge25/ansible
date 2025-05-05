#!/bin/bash

WEBHOOK_URL="https://n8n.gixo.co.uk/webhook/fb82e12c-d48e-476e-9297-4c6263eb373f"
HOSTNAME=$(hostname)
JSON_LOG=()

dns_names=$(fwconsole firewall list trusted | grep -v "trusted" | awk '{print $1}' | grep -vE '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+')

for dns in $dns_names; do
    echo "Checking $dns..."
    ip=$(getent hosts "$dns" | awk '{print $1}')

    if [[ -z "$ip" ]]; then
        echo "  $dns does not resolve. Will delete."
        # fwconsole firewall delete trusted "$dns"
        JSON_LOG+=("{\"dns\":\"$dns\",\"status\":\"not_resolved\"}")
    else
        echo "  $dns resolves to $ip. Keeping."
    fi
done

# Надсилаємо тільки якщо є not_resolved
if [[ ${#JSON_LOG[@]} -gt 0 ]]; then
  JSON_PAYLOAD=$(cat <<EOF
{
  "host": "$HOSTNAME",
  "results": [
    $(IFS=,; echo "${JSON_LOG[*]}")
  ]
}
EOF
  )

  curl -s -X POST "$WEBHOOK_URL" \
      -H "Content-Type: application/json" \
      -d "$JSON_PAYLOAD"
else
  echo "✅ Усі DNS-імена успішно резолвляться. Відправка webhook не потрібна."
fi