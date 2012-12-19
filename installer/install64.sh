#Must be run as root

mkdir downloads
cd downloads

yum install -y wget

wget http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-7.noarch.rpm -O epel-release-6-7.noarch.rpm
rpm -Uvh epel-release-6*.rpm

wget http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.2-2.el6.rf.x86_64.rpm -O rpmforge-release-0.5.2-2.el6.rf.x86_64.rpm

wget http://apt.sw.be/RPM-GPG-KEY.dag.txt -O RPM-GPG-KEY.dag.txt
rpm --import RPM-GPG-KEY.dag.txt

rpm -ivh rpmforge-release-0.5.2-2.el6.rf.x86_64.rpm


yum update

yum install -y java-1.6.0-openjdk lame  perl-Image-ExifTool libreoffice-headless libreoffice-writer libreoffice-calc libreoffice-impress libreoffice-draw x264 ffmpeg unzip git

cd ../rpms
yum install -y ImageMagick-6.7.6.8-9.el6.x86_64.rpm ufraw-*

cd ../misc
cp -rp qt-faststart /usr/bin
sh ./install_entermedia.sh

service tomcat start

echo "Install complete. see: http://localhost:8080/emshare"
