cd ./libopenjp2

# Copy .pc and .so files
cp ./usr/lib64/pkgconfig/libopenjp2.pc /usr/lib64/pkgconfig/
cp ./usr/lib/libopenjp2* /usr/lib/

# Copy Header Files
if [ ! -d "/usr/include/openjpeg-2.1" ]; then
  mkdir /usr/include/openjpeg-2.1
fi

cp ./usr/include/openjpeg-2.1/* /usr/include/openjpeg-2.1/