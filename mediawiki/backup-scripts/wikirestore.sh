#!/bin/bash
#
# fullsiterestore.sh v1.1
#
# Restore of website file and database content made with full site backup.
#
# A number of variables defining file location and database connection
# information must be set before this script will run.
# This script expects a compressed tar file (tgz) made by fullsitebackup.sh.
# Website files should be in a tar file named filecontent.tar, and database
# content should be in a sqldump sql file named dbcontent.sql. This script
# expects the sql to drop the table before readdding the data. In other words,
# it does not do any database preparation.
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
# Parameters:
# tarfile # name of backup file to restore
#
#
# Database connection information
source ./mariadb.env
dbhost="mediawiki-database-1"

#
# Variables

# Execution directory (script start point)
startdir=$PWD

# Temporary Directory
datestamp=`date +'%Y-%m-%d'` # uses US format
tempdir=$startdir/backups/$datestamp

#
# Begin logging
#
echo "Beginning mediawiki site restore using \'fullsiterestore.sh\' ..."

#
# Input Parameter Check
#

# If no input parameter is given, echo usage and exit
if [ $# -eq 0 ]
then
echo " Usage: sh fullsiterestore.sh {backupfile.tgz}"
echo ""
exit
fi

tarfile=$1

# Check that the file exists
if [ ! -f "$tarfile" ]
then
#echo " Can not find file: $tarfile"
echo " Exiting ..."
exit
fi

#
# Create temporary working directory and expand tar file
#
echo " Creating temp working dir ..."
mkdir -p $tempdir
cd $tempdir
echo " unTARing db and file tgz files ..."
cp $tarfile $tempdir
tar xzf $(basename -- "$tarfile")

#
# Remove old website files
#
rm -rf $startdir/images

#
# unTAR website files
#
echo " unTARing website files ..."
tar xf $tempdir/filecontent.tar

#
# Copy website files into webroot
#
echo " Copying website files ..."
mv images LocalSettings.php $startdir
#chown -R apache:apache $webrootdir/images


#
# Load database information
#
echo " Restoring database ..."
echo " user: $MARIADB_USER; database: $MARIADB_DATABASE; host: $dbhost"
echo "use $MARIADB_DATABASE; source dbcontent.sql;" | docker exec -i $dbhost sh -c 'exec mariadb --password=$MARIADB_ROOT_PASSWORD --user=$MARIADB_USER my_wiki' < dbcontent.sql

#
# Cleanup
#
echo " Cleaning up ..."
sudo rm -rf $tempdir

#
# Exit banner
#
endtime=`date`
echo "Restoration completed $endtime for $tarfile."
