#!/bin/bash
# crawlzillaBack.sh backup/restore 帳號＠備份位址/local 路徑
#測試指令 <1>sudo ./crawlzillaBackup.sh backup shunfa@140.110.134.198 ~
#測試指令 <2>sudo ./crawlzillaBackup.sh backup local

function backup_process (){
    echo "start backup process!";
    userAndipAddress=$2
    storeagePath=$3
    date=$(date +%y-%m-%d)
    tomcatPath="/opt/crawlzilla/tomcat/webapps/"
    homePath="/home/crawler/crawlzilla/"

    if [[ $storeagePath ==  "" ]] ; then
	storeagePath="/home/crawler/backup"
	if [ ! -d "/home/crawler/backup" ]; then
	    mkdir -p /home/crawler/backup;
	fi
    fi

    # 打包程序, 存儲至/tmp/路徑下
    # 1. 打包/home/crawler 路徑下的檔案
    tar -zpcv -f /tmp/crawlzillaBackup-$date.tar.gz $homePath
    echo "tar -zpcv -f /tmp/crawlzillaBackup-$date.tar.gz $homePath" 
    # 2. 打包tomcat檔案
    tar -zpcv -f /tmp/tomcatBackup-$date.tar.gz $tomcatPath
    echo "tar -zpcv -f /tmp/tomcatBackup-$date.tar.gz $tomcatPath"
    # 3. 傳送至儲存位址
    if [[ $userAndipAddress == "local" ]]; then
	cp /tmp/crawlzillaBackup-$date.tar.gz $storeagePath
	cp /tmp/tomcatBackup-$date.tar.gz $storeagePath
    else	
	scp /tmp/crawlzillaBackup-$date.tar.gz /tmp/tomcatBackup-$date.tar.gz $userAndipAddress:$storeagePath
    fi
}

function main(){
    # check para
    if [[ $3 == "" ]] && [[ $2 != "local" ]]; then
	echo "備份至其他主機：crawlzillaBack.sh backup/restore 帳號＠備份位址/local 路徑";
        echo "備份至本機：crawlzillaBack.sh backup/restore local 本機路徑(預設為"/home/crawler/backup")";
	exit 1;
    fi

    if [[ $1 == "backup" ]]; then
	backup_process $1 $2 $3
    fi
}

main $1 $2 $3
