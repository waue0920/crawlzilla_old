#!/bin/bash
# Program:
#   Functions for client_install.sh
# Author: 
#   Waue, Shunfa, Rock {waue, shunfa, rock}@nchc.org.tw
# History:
#   2010/05/20  Rock    First release(0.1)

#function debug_info () {
##  if [ $? -eq 0 ]; then
#    echo -e "\033[1;35;40m info - $1 \033[0m"
##  fi
#}

#function show_info () {
##  if [ $? -eq 0 ]; then
#    echo -e "\033[1;32;40m $1 \033[0m"
##  fi
#}

function load_default_lang(){

lang=$(locale | grep 'LANG=' | cut -d "=" -f2)

# Default: source english
. $Work_Path/lang/lang_en_US
# if locale is zh then source chinese

echo $lang | grep 'zh' >> /dev/null && source $Work_Path/lang/lang_zh_TW
}

# choose Language
#function choose_lang(){

#lang=$(locale | grep 'LANG=' | cut -d "=" -f2)

# Default: source english
#. $Work_Path/lang/lang_en_US_client_install
# if locale is zh then source chinese
#echo $lang | grep 'zh' >> /dev/null && source $Work_Path/lang/lang_zh_TW_client_install

# Ask language
#echo -e "\n$choose_lang_1"
#read -p "$choose_lang_2 " langChoice

#if [ $langChoice == "2" ]; then
#    source $Work_Path/lang/lang_zh_TW_client_install
#else
#    source $Work_Path/lang/lang_en_US_client_install
#fi
#}

# 檢查執行這個程式的是否為root權限
function check_root(){
# 正式版後可拿掉此 echo
  debug_info "check_root"
  if [ $USER != "root" ]; then
    show_info "$check_root_1"
    exit
  fi
# 正式版後可拿掉此 echo
  show_info "$check_root_2"
}


# 查出此主機的作業系統,以及版本
function check_systemInfo(){
  debug_info "$check_sys_1"
  show_info "$check_sys_2"
  Linux_Distribution=$(lsb_release -a 2> /dev/null | grep "Distributor ID:" | awk '{print $3}')
  Linux_Version=$(lsb_release -a 2> /dev/null | grep "Release" | awk '{print $2}')
  show_info "$Linux_Distribution , $Linux_Version"
}


# 安裝需要的相依套件 (目前只支援 deb 套件的系統自動安裝，yum或其他套件系統的則需手動安裝)
function install_packages(){
  # deb 系列系統
  debug_info "$install_pack_1"
  debug_info "$install_pack_2"
  if [ "$Linux_Distribution" == "Ubuntu" ] || [ "$Linux_Distribution" == "Debian" ] ;then
    echo -e "\n$install_pack_if_1\n"
    aptitude install -y expect ssh dialog
  # rpm 系列系統
  elif [ "$Linux_Distribution" == "Fedora" ] || [ "$Linux_Distribution" == "CentOS" ] ;then
    show_info "$install_pack_if_2"
  else
    show_info "$install_pack_if_2"
  fi 
}


# 檢查之前是否有安裝Crawlzilla
# 目前先檢查是否有/opt/crawlzilla 這個資料夾即可
function check_nez_installed(){
  debug_info "$check_nez_1"
  if [ -d "opt/crawlzilla" ]; then
    show_info "$check_nez_2"
    exit
  else
    show_info "$check_nez_3"
  fi
}


# 檢查是否有安裝sun java ,並檢查是否為jdk 1.6 以上版本
# 4種判斷可能性 (1)系統沒安裝 JAVA (2)系統有安裝JAVA，但非sun版本 
# (3)系統有安裝但Sun Java 在非預設路徑下 (4)以正確安裝 Sun JAVA 預設路徑下
function check_sunJava(){
  show_info "$check_sunJava_1"
  show_info "$check_sunJava_2"

  javaPath="/usr"
  yesno="no"
  choice="3"

  if [ -e $javaPath/bin/java ]; then
    JAVA_org=$($javaPath/bin/java -version 2>&1 | grep "Java(TM)")
    JAVA_version=$($javaPath/bin/java -version 2>&1 | grep "java version" | \
    awk '{print $3}' | cut -d "." -f1-2 | cut -d "\"" -f2)
   
  if [ "$JAVA_org" == "" ]; then 
    show_info "$check_sunJava_if_1"
    show_info "$check_sunJava_if_2"
    show_info "$check_sunJava_if_3"
    read -p "$check_sunJava_if_4" choice
    case $choice  in
      "1")
        show_info "$check_sunJava_if_5"
        exit 
        ;;
      "2")
        read -p "$check_sunJava_if_6" javaPath
        ;;
        "*")
        exit
        ;;
        esac

        if [ $choice == "2" ]; then
          JAVA_org=$($javaPath/bin/java -version 2>&1 | grep "Java(TM)")
          JAVA_version=$($javaPath/bin/java -version 2>&1 | grep "java version" | \
          awk '{print $3}' | cut -d "." -f1-2 | cut -d "\"" -f2)
              
          if [ "$JAVA_org" == "" ]; then
            show_info "$check_sunJava_if_7"
            exit
            fi
          fi
        fi  

      large16=$(echo "$JAVA_version >= 1.6" | bc)
      if [ "${large16}" == 0 ]; then
        show_info "$check_sunJava_if_8"
        exit
      fi  
      
      show_info "$check_sunJava_if_9"
  else
    show_info "$check_sunJava_if_10"
    exit
  fi

  unset JAVA_org
  unset JAVA_version
}


