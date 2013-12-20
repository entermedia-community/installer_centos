##shut down our server
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

pgrep java && /opt/entermedia/tomcat/bin/shutdown.sh

if [ $PULL_DATA -eq "true" ]; then
   pgrep rsync || $DIR/pulldata.sh > ~/rsync.log;
fi