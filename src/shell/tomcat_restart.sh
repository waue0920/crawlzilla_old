command=$1
tom_pids=$(ps x | grep -v "grep" | grep "tomcat" | awk '{print $1}')
Tomcat_HOME="/opt/nutchez/tomcat"
source "/home/nutchuser/nutchez/system/log.sh" tomcat_restart_sh;
if [ $command == "start" ];then
	$Tomcat_HOME/bin/startup.sh
	debug_info "$Tomcat_HOME/bin/startup.sh"
elif [ $command == "stop" ];then
	$Tomcat_HOME/bin/shutdown.sh
	debug_info "$Tomcat_HOME/bin/shutdown.sh"
	kill $tom_pids
	debug_info "kill $tom_pids"
else
	$Tomcat_HOME/bin/shutdown.sh
	debug_info "$Tomcat_HOME/bin/shutdown.sh"
	kill $tom_pids
	debug_info "kill $tom_pids"
	$Tomcat_HOME/bin/startup.sh	
	debug_info "$Tomcat_HOME/bin/startup.sh"
fi

