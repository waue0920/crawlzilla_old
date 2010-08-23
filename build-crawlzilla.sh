#!/bin/bash
# 此shell 可以用來把svn上的程式碼封裝成安裝壓縮包
# 但目前此shell 不會自己打包 Nutchez 0.2pack 

# 請先設定 DELETE_LOCK 是否要刪除
# 以及安裝的時間版本 DATE_VER 


DELETE_LOCK=1 # 1= 刪除 $TmpDir 資料夾
DATE_VER=`date +%y%m%d` # 年月日
CURRENT_VER=0.2 # 專案目前的版本


function checkMethod(){
  if [ $? -eq 0 ];then
    echo "$1 is ok";
  else
    echo "$1 broken , exit ";
    exit 8
  fi
}


SvnProject=/opt/svn_project
GoogleCodeCrawlzilla=$SvnProject/crawlzilla
TmpDir=Crawlzilla_Install
ShellTar=Crawlzilla-0.2-$DATE_VER-Shell.tar.gz
FullTar=Crawlzilla-0.2-$DATE_VER-Full.tar.gz

# 1 同步資料與編譯web資料

cd $GoogleCodeCrawlzilla; svn update;
checkMethod 1.1
ant -f /opt/svn_project/crawlzilla/src/web/build.xml clean
ant -f /opt/svn_project/crawlzilla/src/web/build.xml
checkMethod 1.2

# 2 開始目錄以及生成暫存目錄

cd $SvnProject

if [ -d $TmpDir ];then
  rm -rf $TmpDir;
  checkMethod 2.1
fi
mkdir $TmpDir

# 2.5 打包 crawlzilla.war
mkdir $TmpDir/web/
checkMethod 2.2
cp $SvnProject/dist/crawlzilla.war $TmpDir/web/
mv $SvnProject/dist/crawlzilla.war $SvnProject/dist/crawlzilla-$DATE_VER.war
checkMethod 2.3


# 3 複製資料夾

cp -rf $GoogleCodeCrawlzilla/src/shell $TmpDir/bin
checkMethod 3.1
cp -rf $GoogleCodeCrawlzilla/docs $TmpDir/
checkMethod 3.2
cp -rf $GoogleCodeCrawlzilla/conf $TmpDir/
checkMethod 3.3

# 4 複製與鍊結檔案

cp $GoogleCodeCrawlzilla/LICENSE.txt $TmpDir/
checkMethod 4.1
cd $TmpDir
ln -sf docs/README.en.txt README.txt
ln -sf bin/install install
cd $SvnProject

# 5 先壓縮精簡包

tar -czvf $ShellTar $TmpDir --exclude=.svn
checkMethod 5.1

# 6 放入 pack 檔
# mkdir $TmpDir/package
# cp $GoogleCodeNutcheEz/src/package/crawlzilla-pack-current.tar.gz $TmpDir/package/
# checkMethod 6.1

# 7 壓縮完整包
# 這邊先註解掉，因為這個包很大
# tar -czvf $FullTar $TmpDir --exclude=.svn
# checkMethod 7.1


# 8 複製到 trac 的 package
#if [ ! -d $SvnProject/dist ];then
#  mkdir $SvnProject/dist
#  checkMethod 8.1
#fi

# 先不做fulltar
#if [ -f $SvnProject/dist/$FullTar ];then
#  rm $SvnProject/dist/$FullTar;
#  checkMethod 8.2
#fi
#mv $FullTar $SvnProject/dist
#checkMethod 8.3

if [ -f $SvnProject/dist/$ShellTar ];then
  rm $SvnProject/dist/$ShellTar;
  checkMethod 8.4
fi
mv $ShellTar $SvnProject/dist
checkMethod 8.5

# 9 刪除 DELETE_LOCK=1
if [ $DELETE_LOCK -eq 1 ];then
  rm -rf $TmpDir;
  checkMethod 9.1
fi


# 10 上傳到 source forge
# 做local user 與 sf.net 上的user 對應, fafa 與
if [ $USER == "waue" ];then
    USER=waue0920;
elif [ $USER == "rock" ];then
    USER=goldjay1231;
fi

# 上傳到sf.net
scp $SvnProject/dist/$ShellTar $USER,crawlzilla@frs.sourceforge.net:/home/frs/project/c/cr/crawlzilla/stable/Crawlzilla-$CURRENT_VER/


echo "完成，一切確認後，最後的檔案放在這個目錄內："
echo "	../dist/ "
echo "最新的版本[ $ShellTar ]也同時上傳到sf.net囉"
echo "http://sourceforge.net/downloads/crawlzilla/stable/Crawlzilla-0.2/"
