#!/usr/bin/bash

# ===== 8.23. MPC-1.3.1 =====
topdir=$(pwd)
err=0
set -e
chapter=8023
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



srcdir=../../src/mpc-1.3.1
tar xf ../../src/mpc-1.3.1.tar.gz -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir

#<p>
#
#  The MPC package contains a library for the arithmetic of complex numbers with 
# arbitrarily high precision and correct rounding of the result. 
#</p>

#  Approximate build time: 0.1 SBU
#  Required disk space: 22 MB
# ==== 8.23.1. Installation of MPC ====
#<p>
#
#  Prepare MPC for compilation: 
#</p>

#********<pre>***********
./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/mpc-1.3.1
#********</pre>**********
#<p>
#
#  Compile the package and generate the HTML documentation: 
#</p>

#********<pre>***********
make
make html
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
#  Install the package and its documentation: 
#</p>

#********<pre>***********
make install
make install-html
#********</pre>**********

# ==== 8.23.2. Contents of MPC ====

#  Installed libraries: libmpc.so
#  Installed directory: /usr/share/doc/mpc-1.3.1
# ====== Short Descriptions ======

#--------------------------------------------
# | libmpc                                   | Contains complex math functions         
#--------------------------------------------
cd $topdir
rm -rf $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt
