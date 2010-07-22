#!/bin/bash
# Master IP here
MasterIP_Address=your.master.ip.here

cd ~
mkdir nutchez_client_install
cd nutchez_client_install
scp -r nutchuser@$MasterIP_Address:/home/nutchuser/nutchez/source/* .

