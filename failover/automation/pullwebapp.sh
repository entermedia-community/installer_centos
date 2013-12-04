if [ "$USER" == "root" ]
     then
         echo "Do NOT run as root!";
         exit 1;
fi

test -f /opt/entermedia/tomcat/ismaster && echo 'This is master' && exit 1;

rsync -azhv --delete --progress $PROD_SERVER:/opt/entermedia/webapp/ /opt/entermedia/webapp/
