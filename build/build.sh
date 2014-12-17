#!/bin/bash
CWD=$(pwd)

source ${CWD}/functions.sh

if [ ! -f "/usr/bin/figlet" ]; then 
	OUTPUT=$($SUDO $YUM -y install figlet)
fi

echo -e "${GREEN}$(figlet entermedia)${ENDCOLOR}"

ALL=true
if [ "$#" -eq 1 ]; then
	ALL=false
	SPEC=$1
	if [[ ! -f "./spec-files/$1" && ! -f "$1" ]]; then
		echoWhite "Provided spec file not found."
		exit
	fi
fi

if [[ "$ALL" == true ]]; then
	echoWhite "No spec file provided, assuming 'all'."
fi

echo 

if [ ! -f "$HOME/.rpmmacros" ]; then
	echoWhite -n "rpmmacros not found, creating... "
	echo "%_topdir %(echo \$HOME)/rpmbuild" > $HOME/.rpmmacros
	echo "%debug_package %{nil}" >> $HOME/.rpmmacros
	checkStatus

	if [ ! -d "$HOME/rpmbuild" ]; then
		echoWhite -n "rpmbuild directory not found, creating... "
		mkdir -p $HOME/rpmbuild/{BUILD,BUILDROOT,RPMS,SOURCES,SPECS,SRPMS}
		checkStatus
	fi
fi

if [ ! -d $RPMFOLDER ]; then
	echoWhite -n "Finished RPM folder ($RPMFOLDER) not found, creating... "
	mkdir -p $RPMFOLDER
	checkStatus
else
	echoWhite "Finished RPMs are stored in $RPMFOLDER"
fi


echoWhite -n "Installing basic requirements for the build... "
OUTPUT=$($SUDO $YUM -y install rpmdevtools yasm wget cmake faac-devel lame-devel 2>&1)
checkStatus
echoWhite -n "Copying patch files to SOURCES folder... "
OUTPUT=$(/bin/cp $CWD/patches/*.patch $HOME/rpmbuild/SOURCES/)
checkStatus

if [[ "$ALL" == true ]]; then 
	echoWhite "Building required libraries first..."
	for spec in `ls $CWD/spec-files/*.spec`; do
		if [[ "$spec" != *"LibAvconv.spec" && "$spec" != *"ImageMagick.spec" ]]; then
			LIB=${spec/$CWD\/spec-files\//}
			LIB=${LIB/\.spec/}
			echoWhite "     Starting build of $LIB..."
			SOURCE=$($SPECTOOL -S $spec | $AWK '{print $2}')
			SOURCEOUT=$(basename $SOURCE)
			if [ ! -f $HOME/rpmbuild/SOURCES/$SOURCEOUT ]; then
				echoWhite -n "          Fetching $SOURCE... "
				OUTPUT=$($WGET $SOURCE -O $HOME/rpmbuild/SOURCES/$SOURCEOUT 2>&1)
				checkStatus
			fi
			echoWhite -n "          Building the RPM... "
			OUTPUT=$($RPMBUILD -bb $spec 2>&1)
			checkStatus
			for rpm in `find $HOME/rpmbuild/RPMS -type f -name "*.rpm"`; do
				/bin/mv $rpm $RPMFOLDER
			done
			if [[ "$LIB" == "LibOgg" ]]; then
				# Because we need libogg for libvorbis, we will install the RPMs for that now
				OUTPUT=$($SUDO $RPM -Uhv --replacefiles $RPMFOLDER/libogg*.rpm 2>&1)
			fi
		fi
	done
	echoWhite -n "Installing required libraries... "
	OUTPUT=$($SUDO $RPM -Uhv --replacefiles $RPMFOLDER/libogg*.rpm 2>&1)
	logsilent "$OUTPUT"
	OUTPUT=$($SUDO $RPM -Uhv --replacefiles $RPMFOLDER/libvorbis*.rpm 2>&1)
	logsilent "$OUTPUT"
	OUTPUT=$($SUDO $RPM -Uhv --replacefiles $RPMFOLDER/libvpx*.rpm 2>&1)
	logsilent "$OUTPUT"
	OUTPUT=$($SUDO $RPM -Uhv --replacefiles $RPMFOLDER/openjpeg*.rpm 2>&1)
	logsilent "$OUTPUT"
	OUTPUT=$($SUDO $RPM -Uhv --replacefiles $RPMFOLDER/x264*.rpm 2>&1)
	logsilent "$OUTPUT"
	# The RPM installer will throw a 1 if they are already installed, so exit codes of RPM are not a trustworthy
	# indication of if something failed or not. Here we just blindly accept that it worked and move on with our
	# lives.
	echoGreen "done."
	for spec in $CWD/spec-files/ImageMagick.spec $CWD/spec-files/LibAvconv.spec; do
		LIB=${spec/$CWD\/spec-files\//}
		LIB=${LIB/\.spec/}
		echoWhite "Starting build of $LIB..."
		SOURCE=$($SPECTOOL -S $spec | $AWK '{print $2}')
		SOURCEOUT=$(basename $SOURCE)
		if [ ! -f $HOME/rpmbuild/SOURCES/$SOURCEOUT ]; then
			echoWhite -n "     Fetching $SOURCE... "
			OUTPUT=$($WGET $SOURCE -O $HOME/rpmbuild/SOURCES/$SOURCEOUT 2>&1)
			checkStatus
		fi
		echoWhite -n "     Building the RPM... "
		OUTPUT=$($RPMBUILD -bb $spec 2>&1)
		checkStatus
		for rpm in `find $HOME/rpmbuild/RPMS -type f -name "*.rpm"`; do
			/bin/mv $rpm $RPMFOLDER
		done
	done			

else
	LIB=${SPEC/\.spec/}
	echoWhite "Building $LIB..."
fi