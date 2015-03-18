#
# Entermedia Spec file...
#

Summary:	Entermedia Software Digital Asset Management
Name: 		entermedia
Version: 	1.0
Release: 	0
License: 	GPL
URL:		https://github.com/entermedia-community
Vendor: 	EnterMedia Software, Inc.
BuildRoot: 	%{_tmppath}/%{name}-root
Requires: 	java-1.7.0-openjdk lcms2 lame faac ImageMagick libav perl-Image-ExifTool ghostscript
Source0: 	entermedia-%{version}.tar.gz
BuildArch: 	x86_64

%description
EnterMedia is an Open Source Media Database that empowers you to take control of managing every aspect of digital assets by providing developers with powerful API’s to build custom applications, and providing users with an intuitive front end that can be rearranged and personalized for specific needs. Our flexible and proven platform allows users to centralize, secure, and share content, manage workflow, and track details and changes throughout the system.

%prep
%setup

%build

%install
rm -rf ${RPM_BUILD_ROOT}
mkdir -p ${RPM_BUILD_ROOT}/usr/bin
install * ${RPM_BUILD_ROOT}%{_bindir}

%post
sh /usr/bin/Entermedia_Install_CentOS_64.sh

%clean
rm -rf ${RPM_BUILD_ROOT}

%files
%defattr(-,root,root)
%attr(755,root,root) %{_bindir}/Entermedia_Install_CentOS_64.sh
%{_bindir}/qt-faststart
%{_bindir}/tomcat
%{_bindir}/libx264-normal.ffpreset

%changelog
* Tue Feb 24 2015 Chris Rose <chris.rose@entermediasoftware.com> 1.0-0
- Initial Build