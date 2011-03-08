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

if [ "$1" == "" ]; then
 echo "1. 使用這個shell ，首先你需要有crawler這個使用者，並且hadoop 已經開始運作";
 echo "2. /home/crawler/crawlzilla/url/urls.txt 裡面有你要抓的網址";
 echo "3. 執行 ./go.sh [深度] [資料夾名稱] 即可，如：";
 echo "	./go.sh 3 crawlname"
 echo "4. 等nutch所有程序完成，則你的資料在 /home/crawler/crawlzilla/user/admin/IDB/crawlname/ "
 exit
fi

#META_PATH="/home/crawler/crawlzilla/.metadata"
#ARCHIEVE_DIR="/home/crawler/crawlzilla/archieve"
#HADOOP_BIN="/opt/crawlzilla/nutch/bin"

Depth=$1
JNAME=$2


source "/opt/crawlzilla/nutch/conf/hadoop-env.sh";
source "/opt/crawlzilla/main/log.sh" crawl_go;

function check_info ( )
{
  if [ $? -eq 0 ];then
    show_info "[ok] $1";
  else
    echo "error: $1 broken" > "/home/crawler/crawlzilla/.metadata/$JNAME/status"
    show_info "[error] $1 broken"
    kill -9 $count_pid
    exit 8
  fi
}

# [ begin ] 
cd /home/crawler/crawlzilla/

# /home/crawler/crawlzilla/user/admin/IDB/tmp 用來放該程序的狀態
if [ ! -e /home/crawler/crawlzilla/.metadata ];then
   mkdir /home/crawler/crawlzilla/.metadata
   check_info "mkdir .metadata"
fi

# 存儲crawling狀態及花費時間的資料夾
if [ ! -e "/home/crawler/crawlzilla/.metadata/$JNAME" ];then
   mkdir "/home/crawler/crawlzilla/.metadata/$JNAME"
   check_info "mkdir crawlStatusDir"
fi

echo $$ > "/home/crawler/crawlzilla/.metadata/$JNAME/go.pid"
check_info "$$ > /home/crawler/crawlzilla/.metadata/$JNAME/go.pid"

# 紀錄爬取深度
echo $1 > "/home/crawler/crawlzilla/.metadata/$JNAME/depth"

# 開始紀錄程序狀態
echo "begin" > "/home/crawler/crawlzilla/.metadata/$JNAME/status"
echo "0" > "/home/crawler/crawlzilla/.metadata/$JNAME/passtime"

# 呼叫counter.sh紀錄時間
/opt/crawlzilla/main/counter.sh $JNAME &
sleep 5
count_pid=$(cat "/home/crawler/crawlzilla/.metadata/$JNAME/count.pid")

# check the replicate directory on HDFS ; $? : 0 = shoud be delete
/opt/crawlzilla/nutch/bin/hadoop fs -test -e /user/crawler/$JNAME
if [ $? -eq 0 ]; then
  /opt/crawlzilla/nutch/bin/hadoop dfs -rmr /user/crawler/$JNAME
  show_info "/user/crawler/$JNAME is deleted."
fi

/opt/crawlzilla/nutch/bin/hadoop dfs -mkdir $JNAME
check_info "hadoop dfs -mkdir $JNAME"

/opt/crawlzilla/nutch/bin/hadoop dfs -put /home/crawler/crawlzilla/user/admin/meta/urls $JNAME/urls
check_info "hadoop dfs -put urls"

# nutch crawl begining
echo "crawling" > "/home/crawler/crawlzilla/.metadata/$JNAME/status"

/opt/crawlzilla/nutch/bin/nutch crawl $JNAME/urls -dir $JNAME -depth $Depth -topN 5000 -threads 1000
check_info "nutch crawl"
/opt/crawlzilla/nutch/bin/hadoop dfs -get $JNAME /home/crawler/crawlzilla/user/admin/IDB/$JNAME
check_info "download search"

# 製作 $JNAME 於 tomcat
cp -rf /opt/crawlzilla/tomcat/webapps/default /opt/crawlzilla/tomcat/webapps/$JNAME
check_info "cp default to "
sed -i '8s/search/'$JNAME'/g' /opt/crawlzilla/tomcat/webapps/$JNAME/WEB-INF/classes/nutch-site.xml
check_info "sed"

# 完成搜尋狀態
cp /home/crawler/crawlzilla/.metadata/$JNAME/depth /home/crawler/crawlzilla/user/admin/IDB/$JNAME/
cp /home/crawler/crawlzilla/.metadata/$JNAME/passtime /home/crawler/crawlzilla/user/admin/IDB/$JNAME/

#if [ -d /home/crawler/crawlzilla/user/admin/IDB/$JNAME/ ];then
#  cp -rf /home/crawler/crawlzilla/.metadata/$JNAME /home/crawler/crawlzilla/user/admin/IDB/$JNAME/metadata
#fi

echo "finish" > "/home/crawler/crawlzilla/.metadata/$JNAME/status"

kill -9 $count_pid

