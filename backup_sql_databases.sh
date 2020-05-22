#!/bin/bash
# backup_sql_databases.sh
#
# Script dumps all MySQL (or MariaDB) databases to separate SQL files (compressed to .sql.gz) named with timestamp.
# It also removes old backups (older than specified amount of days).

############
# Settings #
############
BACKUP_DIR=/volume1/homes/user/backup_sql_databases/
DAYS_KEEP=5 # script will remove backups older than $DAYS_KEEP days
SQL_USER=root
SQL_PASS=root_password
MYSQL_DIR="/volume1/@appstore/MariaDB10/usr/local/mariadb10/bin/"

#############
# Main part #
#############
DATESTAMP=$(date +%Y%m%d%H%M%S)

# remove backups older than $DAYS_KEEP
find ${BACKUP_DIR}* -mtime +$DAYS_KEEP -exec rm -f {} \; 2> /dev/null

# list MySQL databases and dump each
for db in $("$MYSQL_DIR/mysql" --user=$SQL_USER --password=$SQL_PASS -e "SHOW DATABASES;" | tr -d "| " | grep -v Database); do
    if [[ "$db" != _* ]] && [[ "$db" != "mysql" ]] && [[ "$db" != "performance_schema" ]] && [[ "$db" != "information_schema" ]]; then
	FILENAME=${BACKUP_DIR}$db-${DATESTAMP}.sql.gz
        $MYSQL_DIR/mysqldump --user=$SQL_USER --password=$SQL_PASS --opt --routines --force --databases $db | gzip > $FILENAME
    fi
done
