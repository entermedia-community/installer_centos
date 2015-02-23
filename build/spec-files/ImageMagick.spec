%define VER 6.9.0
%define Patchlevel 7

Name:           ImageMagick
Version:        %{VER}.%{Patchlevel}
Release:        7%{?dist}
Summary:        An X application for displaying and manipulating images
Group:          Applications/Multimedia
License:        ImageMagick
Url:            http://www.imagemagick.org/
Source0:	http://www.imagemagick.org/download/%{name}-%{VER}-%{Patchlevel}.tar.bz2
Patch1:         useciecolor-delegates.patch

BuildRoot:      %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)
BuildRequires:  bzip2-devel, freetype-devel, libjpeg-devel, libpng-devel
BuildRequires:  libtiff-devel, giflib-devel, zlib-devel, perl-devel
BuildRequires:  ghostscript-devel
BuildRequires:  libwmf-devel, jasper-devel, libtool-ltdl-devel
BuildRequires:  libX11-devel, libXext-devel, libXt-devel
BuildRequires:  lcms-devel, libxml2-devel, librsvg2-devel
BuildRequires:  OpenEXR-devel

%description
ImageMagick is an image display and manipulation tool for the X
Window System. ImageMagick can read and write JPEG, TIFF, PNM, GIF,
and Photo CD image formats. It can resize, rotate, sharpen, color
reduce, or add special effects to an image, and when finished you can
either save the completed work in the original format or a different
one. ImageMagick also includes command line programs for creating
animated or transparent .gifs, creating composite images, creating
thumbnail images, and more.

ImageMagick is one of your choices if you need a program to manipulate
and display images. If you want to develop your own applications
which use ImageMagick code or APIs, you need to install
ImageMagick-devel as well.


%package devel
Summary: Library links and header files for ImageMagick app development
Group: Development/Libraries
Requires: %{name} = %{version}-%{release}
Requires: libX11-devel, libXext-devel, libXt-devel
Requires: ghostscript-devel
Requires: bzip2-devel
Requires: freetype-devel
Requires: libtiff-devel
Requires: libjpeg-devel
Requires: lcms-devel
Requires: jasper-devel
Requires: pkgconfig

%description devel
ImageMagick-devel contains the library links and header files you'll
need to develop ImageMagick applications. ImageMagick is an image
manipulation program.

If you want to create applications that will use ImageMagick code or
APIs, you need to install ImageMagick-devel as well as ImageMagick.
You do not need to install it if you just want to use ImageMagick,
however.


%package doc
Summary: ImageMagick html documentation
Group: Documentation

%description doc
ImageMagick documentation, this package contains usage (for the
commandline tools) and API (for the libraries) documentation in html format.
Note this documentation can also be found on the ImageMagick website:
http://www.imagemagick.org/


%package perl
Summary: ImageMagick perl bindings
Group: System Environment/Libraries
Requires: %{name} = %{version}-%{release}
Requires: perl(:MODULE_COMPAT_%(eval "`%{__perl} -V:version`"; echo $version))

%description perl
Perl bindings to ImageMagick.

Install ImageMagick-perl if you want to use any perl scripts that use
ImageMagick.


%package c++
Summary: ImageMagick Magick++ library (C++ bindings)
Group: System Environment/Libraries
Requires: %{name} = %{version}-%{release}

%description c++
This package contains the Magick++ library, a C++ binding to the ImageMagick
graphics manipulation library.

Install ImageMagick-c++ if you want to use any applications that use Magick++.


%package c++-devel
Summary: C++ bindings for the ImageMagick library
Group: Development/Libraries
Requires: %{name}-c++ = %{version}-%{release}
Requires: %{name}-devel = %{version}-%{release}

%description c++-devel
ImageMagick-devel contains the static libraries and header files you'll
need to develop ImageMagick applications using the Magick++ C++ bindings.
ImageMagick is an image manipulation program.

If you want to create applications that will use Magick++ code
or APIs, you'll need to install ImageMagick-c++-devel, ImageMagick-devel and
ImageMagick.
You don't need to install it if you just want to use ImageMagick, or if you
want to develop/compile applications using the ImageMagick C interface,
however.


%prep
%setup -q -n %{name}-%{VER}-%{Patchlevel}
%patch1 -p1 

