##set environmental variables
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DIR=${DIR%/*}
. $DIR/setenv.sh

##start up our server

##make sure tomcat is running

touch /opt/entermedia/tomcat/ismaster

##make sure we are not already running
/usr/bin/wget "http://127.0.0.1:8080/crossdomain.xml" --timeout 30 -O - 2>/dev/null | grep "macromedia" || /opt/entermedia/tomcat/bin/startup.sh

##send email if enabled
if $EMAIL_NOTIFICATION; then
   echo "Server: $PROD_SERVER has shutdown. The failover server has started up." | mail -s "Production Server Went Down" $EMAIL_ADDRESS
fi