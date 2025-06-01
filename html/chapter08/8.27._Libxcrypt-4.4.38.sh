#!/usr/bin/bash

# ===== 8.27. Libxcrypt-4.4.38 =====
topdir=$(pwd)
err=0
set -e
chapter=8027
err_report() {
    echo "chapter $chapter: $(date +'%Y.%m.%d %H:%M:%S') Error $? on line $1" | tee >> $topdir/log.txt
}
trap 'err_report $LINENO' ERR
echo "---------" >> $topdir/log.txt
echo chapter $chapter: start = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt




if [ "$EUID" -ne "0" ]; then
  echo "ERROR: Please run as root, not as user id = $EUID";stop
  exit 1
fi

grep -q $LFS/dev/pts /proc/mounts || err=1
if [ "$err" -eq "1" ]; then
  echo "ERROR: The '$LFS/dev/pts' partition must be mounted.";stop
  exit 1
fi

grep -q $LFS/dev /proc/mounts || err=1
if [ "$err" -eq "1" ]; then
  echo "ERROR: The '$LFS/dev' partition must be mounted.";stop
  exit 1
fi

grep -q $LFS/proc /proc/mounts || err=1
if [ "$err" -eq "1" ]; then
  echo "ERROR: The '$LFS/proc' partition must be mounted.";stop
  exit 1
fi

grep -q $LFS/sys /proc/mounts || err=1
if [ "$err" -eq "1" ]; then
  echo "ERROR: The '$LFS/sys' partition must be mounted.";stop
  exit 1
fi

grep -q $LFS/run /proc/mounts || err=1
if [ "$err" -eq "1" ]; then
  echo "ERROR: The '$LFS/run' partition must be mounted.";stop
  exit 1
fi



srcdir=../../src/libxcrypt-4.4.38
tar xf ../../src/libxcrypt-4.4.38.tar.xz -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir

#<p>
#
#  The Libxcrypt package contains a modern library for one-way hashing of 
# passwords. 
#</p>

#  Approximate build time: 0.1 SBU
#  Required disk space: 12 MB
# ==== 8.27.1. Installation of Libxcrypt ====
#<p>
#
#  Prepare Libxcrypt for compilation: 
#</p>

#********<pre>***********
./configure --prefix=/usr                \
            --enable-hashes=strong,glibc \
            --enable-obsolete-api=no     \
            --disable-static             \
            --disable-failure-tokens
#********</pre>**********
#<p>
#
#  The meaning of the new configure options: 
#</p>

#--enable-hashes=strong,glibc 
##<p>
#
#  Build strong hash algorithms recommended for security use cases, and the hash 
# algorithms provided by traditional Glibc libcrypt 
#  for compatibility. 
#</p>

#--enable-obsolete-api=no 
##<p>
#
#  Disable obsolete API functions. They are not needed for a modern Linux system 
# built from source. 
#</p>

#--disable-failure-tokens 
##<p>
#
#  Disable failure token feature. It's needed for compatibility with the 
# traditional hash libraries of some platforms, but a Linux system based on Glibc 
# does not need it. 
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
#  To test the results, issue: 
#</p>

#********<pre>***********
#make check
#********</pre>**********
#<p>
#
#  Install the package: 
#</p>

#********<pre>***********
make install
#********</pre>**********

# ====== Note ======
#<p>
#
#  The instructions above disabled obsolete API functions since no package 
# installed by compiling from sources would link against them at runtime. 
# However, the only known binary-only applications that link against these 
# functions require ABI version 1. If you must have such functions because of 
# some binary-only application or to be compliant with LSB, build the package 
# again with the following commands: 
#</p>

#********<pre>***********
make distclean
./configure --prefix=/usr                \
            --enable-hashes=strong,glibc \
            --enable-obsolete-api=glibc  \
            --disable-static             \
            --disable-failure-tokens
make
cp -av --remove-destination .libs/libcrypt.so.1* /usr/lib
#********</pre>**********

# ==== 8.27.2. Contents of Libxcrypt ====

#  Installed libraries: libcrypt.so
# ====== Short Descriptions ======

#--------------------------------------------
# | libcrypt                                 | Contains functions to hash passwords    
#--------------------------------------------
cd $topdir
rm -rf $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt
