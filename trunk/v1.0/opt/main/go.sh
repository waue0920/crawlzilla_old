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
 echo "2. /home/crawler/crawlzilla/user/admin/meta/urls/urls.txt 裡面有你要抓的網址";
 echo "3. 執行 ./go.sh [深度] [資料夾名稱] 即可，如：";
 echo "	./go.sh 3 crawlname"
 echo "4. 等nutch所有程序完成，則你的資料在 /home/crawler/crawlzilla/user/admin/IDB/crawlname/ "
 exit
fi

#META_PATH="/home/crawler/crawlzilla/.metadata"
#ARCHIEVE_DIR="	/home/crawler/crawlzilla/user/admin/IDB/"
#HADOOP_BIN="/opt/crawlzilla/nutch/bin"

Depth=$1
JNAME=$2

[ $USER != "crawler" ] && echo "please enter crawler's password"  && exec su crawler -c "$0 $Depth $JNAME"

source "/opt/crawlzilla/nutch/conf/hadoop-env.sh";
source "/opt/crawlzilla/main/log.sh" crawl_go;

function check_info ( )
{
  if [ $? -eq 0 ];then
    show_info "[ok] $1";
  else
    echo "error: $1 broken" > "/home/crawler/crawlzilla/user/admin/tmp/$JNAME/meta/status"
    show_info "[error] $1 broken"
    kill -9 $count_pid
    exit 8
  fi
}

# [ begin ] 
cd /home/crawler/crawlzilla/

# check the same name before
if [ -d /home/crawler/crawlzilla/user/admin/tmp/$JNAME ];then
   mv /home/crawler/crawlzilla/user/admin/tmp/$JNAME /home/crawler/crawlzilla/user/admin/tmp/$JNAME-bek
fi

if [ ! -e "/home/crawler/crawlzilla/user/admin/tmp/$JNAME" ];then
   mkdir -p "/home/crawler/crawlzilla/user/admin/tmp/$JNAME/meta"
   check_info "mkdir crawlStatusDir"
fi


# 存儲crawling狀態及花費時間的資料夾
if [ ! -e "/home/crawler/crawlzilla/user/admin/tmp/$JNAME/meta" ];then
   mkdir -p "/home/crawler/crawlzilla/user/admin/tmp/$JNAME/meta"
   check_info "mkdir crawlStatusDir"
fi

echo $$ > "/home/crawler/crawlzilla/user/admin/tmp/$JNAME/meta/go.pid"
check_info "$$ > /home/crawler/crawlzilla/user/admin/tmp/$JNAME/meta/go.pid"

# 紀錄爬取深度
echo $Depth > "/home/crawler/crawlzilla/user/admin/tmp/$JNAME/meta/depth"

# 開始紀錄程序狀態
echo "begin" > "/home/crawler/crawlzilla/user/admin/tmp/$JNAME/meta/status"
echo "0" > "/home/crawler/crawlzilla/user/admin/tmp/$JNAME/meta/passtime"

# 呼叫counter.sh紀錄時間
/opt/crawlzilla/main/counter.sh $JNAME &
sleep 5
count_pid=$(cat "/home/crawler/crawlzilla/user/admin/tmp/$JNAME/meta/count.pid")

# check the replicate directory on HDFS ; $? : 0 = shoud be delete
/opt/crawlzilla/nutch/bin/hadoop dfs -test -e /user/crawler/admin/urls
if [ $? -eq 0 ]; then
  /opt/crawlzilla/nutch/bin/hadoop dfs -rmr /user/crawler/admin/urls
  check_info "rmr urls"
fi
/opt/crawlzilla/nutch/bin/hadoop dfs -test -e /user/crawler/admin/$JNAME
if [ $? -eq 0 ]; then
  /opt/crawlzilla/nutch/bin/hadoop dfs -mv /user/crawler/admin/$JNAME /user/crawler/admin/$JNAME-bek
  check_info "mv $JNAME to $JNAME-bek"
fi


/opt/crawlzilla/nutch/bin/hadoop dfs -mkdir /user/crawler/admin/$JNAME
check_info "hadoop dfs -mkdir /user/crawler/admin/$JNAME"

/opt/crawlzilla/nutch/bin/hadoop dfs -put /home/crawler/crawlzilla/user/admin/meta/urls /user/crawler/admin/urls
check_info "hadoop dfs -put urls"

# nutch crawl begining
echo "crawling" > "/home/crawler/crawlzilla/user/admin/tmp/$JNAME/meta/status"

/opt/crawlzilla/nutch/bin/nutch crawl /user/crawler/admin/urls -dir /user/crawler/admin/$JNAME -depth $Depth -topN 5000 -threads 1000
check_info "nutch crawl"

/opt/crawlzilla/nutch/bin/hadoop dfs -get /user/crawler/admin/$JNAME/* /home/crawler/crawlzilla/user/admin/tmp/$JNAME
check_info "download search"


# move the index-db from tmp to IDB
mv /home/crawler/crawlzilla/user/admin/tmp/$JNAME /home/crawler/crawlzilla/user/admin/IDB/$JNAME
check_info "mv indexdb from tmp to IDB"

# check /home/crawler/crawlzilla/user/admin/web
if [ ! -d /home/crawler/crawlzilla/user/admin/web ];then mkdir -p /home/crawler/crawlzilla/user/admin/web ;fi
# check /opt/crawlzilla/tomcat/webapps/admin/
if [ ! -d /opt/crawlzilla/tomcat/webapps/admin/ ];then mkdir -p /opt/crawlzilla/tomcat/webapps/admin/ ;fi

# 製作 $JNAME 於 tomcat
#cp -rf /opt/crawlzilla/tomcat/webapps/default /opt/crawlzilla/tomcat/webapps/$JNAME
cp -rf /opt/crawlzilla/tomcat/webapps/default /home/crawler/crawlzilla/user/admin/web/$JNAME
check_info "cp default to user/web/$JNAME"
# link user/admin/web/JNAME to tomcat/webapps/admin/JNAME
ln -sf /home/crawler/crawlzilla/user/admin/web/$JNAME /opt/crawlzilla/tomcat/webapps/admin/$JNAME
check_info "link to tomcat/webapps"

# inject the nutch-site.xml for linking web and idb
sed -i '8s/search/admin\/IDB\/'$JNAME'/g' /home/crawler/crawlzilla/user/admin/web/$JNAME/WEB-INF/classes/nutch-site.xml
check_info "inject the nutch-site.xml for linking web and idb"

# 完成搜尋狀態 bedone
#cp /home/crawler/crawlzilla/user/admin/tmp/$JNAME/meta/depth /home/crawler/crawlzilla/user/admin/IDB/$JNAME/
#cp /home/crawler/crawlzilla/user/admin/tmp/$JNAME/meta/passtime /home/crawler/crawlzilla/user/admin/IDB/$JNAME/

#if [ -d /home/crawler/crawlzilla/user/admin/IDB/$JNAME/ ];then
#  cp -rf /home/crawler/crawlzilla/user/admin/tmp/$JNAME/meta /home/crawler/crawlzilla/user/admin/tmp/$JNAME/metadata
#fi

echo "finish" > "/home/crawler/crawlzilla/user/admin/tmp/$JNAME/meta/status"

kill -9 $count_pid

