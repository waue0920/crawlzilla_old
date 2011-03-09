#!/bin/bash
# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Program:
#   Delete duplicating ip $ hostname in file (for crawlzilla management interface).
# Author: 
#   Waue, Shunfa, Rock {waue, shunfa, rock}@nchc.org.tw
# Version:
#    1.0
# History:
#   2010/06/07  Rock    First release (1.0)


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

# define
#META_PATH="/home/crawler/crawlzilla/user/admin/tmp/"
#HADOOP_BIN="/opt/crawlzilla/nutch/bin"

source "/opt/crawlzilla/nutch/conf/hadoop-env.sh";
source "/opt/crawlzilla/main/log.sh" job_fix;

### local
JNAME=$1
JPID=$(cat "/home/crawler/crawlzilla/user/admin/tmp/$JNAME/meta/go.pid") # go job pid 
CPID=$(cat "/home/crawler/crawlzilla/user/admin/tmp/$JNAME/meta/count.pid") # count pid 
JDEPTH="/home/crawler/crawlzilla/user/admin/tmp/$JNAME/meta/depth" # depth
JPTIME="/home/crawler/crawlzilla/user/admin/tmp/$JNAME/meta/passtime"
STATUS_FILE="/home/crawler/crawlzilla/user/admin/tmp/$JNAME/meta/status" # status path

### function
function check_info ( )
{
  if [ $? -eq 0 ];then
    show_info "[ok] $1";
  else
    echo "error: $1 broken" > "/home/crawler/crawlzilla/user/admin/tmp/$JNAME/meta/status"
    show_info "[error] $1 broken"
    kill -9 $CPID
    exit 8
  fi
}

### program

DATE=$(date)
show_info "Fix $JNAME BEGIN at $DATE"

show_info "0 kill ps" 
kill -9 $JPID >/dev/null 2>&1
if [ ! $? -eq 0 ];then debug_info "Warning!!! kill go.sh not work"; fi
echo "fixing" > $STATUS_FILE;


show_info "0 Correcting Information "

SEGS=$(/opt/crawlzilla/nutch/bin/hadoop dfs -ls /user/crawler/$JNAME/segments | grep  segments | awk '{print $8 }')

# checking the contents in $JNAME/segments/ , or hadoop will broken
# content , crawl_fetch , crawl_generate , crawl_parse , parse_data, parse_text

SEOK=""
SEBAD=""
for SE in $SEGS
do
 show_info "checking $SE"
 if /opt/crawlzilla/nutch/bin/hadoop dfs -test -d $SE/content && \
 /opt/crawlzilla/nutch/bin/hadoop dfs -test -d $SE/crawl_fetch && \
 /opt/crawlzilla/nutch/bin/hadoop dfs -test -d $SE/crawl_generate && \
 /opt/crawlzilla/nutch/bin/hadoop dfs -test -d $SE/crawl_parse && \
 /opt/crawlzilla/nutch/bin/hadoop dfs -test -d $SE/parse_data && \
 /opt/crawlzilla/nutch/bin/hadoop dfs -test -d $SE/parse_text ;then
   show_info "$SE .... [Fine] "
   SEOK="$SEOK "$SE
 else
   SEBAD="$SEBAD "$SE
 fi
done
debug_info "SEOK =[ $SEOK ]"
debug_info "SEBAD =[ $SEBAD ]"
## 
/opt/crawlzilla/nutch/bin/hadoop dfs -rmr $SEBAD
show_info "/opt/crawlzilla/nutch/bin/hadoop dfs -rmr $SEBAD"

## [ Do FIX Process ] if at least one correct Segments in pool ##
if [ ! "$SEOK" == "" ];then

## unlock
if /opt/crawlzilla/nutch/bin/hadoop dfs -test -e /user/crawler/$JNAME/linkdb/.locked; then
  /opt/crawlzilla/nutch/bin/hadoop dfs -rmr /user/crawler/$JNAME/linkdb/.locked;
fi

## begin FIX
   
show_info "1 invertlinks"
/opt/crawlzilla/nutch/bin/nutch invertlinks /user/crawler/$JNAME/linkdb -dir /user/crawler/$JNAME/segments/
check_info "invertlinks "

show_info "2 index" 
/opt/crawlzilla/nutch/bin/nutch index /user/crawler/$JNAME/index /user/crawler/$JNAME/crawldb /user/crawler/$JNAME/linkdb $SEOK
check_info "index DB "

show_info "3 dedup" 
/opt/crawlzilla/nutch/bin/nutch dedup /user/crawler/$JNAME/index
check_info "dedup "

show_info "4 download"
/opt/crawlzilla/nutch/bin/hadoop dfs -get $JNAME /home/crawler/crawlzilla/user/admin/IDB/$JNAME
check_info "download hdfs "


show_info "4.1 $JNAME Pass Time"
if [ ! -f /home/crawler/crawlzilla/user/admin/IDB/$JNAME/passtime ];then
  if [ -f $JPTIME ];then
    cp $JPTIME /home/crawler/crawlzilla/user/admin/IDB/$JNAME/passtime
  else
    echo "0h:0m:0s" >> /home/crawler/crawlzilla/user/admin/IDB/$JNAME/passtime
  fi
fi

show_info "4.2 append depth"
if [ ! -f /home/crawler/crawlzilla/user/admin/IDB/$JNAME/depth ];then
  if [ -f $JDEPTH ];then
    cp $JDEPTH /home/crawler/crawlzilla/user/admin/IDB/$JNAME/depth
  else
    echo "0" >> /home/crawler/crawlzilla/user/admin/IDB/$JNAME/depth
  fi
fi

show_info "5 mv index files from part-00000"
mv /home/crawler/crawlzilla/user/admin/IDB/$JNAME/index/part-00000/* /home/crawler/crawlzilla/user/admin/IDB/$JNAME/index/
check_info "mv index files from part-00000 "

show_info "6 rmdir part-00000/"
rmdir /home/crawler/crawlzilla/user/admin/IDB/$JNAME/index/part-00000/
check_info "rmdir part-00000/ "

show_info "7 tomcat nutch search index "
cp -rf /opt/crawlzilla/tomcat/webapps/default /opt/crawlzilla/tomcat/webapps/$JNAME
check_info "tomcat nutch search index"

show_info "8 nutch-site.xml"
sed -i '8s/search/'$JNAME'/g' /opt/crawlzilla/tomcat/webapps/$JNAME/WEB-INF/classes/nutch-site.xml
check_info "nutch-site.xml modify"

fi
## hadoop fix over ##


kill -9 $CPID >/dev/null 2>&1
if [ ! $? -eq 0 ];then debug_info "Warning!!! kill count.sh not work"; fi
# finish
#if [ -d /home/crawler/crawlzilla/user/admin/IDB/$JNAME/ ];then
#  cp -rf /home/crawler/crawlzilla/user/admin/tmp/$JNAME/meta /home/crawler/crawlzilla/user/admin/tmp/$JNAME/metadata
#fi
echo "Fixed" > $STATUS_FILE;
