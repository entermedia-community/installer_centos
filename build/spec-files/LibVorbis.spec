Summary:		The Vorbis General Audio Compression Codec.
Name:			libvorbis
Version:		1.3.3
Release: 		0
Epoch:			4
Group:			System Environment/Libraries
License:		BSD
URL:			http://www.xiph.org/
Source:			http://downloads.xiph.org/releases/vorbis/%{name}-%{version}.tar.gz
BuildRoot:      %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)
BuildRequires: 	libogg-devel >= 0:1.3.1
Requires:		libogg >= 0:1.3.1
Obsoletes:		%{name}

%description
Ogg Vorbis is a fully open, non-proprietary, patent- and royalty-free,
general-purpose compressed audio format for audio and music at fixed
and variable bitrates from 16 to 128 kbps/channel.

The libvorbis package contains runtime libraries for use in programs
that support Ogg Vorbis.

%package devel
Summary: Development tools for Vorbis applications.
Group: Development/Libraries
Requires:	libogg-devel >= 0:1.3.1
Requires:	%{name} = %{epoch}:%{version}-%{release}
Obsoletes:	vorbis-devel
Obsoletes:	%{name}-devel

%description devel
The libvorbis-devel package contains the header files and documentation
needed to develop applications with Ogg Vorbis.

%prep

%setup -q
sed -i "s/-O20/$RPM_OPT_FLAGS/" configure
sed -i "s/-ffast-math//" configure

%build
%configure \
	--with-ogg-libraries=%{_libdir} \
	--prefix=/usr \
	--libdir=%{_libdir} \
	--disable-static
make

%install
rm -rf $RPM_BUILD_ROOT
make DESTDIR=$RPM_BUILD_ROOT install
install -t $RPM_BUILD_ROOT%{_docdir}/%{name}-%{version} AUTHORS COPYING README

# remove unpackaged files from the buildroot
rm -f $RPM_BUILD_ROOT%{_libdir}/*.la

%files
%defattr(-,root,root)
%{_libdir}/libvorbis.so.*
%{_libdir}/libvorbisfile.so.*
%{_libdir}/libvorbisenc.so.*


%files devel
%defattr(-,root,root)
%{_includedir}/vorbis
%{_libdir}/libvorbis*
%{_libdir}/pkgconfig/*.pc
%{_datadir}/aclocal/vorbis.m4
%exclude /usr/share/doc/libvorbis-%{version}/*

%clean 
rm -rf $RPM_BUILD_ROOT

%post -p /sbin/ldconfig

%postun -p /sbin/ldconfig

