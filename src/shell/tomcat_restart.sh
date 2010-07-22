tom_pids=$(ps x | grep -v 'grep' | grep "tomcat" | awk '{print $1}'
Tomcat_HOME="/opt/nutchez/tomcat"

for tom_pid in $tom_pids
    do  
        kill -9 $tom_pid 2>/dev/null
    done

$Tomcat_HOME/bin/startup.sh
$Tomcat_HOME/bin/shutdown.sh
