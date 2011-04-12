#!/bin/bash
# 此shell 可以用來把svn上的程式碼封裝成安裝壓縮包
# 請先設定 DELETE_LOCK 是否要刪除
# 以及安裝的時間版本 DATE_VER 

#DELETE_LOCK=0 # 1= 刪除 $TmpDir 資料夾
DATE_VER=`date +%y%m%d` # 年月日
CURRENT_VER=1.0 # 專案目前的版本
MINOR_VER=alpha

# for ant
SvnCrawlzilla=`dirname "$0"`
SvnCrawlzilla=`cd "$SvnCrawlzilla"; pwd`

DistDir=./packages
TmpDir=Crawlzilla_Install
ShellTar=Crawlzilla-$CURRENT_VER-$DATE_VER-Shell.tar.gz
StableTar=Crawlzilla-$CURRENT_VER.$MINOR_VER.tar.gz
FullTar=Crawlzilla-$CURRENT_VER-$DATE_VER-Full.tar.gz

function checkMethod(){
  if [ $? -eq 0 ];then
    echo "$1 is ok";
  else
    echo "$1 broken , exit ";
    exit 8
  fi
}
# 1. generate version and svn update 
echo "$CURRENT_VER.$MINOR_VER-$DATE_VER" > $SvnCrawlzilla/Crawlzilla_Install/version
checkMethod 1.1
svn update;
checkMethod 1.2

# 2 create crawlzilla.war file
ant -f $SvnCrawlzilla/web-src/build.xml clean
ant -f $SvnCrawlzilla/web-src/build.xml
checkMethod 2.2

# 3 make dir for tmp and final

#cd $SvnProject

#if [ -d $TmpDir ];then
#  rm -rf $TmpDir;
#  checkMethod 3.1
#fi
#mkdir $TmpDir

if [ ! -d $DistDir ];then
  mkdir $DistDir
  checkMethod 3.1
fi

# 4 package crawlzilla.war
mkdir $TmpDir/web/
checkMethod 4.2
cp $SvnCrawlzilla/web-src/tmp/crawlzilla.war $TmpDir/web/
mv $SvnCrawlzilla/web-src/tmp/crawlzilla.war $DistDir/crawlzilla-$DATE_VER.war
checkMethod 4.3


# 5 copy dir

#cp -rf $SvnCrawlzilla/opt/main $TmpDir/
#checkMethod 5.1
#cp -rf $SvnCrawlzilla/docs $TmpDir/
#checkMethod 5.2
#cp -rf $SvnCrawlzilla/conf $TmpDir/
#checkMethod 5.3

# 6 copy and link

#cp $SvnCrawlzilla/LICENSE.txt $TmpDir/
#checkMethod 6.1
#cd $TmpDir
#ln -sf docs/README.en.txt README.txt
#ln -sf bin/install install

# 7 tar file
cd $SvnCrawlzilla
tar -czvf $ShellTar $TmpDir --exclude=.svn
checkMethod 7.1

# 7.1 make full package  .. skip

# 8 reload dir
if [ -f $DistDir/$ShellTar ];then
  rm $DistDir/$ShellTar;
  checkMethod 8.0
fi


echo "Is it stable version ?"
read -p "[y/n] :" stable_check

if [ "$stable_check" == "y" ];then
  if [ -f $DistDir/$StableTar ];then
    rm $DistDir/$StableTar;
    checkMethod 8.0
  fi
  cp $ShellTar $DistDir/$StableTar
  checkMethod 8.1
fi
mv $ShellTar $DistDir
checkMethod 8.1


# 8.2  DELETE_LOCK=1
#if [ $DELETE_LOCK -eq 1 ];then
#  rm -rf $TmpDir;
#  checkMethod 8.2
#fi

echo "完成，一切確認後，最後的檔案放在這個目錄內："
echo "  $DistDir/$StableTar "

# 9 upload to  source forge
echo "Upload to source forge ?"
read -p "[y/n] :" upload_sf
if [ "$upload_sf" == "y" ];then

    # 做local user 與 sf.net 上的user 對應, fafa 與 rock
    if [ $USER == "waue" ];then
        USER=waue0920;
    elif [ $USER == "rock" ];then
        USER=goldjay1231;
    fi
    # 上傳到sf.net
    scp $DistDir/$ShellTar $USER,crawlzilla@frs.sourceforge.net:/home/frs/project/c/cr/crawlzilla/testing/Crawlzilla-$CURRENT_VER/
    echo "最新的版本[ $ShellTar ]也同時上傳到sf.net囉"
    echo "http://sourceforge.net/downloads/crawlzilla/testing/Crawlzilla-$CURRENT_VER/"
fi

# 
