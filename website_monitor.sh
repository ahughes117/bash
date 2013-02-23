#!/bin/bash
#Simple Script to check whether all of my clients' websites are up and running.

#This function takes the site's url as an argument and checks the curl command
#exit code. If it's different than 0, it assumes that the site is down.

#This version comes with a mailing function. Make sure sendEmail is installed 
#along with the appropriate libraries below:

#sudo apt-get install sendEmail
#sudo apt-get install libio-socket-ssl-perl libnet-ssleay-perl

#Alex Hughes, London 2012

notify() {
	
	#email credentials
	username="aUsername@gmail.com"
	password="aPassword"
	host="smtp.gmail.com:587"
	recipient="aRecipient@gmail.com"
	subject="Website Monitor Alert"
	
	#preparing message
	content="Site: "
	content+=$1
	content+=" is down and crying. || "
	content+=$(date)
	
	#sending the email
	sendEmail -v -f $username -s $host -xu $username -xp $password -t $recipient -o tls=yes -u $subject -m $content
}
	

check_site () {
	log="site: "
	log+=$1
	log+=" || "
	curl -s -o "/dev/null" $1
	if  [ $? -ne 0 ]; then
		log+="DOWN || "
		log+=$(date)
		echo "*******DOWN*******"
		notify $1
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
