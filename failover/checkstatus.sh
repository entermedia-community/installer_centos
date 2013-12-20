DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
. $DIR/setenv.sh 
if /usr/bin/wget "http://$PROD_SERVER/crossdomain.xml" --timeout 30 -O - 2>/dev/null | grep "macromedia" > /dev/null 2>&1
then
  echo "Production is Up";$DIR/automation/productionsup.sh
else
  echo "Production is Down";$DIR/automation/productionsdown.sh
fi