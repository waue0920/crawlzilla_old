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
LOGFILE=/var/log/crawlzilla/shell-logs/crawl_fix.log
#LOGFILE=/home/crawler/crawlzilla/debug_fix.log # no used
META_PATH=/home/crawler/crawlzilla/.tmp

### not test
JPID=$(cat "$META_PATH/$JNAME/$JNAME"_go_pid) # go job pid 
CPID=$(cat "$META_PATH/$JNAME/$JNAME"_count_pid) # count pid 
JDEPTH=$(cat "$META_PATH/$JNAME/".crawl_depth) # depth
STATUS_FILE=$META_PATH/$JNAME/$JNAME # status path
#JPTIME="$META_PATH/$JNAME/$JNAME"PassTime
### not test


DATE=$(date)
echo "$JNAME BEGINE at $DATE" >> $LOGFILE

echo "0 kill ps" >> $LOGFILE
kill -9 $JPID
if [ ! $? -eq 0 ];then echo "Warning!!! kill go.sh not work" >> $LOGFILE ; fi
kill -9 $CPID
if [ ! $? -eq 0 ];then echo "Warning!!! kill count.sh not work">> $LOGFILE; fi
echo "fixing" > $STATUS_FILE;

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


if [ ! -f /home/crawler/crawlzilla/archieve/$JNAME/$JNAME"PassTime" ];then
    echo "4.1 $JNAMEPassTime" >> $LOGFILE
    echo "0h:0m:0s" >> /home/crawler/crawlzilla/archieve/$JNAME/$JNAME"PassTime"
fi

if [ ! -f /home/crawler/crawlzilla/archieve/$JNAME/.crawl_depth ];then
    echo "4.2 append depth" >> $LOGFILE
    echo "0" >> /home/crawler/crawlzilla/archieve/$JNAME/.crawl_depth
fi

echo "5 mv index files from part-00000" >> $LOGFILE
mv /home/crawler/crawlzilla/archieve/$JNAME/index/part-00000/* /home/crawler/crawlzilla/archieve/$JNAME/index/
if [ ! $? -eq 0 ];then echo "ERROR!!! see $LOGFILE ";exit 8; fi

echo "6 rmdir part-00000/"  >> $LOGFILE
rmdir /home/crawler/crawlzilla/archieve/$JNAME/index/part-00000/
if [ ! $? -eq 0 ];then echo "ERROR!!! see $LOGFILE ";exit 8; fi

echo "7 tomcat"  >> $LOGFILE
cp -rf /opt/crawlzilla/tomcat/webapps/default /opt/crawlzilla/tomcat/webapps/$JNAME
if [ ! $? -eq 0 ];then echo "ERROR!!! see $LOGFILE ";exit 8; fi

echo "8 nutch-site.xml"  >> $LOGFILE
sed -i '8s/search/'${JNAME}'/g' /opt/crawlzilla/tomcat/webapps/$JNAME/WEB-INF/classes/nutch-site.xml
if [ ! $? -eq 0 ];then echo "ERROR!!! see $LOGFILE ";exit 8; fi


echo "fixed" > $STATUS_FILE;

DATE=$(date)
echo "$JNAME completed and finished at"$DATE >> $LOGFILE

