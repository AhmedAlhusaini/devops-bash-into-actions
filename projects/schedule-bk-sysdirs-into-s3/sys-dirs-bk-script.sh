#!/usr/bin/env bash
# Script to backup ArcGIS Server configuration directory to S3
# Usage: ./arcserver-dirs-bk-script.sh <source_directory> [local_backup_dir] [s3_bucket_name]
	#If bucket name is not provided, it will be created --> named as arcgis_server_backup_<timestamp>
	#else it will use the provided bucket name.(If Exists, it will use it directly)

set -euo pipefail

# Timestamp for naming
timestamp=$(date +"%Y-%m-%d-%H-%M-%S")


############################################################
#                     # INPUT ARGUMENTS                    #
############################################################

arc_server_config_src=${1:-"arc-server-directories"}
arc_server_config_local_dst=${2:-"${arc_server_config_src}_bk"}
#arc_server_config_cloud_dst=${3:-"arcgis_server_backup_$timestamp"}
arc_server_config_cloud_dst=${3:-"gisoverflow"}


############################################################
#                     VALIDATION STEPS                    #
############################################################

# Validate AWS CLI
if ! command -v aws &> /dev/null; then
    echo "AWS CLI not found. Please install and configure it."
    exit 4
fi


############################################################
#                # VALIDATE SOURCE DIRECTORY               #
############################################################

# if [ -z "$arc_server_config_src" ] || [ ! -d "$arc_server_config_src" ]; then
#     echo "Source directory is missing or invalid."
#     echo "Usage: ./arcserver-dirs-bk-script.sh <source_directory> [s3_bucket_name] [local_backup_dir]"
#     exit 2
# fi



############################################################
#              # CREATE LOCAL BACKUP DIRECTORY             #
############################################################

mkdir -p "$arc_server_config_local_dst"


############################################################
#           # CREATE LOGS DIRECTORY AND LOG FILE          #
############################################################

mkdir -p ./logs
LOG_FILE="./logs/Log-$timestamp.log"
echo "📁 Log file created at $LOG_FILE" | tee -a "$LOG_FILE"

# Header
tee -a "$LOG_FILE" << EOL
===================================================================
ArcGIS Server Configuration Backup Script
Name: Ahmed Alhusainy
Start Time: $(date)
Source Directory: $arc_server_config_src
Local Backup Directory: $arc_server_config_local_dst
S3 Backup Bucket: $arc_server_config_cloud_dst
===================================================================
EOL


############################################################
#                CLOUD PARAMTERS VALIDATION               #
############################################################

# Backup file name and paths
bk_file_name="arcserver-config-backup-$timestamp.tar.gz"
file_to_upload="$arc_server_config_local_dst/$bk_file_name"
s3_backup_uri="s3://$arc_server_config_cloud_dst/$bk_file_name"


# Check if backup file already exists
if [ -f "$file_to_upload" ]; then
    echo "Backup file already exists: $file_to_upload" | tee -a "$LOG_FILE"
    exit 3
fi

# Create S3 bucket if it doesn't exist
if ! aws s3api head-bucket --bucket "$arc_server_config_cloud_dst" 2>/dev/null; then
	echo
    echo "🪣 Creating S3 bucket: $arc_server_config_cloud_dst" | tee -a "$LOG_FILE"
    aws s3api create-bucket --bucket "$arc_server_config_cloud_dst" --region us-east-1
    sleep 5
else
	echo
	echo "🪣 S3 bucket already exists: $arc_server_config_cloud_dst" | tee -a "$LOG_FILE"
fi
 

############################################################
#                      # CREATE BACKUP                     #
############################################################
echo 
echo "📦 Creating backup file: $bk_file_name" | tee -a "$LOG_FILE"
tar -czvf "$file_to_upload" "$arc_server_config_src" >> "$LOG_FILE" 2>&1
echo "✅ Backup created at $file_to_upload" | tee -a "$LOG_FILE"


############################################################
#                      # UPLOAD TO S3                     #
############################################################

echo "🚀 Uploading backup to S3: $s3_backup_uri" | tee -a "$LOG_FILE"
aws s3 cp "$file_to_upload" "$s3_backup_uri" >> "$LOG_FILE" 2>&1

if [ $? -eq 0 ]; then
    echo "✅ Backup uploaded successfully to $s3_backup_uri" | tee -a "$LOG_FILE"
else
    echo "❌ Upload failed." | tee -a "$LOG_FILE"
    exit 1
fi
