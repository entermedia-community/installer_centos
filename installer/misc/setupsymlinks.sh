# Create symbolic links

cd /media
ln -s git/entermedia-customisations/deployed/entermedia entermedia

cp -r git/entermedia-customisations/data .
chown -R entermedia:entermedia data

mkdir local
cd local
cp -f ../git/entermedia-customisations/webapp/WEB-INF/oemounts.xml .

cd /opt

rm -rf entermedia
ln -s /media/entermedia entermedia

cd /opt/entermedia/webapp/WEB-INF

rm -rf ./data
rm -f ./oemounts.xml

ln -s /media/data data
ln -s /media/local/oemounts.xml oemounts.xml