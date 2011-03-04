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
   echo "user \"crawlzilla on \\home\\crawler\\ \" existing..."
 fi
 if [ ! -d "/opt/crawlzilla" ];then
   echo "build /opt/crawlzilla"
   sudo ln -sf $SvnCrawlzilla/opt /opt/crawlzilla
   sudo ln -sf $SvnCrawlzilla/conf/crawlzilla_conf/* /etc/init.d/
   sudo cp $SvnCrawlzilla/conf/tomcat_conf/* /opt/crawlzilla/tomcat/conf/
   sudo cp $SvnCrawlzilla/conf/nutch_conf/* /opt/crawlzilla/nutch/conf/
 else
   echo "user \"crawlzilla on \\opt\" existing..."
 fi
}

function do_update ( ) 
{
  echo "update info "
  sudo cp $SvnCrawlzilla/conf/tomcat_conf/* /opt/crawlzilla/tomcat/conf/
  if [ "$?" == "0" ];then echo "[update] tomcat conf --> ./ " ; fi
  sudo cp $SvnCrawlzilla/conf/nutch_conf/* /opt/crawlzilla/nutch/conf/
  if [ "$?" == "0" ];then echo "[update] nutch conf --> ./ " ; fi
  sudo chown -R crawler:crawler /home/crawler/
  if [ "$?" == "0" ];then echo "[chown] /home/crawler/ --> ./ " ; fi
}

function do_remove ( ) 
{
  echo "remove"
  if [ -d "/home/crawler/crawlzilla" ];then
    sudo rm -rf /home/crawler/crawlzilla
    if [ "$?" == "0" ];then echo "[rm] /home/crawler/crawlzilla " ; fi
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
  echo " $0 build "
  echo " $0 update "
  echo " $0 remove "
  echo " $0 web "
  exit 0;
;;
esac
