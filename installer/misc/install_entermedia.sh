##make sure you have a user useradd entermedia 

mkdir /home/entermedia/.ffmpeg
cp .ffmpeg/libx264-normal.ffpreset /home/entermedia/.ffmpeg/libx264-normal.ffpreset

chown -R entermedia:entermedia /home/entermedia/.ffmpeg

cp tomcat /etc/init.d/
chkconfig --add tomcat

cp -rp ../entermedia /opt/entermedia
cd /opt/entermedia/webapp
wget http://dev.entermediasoftware.com/jenkins/view/Demo/job/demoall/lastSuccessfulBuild/artifact/deploy/ROOT.war
unzip ROOT.war 
rm ROOT.war

chown -R entermedia:entermedia /opt/entermedia

