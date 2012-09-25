##make sure you have a user useradd entermedia 

adduser entermedia

mkdir /home/entermedia/.ffmpeg
cp .ffmpeg/libx264-normal.ffpreset /home/entermedia/.ffmpeg/libx264-normal.ffpreset

chown -R entermedia:entermedia /home/entermedia/.ffmpeg

cp tomcat /etc/init.d/
chkconfig --add tomcat
chkconfig --level 3 tomcat on
chkconfig --level 5 tomcat on

mkdir -p /opt/entermedia/tomcat/logs

mkdir -p /opt/entermedia/webapp
cp -rp ../entermedia/* /opt/entermedia/
cd /opt/entermedia/webapp
wget http://dev.entermediasoftware.com/jenkins/view/Demo/job/demoall/lastSuccessfulBuild/artifact/deploy/ROOT.war -O ROOT.war
unzip ROOT.war 
rm ROOT.war

chown -R entermedia:entermedia /opt/entermedia

export ip=`ifconfig eth0 |grep "inet addr" |awk '{print $2}' |awk -F: '{print $2}'`
/sbin/iptables -t nat -A OUTPUT -d localhost -p tcp --dport 80 -j REDIRECT --to-ports 8080
/sbin/iptables -t nat -A OUTPUT -d $ip -p tcp --dport 80 -j REDIRECT --to-ports 8080
/sbin/iptables -t nat -A PREROUTING -d $ip -p tcp --dport 80 -j REDIRECT --to-ports 8080
iptables-save > /etc/sysconfig/iptables

