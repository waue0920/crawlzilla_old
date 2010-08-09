#!/bin/bash
# Master IP here
Master_IP_Address=your.master.ip.here
Work_Path=`dirname "$0"`
cd ~
if [ -e /usr/bin/ssh ]; then
  echo "checking ssh ... found"
else
  echo "pleash instsll \"ssh\""
  exit
fi

if [ -e /usr/sbin/sshd ]; then
  echo "checking sshd ... found"
else
  echo "pleash instsll \"sshd\""
  exit
fi
mkdir crawlzilla_client_install
scp -r -o StrictHostKeyChecking=no crawler@$Master_IP_Address:/home/crawler/crawlzilla/source/* crawlzilla_client_install/.
exec crawlzilla_client_install/client_install
