This script should be installed on the backup server.

1. Copy the failover folder to someplace like /opt/entermedia/failover
2. edit the setenv.sh to point to the production server
3. Change your DNS server to add an alias that uses the primary or seconday IP depending on the one that is up
4. add a crontab to monitor the production server: crontab -e

#check production every 5 minutes
*/5 * * * * /opt/entermedia/failover/checkstatus.sh >/dev/null 2>&1