sed -i 's/libltdl.la/libltdl.so/g' configure
iconv -f ISO-8859-1 -t UTF-8 README.txt > README.txt.tmp
touch -r README.txt README.txt.tmp
mv README.txt.tmp README.txt
# for %doc
mkdir Magick++/examples
cp -p Magick++/demo/*.cpp Magick++/demo/*.miff Magick++/examples


%build
%configure --enable-shared \
           --disable-static \
           --with-modules \
           --with-perl \
           --with-x \
           --with-threads \
           --with-magick_plus_plus \
           --with-wmf \
           --with-lcms2 \
           --with-rsvg \
           --with-xml \
	         --with-bzlib \
      	   --with-fontconfig \
      	   --with-freetype \
           --with-gslib \
      	   --with-gvc \
      	   --with-jpeg \
      	   --with-openjp2 \
      	   --with-jp2 \
      	   --with-png \
      	   --with-tiff \
      	   --without-webp \
      	   --without-fftw \
           --with-perl-options="INSTALLDIRS=vendor %{?perl_prefix} CC='%__cc -L$PWD/magick/.libs' LDDLFLAGS='-shared -L$PWD/magick/.libs'" \
           --without-dps 
# Disable rpath
sed -i 's|^hardcode_libdir_flag_spec=.*|hardcode_libdir_flag_spec=""|g' libtool
sed -i 's|^runpath_var=LD_RUN_PATH|runpath_var=DIE_RPATH_DIE|g' libtool
# Do *NOT* use %%{?_smp_mflags}, this causes PerlMagick to be silently misbuild
make


%install
rm -rf $RPM_BUILD_ROOT

make install DESTDIR=$RPM_BUILD_ROOT INSTALL="install -p"
cp -a www/source $RPM_BUILD_ROOT%{_datadir}/doc/%{name}-%{VER}
rm $RPM_BUILD_ROOT%{_libdir}/*.la

# fix weird perl Magick.so permissions
chmod 755 $RPM_BUILD_ROOT%{perl_vendorarch}/auto/Image/Magick/Magick.so

# perlmagick: fix perl path of demo files
%{__perl} -MExtUtils::MakeMaker -e 'MY->fixin(@ARGV)' PerlMagick/demo/*.pl

# perlmagick: cleanup various perl tempfiles from the build which get installed
find $RPM_BUILD_ROOT -name "*.bs" |xargs rm -f
find $RPM_BUILD_ROOT -name ".packlist" |xargs rm -f
find $RPM_BUILD_ROOT -name "perllocal.pod" |xargs rm -f

# perlmagick: build files list
echo "%defattr(-,root,root,-)" > perl-pkg-files
find $RPM_BUILD_ROOT/%{_libdir}/perl* -type f -print \
        | sed "s@^$RPM_BUILD_ROOT@@g" > perl-pkg-files 
find $RPM_BUILD_ROOT%{perl_vendorarch} -type d -print \
        | sed "s@^$RPM_BUILD_ROOT@%dir @g" \
        | grep -v '^%dir %{perl_vendorarch}$' \
        | grep -v '/auto$' >> perl-pkg-files 
if [ -z perl-pkg-files ] ; then
    echo "ERROR: EMPTY FILE LIST"
    exit -1
fi

# fix multilib issues
%ifarch x86_64 s390x ia64 ppc64 alpha sparc64
%define wordsize 64
%else
%define wordsize 32
%endif

%clean
rm -rf $RPM_BUILD_ROOT


%post -p /sbin/ldconfig

%post c++ -p /sbin/ldconfig

%postun -p /sbin/ldconfig

%postun c++ -p /sbin/ldconfig


%files
%defattr(-,root,root,-)
%doc QuickStart.txt Platforms.txt
%doc README.txt LICENSE NOTICE AUTHORS.txt NEWS.txt
%{_bindir}/[a-z]*
%{_mandir}/man[145]/[a-z]*
%{_mandir}/man1/%{name}.*
%{_libdir}/libMagickCore-6.Q16.so*
%{_libdir}/libMagickWand-6.Q16.so*
%{_libdir}/%{name}-%{VER}
%{_datadir}/%{name}-6
%{_sysconfdir}/%{name}-6

%files devel
%defattr(-,root,root,-)
%{_bindir}/MagickCore-config
%{_bindir}/Magick-config
%{_bindir}/MagickWand-config
%{_bindir}/Wand-config
%{_libdir}/libMagickCore-6.Q16.so
%{_libdir}/libMagickWand-6.Q16.so
%{_libdir}/pkgconfig/MagickCore.pc
%{_libdir}/pkgconfig/MagickCore-6.Q16.pc
%{_libdir}/pkgconfig/ImageMagick.pc
%{_libdir}/pkgconfig/ImageMagick-6.Q16.pc
%{_libdir}/pkgconfig/MagickWand.pc
%{_libdir}/pkgconfig/MagickWand-6.Q16.pc
%{_libdir}/pkgconfig/Wand.pc
%{_libdir}/pkgconfig/Wand-6.Q16.pc
%dir %{_includedir}/%{name}-6
%{_includedir}/%{name}-6/magick
%{_includedir}/%{name}-6/wand
%{_mandir}/man1/Magick-config.*
%{_mandir}/man1/MagickCore-config.*
%{_mandir}/man1/Wand-config.*
%{_mandir}/man1/MagickWand-config.*

%files doc
%defattr(-,root,root,-)
%doc %{_datadir}/doc/%{name}-6
%doc %{_datadir}/doc/%{name}-%{VER}
%doc LICENSE


%files c++
%defattr(-,root,root,-)
%doc Magick++/AUTHORS Magick++/ChangeLog Magick++/NEWS Magick++/README
%doc www/Magick++/COPYING
%{_libdir}/libMagick++-6.Q16.so.*

%files c++-devel
%defattr(-,root,root,-)
%doc Magick++/examples
%{_bindir}/Magick++-config
%{_includedir}/%{name}-6/Magick++
%{_includedir}/%{name}-6/Magick++.h
%{_libdir}/libMagick++-6.Q16.so
%{_libdir}/pkgconfig/Magick++.pc
%{_libdir}/pkgconfig/Magick++-6.Q16.pc
%{_libdir}/pkgconfig/ImageMagick++.pc
%{_libdir}/pkgconfig/ImageMagick++-6.Q16.pc
%{_mandir}/man1/Magick++-config.*

%files perl -f perl-pkg-files
%defattr(-,root,root,-)
%{_mandir}/man3/*
%doc PerlMagick/demo/ PerlMagick/Changelog PerlMagick/README.txt

