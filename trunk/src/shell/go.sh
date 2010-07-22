#!/bin/bash
crawl_dep=$1
crawlname_from_jsp=$2

if [ "$1" == "" ]; then
 echo "1. 使用這個shell ，首先你需要有nutchuser這個使用者，並且hadoop 已經開始運作";
 echo "2. /home/nutchuser/nutchez/url/urls.txt 裡面有你要抓的網址";
 echo "3. 執行 ./go.sh [深度] [資料夾名稱] 即可，如：";
 echo "	./go.sh 3 crawlname"
 echo "4. 等nutch所有程序完成，則你的資料在 /home/nutchuser/nutchez/archieve/crawlname/ "
 exit
fi

function debug_echo () {

  if [ $? -eq 0 ]; then
      echo "$1 finished "
  else
      echo "$1 is error"
      exit
  fi
}



source /opt/nutchez/nutch/conf/hadoop-env.sh

debug_echo "import hadoop-env.sh"

echo "delete search (local,hdfs) and urls (hdfs) "

# 刪除link
rm -rf /home/nutchuser/nutchez/search

/opt/nutchez/nutch/bin/hadoop dfs -rmr urls search

/opt/nutchez/nutch/bin/hadoop dfs -put /home/nutchuser/nutchez/urls urls

# 

/opt/nutchez/nutch/bin/nutch crawl urls -dir search -depth $crawl_dep -topN 5000 -threads 1000

debug_echo "nutch crawl"

#

#/opt/nutchez/nutch/bin/hadoop dfs -get search /home/nutchuser/nutchez/search
/opt/nutchez/nutch/bin/hadoop dfs -get search /home/nutchuser/nutchez/archieve/$crawlname_from_jsp

/opt/nutchez/nutch/bin/hadoop dfs -get urls /home/nutchuser/nutchez/archieve/$crawlname_from_jsp/

debug_echo "download search"

#

# 建立search link

ln -sf /home/nutchuser/nutchez/archieve/$crawlname_from_jsp /home/nutchuser/nutchez/search

# tomcat 重新啟動的指令停止

#/opt/nutchez/tomcat/bin/shutdown.sh

#/opt/nutchez/tomcat/bin/startup.sh


debug_echo "tomcat restart"