# 檢查是否有安裝openssh, openssh-server
function check_ssh(){
  debug_info "$check_ssh_1"
  if [ -e /usr/bin/ssh ]; then
    show_info "$check_ssh_2"
  else
    show_info "$check_ssh_3"
    exit
  fi

  if [ -e /usr/sbin/sshd ]; then
    show_info "$check_ssh_4"
  else
    show_info "$check_ssh_5"
    exit
  fi
}


# 檢查是否有安裝dialog
function check_dialog(){
  debug_info "$check_dialog_1"
  if [ -e /usr/bin/dialog ]; then
    show_info "$check_dialog_2"
  else
    show_info "$check_dialog_3"
    exit
  fi
}


# scp crawler@master_ip:~ 把.ssh/目錄複製下來
# 當使用者輸入crawler 密碼時，將此密碼紀錄到Nutchuser_Passwd
# 此步驟若無法連到 master 則跳出
function scp_master_crawler_sshkey(){
  debug_info "$scp_sshkey_d1"
  debug_info "$scp_sshkey_d2"
  mkdir -p /home/crawler/.ssh/
  rm -fr /home/crawler/.ssh/*
  unset Crawler_Passwd2

  debug_info "$scp_sshkey_d3"
expect -c "spawn scp -r -o StrictHostKeyChecking=no crawler@$1:~/.ssh /home/crawler/
set timeout 1
sleep 2
expect \"*: \" { send \"$Crawler_Passwd\r\" }
expect \"*: \" { send_user \"$scp_sshkey_expect_1\" }
expect eof"

  if [ -e "/home/crawler/.ssh/authorized_keys" ]; then
    show_info "$scp_sshkey_s1"    
    else
      show_info "$scp_sshkey_s2"
    exit
  fi
  ssh-add /home/crawler/.ssh/id_rsa
  debug_info "$scp_sshkey_d4"
  chown -R crawler:crawler /home/crawler/.ssh
}

# 新增crawler 帳號時用 Crawler_Passwd 當密碼
function creat_crawler_account(){
  debug_info "$create_crawler_d1"
  while [ "$Crawler_Passwd" != "$Crawler_Passwd2" ]
  do
      echo -e "\n"
      read -sp "$create_crawler_1" Crawler_Passwd
      echo 
      read -sp "$create_crawler_2" Crawler_Passwd2
      echo 
        if [ "$Crawler_Passwd" == "$Crawler_Passwd2" ]; then
          show_info "$create_crawler_3"
        else
          show_info "$create_crawler_4"
        fi
  done                                                                                                                                    
  unset Crawler_Passwd2

  if [ $(cat /etc/passwd | grep crawler) ]; then
    show_info "$create_crawler_s1"
    expect -c "spawn passwd crawler
    set timeout 1
    expect \"*: \"
    send \"$Crawler_Passwd\r\"
    expect \"*: \"
    send \"$Crawler_Passwd\r\"
    expect eof"
    else
      show_info "$create_crawler_s2"
      useradd -m crawler -s /bin/bash
      expect -c "spawn passwd crawler
      set timeout 1
      expect \"*: \"
      send \"$Crawler_Passwd\r\"
      expect \"*: \"
      send \"$Crawler_Passwd\r\"
      expect eof"
  fi
}

# 用scp 複製 master 的設定與安裝資料
function scp_packages(){
  debug_info "$scp_packages_d1"
  mkdir /opt/crawlzilla
  mkdir /var/lib/crawlzilla
  if [ ! -e "/var/log/crawlzilla/shell-logs" ]; then
      mkdir -p "/var/log/crawlzilla/shell-logs";
  fi
  mkdir /var/log/crawlzilla/tomcat-logs
  mkdir /var/log/crawlzilla/hadoop-logs
  mkdir /home/crawler/crawlzilla
  mkdir /home/crawler/crawlzilla/source
  mkdir /home/crawler/crawlzilla/system
  debug_info "$scp_packages_d2"
  chown -R crawler:crawler /opt/crawlzilla
  chown -R crawler:crawler /var/log/crawlzilla
  chown -R crawler:crawler /var/lib/crawlzilla
  chown -R crawler:crawler /home/crawler/crawlzilla
  chmod 755 /opt/crawlzilla
  debug_info "$scp_packages_d3"
  if [ -e "$Work_Path/NutchezForClientOf_$Master_IP_Address.tar.gz" ];then
    mv CrawlzillaForClientOf_$Master_IP_Address.tar.gz /home/crawler/crawlzilla/source
  fi
 
  if [ ! -e "/home/crawler/crawlzilla/source/CrawlzillaForClientOf_$Master_IP_Address.tar.gz" ];then
    su crawler -c "scp -r -o StrictHostKeyChecking=no crawler@$1:/home/crawler/crawlzilla/source/CrawlzillaForClientOf_$Master_IP_Address.tar.gz /home/crawler/crawlzilla/source"
  fi
  cp -r $Work_Path/lang /home/crawler/crawlzilla/system
  cp $Work_Path/log.sh $Work_Path/client_remove /home/crawler/crawlzilla/system
}


function install_nutch_package(){
  debug_info "$install_nutch_package_d1"
  tar -zxvf /home/crawler/crawlzilla/source/CrawlzillaForClientOf_$Master_IP_Address.tar.gz -C /opt/crawlzilla
  cp /etc/hosts /home/crawler/crawlzilla/system/hosts.bak
  sed -i '1a '$Master_IP_Address' '$Master_Hostname'' /etc/hosts

}

function change_hosts_owner (){
  if [ -f /etc/hosts ];then
    cp -f /etc/hosts /home/crawler/crawlzilla/system/
    ln -sf /home/crawler/crawlzilla/system/hosts /etc/hosts
    chown crawler:crawler /home/crawler/crawlzilla/system/hosts
  else
    show_info "no /etc/hosts exists.. please check!!"
  fi
}

function recall_hostname_ip(){
  debug_info "$recall_hostname_ip_d1"
  net_interfaces=$(ifconfig | grep ^eth | cut -d " " -f1)
  net_nu=$(echo $net_interfaces | wc -w)
  # 若只有一個 eth　時
  if [ "$net_nu" == "1" ]; then
  # ifconfig $net_interfaces | grep "inet addr:" | sed 's/^.*inet addr://g' | cut -d " " -f1
  net_address=$(ifconfig $net_interfaces | grep "inet addr:" | sed 's/^.*inet addr://g' | cut -d " " -f1)
  net_MacAddr=$(ifconfig $net_interfaces | grep 'HW' | sed 's/^.*HWaddr //g')
  show_info "$recall_hostname_ip_1 $net_address"
  show_info "$recall_hostname_ip_2 $net_MacAddr"

  # 若有多個 eth 時
    else
      declare -i i=1
      show_info "$recall_hostname_ip_3"
       
      for net in $net_interfaces
      do  
        echo "($i)  $net  $(ifconfig $net | grep "inet addr:" | sed 's/^.*inet addr://g' | cut -d " " -f1)"
        i=i+1
      done
       
      read -p "$recall_hostname_ip_4" net_choice
  if [ -z $net_choice ]; then
    net_choice=1
  fi   

  show_info "choice is $net_choice"
  net_interface=$(echo $net_interfaces | cut -d " " -f $net_choice)
  # config $net_interface | grep "inet addr:" | sed 's/^.*inet addr://g' | cut -d " " -f1
  net_address=$(ifconfig $net_interface | grep "inet addr:" | sed 's/^.*inet addr://g' | cut -d " " -f1)
  net_MacAddr=$(ifconfig $net_interface | grep 'HW' | sed 's/^.*HWaddr //g') 
  show_info "$recall_hostname_ip_1 $net_address"
  show_info "$recall_hostname_ip_2 $net_MacAddr"
  fi

  debug_info "$recall_hostname_ip_d2"
  su crawler -c "ssh crawler@$1 echo $net_address $(hostname) $net_MacAddr \>\> ~/crawlzilla/system/crawl_nodes"

}

function change_ownship(){
chown -R $1.$1 $2
}
