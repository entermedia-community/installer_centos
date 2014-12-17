#!/bin/bash
SPECTOOL="/usr/bin/spectool"
WGET="/usr/bin/wget"
AWK="/bin/awk"
RPMBUILD="/usr/bin/rpmbuild"
YUM="/usr/bin/yum"
WHOAMI=$(/usr/bin/whoami)
RPMFOLDER="$HOME/rpms/"
RPM="/bin/rpm"
GREEN='\e[0;32m' # '\e[1;32m' is too bright for white bg.
ENDCOLOR='\e[0m'

if [[ "$WHOAMI" != "root" ]]; then
  SUDO="/usr/bin/sudo"
else
  SUDO=""
fi

BASENAME=$(basename $0)
LOGFILE="/tmp/$BASENAME.log"
[ -f "$LOGFILE" ] && mv "$LOGFILE" $LOGFILE.$(date "+%m-%d-%Y-%H:%M:%S")

log() { tee -a "$LOGFILE" ; }

logsilent() { 
  echo -e "\n" >> $LOGFILE
  echo "Cmd Output: " >> $LOGFILE
  echo -e "$1" >> $LOGFILE
  echo -e "End Cmd Output.\n" >> $LOGFILE
}

checkStatus() {
  if [[ $? == 0 ]]; then
    echoGreen "done."
    logsilent "$OUTPUT"
  else
    echo $?
    echoRed "failed."
    logsilent "$OUTPUT"

    exit 1
  fi
}

echoWhite() {
    echo -en "\033[1m"
    if [ "$1" = "-n" ]; then
        echo -n "$2" | log
    else
        echo "$1" | log
    fi
    echo -en "\033[0m";
}

echoGreen() {
    echo -en "\033[0;32m"
    if [ "$1" = "-n" ]; then
        echo -n "$2" | log
    else
        echo "$1" | log
    fi
    echo -en "\033[0m";
}

echoRed() {
    echo -en "\033[1;31m"
    if [ "$1" = "-n" ]; then
        echo -n "$2" | log
    else
        echo "$1" | log
    fi
    echo -en "\033[0m";
}

find_os() {
  cloudlinux="no"
 if [ -f /etc/redhat-release ]; then
   os="centos"
   version=$(cat /etc/redhat-release | cut -d" " -f3 | cut -d "." -f1)
   if [ $(cat /etc/redhat-release | grep -iq cloudlinux) ] ; then
    cloudlinux="yes"
   fi
 elif [ -f /etc/debian_version ]; then
   if [ ! -f /usr/bin/lsb_release ] ; then
      RESULT=$(apt-get -y -q install lsb-release)
      
   fi
   codename=$(lsb_release -a 2>&1 | grep Codename | awk  '{print $2}')
   os="debian"
 else
   os="unknown"
 fi

 if [[ "$(uname -m)" =~ ^i ]]; then
   arch="i386"        
 elif [[ "$(uname -m)" =~ ^x ]] ; then
   arch="x86_64"
 fi

}