#!/bin/bash
################################################################################
#
# !!!!! IMPORTANT !!!!!
#
# Before we run this script, we must make sure apt sources list has access
# to libfaac. All of the following commands must be run with ROOT permissions.
# Edit the sources list directly:
#
# vi /etc/apt/sources.list and add the following line:
#
# deb http://www.deb-multimedia.org/ wheezy main non-free
#
# Save the sources list and update apt:
#
# apt-get update
#
# This command will issue a pubkey error print the offending key
# Copy the key and issue the following commands AS ROOT, substituting your key
#
# gpg --keyserver pgpkeys.mit.edu --recv-key ${YOUR_KEY}
# gpg --armor --export ${YOUR_KEY} | apt-key add -
#
# Then run the 'apt-get update' command again and then run this script again
#
###############################################################################

#Must be run as root
WHOAMI=$(whoami)
if [[ "$WHOAMI" != "root" ]]; then
        echo "You must run this script as root!"
        exit
fi

INSTALLER= `cd -P "$(dirname "$0")" && pwd`

apt-get install --no-install-recommends --force-yes automake libogg0 libogg-dev libvorbis0a libvorbisenc2 x264 liblcms2-2 libopenjpeg2 libav-tools openjdk-7-jre lame libimage-exiftool-perl libreoffice unzip git libilmbase6 libopenexr6 libltdl-dev librsvg2-2 libwmf-bin libxt6 libgomp1 libtiff5-dev libtiff5 libfaac-dev lame imagemagick ghostscript iptables-persistent

# soffice may need configuration to use --headless
# src: http://askubuntu.com/questions/194352/install-openoffice-for-headless-use

cp -rp ./misc/qt-faststart /usr/bin

# No longer necessary to link these? apt install seems to have created both
# ln -s /usr/bin/avprobe /usr/bin/ffprobe

./misc/install_entermedia_deb.sh

su - entermedia -c 'service tomcat start'

echo "Install complete. see: http://localhost:8080/emshare"
