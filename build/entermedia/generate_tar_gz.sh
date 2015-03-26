mkdir entermedia-1.0
cp Entermedia_Install_CentOS_64.sh entermedia-1.0/
cp ../../installer/misc/.ffmpeg/libx264-normal.ffpreset entermedia-1.0/
cp ../../installer/misc/tomcat entermedia-1.0/
cp ../../installer/misc/qt-faststart entermedia-1.0/
tar -pczf entermedia-1.0.tar.gz ./entermedia-1.0
rm -rf entermedia-1.0
