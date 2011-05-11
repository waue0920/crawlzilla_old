#!/bin/bash

[ $USER != "crawler" ] && echo "please enter crawler's password"  && exec su crawler -c "$0" "$@"

Update_Dir="/opt/crawlzilla/update"
VER_CURR=$(cat /opt/crawlzilla/version)

if [ -d $Update_Dir ];then
  rm -rf $Update_Dir/*
else
  mkdir -p $Update_Dir
fi

wget http://sourceforge.net/projects/crawlzilla/files/testing/version/download -O $Update_Dir/version
VER_NEW=$(cat $Update_Dir/version)

if [ "$VER_NEW" == "$VER_CURR" ];then
  echo "Crawlzilla $VER_CURR is latest."
  exit 0
fi
read
wget http://sourceforge.net/projects/crawlzilla/files/testing/Crawlzilla-1.0/Crawlzilla-$VER_NEW.tar.gz/download -O $Update_Dir/crawlzilla-update.tar.gz

tar -xzvf $Update_Dir/crawlzilla-update.tar.gz -C $Update_Dir/

Work_Path="$Update_Dir/Crawlzilla_Install"
cp -rf $Work_Path/main/*  /opt/crawlzilla/main/
cp $Work_Path/version  /opt/crawlzilla/
# copy crawlzilla.war to /opt/crawlzilla/tomcat/webapps
mv /opt/crawlzilla/tomcat/webapps/crawlzilla.war $Update_Dir/
mv /opt/crawlzilla/tomcat/webapps/crawlzilla $Update_Dir/crawlzilla-web
cp $Work_Path/web/crawlzilla.war /opt/crawlzilla/tomcat/webapps/crawlzilla.war

#chown -R crawler /opt/crawlzilla/main/
#chown -R crawler /opt/crawlzilla/tomcat/webapps/

echo "System Update Finished"
