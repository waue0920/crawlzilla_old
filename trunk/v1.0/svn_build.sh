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
 echo "installation"
 if [ ! -d "/home/crawler" ];then
   sudo useradd -m crawler -s /bin/bash
   sudo su crawler -c 'ssh-keygen -t rsa -f ~/.ssh/id_rsa -P ""'
   sudo su crawler -c "cp ~/.ssh/id_rsa.pub ~/.ssh/authorized_keys"
   sudo su crawler -c "ssh-add /home/crawler/.ssh/id_rsa"
 fi
 sudo mkdir -p /home/crawler/crawlzilla/
 sudo mkdir -p /home/crawler/crawlzilla/user/admin/IDB/
 sudo mkdir -p /home/crawler/crawlzilla/slave
 sudo mkdir -p /home/crawler/crawlzilla/tmp
 sudo ln -sf $SvnCrawlzilla/opt /opt/crawlzilla
 sudo ln -sf $SvnCrawlzilla/conf/crawlzilla_conf/* /etc/init.d/
 sudo cp $SvnCrawlzilla/conf/tomcat_conf/* /opt/crawlzilla/tomcat/conf/
 sudo cp $SvnCrawlzilla/conf/nutch_conf/* /opt/crawlzilla/nutch/conf/
 sudo chown -R crawler:crawler /home/crawler/

}

function do_update ( ) 
{
 echo "update info"
 cp $SvnCrawlzilla/conf/tomcat_conf/* /opt/crawlzilla/conf/
 cp $SvnCrawlzilla/conf/nutch_conf/* /opt/crawlzilla/conf/
 chown -R crawler:crawler /home/crawler/

}

function do_remove ( ) 
{
  echo "remove"
  rm -rf /home/crawler/crawlzilla
}

function make_war ( ) 
{
 echo "make war"
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
