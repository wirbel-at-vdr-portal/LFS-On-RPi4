#!/usr/bin/bash

# ===== 8.37. Libtool-2.5.4 =====
topdir=$(pwd)
err=0
set -e
chapter=8037
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



srcdir=../../src/libtool-2.5.4
tar xf ../../src/libtool-2.5.4.tar.xz -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir

#<p>
#
#  The Libtool package contains the GNU generic library support script. It makes 
# the use of shared libraries simpler with a consistent, portable interface. 
#</p>

#  Approximate build time: 0.6 SBU
#  Required disk space: 44 MB
# ==== 8.37.1. Installation of Libtool ====
#<p>
#
#  Prepare Libtool for compilation: 
#</p>

#********<pre>***********
./configure --prefix=/usr
#********</pre>**********
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
#<p>
#
#  Remove a useless static library: 
#</p>

#********<pre>***********
rm -fv /usr/lib/libltdl.a
#********</pre>**********

# ==== 8.37.2. Contents of Libtool ====

#  Installed programs: libtool and libtoolize
#  Installed libraries: libltdl.so
#  Installed directories: /usr/include/libltdl and /usr/share/libtool
# ====== Short Descriptions ======

#--------------------------------------------
# | libtool                                  | Provides generalized library-building support services
# | libtoolize                               | Provides a standard way to add          libtool                                 support to a package                    
# | libltdl                                  | Hides the various difficulties of opening dynamically loaded libraries
#--------------------------------------------
cd $topdir
rm -rf $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt
