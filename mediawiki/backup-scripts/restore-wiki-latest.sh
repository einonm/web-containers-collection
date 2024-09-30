#! /usr/bin/env bash
#
# Restores the latest wiki backup from the backup server
#
# Runs as root
#
# Mark Einon <mark.einon@gmail.com>

BACKUP_PATH=$PWD/backups/


BACKUP_FILE=`ls -pt $BACKUP_PATH | grep -v / | head -n1`
echo "Backup file: $BACKUP_FILE" > /tmp/wikirestore.log

./backup-scripts/wikirestore.sh /$BACKUP_PATH/$BACKUP_FILE  >> /tmp/wikirestore.log

echo "** If moving container host, set the site name (wgServer parameter) according to the hostname in LocalSettings.php **"
