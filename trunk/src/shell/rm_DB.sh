#!/bin/bash
if [ $1 == " " ]; then
echo "No parameter"
else
rm -f /home/crawler/crawlzilla/.tmp/$1
rm -fr /opt/crawlzilla/tomcat/webapps/$1
/opt/crawlzilla/nutch/bin/hadoop fs -rmr /user/crawler/$1
fi

