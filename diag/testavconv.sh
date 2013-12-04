#!/bin/bash
VER="2.0";
assert()
{
FILE=$1
if [ -f $FILE ];
then
        echo "File $FILE exists."
		mv $FILE results/
else
        echo "File $FILE does NOT exists."
	#exit 0;
fi

}
if [ "$1" = "-v" ];
then
echo $VER;
exit 0;
fi

mkdir results
convert baby.jpg  results/01bout.jpg

convert IMG_0192.CR2  results/02out.jpg

convert cc.tif results/03tifout.jpg

avconv -i cb1sampleiTunes4.mov -y -acodec libfaac -ab 96k -ar 44100 -ac 1 -vcodec libx264 -preset medium -crf 28 -threads 2 -s 704x480 results/04outtmp.mp4

ffprobe cb1sampleiTunes4.mov > results/10probe.txt

qt-faststart results/04outtmp.mp4 results/05qtout.mp4

avconv -ss 2 -i cb1sampleiTunes4.mov  -y -vframes 1 -f mjpeg results/06ffmpegout.jpg

convert -density 200 agenda.pdf[0]  -colorspace rgb -strip results/07pdfout.jpg

soffice --headless --nologo --norestore --convert-to pdf:writer_pdf_Export Office.doc 
mv Office.pdf results/08office.pdf

exiftool -canon IMG_0192.CR2 -w txt
mv IMG_0192.txt results/09IMG_0192.txt
