%define date 20141208
%define rev 2245
Summary:        The X264 software library and application
Name:           x264
Version:        0.0.0
Release:        0.4.%{date}
Epoch:			0
Group:          System Environment/Libraries
License:        GNU GPL
URL:            http://www.videolan.org/developers/x264.html
Source:         http://download.videolan.org/pub/videolan/x264/snapshots/%{name}-snapshot-%{date}-%{rev}-stable.tar.bz2
BuildRoot:      %{_tmppath}/%{name}-snapshot-%{version}-%{release}-stable-root-%(%{__id_u} -n)
BuildRequires:  yasm >= 1.2.0
Obsoletes:		%{name} <= %{version}
Provides:		%{name} = %{version}
Provides:		libx264

%description
x264 is a free software library and application for encoding video streams into the
H.264/MPEG-4 AVC compression format.


%package devel
Summary:        Files needed for development using x264
Group:          Development/Libraries
Requires:       libogg >= 1.3.1
Requires:       pkgconfig
Requires:       automake
Obsoletes:		%{name}-devel

%description devel
x264 is a free software library and application for encoding video streams
into the H.264/MPEG-4 AVC compression format. The x264-devel package contains
the header files and documentation needed for development using x264.


%prep
%setup -q -n %{name}-snapshot-%{date}-%{rev}-stable


%build
%configure \
	--enable-shared \
	--prefix=%{_prefix} \
	--bindir="%{_bindir}" \
    --includedir="%{_includedir}" \
	--libdir=%{_libdir} \
	--enable-pic \
    --enable-pthread \
    --enable-shared
make %{?_smp_mflags}


%install
rm -rf $RPM_BUILD_ROOT
make DESTDIR=$RPM_BUILD_ROOT install
rm -f $RPM_BUILD_ROOT%{_libdir}/*.la
ln -f -s libx264.so $RPM_BUILD_ROOT%{_libdir}/libx264.so.107


%clean 
rm -rf $RPM_BUILD_ROOT

%post -p /sbin/ldconfig

%postun -p /sbin/ldconfig


%files
%defattr(-,root,root)
%doc AUTHORS COPYING
%{_bindir}/x264
%{_libdir}/libx264.so
%{_libdir}/libx264.so.142
%{_libdir}/libx264.so.107

%files devel
%defattr(-,root,root)
%{_includedir}/x264.h
%{_includedir}/x264_config.h
%{_libdir}/pkgconfig/x264.pc
