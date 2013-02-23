#!/bin/bash

# This script performs a full file backup of a linux file server,
# using rsync to minimise bandwidth usage.

# I personally schedule it with cron to run every night.
# It has some man in the middle attack vulnerabilities because it sends a raw
# ssh password, but I wanted it to work also in servers that I cannot fully configure
# to work only with key authentication.

# Make sure you have sshpass already installed for the script to work:
# sudo apt-get install sshpass

# Alex Hughes, London 2013

echo
echo "File Backup Initialized"

#perform a backup using the rsync command
sshpass -p 'anSSHpassword' rsync -e "ssh -p 2222" -avz --delete user@host.org:/home/user/public_html/ rsync_files/

#archive and compress all files
tar -zcf backup.tar.gz rsync_files/*

#move archive to desired location. Don't delete files and folders
#so that differential transfer is performed next time
mv backup.tar.gz /home/user/Dropbox/

#update the log
log="File Backup: "
log+=$(date)
log+=" completed succesfully"

echo $log >> /home/user/Dropbox/log

echo "File Backup Completed"
echo