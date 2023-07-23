#!/bin/bash

if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root."
  exit 1
fi

# Define a lock file
LOCK_FILE="/var/run/backup.lock"

# Check if the lock file is present
if [ -f "$LOCK_FILE" ]; then
  echo "An existing backup task is running."
  exit 1
fi

# Create the lock file
touch "$LOCK_FILE"

# Load environment variables
source /etc/backups/env.sh

# Turn on Nextcloud's maintenance mode
su "$NC_SHELL_USER" -c "$PATH_TO_PHP \"$PATH_TO_NC_OCC\" maintenance:mode --on"

# Dump MySQL
rm -f "$PATH_TO_NC_DATA/dump.sql"
"$PATH_TO_MYSQLDUMP" "$NC_MYSQL_DB" > "$PATH_TO_NC_DATA/dump.sql"

# Perform backup
"$PATH_TO_RESTIC" backup --verbose --files-from /etc/backups/structure.conf --exclude-file="/etc/backups/exclusions.conf"

# Turn off Nextcloud's maintenance mode
su "$NC_SHELL_USER" -c "$PATH_TO_PHP \"$PATH_TO_NC_OCC\" maintenance:mode --off"
rm -f "$PATH_TO_NC_DATA/dump.sql"

# Delete lock file
rm -f "$LOCK_FILE"

# We're done
echo "Done."
exit 0