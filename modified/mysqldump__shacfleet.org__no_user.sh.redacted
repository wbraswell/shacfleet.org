#!/bin/sh
DATE=`date +%Y%m%d`
USER=shacfleet_user
PASS=REDACTED
DB=shacfleet_org
DIR=/home/wbraswell/public_html/shacfleet.org-latest/backup
FILE=wbraswell_$DATE-shacfleet.org__no_user.sql
rm $DIR/*no_user.sql.bz2
mysqldump --user=$USER --password=$PASS $DB --lock-tables --ignore-table=$DB.user > $DIR/$FILE
cd $DIR
du -hs $FILE
bzip2 $FILE
du -hs $FILE.bz2
