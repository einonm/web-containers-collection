#!/bin/bash
#
# fullsitebackup.sh V1.2
#
# Full backup of website files and database content.
#
# A number of variables defining file location and database connection
# information must be set before this script will run.
# Files are tar'ed from the root directory of the website. All files are
# saved. The MySQL database tables are dumped without a database name and
# and with the option to drop and recreate the tables.
#
# ----------------------
# 05-Jul-2007 - Quick adaptation for MediaWiki (currently testing)
# ----------------------
# March 2007 Updates - Version for Drupal
# - Updated script to resolve minor path bug
# - Added mysql password variable (caution - this script file is now a security risk - protect it)
# - Generates temp log file
# - Updated backup and restore scripts have been tested on Ubunutu Edgy server w/Drupal 5.1
#
# - Enjoy! BristolGuy
#-----------------------
#
## Parameters:
# tar_file_name (optional)
#
#
# Configuration
#

# Database connection information
source ./mariadb.env
dbhost="mediawiki-database-1" # docker container name

#
# Variables
#

# Default TAR Output File Base Name
tarnamebase=wikibackup-
datestamp=`date +'%m-%d-%Y'`

# Execution directory (script start point)
startdir=$PWD/backups/

# Temporary Directory
tempdir=$startdir/$datestamp

#
# Input Parameter Check
#

if test "$1" = ""
then
tarname=$tarnamebase$datestamp.tgz
else
tarname=$1
fi

#
# Begin logging
#
echo "Beginning mediawiki site backup using fullsitebackup.sh ..."
#
# Create temporary working directory
#
echo " Creating temp working dir ..."
mkdir -p $tempdir

#
# TAR website files
#
echo " TARing website files... from $PWD"
tar cf $tempdir/filecontent.tar images LocalSettings.php

#
# sqldump database information
#
echo " Dumping mediawiki database, using ..."
echo " user:$MARIADB_USER; database:$MARIADB_DATABASE container:$dbhost "
cd $tempdir
docker exec $dbhost mariadb-dump --user=$MARIADB_USER --password=$MARIADB_ROOT_PASSWORD --add-drop-table $MARIADB_DATABASE > dbcontent.sql

#
# Create final backup file
#
echo " Creating final compressed (tgz) TAR file: $tarname ..."
tar czf $startdir/$tarname filecontent.tar dbcontent.sql

#
# Cleanup
#
echo " Removing temp dir $tempdir ..."
rm -r $tempdir

echo "Removing files older than two weeks..."
find $startdir -name "$tarnamebase*" -mtime +14 -delete

#
# Exit banner
#
endtime=`date`
echo "Backup completed $endtime, TAR file at $tarname. "
