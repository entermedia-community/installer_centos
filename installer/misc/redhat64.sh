#red hat requires some extra stuff

wget http://download.documentfoundation.org/libreoffice/stable/4.0.2/rpm/x86_64/LibreOffice_4.0.2_Linux_x86-64_rpm.tar.gz

gunzip LibreOffice_4.0.2_Linux_x86-64_rpm.tar.gz
tar -xf LibreOffice_4.0.2_Linux_x86-64_rpm.tar
cd LibreOffice_4.0.2.2_Linux_x86-64_rpm/
yum install libpng-compat
yum localinstall RPMS/*.rpm

echo "Add    pathmunge /opt/libreoffice4.0/program after"
vi /etc/profile
# Path manipulation
#if [ "$EUID" = "0" ]; then
#    pathmunge /sbin
#    pathmunge /usr/sbin
#    pathmunge /usr/local/sbin
#else
#    pathmunge /usr/local/sbin after
#    pathmunge /usr/sbin after
#    pathmunge /sbin after
#    pathmunge /opt/libreoffice4.0/program after
#fi


