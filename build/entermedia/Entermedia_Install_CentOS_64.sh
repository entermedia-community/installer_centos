yum install -y automake ufraw-*
yum install -y libreoffice-headless libreoffice-writer libreoffice-calc libreoffice-impress libreoffice-draw unzip wget git
yum install -y ilmbase OpenEXR-libs libtool-ltdl librsvg2 libwmf-lite libXt libgomp libtiff

mv qt-faststart /usr/bin
ln -s /usr/bin/avprobe /usr/bin/ffprobe

##make sure you have a user useradd entermedia 
adduser entermedia
usermod -a -G vboxsf entermedia

# Fix File Limits
echo "fs.file-max = 10000000" >> /etc/sysctl.conf
echo "entermedia      soft    nofile  409600" >> /etc/security/limits.conf
echo "entermedia      hard    nofile  1024000" >> /etc/security/limits.conf
sysctl -p
#End Fix File Limits

mkdir /home/entermedia/.ffmpeg
mv libx264-normal.ffpreset /home/entermedia/.ffmpeg/libx264-normal.ffpreset

chown -R entermedia:entermedia /home/entermedia/.ffmpeg

mv tomcat /etc/init.d/
chkconfig --add tomcat
chkconfig --level 3 tomcat on
chkconfig --level 5 tomcat on

mkdir -p /opt/entermedia/webapp
cd /opt/entermedia/
wget https://github.com/entermedia-community/tomcat8/archive/master.zip -O tomcat.zip
unzip tomcat.zip
rm -f tomcat.zip
mv tomcat8-master tomcat

cd /opt/entermedia/webapp
wget http://dev.entermediasoftware.com/jenkins/view/Demo/job/demoall/lastSuccessfulBuild/artifact/deploy/ROOT.war -O ROOT.war
unzip ROOT.war
rm ROOT.war

#Copy data directory out and link it
mkdir /media
mv /opt/entermedia/webapp/WEB-INF/data /media
ln -s /media/data /opt/entermedia/webapp/WEB-INF/data

chown -R entermedia:entermedia /opt/entermedia
chmod -R u+s,g+s /opt/entermedia 

#iptables -F
export ip=`ifconfig eth0 |grep "inet addr" |awk '{print $2}' |awk -F: '{print $2}'`
/sbin/iptables -t nat -A OUTPUT -d localhost -p tcp --dport 80 -j REDIRECT --to-ports 8080
/sbin/iptables -t nat -A OUTPUT -d $ip -p tcp --dport 80 -j REDIRECT --to-ports 8080
/sbin/iptables -t nat -A PREROUTING -d $ip -p tcp --dport 80 -j REDIRECT --to-ports 8080

/sbin/iptables -t nat -A OUTPUT -d localhost -p tcp --dport 22 -j REDIRECT --to-ports 22
/sbin/iptables -t nat -A OUTPUT -d $ip -p tcp --dport 22 -j REDIRECT --to-ports 22
/sbin/iptables -t nat -A PREROUTING -d $ip -p tcp --dport 22 -j REDIRECT --to-ports 22

iptables-save > /etc/sysconfig/iptables

service tomcat start

echo "Install complete. see: http://localhost:8080/emshare"
