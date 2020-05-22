#!/bin/bash
# backup_NAS_config.sh
#
# Script backups Synology NAS configuration dir to DSS file.
# Have to be run as root because of synoconfbkp.

############
# Settings #
############
BACKUP_DIR=/volume1/homes/user/backup_NAS_config/ # where backups will be stored
DAYS_KEEP=5 # script will remove backups older than $DAYS_KEEP days
DIR_TO_BACKUP=/volume1/homes/ # what to backup
FILENAME=my_NAS # filename with backup without extension (will be additionally timestamped)

#############
# Main part #
#############
DATESTAMP=$(date +%Y%m%d%H%M%S)

# remove backups older than $DAYS_KEEP
find ${BACKUP_DIR}* -mtime +$DAYS_KEEP -exec rm -f {} \; 2> /dev/null

# make a backup
FILENAME=${BACKUP_DIR}$FILENAME-${DATESTAMP}.dss
/usr/syno/bin/synoconfbkp export --filepath=$FILENAME