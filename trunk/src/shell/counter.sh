#!/bin/bash
Begin=0
crawlname_from_jsp=$1
tmp_dir="/home/crawler/crawlzilla/.tmp"
echo $$ > $tmp_dir/$crawlname_from_jsp/$crawlname_from_jsp'count_pid'

while [ 1 ]
  do
    sleep 1
    Begin=$(expr $Begin + 1)
    Min=$(expr $Begin / 60)
    Hour=$(expr $Min / 60)
    Min=$(expr $Min % 60)
    Sec=$(expr $Begin % 60)
    echo $Hour'h:'$Min'm:'$Sec's' > $tmp_dir/$crawlname_from_jsp/$crawlname_from_jsp'PassTime'
  done
