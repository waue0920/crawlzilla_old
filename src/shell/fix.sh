#!/bin/bash

# prompt
if [ "$1" == "" ];then
    echo "Usage : fix <JOB_NAME>";
    echo " where JOB_NAME is one of: ";
    echo "==========="
    NN=$(/opt/crawlzilla/nutch/bin/hadoop dfs -ls |grep crawler |awk '{print $8}' | cut -d "/" -f 4)
    echo "$NN"
    echo "==========="
    exit 9;
fi

# begin

JNAME=$1
LOGFILE=~/crawlzilla/debug_fix.log
META_PATH=/home/crawler/crawlzilla/.tmp

### not test
JPID="$META_PATH/$JNAME/$JNAME"_count_pid # go.sh need add go.sh's pid
JDEPTH="$META_PATH/$JNAME/$JNAME"xxx # go.sh need fix
JPTIME="$META_PATH/$JNAME/$JNAME"PassTime
### not test


DATE=$(date)
echo "$JNAME BEGINE at $DATE" >> $LOGFILE

echo "1 invertlinks" >> $LOGFILE

/opt/crawlzilla/nutch/bin/nutch invertlinks /user/crawler/$JNAME/linkdb -dir /user/crawler/$JNAME/segments/
if [ ! $? -eq 0 ];then echo "ERROR!!! see $LOGFILE ";exit 8; fi

echo "2 index" >> $LOGFILE
SEGS=$(/opt/crawlzilla/nutch/bin/hadoop dfs -ls /user/crawler/$JNAME/segments | grep  segments | awk '{print $8 }')
/opt/crawlzilla/nutch/bin/nutch index /user/crawler/$JNAME/index /user/crawler/$JNAME/crawldb /user/crawler/$JNAME/linkdb $SEGS
if [ ! $? -eq 0 ];then echo "ERROR!!! see $LOGFILE ";exit 8; fi

echo "3 dedup" >> $LOGFILE
/opt/crawlzilla/nutch/bin/nutch dedup /user/crawler/$JNAME/index
if [ ! $? -eq 0 ];then echo "ERROR!!! see $LOGFILE ";exit 8; fi

echo "4 download" >> $LOGFILE
/opt/crawlzilla/nutch/bin/hadoop dfs -get $JNAME /home/crawler/crawlzilla/archieve/$JNAME
if [ ! $? -eq 0 ];then echo "ERROR!!! see $LOGFILE ";exit 8; fi

echo "5 $JNAMEPassTime" >> $LOGFILE
echo "0h:0m:0s" >> /home/crawler/crawlzilla/archieve/$JNAME/$JNAME"PassTime"
if [ ! $? -eq 0 ];then echo "ERROR!!! see $LOGFILE ";exit 8; fi

echo "6 append depth" >> $LOGFILE
echo "0" >> /home/crawler/crawlzilla/archieve/$JNAME/.crawl_depth
if [ ! $? -eq 0 ];then echo "ERROR!!! see $LOGFILE ";exit 8; fi

echo "7 mv index files from part-00000" >> $LOGFILE
mv /home/crawler/crawlzilla/archieve/$JNAME/index/part-00000/* /home/crawler/crawlzilla/archieve/$JNAME/index/
if [ ! $? -eq 0 ];then echo "ERROR!!! see $LOGFILE ";exit 8; fi

echo "8 rmdir part-00000/"  >> $LOGFILE
rmdir /home/crawler/crawlzilla/archieve/$JNAME/index/part-00000/
if [ ! $? -eq 0 ];then echo "ERROR!!! see $LOGFILE ";exit 8; fi

echo "9 tomcat"  >> $LOGFILE
cp -rf /opt/crawlzilla/tomcat/webapps/default /opt/crawlzilla/tomcat/webapps/$JNAME
if [ ! $? -eq 0 ];then echo "ERROR!!! see $LOGFILE ";exit 8; fi

echo "10 nutch-site.xml"  >> $LOGFILE
sed -i '8s/search/'${JNAME}'/g' /opt/crawlzilla/tomcat/webapps/$JNAME/WEB-INF/classes/nutch-site.xml
if [ ! $? -eq 0 ];then echo "ERROR!!! see $LOGFILE ";exit 8; fi




DATE=$(date)
echo "$JNAME completed and finished at"$DATE >> $LOGFILE

