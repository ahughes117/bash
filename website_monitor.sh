#!/bin/bash
#Simple Script to check whether all of my clients' websites are up and running.

#This function takes the site's url as an argument and checks the curl command
#exit code. If it's different than 0, it assumes that the site is down.

#Future additions would be a nice mailing or SMS function that notifies the 
#administrator, as well as more detailed info about the errors encountered.

check_site () {
	log="site: "
	log+=$1
	log+=" || "
	curl -s -o "/dev/null" $1
	if  [ $? -ne 0 ]; then
		log+="DOWN || "
		log+=$(date)
		echo "*******DOWN*******"
		#TODO mailing function
	else
		log+="UP || "
		log+=$(date)
		echo "*******UP*******"
	fi
	echo $log >> /home/user/web_monitor_log
}

sites[0]='site1.com'
sites[1]='site2.com'

for i in "${sites[@]}"
do
	check_site $i
done

cp /home/user/web_monitor_log /home/user/Dropbox/
