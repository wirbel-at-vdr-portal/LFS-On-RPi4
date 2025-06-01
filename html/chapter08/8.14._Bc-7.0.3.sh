#!/usr/bin/bash

# ===== 8.14. Bc-7.0.3 =====
topdir=$(pwd)
err=0
set -e
chapter=8014
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



srcdir=../../src/bc-7.0.3
tar xf ../../src/bc-7.0.3.tar.xz -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir

#<p>
#
#  The Bc package contains an arbitrary precision numeric processing language. 
#</p>

#  Approximate build time: less than 0.1 SBU
#  Required disk space: 7.8 MB
# ==== 8.14.1. Installation of Bc ====
#<p>
#
#  Prepare Bc for compilation: 
#</p>

#********<pre>***********
CC=gcc ./configure --prefix=/usr -G -O3 -r
#********</pre>**********
#<p>
#
#  The meaning of the configure options: 
#</p>

#CC=gcc 
##<p>
#
#  This parameter specifies the compiler to use. 
#</p>

#-G 
##<p>
#
#  Omit parts of the test suite that won't work until the bc program has been 
# installed. 
#</p>

#-O3 
##<p>
#
#  Specify the optimization to use. 
#</p>

#-r 
##<p>
#
#  Enable the use of Readline
#  to improve the line editing feature of bc. 
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
#  To test bc, run: 
#</p>

#********<pre>***********
make test
#********</pre>**********
#<p>
#
#  Install the package: 
#</p>

#********<pre>***********
make install
#********</pre>**********

# ==== 8.14.2. Contents of Bc ====

#  Installed programs: bc and dc
# ====== Short Descriptions ======

#--------------------------------------------
# | bc                                       | A command line calculator               
# | dc                                       | A reverse-polish command line calculator
#--------------------------------------------
cd $topdir
rm -rf $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt
