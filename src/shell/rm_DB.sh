#!/bin/bash
if [ $1 == " " ]; then
echo "No parameter"
else
rm -f /home/nutchuser/nutchez/.tmp/$1
rm -fr /opt/nutchez/tomcat/webapps/$1
/opt/nutchez/nutch/bin/hadoop fs -rmr /user/nutchuser/$1
fi

