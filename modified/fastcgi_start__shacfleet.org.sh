#!/bin/bash
USERNAME=`whoami`
export HOME=/home/$USERNAME
SITE=$HOME/public_html/shacfleet.org-latest
cd $SITE
eval $(perl -I$HOME/perl5/lib/perl5 -Mlocal::lib)
$SITE/bin/external-fastcgi-server
