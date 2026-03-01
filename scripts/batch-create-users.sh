#!/bin/bash

# Batch User Creation Script
# Usage: sudo ./batch-create-users.sh users.txt

set -e

if [ "$EUID" -ne 0 ]; then
    echo "Please run as root (use sudo)"
    exit 1
fi

if [ -z "$1" ]; then
    echo "Usage: sudo ./batch-create-users.sh <users_file>"
    echo ""
    echo "File format (one user per line):"
    echo "username1:api_key1"
    echo "username2:api_key2"
    echo "username3:api_key3"
    exit 1
fi

USERS_FILE=$1
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ ! -f "$USERS_FILE" ]; then
    echo "Error: File $USERS_FILE not found"
    exit 1
fi

echo "Starting batch user creation..."
echo "================================"

# Read users file line by line
while IFS=: read -r username api_key; do
    # Skip empty lines and comments
    [[ -z "$username" || "$username" =~ ^#.*$ ]] && continue

    echo ""
    echo "Creating user: $username"
    echo "------------------------"

    # Call the main create-user script
    if [ -n "$api_key" ]; then
        "$SCRIPT_DIR/create-user.sh" "$username" "$api_key"
    else
        "$SCRIPT_DIR/create-user.sh" "$username"
    fi

    echo "✅ User $username created successfully"

done < "$USERS_FILE"

echo ""
echo "================================"
echo "Batch creation complete!"
echo ""
echo "Created users:"
dscl . list /Users | grep -v "^_" | tail -n +2
