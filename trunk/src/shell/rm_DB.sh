#!/bin/bash
if [ $1 == " " ]; then
echo "No parameter"
else
rm -f /home/nutchuser/crawlzilla/.tmp/$1
rm -fr /opt/crawlzilla/tomcat/webapps/$1
/opt/crawlzilla/nutch/bin/hadoop fs -rmr /user/nutchuser/$1
fi

