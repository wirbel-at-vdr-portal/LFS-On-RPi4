#!/usr/bin/bash

# ===== 5.2. Binutils-2.44 - Pass 1 =====
topdir=$(pwd)
err=0
set -e
chapter=5002
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

srcdir=../../src/binutils-2.44
tar xf ../../src/binutils-2.44.tar.xz -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir

#<p>
#
#  The Binutils package contains a linker, an assembler, and other tools for 
# handling object files. 
#</p>

#  Approximate build time: 1 SBU
#  Required disk space: 677 MB
# ==== 5.2.1. Installation of Cross Binutils ====

# ====== Note ======
#<p>
#
#  Go back and re-read the notes in the section titled [General Compilation Instructions](../partintro/generalinstructions.html)
#  . Understanding the notes labeled important can save you a lot of problems 
# later. 
#</p>
#<p>
#
#  It is important that Binutils be the first package compiled because both Glibc 
# and GCC perform various tests on the available linker and assembler to 
# determine which of their own features to enable. 
#</p>
#<p>
#
#  The Binutils documentation recommends building Binutils in a dedicated build 
# directory: 
#</p>

#********<pre>***********
mkdir -v build
cd       build
#********</pre>**********

# ====== Note ======
#<p>
#
#  In order for the SBU values listed in the rest of the book to be of any use, 
# measure the time it takes to build this package from the configuration, up to 
# and including the first install. To achieve this easily, wrap the commands in a time
#  command like this: time { ../configure ... && make && make install; } 
#  . 
#</p>
#<p>
#
#  Now prepare Binutils for compilation: 
#</p>

#********<pre>***********
../configure --prefix=$LFS/tools \
             --with-sysroot=$LFS \
             --target=$LFS_TGT   \
             --disable-nls       \
             --enable-gprofng=no \
             --disable-werror    \
             --enable-new-dtags  \
             --enable-default-hash-style=gnu
#********</pre>**********
#<p>
#
#  The meaning of the configure options: 
#</p>

#--prefix=$LFS/tools 
##<p>
#
#  This tells the configure script to prepare to install the Binutils programs in 
# the $LFS/tools 
#  directory. 
#</p>

#--with-sysroot=$LFS 
##<p>
#
#  For cross compilation, this tells the build system to look in $LFS for the 
# target system libraries as needed. 
#</p>

#--target=$LFS_TGT 
##<p>
#
#  Because the machine description in the LFS_TGT 
#  variable is slightly different than the value returned by the config.guess
#  script, this switch will tell the configure
#  script to adjust binutil's build system for building a cross linker. 
#</p>

#--disable-nls 
##<p>
#
#  This disables internationalization as i18n is not needed for the temporary 
# tools. 
#</p>

#--enable-gprofng=no 
##<p>
#
#  This disables building gprofng which is not needed for the temporary tools. 
#</p>

#--disable-werror 
##<p>
#
#  This prevents the build from stopping in the event that there are warnings 
# from the host's compiler. 
#</p>

#--enable-new-dtags 
##<p>
#
#  This makes the linker use the “runpath”
#  tag for embedding library search paths into executables and shared libraries, 
# instead of the traditional “rpath”
#  tag. It makes debugging dynamically linked executables easier and works around 
# potential issues in the test suite of some packages. 
#</p>

#--enable-default-hash-style=gnu 
##<p>
#
#  By default, the linker would generate both the GNU-style hash table and the 
# classic ELF hash table for shared libraries and dynamically linked executables. 
# The hash tables are only intended for a dynamic linker to perform symbol 
# lookup. On LFS the dynamic linker (provided by the Glibc package) will always 
# use the GNU-style hash table which is faster to query. So the classic ELF hash 
# table is completely useless. This makes the linker only generate the GNU-style 
# hash table by default, so we can avoid wasting time to generate the classic ELF 
# hash table when we build the packages, or wasting disk space to store it. 
#</p>
#<p>
#
#  Continue with compiling the package: 
#</p>

#********<pre>***********
make
#********</pre>**********
#<p>
#
#  Install the package: 
#</p>

#********<pre>***********
make install
#********</pre>**********
#<p>
#
#  Details on this package are located in [Section 8.20.2, “Contents of Binutils.”](../chapter08/binutils.html#contents-binutils)
#</p>

cd $topdir
rm -rfv $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt
