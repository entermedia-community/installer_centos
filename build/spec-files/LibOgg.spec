Summary:        The Ogg bitstream file format library
Name:           libogg
Version:        1.3.1
Release:        0
Epoch:			4
Group:          System Environment/Libraries
License:        BSD
URL:            http://www.xiph.org/
Source:         http://downloads.xiph.org/releases/ogg/%{name}-%{version}.tar.gz
BuildRoot:      %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)
Obsoletes:		%{name}

%description
Libogg is a library for manipulating Ogg bitstream file formats.
Libogg supports both making Ogg bitstreams and getting packets from
Ogg bitstreams.


%package devel
Summary:        Files needed for development using libogg
Group:          Development/Libraries
Requires:       libogg = %{epoch}:%{version}-%{release}
Requires:       pkgconfig
Requires:       automake
Obsoletes:		%{name}-devel

%description devel
Libogg is a library used for manipulating Ogg bitstreams. The
libogg-devel package contains the header files and documentation
needed for development using libogg.


%prep
%setup -q


%build
sed -i "s/-O20/$RPM_OPT_FLAGS/" configure
sed -i "s/-ffast-math//" configure
%configure \
	--disable-static \
	--prefix=/usr \
	--libdir=%{_libdir}
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
%doc AUTHORS CHANGES COPYING README
%{_libdir}/libogg.so.*

%files devel
%defattr(-,root,root)
%dir %{_includedir}/ogg
%{_includedir}/ogg/ogg.h
%{_includedir}/ogg/os_types.h
%{_includedir}/ogg/config_types.h
%{_libdir}/libogg.so
%{_libdir}/pkgconfig/ogg.pc
%{_datadir}/aclocal/ogg.m4
%exclude /usr/share/doc/libogg/*
