Summary:        Open-source C-Library for JPEG 2000
Name:           openjpeg
Version:        2.1.0
Release:        0
Epoch:			0
Group:          System Environment/Libraries
License:        BSD
URL:            https://code.google.com/p/openjpeg/
Source:         http://softlayer-dal.dl.sourceforge.net/project/openjpeg.mirror/%{version}/%{name}-%{version}.tar.gz
BuildRoot:      %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)
BuildRequires:	cmake
Obsoletes:		%{name}

%description
The OpenJPEG library is an open-source JPEG 2000 library developed in order to promote the use of JPEG 2000.


%package devel
Summary:        Files needed for development using openjpeg
Group:          Development/Libraries
Requires:       %{name} = %{epoch}:%{version}-%{release}
Requires:       pkgconfig
Requires:       automake
Obsoletes:		%{name}-devel

%description devel
This package contains files necessary to build against the openjpeg library


%prep
%setup -q


%build
%ifarch x86_64
    %global libdir lib64
%else
	%global libdir lib
%endif
cmake -DCMAKE_INSTALL_PREFIX=%{_prefix} -DOPENJPEG_INSTALL_LIB_DIR=%{libdir}
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
%doc AUTHORS CHANGES LICENSE README
%{_bindir}/opj_*
%{_libdir}/libopenjp2.so*


%files devel
%defattr(-,root,root)
%dir %{_libdir}/openjpeg-2.1
%dir %{_includedir}/openjpeg-2.1
%{_includedir}/openjpeg-2.1/*.h
%{_libdir}/openjpeg-2.1/*
%{_libdir}/pkgconfig/libopenjp2.pc