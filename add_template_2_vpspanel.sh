#!/bin/bash

set -e

VPSMANAGER_URL="example.cunty.lol"
API_KEY="removed_cunt"

read -p "Enter node ID: " NODE_ID

POST_URL="https://${VPSMANAGER_URL}/api/application/nodes/${NODE_ID}/template-groups"

HEADERS=(
  -H "Authorization: Bearer ${API_KEY}"
  -H "Accept: application/json"
  -H "Content-Type: application/json"
)

create_group_and_templates() {
    local GROUP_NAME="$1"
    shift

    echo "Creating template group: ${GROUP_NAME}"

    GROUP_PAYLOAD=$(jq -n \
        --arg name "$GROUP_NAME" \
        '{hidden:false,name:$name}')

    RESPONSE=$(curl -s -X POST "$POST_URL" \
        "${HEADERS[@]}" \
        -d "$GROUP_PAYLOAD")

    UUID=$(echo "$RESPONSE" | jq -r '.data.uuid // empty')

    if [[ -z "$UUID" ]]; then
        echo "Failed creating group: ${GROUP_NAME}"
        echo "$RESPONSE"
        return
    fi

    echo "Created group '${GROUP_NAME}' UUID: $UUID"

    TEMPLATE_URL="${POST_URL}/${UUID}/templates"

    while [[ $# -gt 1 ]]; do
        TEMPLATE_NAME="$1"
        VMID="$2"

        TEMPLATE_PAYLOAD=$(jq -n \
            --arg name "$TEMPLATE_NAME" \
            --argjson vmid "$VMID" \
            '{hidden:false,name:$name,vmid:$vmid}')

        TEMPLATE_RESPONSE=$(curl -s -X POST "$TEMPLATE_URL" \
            "${HEADERS[@]}" \
            -d "$TEMPLATE_PAYLOAD")

        TEMPLATE_UUID=$(echo "$TEMPLATE_RESPONSE" | jq -r '.data.uuid // empty')

        if [[ -n "$TEMPLATE_UUID" ]]; then
            echo "  Added: ${TEMPLATE_NAME} (${VMID})"
        else
            echo "  Failed: ${TEMPLATE_NAME}"
            echo "$TEMPLATE_RESPONSE"
        fi

        shift 2
    done
}

# Debian
create_group_and_templates "Debian" \
"Debian 10" 900 \
"Debian 11" 901 \
"Debian 12" 902 \
"Debian 13" 903 \
"Debian Sid" 909

# Ubuntu
create_group_and_templates "Ubuntu" \
"Ubuntu 20.04" 910 \
"Ubuntu 22.04" 911 \
"Ubuntu 24.04" 912 \
"Ubuntu 24.10" 913 \
"Ubuntu 25.04" 914

# Fedora
create_group_and_templates "Fedora" \
"Fedora 41" 921 \
"Fedora 42" 922

# Rocky Linux
create_group_and_templates "Rocky Linux" \
"Rocky Linux 8" 930 \
"Rocky Linux 9" 931 \
"Rocky Linux 10" 932

# AlmaLinux
create_group_and_templates "AlmaLinux" \
"AlmaLinux 8" 940 \
"AlmaLinux 9" 941 \
"AlmaLinux 10" 942

# CentOS Stream
create_group_and_templates "CentOS Stream" \
"CentOS Stream 9" 950 \
"CentOS Stream 10" 951

# Oracle Linux
create_group_and_templates "Oracle Linux" \
"Oracle Linux 8" 960 \
"Oracle Linux 9" 961

# openSUSE
create_group_and_templates "openSUSE" \
"openSUSE Leap 15.5" 970 \
"openSUSE Leap 15.6" 971 \
"openSUSE Leap 16.0" 972 \
"openSUSE Tumbleweed" 973

# Alpine
create_group_and_templates "Alpine Linux" \
"Alpine Linux 3.22" 980

# Arch
create_group_and_templates "Arch Linux" \
"Arch Linux" 990

# Kali
create_group_and_templates "Kali Linux" \
"Kali Linux Rolling" 995

# FreeBSD
create_group_and_templates "FreeBSD" \
"FreeBSD 14.2" 999

echo
echo "Done."
