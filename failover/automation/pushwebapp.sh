if [ "$USER" == "root" ]
     then
         echo "Do NOT run as root!";
         exit 1;
fi
## This should only be run after disater is complete and you need to push changes back to production

rsync -azhv  --delete  /opt/entermedia/webapp/ --progress $PROD_SERVER:/opt/entermedia/webapp/
