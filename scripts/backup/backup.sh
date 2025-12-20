#!/bin/bash

# ===================================== #
# SERVER BACKUP SCRIPT (Local + AWS S3) #
# ===================================== #

BACKUP_DIR="/home/YOUR_USER/backups"
DATA_DIR="/home/YOUR_USER/docker_data"
PG_CONTAINER="infra-db-postgres-1"
PG_USER="postgres"
RETENTION_DAYS=7

ENABLE_S3="false"
S3_BUCKET="s3://your-bucket-name/folder"

TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
TODAY_DIR="$BACKUP_DIR/$TIMESTAMP"

mkdir -p "$TODAY_DIR"

echo "Starting backup at $TIMESTAMP..."

if [ "$(docker ps -q -f name=$PG_CONTAINER)" ]; then
    echo "Dumping PostgreSQL database..."
    docker exec -t $PG_CONTAINER pg_dumpall -c -U $PG_USER > "$TODAY_DIR/postgres_dump.sql"
    # Compress the SQL file to save space
    gzip "$TODAY_DIR/postgres_dump.sql"
else
    echo "Postgres container ($PG_CONTAINER) not found or not running!"
fi

echo "Compressing data volumes..."

tar -czf "$TODAY_DIR/volumes_backup.tar.gz" --exclude="backups" --exclude="infra-stacks" -C "$DATA_DIR" .

if [ "$ENABLE_S3" = "true" ]; then
    if command -v aws &> /dev/null; then
        echo "Uploading to AWS S3..."
        aws s3 cp "$TODAY_DIR" "$S3_BUCKET/$TIMESTAMP" --recursive
        if [ $? -eq 0 ]; then
            echo "Upload successful."
        else
            echo "Upload failed. Check AWS credentials."
        fi
    else
        echo "'aws' CLI not found. Skipping S3 upload."
    fi
else
    echo "S3 upload disabled in config."
fi

echo "Cleaning up local backups older than ${RETENTION_DAYS} days..."
find "$BACKUP_DIR" -maxdepth 1 -type d -mtime +$RETENTION_DAYS -exec rm -rf {} +

echo "Backup process finished successfully!"