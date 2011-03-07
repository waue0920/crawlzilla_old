#!/bin/bash

SvnCrawlzilla=`dirname "$0"`
SvnCrawlzilla=`cd "$SvnCrawlzilla"; pwd`

function su_permit ( )
{
 if [ ! "$USER" == "root" ];then
    echo "please :  sudo $0"
    exit 0
 fi
}

function do_build ( ) 
{
 su_permit
 if [ ! -d "/home/crawler" ];then
   echo "build crawler"
   sudo useradd -m crawler -s /bin/bash
   sudo su crawler -c 'ssh-keygen -t rsa -f ~/.ssh/id_rsa -P ""'
   sudo su crawler -c "cp ~/.ssh/id_rsa.pub ~/.ssh/authorized_keys"
   sudo su crawler -c "ssh-add /home/crawler/.ssh/id_rsa"
 else
   echo "user \"crawler\" existing..."
 fi
 if [ ! -d "/home/crawler/crawlzilla" ];then
   echo "build /home/crawler/crawlzilla"
   sudo mkdir -p /home/crawler/crawlzilla/
   sudo mkdir -p /home/crawler/crawlzilla/user/admin/IDB/
   sudo mkdir -p /home/crawler/crawlzilla/slave
   sudo mkdir -p /home/crawler/crawlzilla/tmp
   sudo chown -R crawler:crawler /home/crawler/
 else
   echo "\"crawlzilla on \\home\\crawler\\ \" existing..."
 fi
 if [ ! -d "/opt/crawlzilla" ];then
   echo "build /opt/crawlzilla"
   sudo cp -rf $SvnCrawlzilla/opt /opt/crawlzilla
   sudo ln -sf $SvnCrawlzilla/conf/crawlzilla_conf/* /etc/init.d/
   sudo cp $SvnCrawlzilla/conf/tomcat_conf/* /opt/crawlzilla/tomcat/conf/
   sudo cp $SvnCrawlzilla/conf/nutch_conf/* /opt/crawlzilla/nutch/conf/
 else
   echo "\"crawlzilla on \\opt\" existing..."
 fi
 if [ ! -d "/var/log/crawlzilla/" ];then
   echo "create /var/log/crawlzilla"
   sudo mkdir /var/log/crawlzilla/
   sudo chmod 777 /var/log/crawlzilla/
 else
   echo "\"crawlzilla on \\var\\log\\ \" existing..."
 fi
 if [ ! -d "/home/crawler/crawlzilla/workspace/" ];then
   echo "create /home/crawler/crawlzilla/workspace/"
   sudo mkdir /home/crawler/crawlzilla/workspace/
   sudo chown crawler:crawler /home/crawler/crawlzilla/workspace/
   sudo chmod 777 /home/crawler/crawlzilla/workspace/
 else
   echo "\"crawlzilla on \\var\\log\\ \" existing..."
 fi
 sudo su crawler -c "/opt/crawlzilla/nutch/bin/hadoop namenode -format"
 sudo su crawler -c "/opt/crawlzilla/nutch/bin/start-all.sh"

}

function do_update ( ) 
{
  echo "update info "
  sudo cp $SvnCrawlzilla/conf/tomcat_conf/* /opt/crawlzilla/tomcat/conf/
  if [ "$?" == "0" ];then echo "[tomcat] --> /opt/crawlzilla/tomcat/conf " ; fi
  sudo cp $SvnCrawlzilla/conf/nutch_conf/* /opt/crawlzilla/nutch/conf/
  if [ "$?" == "0" ];then echo "[nutch] --> /opt/crawlzilla/nutch/conf " ; fi
  sudo chown -R crawler:crawler /home/crawler/crawlzilla/
  if [ "$?" == "0" ];then echo "[chown] /home/crawler/crawlzilla --> ./ " ; fi
}

function do_remove ( ) 
{
  echo "removeing ..." 
  if [ -e "/opt/crawlzilla/nutch/bin/stop-all.sh" ];then
    sudo su crawler -c "/opt/crawlzilla/nutch/bin/stop-all.sh"
  fi
  if [ -e "/etc/init.d/crawlzilla-master" ];then
  sudo rm /etc/init.d/crawlzilla-master
    if [ "$?" == "0" ];then echo "[rm] /etc/init.d/crawlzilla-master " ; fi
  fi
  if [ -e "/etc/init.d/crawlzilla-slave" ];then
  sudo rm /etc/init.d/crawlzilla-slave
    if [ "$?" == "0" ];then echo "[rm] /etc/init.d/crawlzilla-slave " ; fi
  fi

  if [ -d "/home/crawler/crawlzilla" ];then
    sudo rm -rf /home/crawler/crawlzilla
    if [ "$?" == "0" ];then echo "[rm] /home/crawler/crawlzilla " ; fi
  fi
  if [ -d "/var/log/crawlzilla" ];then
    sudo rm -rf /var/log/crawlzilla/ 
    if [ "$?" == "0" ];then echo "[rm] /var/log/crawlzilla/ " ; fi
  fi
  if [ -d "/home/crawler/crawlzilla/workspace" ];then
    sudo rm -rf /home/crawler/crawlzilla/workspace/
    if [ "$?" == "0" ];then echo "[rm] /home/crawler/crawlzilla/workspace/ " ; fi
  fi
  if [ -d /opt/crawlzilla/ ];then
    sudo rm -rf /opt/crawlzilla
    if [ "$?" == "0" ];then echo "[rm] /opt/crawlzilla " ; fi
  fi
}

function make_war ( ) 
{
 echo "make war"
 ant -f $SvnCrawlzilla/web-src/build.xml clean
 ant -f $SvnCrawlzilla/web-src/build.xml
 if [ "$?" == "0" ];then
    echo "[ok] crawlzilla.war --> ./ "
 fi
 mv $SvnCrawlzilla/web-src/tmp/crawlzilla.war ./

}
case "$1" in
build)
  do_build;exit 0;
  ;;
update)
  do_update; exit 0;
  ;;
remove)
  do_remove; exit 0;
  ;;
web)
  make_war; exit 0;
  ;;
*)
  echo " Usage : "
  echo " sudo $0 build "
  echo " sudo $0 update "
  echo " sudo $0 remove "
  echo " $0 web "
  exit 0;
;;
esac
