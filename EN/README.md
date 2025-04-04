# 🧹 Daily Cleaning Script for Linux Servers

This repository contains a fully customizable Bash script that automates common Linux system maintenance tasks such as:

- Docker cleanup
- System log rotation
- Deletion of temporary files in `/tmp`
- Logging its own actions and cleaning old logs

---

## 📁 Included Files

- `cleaning_tasks_EN.sh` → Main script
- `cleaning_tasks_EN.conf` → Editable configuration file

---

## ⚙️ Configuration

Edit `cleaning_tasks_EN.conf` with your preferences:

```bash
# Enable or disable each function
CLEAN_DOCKER="yes"
ROTATE_LOGS="yes"
CLEAN_TMP="yes"

# Enable dry-run mode (shows commands, does not run them)
DRY_RUN="no"

# Days to keep system logs
LOG_RETENTION_DAYS=7

# Delete /tmp files not accessed in this number of days
TMP_RETENTION_DAYS=1

# Maximum days to keep the script's own log
MAX_LOG_AGE_DAYS=30

# Path to the script's log file
SCRIPT_LOG="/var/log/cleaning_tasks.log"
```

> ⚠️ This file must be in the same folder as the script or you must adjust the path in the script.

---

## 🔐 Required Privileges

This script **must be executed as root** because it:

- Modifies files in `/etc/logrotate.d/`
- Runs `docker system prune`
- Deletes files in `/tmp`
- Writes logs to `/var/log`

---

## 🧪 Manual Execution

```bash
sudo bash cleaning_tasks_EN.sh
```

Set `DRY_RUN="yes"` in the `.conf` to simulate execution without running any real commands.

---

## ⏰ Automation with cron (recommended)

Edit the root user's crontab:

```bash
sudo crontab -e
```

Then add a line like this to run the script every day at 2:00 AM:

```cron
0 2 * * * /full/path/to/cleaning_tasks_EN.sh
```

✔️ No need to use `sudo` in the cron line if it runs as root.

---

## 📄 License

This project is licensed under the MIT License.
