#!/usr/bin/bash

# ===== 8.21. GMP-6.3.0 =====
topdir=$(pwd)
err=0
set -e
chapter=8021
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



srcdir=../../src/gmp-6.3.0
tar xf ../../src/gmp-6.3.0.tar.xz -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir

#<p>
#
#  The GMP package contains math libraries. These have useful functions for 
# arbitrary precision arithmetic. 
#</p>

#  Approximate build time: 0.3 SBU
#  Required disk space: 54 MB
# ==== 8.21.1. Installation of GMP ====

# ====== Note ======
#<p>
#
#  If you are building for 32-bit x86, but you have a CPU which is capable of 
# running 64-bit code and
#  you have specified CFLAGS 
#  in the environment, the configure script will attempt to configure for 64-bits 
# and fail. Avoid this by invoking the configure command below with 
#</p>

#********<pre>***********
ABI=32 ./configure ...
#********</pre>**********

# ====== Note ======
#<p>
#
#  The default settings of GMP produce libraries optimized for the host 
# processor. If libraries suitable for processors less capable than the host's 
# CPU are desired, generic libraries can be created by appending the --host=none-linux-gnu 
#  option to the configure
#  command. 
#</p>
#<p>
#
#  Prepare GMP for compilation: 
#</p>

#********<pre>***********
./configure --prefix=/usr    \
            --enable-cxx     \
            --disable-static \
            --docdir=/usr/share/doc/gmp-6.3.0 \
            --build=aarch64-unknown-linux-gnu
#********</pre>**********
#<p>
#
#  The meaning of the new configure options: 
#</p>

#--enable-cxx 
##<p>
#
#  This parameter enables C++ support 
#</p>

#--docdir=/usr/share/doc/gmp-6.3.0 
##<p>
#
#  This variable specifies the correct place for the documentation. 
#</p>
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
#  The test suite for GMP in this section is considered critical. Do not skip it 
# under any circumstances. 
#</p>
#<p>
#
#  Test the results: 
#</p>

#********<pre>***********
#make check 2>&1 | tee gmp-check-log
#********</pre>**********

# ====== Caution ======
#<p>
#
#  The code in gmp is highly optimized for the processor where it is built. 
# Occasionally, the code that detects the processor misidentifies the system 
# capabilities and there will be errors in the tests or other applications using 
# the gmp libraries with the message Illegal instruction 
#  . In this case, gmp should be reconfigured with the option --host=none-linux-gnu 
#  and rebuilt. 
#</p>
#<p>
#
#  Ensure that at least 199 tests in the test suite passed. Check the results by 
# issuing the following command: 
#</p>

#********<pre>***********
awk '/# PASS:/{total+=$3} ; END{print total}' gmp-check-log
#********</pre>**********
#<p>
#
#  Install the package and its documentation: 
#</p>

#********<pre>***********
make install
make install-html
#********</pre>**********

# ==== 8.21.2. Contents of GMP ====

#  Installed libraries: libgmp.so and libgmpxx.so
#  Installed directory: /usr/share/doc/gmp-6.3.0
# ====== Short Descriptions ======

#--------------------------------------------
# | libgmp                                   | Contains precision math functions       
# | libgmpxx                                 | Contains C++ precision math functions   
#--------------------------------------------
cd $topdir
rm -rf $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt
