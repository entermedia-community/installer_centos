Summary:        WebM is an open, royalty-free, media file format designed for the web.
Name:           libvpx
Version:        1.3.0
Release:        0
Epoch:			0
Group:          System Environment/Libraries
License:        BSD
URL:            http://www.webmproject.org/
Source:         https://webm.googlecode.com/files/%{name}-v%{version}.tar.bz2
BuildRoot:      %{_tmppath}/%{name}-v%{version}-%{release}-root-%(%{__id_u} -n)
BuildRequires:	yasm
Obsoletes:		%{name}

%description
VP8 is a highly efficient video compression technology


%package devel
Summary:        Files needed for development using libvpx/webm
Group:          Development/Libraries
Requires:       pkgconfig
Requires:       automake
Obsoletes:		%{name}-devel

%description devel
WebM is an open media file format designed for the web. WebM files consist of
video streams compressed with the VP8 video codec and audio streams compressed
with the Vorbis audio codec


%prep
%setup -q -n %{name}-v%{version}


%build
./configure \
	--prefix="/usr" \
	--libdir=%{_libdir} \
	--enable-shared
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
%doc README CHANGELOG LICENSE PATENTS
%exclude %{_bindir}/vp8_scalable_patterns
%exclude %{_bindir}/vp9_spatial_scalable_encoder
%{_bindir}/vpxdec
%{_bindir}/vpxenc
%{_libdir}/libvpx.so.*

%files devel
%defattr(-,root,root)
%dir %{_includedir}/vpx
%{_includedir}/vpx/*.h
%{_libdir}/libvpx.a
%{_libdir}/libvpx.so
%{_libdir}/pkgconfig/vpx.pc

