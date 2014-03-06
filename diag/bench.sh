#install tools and run as root
#yum install hdparm bc

wget http://demo.entermediasoftware.com/node2/artbeats_red_m480pBIG.mp4 -nc

cputime="$( TIMEFORMAT='%lU';time ( echo '2^2^20' | bc ) 2>&1 1>/dev/null )"

videotime="$( TIMEFORMAT='%lU';time ( avconv -i artbeats_red_m480pBIG.mp4 -y -acodec libfaac -ab 96k -ar 44100 -ac 1 -vcodec libx264 -crf 28 -threads 2 -s 540x360 video.mp4tmp.mp4 2>&1 1>/dev/null ) 2>&1 1>/dev/null )"

hdtime="$( /sbin/hdparm -Tt /dev/sda )"

echo "HD: $hdtime (higher is better)"
echo "CPU: $cputime (lower is better)"
echo "Video: $videotime (lower is better)"



