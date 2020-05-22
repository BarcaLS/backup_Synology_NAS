#!/bin/bash
# backup_home_dir.sh
#
# Script backups $HOME dir to zip file.

############
# Settings #
############
BACKUP_DIR=/volume1/homes/user/backup_home/ # where backups will be stored
DAYS_KEEP=3 # script will remove backups older than $DAYS_KEEP days
DIR_TO_BACKUP=/volume1/homes/ # what to backup
FILENAME=home # filename with backup without extension (will be additionally timestamped)
EXCLUDE=-xr'!homes/user/backup_home' # directories to exclude from backuping (specify almost full path,
# i.e. begin from last subdirectory specified in DIR_TO_BACKUP (without "/" sign in the beginning).

#############
# Main part #
#############
DATESTAMP=$(date +%Y%m%d%H%M%S)

# remove backups older than $DAYS_KEEP
find ${BACKUP_DIR}* -mtime +$DAYS_KEEP -exec rm -f {} \; 2> /dev/null

# make a backup
FILENAME=${BACKUP_DIR}$FILENAME-${DATESTAMP}.zip
7z a -tzip $EXCLUDE $FILENAME $DIR_TO_BACKUP
