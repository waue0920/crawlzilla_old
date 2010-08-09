#!/bin/bash
crawl_dep=$1
crawlname_from_jsp=$2
archieve_dir="/home/nutchuser/nutchez/archieve"
tmp_dir="/home/nutchuser/nutchez/.tmp"

if [ "$1" == "" ]; then
 echo "1. 使用這個shell ，首先你需要有nutchuser這個使用者，並且hadoop 已經開始運作";
 echo "2. /home/nutchuser/nutchez/url/urls.txt 裡面有你要抓的網址";
 echo "3. 執行 ./go.sh [深度] [資料夾名稱] 即可，如：";
 echo "	./go.sh 3 crawlname"
 echo "4. 等nutch所有程序完成，則你的資料在 $archieve_dir/crawlname/ "
 exit
fi

source "/opt/nutchez/nutch/conf/hadoop-env.sh";
source "/home/nutchuser/nutchez/system/log.sh" crawl_go;

function checkMethod(){
  if [ $? -eq 0 ];then
    echo "$1 is ok";
  else
    echo "error: $1 broken" > "$tmp_dir/$crawlname_from_jsp"
    show_info "error: $1 broken"
    exit 8
  fi
}

checkMethod "import lib path"

# 策略改變 不用檢查
#if [ -e /home/nutchuser/nutchez/search ];then
    # 不是第一次搜尋，刪除hdfs上的資料夾
#    echo "delete search (local,hdfs) and urls (hdfs) "
#    echo "not first time"
#    FirstTime=2;
#else
    # 第一次搜尋，設定參數，以後使用
#    echo "first time set"
#    FirstTime=1;
#fi


# $archieve_dir/tmp 用來放該程序的狀態
if [ ! -e $tmp_dir ];then
   mkdir $tmp_dir
   checkMethod "mkdir .tmp"
fi
# 開始紀錄程序狀態
echo "begin" > "$tmp_dir/$crawlname_from_jsp"

/opt/nutchez/nutch/bin/hadoop dfs -mkdir $crawlname_from_jsp
checkMethod "hadoop dfs -mkdir $crawlname_from_jsp"
/opt/nutchez/nutch/bin/hadoop dfs -put /home/nutchuser/nutchez/urls $crawlname_from_jsp/urls
checkMethod "hadoop dfs -put urls"

# 開始nutch 搜尋
echo "crawling" > "$tmp_dir/$crawlname_from_jsp"

/opt/nutchez/nutch/bin/nutch crawl $crawlname_from_jsp/urls -dir $crawlname_from_jsp -depth $crawl_dep -topN 5000 -threads 1000
checkMethod "nutch crawl"

/opt/nutchez/nutch/bin/hadoop dfs -get $crawlname_from_jsp $archieve_dir/$crawlname_from_jsp
checkMethod "download search"

# 製作 $crawlname_from_jsp 於 tomcat
cp -rf /opt/nutchez/tomcat/webapps/default /opt/nutchez/tomcat/webapps/$crawlname_from_jsp
checkMethod "cp default to "
sed -i '8s/search/'${crawlname_from_jsp}'/g' /opt/nutchez/tomcat/webapps/$crawlname_from_jsp/WEB-INF/classes/nutch-site.xml
checkMethod "sed"

# 完成搜尋狀態
echo "finish" > "$tmp_dir/$crawlname_from_jsp"

# 策略改變，不分別下載
# /opt/nutchez/nutch/bin/hadoop dfs -get search $archieve_dir/$crawlname_from_jsp
# checkMethod "download search"
# /opt/nutchez/nutch/bin/hadoop dfs -get urls $archieve_dir/$crawlname_from_jsp/
# checkMethod "download urls"

# 策略改變 已經不用檢查是否第一次
# 第一次要建立search link並且重新啟動tomcat
#if [ $FirstTime -eq 1 ];then
    # first time link and restart
    #ln -sf $archieve_dir/$crawlname_from_jsp /home/nutchuser/nutchez/search
    # tomcat 重新啟動的指令
    #/opt/nutchez/tomcat/bin/shutdown.sh
    #/opt/nutchez/tomcat/bin/startup.sh
    #checkMethod "tomcat restart"
#fi


