#!/bin/bash
##make sure you have a user useradd entermedia
cd `dirname $0`
useradd -m entermedia
#usermod -a -G vboxsf entermedia

# Fix File Limits
echo "fs.file-max = 10000000" >> /etc/sysctl.conf
echo "entermedia      soft    nofile  409600" >> /etc/security/limits.conf
echo "entermedia      hard    nofile  1024000" >> /etc/security/limits.conf
sysctl -p
#End Fix File Limits

mkdir /home/entermedia/.ffmpeg
cp .ffmpeg/libx264-normal.ffpreset /home/entermedia/.ffmpeg/libx264-normal.ffpreset

chown -R entermedia:entermedia /home/entermedia/.ffmpeg

cp tomcat /etc/init.d/
update-rc.d tomcat defaults
update-rc.d tomcat start 20 3 5

#Remove any old tomcat if it exists
rm -r /opt/entermedia/tomcat

mkdir -p /opt/entermedia/tomcat/logs
mkdir -p /opt/entermedia/webapp
cp -rp ../entermedia/* /opt/entermedia/
cp -p ../misc/delegates.xml /etc/ImageMagick/delegates.xml
cd /opt/entermedia/webapp
wget http://dev.entermediasoftware.com/jenkins/view/Demo/job/demoall/lastSuccessfulBuild/artifact/deploy/ROOT.war -O ROOT.war
unzip ROOT.war
rm ROOT.war

#Copy data directory out and link it
mkdir /media
mv /opt/entermedia/webapp/WEB-INF/data /media/
ln -s /media/data /opt/entermedia/webapp/WEB-INF/data

chown -R entermedia. /opt/entermedia
chown -R entermedia. /media

chmod -R u+s,g+s /opt/entermedia

#iptables -F
export ip=`ifconfig eth0 |grep "inet addr" |awk '{print $2}' |awk -F: '{print $2}'`
ifconfig eth0 |grep "inet addr" |awk '{print $2}' |awk -F: '{print $2}'
/sbin/iptables -t nat -A OUTPUT -d localhost -p tcp --dport 80 -j REDIRECT --to-ports 8080
/sbin/iptables -t nat -A OUTPUT -d $ip -p tcp --dport 80 -j REDIRECT --to-ports 8080
/sbin/iptables -t nat -A PREROUTING -d $ip -p tcp --dport 80 -j REDIRECT --to-ports 8080

/sbin/iptables -t nat -A OUTPUT -d localhost -p tcp --dport 22 -j REDIRECT --to-ports 22
/sbin/iptables -t nat -A OUTPUT -d $ip -p tcp --dport 22 -j REDIRECT --to-ports 22
/sbin/iptables -t nat -A PREROUTING -d $ip -p tcp --dport 22 -j REDIRECT --to-ports 22


iptables-save > /etc/iptables/rules.v4

