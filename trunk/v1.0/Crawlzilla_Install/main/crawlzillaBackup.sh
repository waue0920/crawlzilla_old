#!/bin/bash
# crawlzillaBack.sh backup/restore 帳號＠備份位址/local 路徑
# 測試指令 <1>sudo ./crawlzillaBackup.sh backup shunfa@140.110.134.198 ~
# 測試指令 <2>sudo ./crawlzillaBackup.sh backup local
# 測試指令 <3>sudo ./crawlzillaBackup.sh restore 路徑

tomcatPath="/opt/crawlzilla/tomcat/webapps"
homePath="/home/crawler/crawlzilla"
date=$(date +%y-%m-%d-%H%M)

function backupProcess (){
    echo "start backup process!";

    if [[ $storeagePath ==  "" ]] ; then
	storeagePath="/home/crawler/backup"
	if [ ! -d "/home/crawler/backup" ]; then
	    mkdir -p /home/crawler/backup;
	fi
    fi

    # 打包程序, 存儲至/tmp/路徑下
    # 1. 打包檔案
    echo "$date: backup process" >> /var/log/crawlzilla/shell-logs/backup.log
    touch $homePath/meta/$date.backup.flag
    tar -zpcv -f /tmp/crawlzillaBackup-$date.tar.gz $homePath/applyUser $homePath/meta $homePath/user $tomcatPath
    rm $homePath/meta/$date.backup.flag

    # 2. 傳送至儲存位址
    if [[ $userAndipAddress == "local" ]]; then
	cp /tmp/crawlzillaBackup-$date.tar.gz $storeagePath
	chown -R crawler:crawler $storeagePath
	chmod -R 755 $storeagePath
	echo "store path: $storeagePath";
	echo "backup finished!" >> /var/log/crawlzilla/shell-logs/backup.log
    else	
	scp /tmp/crawlzillaBackup-$date.tar.gz $userAndipAddress:$storeagePath
    fi
}

function restoreProcess(){
    echo "start restore process!";
    echo "restore file: $storeagePath ...";
    echo "$date: restore process" >> /var/log/crawlzilla/shell-logs/restore.log
    
    restoreDate=$(echo $storeagePath | cut -d '-' -f 2,3,4,5 | cut -d '.' -f 1);

    # rename 
    mv $homePath/applyUser $homePath/applyUser-bak
    mv $homePath/meta $homePath/meta-bak
    mv $homePath/user $homePath/user-bak
    mv $tomcatPath $tomcatPath-bak


    tar -zxvf $storeagePath
    # check flag
    if [[ ! -e $homePath/meta/$restoreDate.backup.flag ]]; then
	echo "restore process failured!" >> /var/log/crawlzilla/shell-logs/restore.log;
	rm -rf $homePath/applyUser $homePath/meta $homePath/user $tomcatPath 
	
	# 還原之前狀態
        mv $homePath/applyUser-bak $homePath/applyUser
	mv $homePath/meta-bak $homePath/meta
	mv $homePath/user-bak $homePath/user
	mv $tomcatPath-bak $tomcatPath
	exit 1;
    fi

    rm $homePath/meta/$restoreDate.backup.flag;
    # write log
    chown -R crawler:crawler $homePath
    chown -R crawler:crawler $tomcatPath
    chmod -R 755 $homePath
    chmod -R 755 $tomcatPath
    echo "$date: restore process finished!" >> /var/log/crawlzilla/shell-logs/restore.log
}

function main(){
    # check para
    if [[ $1 != "restore" ]]  && [[ $3 == "" ]] && [[ $2 != "local" ]] ; then
	echo "備份至其他主機：crawlzillaBack.sh backup/restore 帳號＠備份位址/local 路徑";
        echo "備份至本機：crawlzillaBack.sh backup/restore local 本機路徑(預設為"/home/crawler/backup")";
	exit 1;
    fi
    
    if [[ $1 == "restore" ]] && [[ $2 == ""  ]]; then
	echo "restore type: crawlzillaBack.sh restore 還原檔路徑及檔名";
	exit 1;
    fi

    if [[ $1 == "restore" ]] ; then
	storeagePath=$2;
	if [[ ! -e $storeagePath ]]; then
	    echo "$storeagePath file not found";
	    exit 1;
	fi
	restoreDate=$(echo $storeagePath | cut -d '-' -f 2,3,4,5| cut -d '.' -f 1);
	restoreProcess;
    fi

    if [[ $1 == "backup" ]]; then
	if [[ $2 == "local" ]]; then
	    userAndipAddress=$2
	    storeagePath=$3
            backupProcess
	    exit 1;
	fi
    fi
}

main $1 $2 $3
