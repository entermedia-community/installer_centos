Summary:        Libav provides cross-platform tools and libraries to convert, manipulate and stream a wide range of multimedia formats and protocols.
Name:           libav
Version:        11.1
Release:        0
Epoch:			0
Group:          System Environment/Libraries
License:        LGPL/GPL
URL:            https://libav.org/
Source:         https://libav.org/releases/%{name}-%{version}.tar.gz
BuildRoot:      %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)
BuildRequires:	libogg-devel
BuildRequires:	libvorbis-devel
BuildRequires:	x264-devel
BuildRequires:	libvpx-devel
BuildRequires:	faac-devel
BuildRequires:	lame-devel
BuildRequires:	yasm

%description
Libav provides cross-platform tools and libraries to convert, manipulate and stream a wide range of multimedia formats and protocols.


%package devel
Summary:        Files needed for development using libavconv
Group:          Development/Libraries
Requires:       pkgconfig
Requires:       automake

%description devel
Libav provides cross-platform tools and libraries to convert, manipulate and stream a wide range of multimedia formats and protocols.


%prep
%setup -q


%build
./configure \
	--prefix="/usr" \
	--libdir=%{_libdir} \
	--enable-libx264 \
	--enable-libfaac \
	--enable-libmp3lame \
	--enable-gpl \
	--enable-nonfree \
	--enable-libvpx \
	--enable-libvorbis
make %{?_smp_mflags}

%install
rm -rf $RPM_BUILD_ROOT
make DESTDIR=$RPM_BUILD_ROOT install
rm -f $RPM_BUILD_ROOT%{_libdir}/*.la

%clean 
rm -rf $RPM_BUILD_ROOT

%post -p /sbin/ldconfig

%postun -p /sbin/ldconfig

%files
%defattr(-,root,root)
%doc README LICENSE CREDITS VERSION
%dir %{_datadir}/avconv
%{_bindir}/avconv
%{_bindir}/avprobe
%{_mandir}/man1/avconv.1.gz
%{_mandir}/man1/avprobe.1.gz
%{_datadir}/avconv/*.avpreset


%files devel
%defattr(-,root,root)
%dir %{_includedir}/libavutil
%dir %{_includedir}/libavresample
%dir %{_includedir}/libavfilter
%dir %{_includedir}/libavdevice
%dir %{_includedir}/libavcodec
%dir %{_includedir}/libavformat
%dir %{_includedir}/libswscale
%{_libdir}/libav*.a
%{_libdir}/libswscale.a
%{_libdir}/pkgconfig/libav*.pc
%{_libdir}/pkgconfig/libswscale.pc
%{_includedir}/libavutil/*.h
%{_includedir}/libavresample/*.h
%{_includedir}/libavfilter/*.h
%{_includedir}/libavdevice/*.h
%{_includedir}/libavcodec/*.h
%{_includedir}/libavformat/*.h
%{_includedir}/libswscale/*.h
