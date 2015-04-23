iptables -F
iptables -X
iptables -t nat -F
iptables -t nat -X
iptables -t mangle -F
iptables -t mangle -X
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT
export ip=`ifconfig eth0 |grep "inet addr" |awk '{print $2}' |awk -F: '{print $2}'`
/sbin/iptables -t nat -A OUTPUT -d localhost -p tcp --dport 80 -j REDIRECT --to-ports 8080
/sbin/iptables -t nat -A OUTPUT -d $ip -p tcp --dport 80 -j REDIRECT --to-ports 8080
/sbin/iptables -t nat -A PREROUTING -d $ip -p tcp --dport 80 -j REDIRECT --to-ports 8080

/sbin/iptables -t nat -A OUTPUT -d localhost -p tcp --dport 443 -j REDIRECT --to-ports 8443
/sbin/iptables -t nat -A OUTPUT -d $ip -p tcp --dport 443 -j REDIRECT --to-ports 8443
/sbin/iptables -t nat -A PREROUTING -d $ip -p tcp --dport 443 -j REDIRECT --to-ports 8443

/sbin/iptables -t nat -A OUTPUT -d localhost -p tcp --dport 22 -j REDIRECT --to-ports 22
/sbin/iptables -t nat -A OUTPUT -d $ip -p tcp --dport 22 -j REDIRECT --to-ports 22
/sbin/iptables -t nat -A PREROUTING -d $ip -p tcp --dport 22 -j REDIRECT --to-ports 22

/sbin/iptables -A INPUT -j DROP


iptables-save > /etc/sysconfig/iptables

