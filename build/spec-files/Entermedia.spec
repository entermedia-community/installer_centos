#
# Entermedia Spec file...
#

Summary:	Entermedia Software Digital Asset Management
Name: 		entermedia
Version: 	1.0
Release: 	1
License: 	GNU GPL
URL:		https://github.com/entermedia-community
Source: 	https://github.com/entermedia-community/installer_centos/archive/dev.zip
Vendor: 	EnterMedia Software, Inc.

%description
EnterMedia is an Open Source Media Database
that empowers you to take control of managing every aspect of digital assets by providing developers with powerful API’s to build custom applications, and providing users with an intuitive front end that can be rearranged and personalized for specific needs. Our flexible and proven platform allows users to centralize, secure, and share content, manage workflow, and track details and changes throughout the system.

%prep
unzip ${RPM_SOURCE_DIR}/dev.zip

%install
sh ${RPM_SOURCE_DIR}/dev/installer/install64.sh

%clean
rm -rf ${RPM_SOURCE_DIR}

%files
