#! /bin/bash

SHELLNAME=$1
DATE=`date +%y%m%d`
TIME=`date +%Y/%m/%d-%H:%M:%S`
export LOG_SH_TARGET=/var/log/nutchez/shell-logs/$SHELLNAME-$DATE.log

##########  echo function  ##########
function debug_info () {
  if [ $? -eq 0 ]; then
    echo -e " [D-INFO] - $1 " >> $LOG_SH_TARGET
  fi
}


function show_info () {
  if [ $? -eq 0 ]; then
    echo -e "\033[1;32;40m $1 \033[0m"
    echo "[INFO] - $1" >> $LOG_SH_TARGET
  fi
}
#########end echo function ##########


if [ ! -e "/var/log/nutchez/shell-logs/" ]; then
    mkdir -p "/var/log/nutchez/shell-logs/";
fi
# file descriptor 4 prints to STDOUT and to TARGET
#exec 4> >(while read a; do echo $a; echo $a >> $LOG_SH_TARGET; done)
# now STDOUT is redirected
#exec 1>&4
#exec 2>&4

echo "" >> $LOG_SH_TARGET;
echo "*****************************************************" 	>> $LOG_SH_TARGET;
echo "* $TIME => $SHELLNAME begin   *" 				>> $LOG_SH_TARGET;
echo "*****************************************************" 	>> $LOG_SH_TARGET;
