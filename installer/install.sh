#Must be run as root

mkdir downloads
cd downloads
wget http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-7.noarch.rpm
rpm -Uvh epel-release-6*.rpm

## wget ftp://fr2.rpmfind.net/linux/dag/redhat/el6/en/x86_64/dag/RPMS/a52dec-0.7.4-8.el6.rf.x86_64.rpm
## wget http://pkgs.repoforge.org/faac/faac-1.26-1.el6.rf.x86_64.rpm
## wget http://pkgs.repoforge.org/faad2/faad2-2.7-1.el6.rf.x86_64.rpm
## wget http://dl.atrpms.net/el6-x86_64/atrpms/stable/ffmpeg-0.10.2-54.el6.x86_64.rpm
## No work. wget http://pkgs.org/centos-6-rhel-6/rpmfusion-free-updates-testing-x86_64/gpac-doc-0.5.0-1.el6.x86_64.rpm

wget http://download1.rpmfusion.org/free/el/updates/6/i386/rpmfusion-free-release-6-1.noarch.rpm
wget http://download1.rpmfusion.org/nonfree/el/updates/6/i386/rpmfusion-nonfree-release-6-1.noarch.rpm
rpm -i --nosignature rpmfusion-free-release-6-1.noarch.rpm
rpm -i --nosignature rpmfusion-nonfree-release-6-1.noarch.rpm
-- INSERT --

wget http://rpms.famillecollet.com/enterprise/remi-release-6.rpm
rpm -Uvh remi-release-6*.rpm epel-release-6*.rpm

## wget ftp://fr2.rpmfind.net/linux/dag/redhat/el6/en/x86_64/dag/RPMS/a52dec-0.7.4-8.el6.rf.x86_64.rpm
## wget http://pkgs.repoforge.org/faac/faac-1.26-1.el6.rf.x86_64.rpm
## wget http://pkgs.repoforge.org/faad2/faad2-2.7-1.el6.rf.x86_64.rpm
## wget http://dl.atrpms.net/el6-x86_64/atrpms/stable/ffmpeg-0.10.2-54.el6.x86_64.rpm
## No work. wget http://pkgs.org/centos-6-rhel-6/rpmfusion-free-updates-testing-x86_64/gpac-doc-0.5.0-1.el6.x86_64.rpm

wget http://download1.rpmfusion.org/free/el/updates/6/i386/rpmfusion-free-release-6-1.noarch.rpm
wget http://download1.rpmfusion.org/nonfree/el/updates/6/i386/rpmfusion-nonfree-release-6-1.noarch.rpm
rpm -i --nosignature rpmfusion-free-release-6-1.noarch.rpm 
rpm -i --nosignature rpmfusion-nonfree-release-6-1.noarch.rpm 

yum update

## wget http://pkgs.repoforge.org/gtkimageview/gtkimageview-1.6.3-1.el6.rf.x86_64.rpm
#rpm -i --nosignature gtkimageview-1.6.3-1.el6.rf.x86_64.rpm

yum install java-1.6.0-openjdk gpac gtkimageview lame x264  perl-Image-ExifTool libreoffice-headless
#exiftool, open office, newer version of image magick
#yum install gpac
#yum install gtkimageview
#yum install ImageMagick
#yum install lame
#yum install libmad
#yum install librtmp
#yum install opencore-amr
#yum install x264
#yum install xvidcore
#yum install ffmpeg

sh ./misc/install_entermedia.sh
