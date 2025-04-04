#!/bin/bash

# -----------------------------------------------------------------------------
# 🧹 Daily Cleaning Script for Linux Servers
# Author: Alex | Last update: April 2025
# -----------------------------------------------------------------------------
# This script automates system maintenance and cleaning tasks.
# Configuration is managed through an external file: cleaning_tasks.conf
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# 📄 LOAD CONFIGURATION
# -----------------------------------------------------------------------------

CONFIG_FILE="./cleaning_tasks.conf"
if [ -f "$CONFIG_FILE" ]; then
    source "$CONFIG_FILE"
else
    echo "❌ Configuration file not found: $CONFIG_FILE"
    exit 1
fi

# -----------------------------------------------------------------------------
# ✅ INITIAL VERIFICATIONS
# -----------------------------------------------------------------------------

# Requires root privileges
if [ "$EUID" -ne 0 ]; then
    echo "❌ This script must be run as root or with sudo."
    exit 1
fi

# Validate required commands
check_command() {
    command -v "$1" >/dev/null 2>&1 || {
        echo "❌ Command '$1' is not installed. Aborting..."
        exit 1
    }
}

# Function to run commands with dry-run mode
run() {
    echo "🔧 Running: $*"
    [ "$DRY_RUN" != "yes" ] && eval "$*"
}

# -----------------------------------------------------------------------------
# 🔧 CLEANING FUNCTIONS
# -----------------------------------------------------------------------------

clean_docker() {
    check_command docker
    echo "🧼 Cleaning Docker resources..."
    run "docker system prune -f"
}

rotate_logs() {
    check_command logrotate
    echo "🧾 Setting up system log rotation..."
    cat <<EOF > /etc/logrotate.d/system-logs
/var/log/syslog /var/log/auth.log {
    daily
    rotate $LOG_RETENTION_DAYS
    compress
    missingok
    notifempty
    delaycompress
    copytruncate
}
EOF
    echo "🔁 Log rotation configured for $LOG_RETENTION_DAYS days."
}

clean_tmp() {
    echo "🧹 Deleting files in /tmp not accessed in $TMP_RETENTION_DAYS days..."
    run "find /tmp -type f -atime +$TMP_RETENTION_DAYS -exec rm -f {} \;"
}

clean_script_logs() {
    echo "🧼 Deleting old script logs older than $MAX_LOG_AGE_DAYS days..."
    find "$(dirname "$SCRIPT_LOG")" -type f -name "$(basename "$SCRIPT_LOG")" -mtime +$MAX_LOG_AGE_DAYS -exec rm -f {} \;
}

# -----------------------------------------------------------------------------
# 🚀 TASK EXECUTION BASED ON CONFIGURATION
# -----------------------------------------------------------------------------

[ "$CLEAN_DOCKER" = "yes" ] && clean_docker
[ "$ROTATE_LOGS" = "yes" ] && rotate_logs
[ "$CLEAN_TMP" = "yes" ] && clean_tmp
clean_script_logs

# -----------------------------------------------------------------------------
# 🧾 EXECUTION LOGGING
# -----------------------------------------------------------------------------

mkdir -p "$(dirname "$SCRIPT_LOG")"
echo "$(date '+%Y-%m-%d %H:%M:%S') - Daily cleaning completed." >> "$SCRIPT_LOG"

# -----------------------------------------------------------------------------
# ✅ FINALIZATION
# -----------------------------------------------------------------------------

echo "✅ Daily cleaning completed."
