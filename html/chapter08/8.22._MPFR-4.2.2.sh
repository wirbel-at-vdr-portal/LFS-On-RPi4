#!/usr/bin/bash

# ===== 8.22. MPFR-4.2.2 =====
topdir=$(pwd)
err=0
set -e
chapter=8022
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



srcdir=../../src/mpfr-4.2.2
tar xf ../../src/mpfr-4.2.2.tar.xz -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir

#<p>
#
#  The MPFR package contains functions for multiple precision math. 
#</p>

#  Approximate build time: 0.2 SBU
#  Required disk space: 43 MB
# ==== 8.22.1. Installation of MPFR ====
#<p>
#
#  Prepare MPFR for compilation: 
#</p>

#********<pre>***********
./configure --prefix=/usr        \
            --disable-static     \
            --enable-thread-safe \
            --docdir=/usr/share/doc/mpfr-4.2.2
#********</pre>**********
#<p>
#
#  Compile the package and generate the HTML documentation: 
#</p>

#********<pre>***********
make
make html
#********</pre>**********

# ====== Important ======
#<p>
#
#  The test suite for MPFR in this section is considered critical. Do not skip it 
# under any circumstances. 
#</p>
#<p>
#
#  Test the results and ensure that all 198 tests passed: 
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

# ==== 8.22.2. Contents of MPFR ====

#  Installed libraries: libmpfr.so
#  Installed directory: /usr/share/doc/mpfr-4.2.2
# ====== Short Descriptions ======

#--------------------------------------------
# | libmpfr                                  | Contains multiple-precision math functions
#--------------------------------------------
cd $topdir
rm -rf $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt
