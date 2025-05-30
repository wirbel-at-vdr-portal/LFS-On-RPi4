#!/usr/bin/bash

# ===== 5.6. Libstdc++ from GCC-14.2.0 =====
topdir=$(pwd)
err=0
set -e
chapter=5006
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
#  Libstdc++ is the standard C++ library. It is needed to compile C++ code (part 
# of GCC is written in C++), but we had to defer its installation when we built [gcc-pass1](gcc-pass1.html)
#  because Libstdc++ depends on Glibc, which was not yet available in the target 
# directory. 
#</p>

#  Approximate build time: 0.2 SBU
#  Required disk space: 850 MB
# ==== 5.6.1. Installation of Target Libstdc++ ====

# ====== Note ======
#<p>
#Libstdc++
#  is part of the GCC sources. You should first unpack the GCC tarball and change 
# to the gcc-14.2.0 
#  directory. 
#</p>
#<p>
#
#  Create a separate build directory for Libstdc++ and enter it: 
#</p>

#********<pre>***********
mkdir -v build
cd       build
#********</pre>**********
#<p>
#
#  Prepare Libstdc++ for compilation: 
#</p>

#********<pre>***********
../libstdc++-v3/configure      \
    --host=$LFS_TGT            \
    --build=$(../config.guess) \
    --prefix=/usr              \
    --disable-multilib         \
    --disable-nls              \
    --disable-libstdcxx-pch    \
    --with-gxx-include-dir=/tools/$LFS_TGT/include/c++/14.2.0
#********</pre>**********
#<p>
#
#  The meaning of the configure options: 
#</p>

#--host=... 
##<p>
#
#  Specifies that the cross-compiler we have just built should be used instead of 
# the one in /usr/bin 
#  . 
#</p>

#--disable-libstdcxx-pch 
##<p>
#
#  This switch prevents the installation of precompiled include files, which are 
# not needed at this stage. 
#</p>

#--with-gxx-include-dir=/tools/$LFS_TGT/include/c++/14.2.0 
##<p>
#
#  This specifies the installation directory for include files. Because Libstdc++ 
# is the standard C++ library for LFS, this directory should match the location 
# where the C++ compiler ( $LFS_TGT-g++
#  ) would search for the standard C++ include files. In a normal build, this 
# information is automatically passed to the Libstdc++ configure
#  options from the top level directory. In our case, this information must be 
# explicitly given. The C++ compiler will prepend the sysroot path $LFS 
#  (specified when building GCC-pass1) to the include file search path, so it 
# will actually search in $LFS/tools/$LFS_TGT/include/c++/14.2.0 
#  . The combination of the DESTDIR 
#  variable (in the make install
#  command below) and this switch causes the headers to be installed there. 
#</p>
#<p>
#
#  Compile Libstdc++ by running: 
#</p>

#********<pre>***********
make
#********</pre>**********
#<p>
#
#  Install the library: 
#</p>

#********<pre>***********
make DESTDIR=$LFS install
#********</pre>**********
#<p>
#
#  Remove the libtool archive files because they are harmful for 
# cross-compilation: 
#</p>

#********<pre>***********
rm -v $LFS/usr/lib/lib{stdc++{,exp,fs},supc++}.la
#********</pre>**********
#<p>
#
#  Details on this package are located in [Section 8.29.2, “Contents of GCC.”](../chapter08/gcc.html#contents-gcc)
#</p>

cd $topdir
rm -rfv $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt
