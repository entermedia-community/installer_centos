##start up our server

##make sure tomcat is running

touch /opt/entermedia/tomcat/ismaster

##make sure we are not already running
/usr/bin/wget "http://127.0.0.1:8080/crossdomain.xml" --timeout 30 -O - 2>/dev/null | grep "macromedia" || /opt/entermedia/tomcat/bin/startup.sh

