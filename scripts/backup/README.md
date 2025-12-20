# Backup Script [`backup.sh`](./backup.sh)

An automated script designed to perform "hot backups" of your databases, compress persistent data volumes, and optionally upload them to AWS S3.

## Features
* **PostgreSQL Dump:** Exports the database safely without stopping containers.
* **Volume Compression:** Archives the entire `${HOST_DATA_PATH}` directory.
* **Cloud Ready:** Native integration with AWS S3.
* **Auto-Rotation:** Automatically deletes local backups older than 7 days.

---

## Installation & Configuration

### 1. Configure the Script
Open `backup.sh` and adjust the variables at the top to match your server paths:
```bash
BACKUP_DIR="/home/YOUR_USER/backups"
DATA_DIR="/home/YOUR_USER/docker_data"
PG_CONTAINER="postgres" # Verify your actual container name
```

### 2. Enable AWS S3 (Optional but recommended)

To send backups to the cloud:

1. Install the AWS CLI on your host:
   ```bash
   sudo apt install awscli
   ```
2. Configure your credentials (Access Key & Secret):
   ```bash
   aws configure
   ```
3. In backup.sh, enable the feature:
   ```bash
   ENABLE_S3="true"
   S3_BUCKET="s3://your-bucket-name/folder"
   ```

### 3. For AWS S3 Retention Policy (Auto-Cleanup)

Do not rely on scripts to delete old files from S3. Instead, configure a **Lifecycle Rule** in the AWS Console to automatically expire objects older than X days.

1.  Go to your **S3 Bucket** in the AWS Console.
2.  Click on the **Management** tab.
3.  Click **Create lifecycle rule**.
4.  Name it (e.g., "Delete after 7 days").
5.  Select **Apply to all objects in the bucket**.
6.  Under "Lifecycle rule actions", check **Expire current versions of objects**.
7.  Set "Days after object creation" to **7** (or your desired retention).
8.  Click **Create rule**.

### 4. Set Permissions

Make the script executable:

```bash
chmod +x backup.sh
```

## Setting up Schedule

### Method A - Automatic Scheduling (recommended)

The most reliable way to run this script is via the host's Cron scheduler.

1. Open the crontab editor:
   ```bash
   crontab -e
   ```
2. Add the following line to run daily at 03:00 AM:
   ```bash
   0 3 * * * /home/YOUR_USER/infra-stacks/scripts/backup.sh >> /var/log/backup.log 2>&1
   ```

### Method B - Running via Portainer
You can execute the backup manually directly from the Portainer interface without opening a separate SSH terminal.

1. Log in to Portainer.
2. Navigate to Environments and select your Local environment.
3. On the left menu, click Host > Console.
    - **Note:** This feature requires the Portainer Agent to be running with host management capabilities.
4. In the terminal window that opens, type the full path to your script and press Enter:
   ```bash
   /home/YOUR_USER/infra-stacks/scripts/backup.sh
   ```

You will see the backup logs (Postgres dump, Compression, AWS Upload) appearing in real-time.

## Recovery Instructions

To restore a backup:

1. Unzip the volumes_backup.tar.gz into your ${HOST_DATA_PATH}.
2. Unzip postgres_dump.sql.gz.
3. Restore the database dump inside the container:
   ```bash
   cat postgres_dump.sql | docker exec -i infra-db-postgres-1 psql -U postgres
   ```