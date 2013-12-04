if /usr/bin/wget "http://10.0.251.185/crossdomain.xml" --timeout 30 -O - 2>/dev/
null | grep "macromedia" > /dev/null 2>&1
then
  echo "Production is Up";/etc/alm/productionsup.sh
else
  echo "Production is Down";/etc/alm/productionsdown.sh
fi

