#!/bin/bash

# This script performs a full backup of a MySQL database server,
# excluding databases explicitly. It's extremely helpful if you have 50 databases
# and you want to exclude 5 or 6 of them. It dumps the contents into a .sql file, like always.
# That's why I wrote it the first time. I really kept it simple to use and really hope you find it helpful.
# I am really open to comments, suggestions etc...

# Alex Hughes, London 2012.

echo
echo "Database Backup Initialized"

# selecting database schema names that are going to be excluded
# it is a good idea to exclude the performance schema and the information schema as well.
query="SELECT schema_name "
query+="FROM information_schema.schemata " 
query+="WHERE schema_name "
query+="NOT IN ('anExcludedDB1', 'anExcludedDB2', 'information_schema', 'performance_schema') "

#grep is used to get rid of the column name, which is not a db
databases=$(mysql -u aUsername -paPassword -B -n -e "$query" | grep -v "schema_name")

#performing the dump and placing it in a file.
#I prefer to have it in my dropbox so it is automatically impossible to lose any data.
mysqldump -u aUsername -paPassword --databases $databases > /home/user/Dropbox/server_backup/db.sql;

#also a mini log is being kept. Just to know that cron is working.
log="DB Backup: "
log+=$(date)
log+=" completed succesfully"

#Every backup instance is appended at the end of the file
echo $log >> /home/user/Dropbox/server_backup/log

echo "Database Backup Completed"
echo


