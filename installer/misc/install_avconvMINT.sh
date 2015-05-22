#Remove old programs and create a workspace avconv
apt-get remove ffmpeg x264 libx264-dev
cd /tmp
mkdir avconvupgrade
cd avconvupgrade

apt-get install gcc yasm make libvorbis-dev libfaac-dev libmp3lame0 build-essential libmp3lame-dev

#Orbis Support
curl -O http://downloads.xiph.org/releases/ogg/libogg-1.3.1.tar.gz
tar xzvf libogg-1.3.1.tar.gz
cd libogg-1.3.1
./configure --prefix="/usr" --disable-shared
make
make install
make distclean
cd ..

#Vorbis audio encoder
curl -O http://downloads.xiph.org/releases/vorbis/libvorbis-1.3.3.tar.gz
tar xzvf libvorbis-1.3.3.tar.gz
cd libvorbis-1.3.3
./configure --prefix="/usr" --with-ogg="/usr" --disable-shared
make
make install
cd ..

#Upgrade x264
wget ftp://ftp.videolan.org/pub/x264/snapshots/last_x264.tar.bz2
tar jxvf last_x264.tar.bz2
cd x264-snapshot-*
./configure --enable-shared --prefix=/usr
make
sudo make install
x264 --version
ldconfig
cd ..

#Install libvpx (for WebM)
git clone http://git.chromium.org/webm/libvpx.git
cd libvpx*
./configure
make
sudo make install
vpxenc
cd ..

#Install avconv
curl "http://git.libav.org/?p=libav.git;a=snapshot;h=HEAD;sf=tgz" | tar zxv
cd libav-HEAD-*
./configure --prefix=/usr --enable-libx264 --enable-libfaac --enable-libmp3lame --enable-gpl --enable-nonfree --enable-libvpx --enable-libvorbis

make
make install
avconv

#Remove workspace
#rm -Rf /tmp/avconvupgrade
cd ..
cp -rp qt-faststart /usr/bin
ln -s /usr/bin/avprobe /usr/bin/ffprobe

