#!/bin/bash
# crawlzillaBack.sh backup/restore 帳號 備份位址 路徑

if [ $1 == "backup" ]; then
    
	if [$4 -eq ""]; then
	    echo "使用方式： crawlzillaBack.sh backup/restore 帳號 備份位址 路徑"
	    exit
	fi

	account=$2
	ipAddress=$3
	storeagePath=$4
	memberPath="/home/crawler/crawlzilla/"
	tomcatPath="/opt/crawlzilla/tomcat/webapps/"
   
	# 打包程序, 存儲至/tmp/路徑下
	# 1. 打包/home/crawler 路徑下的檔案
	tar -zpcv -f /tmp/crawlzillaBackup.tar.gz $memberPath

	# 2. 打包tomcat檔案
	tar -zpcv -f /tmp/tomcatBackup.tar.gz $tomcatPath

	# 3. 傳送至備份主機
        scp /tmp/crawlzillaBackup.tar.gz /tmp/tomcatBackup.tar.gz $account@$ipAddress:$storeagePath


fi

