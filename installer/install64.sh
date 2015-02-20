#!/bin/bash
#Must be run as root
WHOAMI=$(whoami)
if [[ "$WHOAMI" != "root" ]]; then
	echo "You must run this script as root!"
	exit
fi


mkdir downloads
cd downloads

yum install -y wget

wget http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm -O epel-release-6-7.noarch.rpm
rpm -Uvh epel-release-6*.rpm

wget http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.2-2.el6.rf.x86_64.rpm -O rpmforge-release-0.5.2-2.el6.rf.x86_64.rpm

wget http://apt.sw.be/RPM-GPG-KEY.dag.txt -O RPM-GPG-KEY.dag.txt
rpm --import RPM-GPG-KEY.dag.txt

rpm -ivh rpmforge-release-0.5.2-2.el6.rf.x86_64.rpm


yum -y update

cd ../rpms

yum install -y automake
yum install -y ufraw-* lcms2
rpm -Uhv libogg* libvorbis* x264* libvpx* openjpeg*
rpm -ihv --force --nodeps ImageMagick-*
rpm -Uhv libav*

yum install -y java-1.7.0-openjdk lame  perl-Image-ExifTool libreoffice-headless libreoffice-writer libreoffice-calc libreoffice-impress libreoffice-draw unzip git

yum -y install ilmbase OpenEXR-libs libtool-ltdl librsvg2 libwmf-lite libXt libgomp libtiff faac lame ghostscript

cd ../misc
cp -rp qt-faststart /usr/bin
ln -s /usr/bin/avprobe /usr/bin/ffprobe

sh ./install_entermedia.sh
# Removed the custom process because we are now installing them above as RPMs.
#sh ./install_avconv.sh

service tomcat start

echo "Install complete. see: http://localhost:8080/emshare"
