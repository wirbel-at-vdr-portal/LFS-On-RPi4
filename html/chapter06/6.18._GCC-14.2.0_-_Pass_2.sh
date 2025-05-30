#!/usr/bin/bash

# ===== 6.18. GCC-14.2.0 - Pass 2 =====
topdir=$(pwd)
err=0
set -e
chapter=6018
err_report() {
    echo "chapter $chapter: $(date +'%Y.%m.%d %H:%M:%S') Error $? on line $1" | tee >> $topdir/log.txt
}
trap 'err_report $LINENO' ERR
echo "---------" >> $topdir/log.txt
echo chapter $chapter: start = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt

if [[ -z "${LFS}" ]]; then
  echo "ERROR: 'LFS' is not set.";stop
  exit 1
fi

grep -q $LFS /proc/mounts || err=1
if [ "$err" -eq "1" ]; then
  echo "ERROR: The '$LFS' partition must be mounted.";stop
  exit 1
fi

if [ "$EUID" -eq "0" ]; then
  echo "ERROR: Please run as user lfs"
  exit 1
fi

srcdir=../../src/gcc-14.2.0
tar xf ../../src/gcc-14.2.0.tar.xz -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir

#<p>
#
#  The GCC package contains the GNU compiler collection, which includes the C and 
# C++ compilers. 
#</p>

#  Approximate build time: 4.1 SBU
#  Required disk space: 5.5 GB
# ==== 6.18.1. Installation of GCC ====
#<p>
#
#  As in the first build of GCC, the GMP, MPFR, and MPC packages are required. 
# Unpack the tarballs and move them into the required directories: 
#</p>

#********<pre>***********
tar -xf ../mpfr-4.2.2.tar.xz
mv -v mpfr-4.2.2 mpfr
tar -xf ../gmp-6.3.0.tar.xz
mv -v gmp-6.3.0 gmp
tar -xf ../mpc-1.3.1.tar.gz
mv -v mpc-1.3.1 mpc
#********</pre>**********
#<p>
#
#  If building on x86_64, change the default directory name for 64-bit libraries 
# to “lib”
#  : 
#</p>

#********<pre>***********
case $(uname -m) in
  x86_64)
    sed -e '/m64=/s/lib64/lib/' \
        -i.orig gcc/config/i386/t-linux64
  ;;
esac
#********</pre>**********
#<p>
#
#  Override the building rule of libgcc and libstdc++ headers, to allow building 
# these libraries with POSIX threads support: 
#</p>

#********<pre>***********
sed '/thread_header =/s/@.*@/gthr-posix.h/' \
    -i libgcc/Makefile.in libstdc++-v3/include/Makefile.in
#********</pre>**********
#<p>
#
#  Create a separate build directory again: 
#</p>

#********<pre>***********
mkdir -v build
cd       build
#********</pre>**********
#<p>
#
#  Before starting to build GCC, remember to unset any environment variables that 
# override the default optimization flags. 
#</p>
#<p>
#
#  Now prepare GCC for compilation: 
#</p>

#********<pre>***********
../configure                   \
    --build=$(../config.guess) \
    --host=$LFS_TGT            \
    --target=$LFS_TGT          \
    LDFLAGS_FOR_TARGET=-L$PWD/$LFS_TGT/libgcc \
    --prefix=/usr              \
    --with-build-sysroot=$LFS  \
    --enable-default-pie       \
    --enable-default-ssp       \
    --disable-nls              \
    --disable-multilib         \
    --disable-libatomic        \
    --disable-libgomp          \
    --disable-libquadmath      \
    --disable-libsanitizer     \
    --disable-libssp           \
    --disable-libvtv           \
    --enable-languages=c,c++
#********</pre>**********
#<p>
#
#  The meaning of the new configure options: 
#</p>

#--with-build-sysroot=$LFS 
##<p>
#
#  Normally, using --host 
#  ensures that a cross-compiler is used for building GCC, and that compiler 
# knows that it has to look for headers and libraries in $LFS 
#  . But the build system for GCC uses other tools, which are not aware of this 
# location. This switch is needed so those tools will find the needed files in $LFS 
#  , and not on the host. 
#</p>

#--target=$LFS_TGT 
##<p>
#
#  We are cross-compiling GCC, so it's impossible to build target libraries ( libgcc 
#  and libstdc++ 
#  ) with the GCC binaries compiled in this pass—those binaries won't run on 
# the host. The GCC build system will attempt to use the host's C and C++ 
# compilers as a workaround by default. Building the GCC target libraries with a 
# different version of GCC is not supported, so using the host's compilers may 
# cause the build to fail. This parameter ensures the libraries are built by GCC 
# pass 1. 
#</p>

#LDFLAGS_FOR_TARGET=... 
##<p>
#
#  Allow libstdc++ 
#  to use the libgcc 
#  being built in this pass, instead of the previous version built in [gcc-pass1](../chapter05/gcc-pass1.html)
#  . The previous version cannot properly support C++ exception handling because 
# it was built without libc support. 
#</p>

#--disable-libsanitizer 
##<p>
#
#  Disable GCC sanitizer runtime libraries. They are not needed for the temporary 
# installation. In [gcc-pass1](../chapter05/gcc-pass1.html)
#  it was implied by --disable-libstdcxx 
#  , and now we can explicitly pass it. 
#</p>
#<p>
#
#  Compile the package: 
#</p>

#********<pre>***********
make
#********</pre>**********
#<p>
#
#  Install the package: 
#</p>

#********<pre>***********
make DESTDIR=$LFS install
#********</pre>**********
#<p>
#
#  As a finishing touch, create a utility symlink. Many programs and scripts run cc
#  instead of gcc
#  , which is used to keep programs generic and therefore usable on all kinds of 
# UNIX systems where the GNU C compiler is not always installed. Running cc
#  leaves the system administrator free to decide which C compiler to install: 
#</p>

#********<pre>***********
ln -sv gcc $LFS/usr/bin/cc
#********</pre>**********
#<p>
#
#  Details on this package are located in [Section 8.29.2, “Contents of GCC.”](../chapter08/gcc.html#contents-gcc)
#</p>

cd $topdir
rm -rf $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt
