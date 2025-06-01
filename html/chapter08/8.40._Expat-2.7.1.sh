#!/usr/bin/bash

# ===== 8.40. Expat-2.7.1 =====
topdir=$(pwd)
err=0
set -e
chapter=8040
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



srcdir=../../src/expat-2.7.1
tar xf ../../src/expat-2.7.1.tar.xz -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir

#<p>
#
#  The Expat package contains a stream oriented C library for parsing XML. 
#</p>

#  Approximate build time: 0.1 SBU
#  Required disk space: 14 MB
# ==== 8.40.1. Installation of Expat ====
#<p>
#
#  Prepare Expat for compilation: 
#</p>

#********<pre>***********
./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/expat-2.7.1
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
#  If desired, install the documentation: 
#</p>

#********<pre>***********
install -v -m644 doc/*.{html,css} /usr/share/doc/expat-2.7.1
#********</pre>**********

# ==== 8.40.2. Contents of Expat ====

#  Installed program: xmlwf
#  Installed libraries: libexpat.so
#  Installed directory: /usr/share/doc/expat-2.7.1
# ====== Short Descriptions ======

#--------------------------------------------
# | xmlwf                                    | Is a non-validating utility to check whether or not XML documents are well formed
# | libexpat                                 | Contains API functions for parsing XML  
#--------------------------------------------
cd $topdir
rm -rf $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt
