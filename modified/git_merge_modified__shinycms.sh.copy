#!/bin/sh
PARENT_DIR=$1
MY_REPO_NAME=$2
MY_DIR_SUFFIX=$3
MY_DIR=$PARENT_DIR/$MY_REPO_NAME$MY_DIR_SUFFIX
DATE=`date +%Y%m%d`
BACKUP_DIR=$PARENT_DIR/$MY_REPO_NAME-backup_$DATE
GIT_BACKUP_COMMAND=/home/wbraswell/bin/git_backup__$MY_REPO_NAME.sh
SHINY_DIR=/home/wbraswell/public_html/ShinyCMS-latest

# GIT BACKUP, LOCAL BACKUP, GIT PULL, COPY

$GIT_BACKUP_COMMAND

echo
echo
echo "ABOUT TO MERGE FILES, DID BACKUP SUCCEED???"
echo "ABOUT TO MERGE FILES, DID BACKUP SUCCEED???"
echo "ABOUT TO MERGE FILES, DID BACKUP SUCCEED???"
sleep 3

rm -Rf $BACKUP_DIR
mv $MY_DIR $BACKUP_DIR

cd $SHINY_DIR
git pull origin master

cp -a $SHINY_DIR $MY_DIR
cd $MY_DIR
rm -Rf .git
cp -a $BACKUP_DIR/.git ./
cp -a $BACKUP_DIR/modified ./
cp -a $BACKUP_DIR/backup ./

# MERGE MODIFIED FILES

cd $MY_DIR
rm .gitignore
ln -s ./modified/.gitignore ./.gitignore

cd $MY_DIR
rm README
rm README.md
# HARD LINK so README contents show up in GitHub online
ln ./modified/README.md ./README.md  

cd $MY_DIR
mv shinycms.conf shinycms.conf.orig
ln -s ./modified/shinycms.conf ./shinycms.conf

cd $MY_DIR
cd root/static/ckeditor/
mv config.js config.js.orig
ln -s ../../../modified/config.js ./config.js

cd $MY_DIR
cd root/pages/cms-templates/
mv homepage.tt homepage.tt.orig
ln -s ../../../modified/homepage.tt ./homepage.tt

cd $MY_DIR
cd root/static/css/
mv main.css main.css.orig
ln -s ../../../modified/main.css ./main.css

cd $MY_DIR
cd root/
mv site-footer.tt site-footer.tt.orig
ln -s ../modified/site-footer.tt ./site-footer.tt

cd $MY_DIR
cd root/
mv site-wrapper.tt site-wrapper.tt.orig
ln -s ../modified/site-wrapper.tt ./site-wrapper.tt

cd $MY_DIR
cd root/static/
mv cms-uploads cms-uploads.orig
ln -s ../../modified/cms-uploads ./cms-uploads

cd $MY_DIR
cd root/
mv site-menu.tt site-menu.tt.orig
ln -s ../modified/site-menu.tt ./site-menu.tt

cd $MY_DIR
cd root/
mv offline.html offline.html.orig
ln -s ../modified/offline.html ./offline.html

cd $MY_DIR
cd bin/
mv external-fastcgi-server external-fastcgi-server.orig
ln -s ../modified/external-fastcgi-server ./external-fastcgi-server

cd $MY_DIR
cd root/pages/cms-templates
ln -s ../../../modified/html_only.tt ./html_only.tt

cd $MY_DIR
cd root/static/images
ln -s ../../../modified/w3c-valid-html5.png ./w3c-valid-html5.png

cd $MY_DIR
cd root/events
mv view_events.tt view_events.tt.orig
ln -s ../../modified/view_events.tt ./view_events.tt

cd $MY_DIR
cd root/events
mv view_event.tt view_event.tt.orig
ln -s ../../modified/view_event.tt ./view_event.tt

cd $MY_DIR
cd root/user
mv view_user.tt view_user.tt.orig
ln -s ../../modified/view_user.tt ./view_user.tt

cd $MY_DIR
cd root/admin/pages
mv edit_page.tt edit_page.tt.orig
ln -s ../../../modified/edit_page.tt ./edit_page.tt

cd $MY_DIR
cd root/admin/news
mv edit_item.tt edit_item.tt.orig
ln -s ../../../modified/edit_item.tt ./edit_item.tt

cd $MY_DIR
cd root/admin/blog
mv edit_post.tt edit_post.tt.orig
ln -s ../../../modified/edit_post.tt ./edit_post.tt

cd $MY_DIR
cd root/admin/events
mv edit_event.tt edit_event.tt.orig
ln -s ../../../modified/edit_event.tt ./edit_event.tt

cd $MY_DIR
cd root/admin/shop
mv edit_item.tt edit_item.tt.orig
ln -s ../../../modified/edit_item.tt.shop ./edit_item.tt

cd $MY_DIR
cd root/admin/newsletters
mv edit_newsletter.tt edit_newsletter.tt.orig
ln -s ../../../modified/edit_newsletter.tt ./edit_newsletter.tt
