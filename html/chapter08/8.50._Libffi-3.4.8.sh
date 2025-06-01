#!/usr/bin/bash

# ===== 8.50. Libffi-3.4.8 =====
topdir=$(pwd)
err=0
set -e
chapter=8050
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



srcdir=../../src/libffi-3.4.8
tar xf ../../src/libffi-3.4.8.tar.gz -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir

#<p>
#
#  The Libffi library provides a portable, high level programming interface to 
# various calling conventions. This allows a programmer to call any function 
# specified by a call interface description at run time. 
#</p>
#<p>
#
#  FFI stands for Foreign Function Interface. An FFI allows a program written in 
# one language to call a program written in another language. Specifically, 
# Libffi can provide a bridge between an interpreter like Perl, or Python, and 
# shared library subroutines written in C, or C++. 
#</p>

#  Approximate build time: 1.7 SBU
#  Required disk space: 11 MB
# ==== 8.50.1. Installation of Libffi ====

# ====== Note ======
#<p>
#
#  Like GMP, Libffi builds with optimizations specific to the processor in use. 
# If building for another system, change the value of the --with-gcc-arch= 
#  parameter in the following command to an architecture name fully implemented 
# by both
#  the host CPU and the CPU on that system. If this is not done, all applications 
# that link to libffi 
#  will trigger Illegal Operation Errors. If you cannot figure out a value safe 
# for both the CPUs, replace the parameter with --without-gcc-arch 
#  to produce a generic library. 
#</p>
#<p>
#
#  Prepare Libffi for compilation: 
#</p>

#********<pre>***********
./configure --prefix=/usr    \
            --disable-static \
            --with-gcc-arch=native
#********</pre>**********
#<p>
#
#  The meaning of the configure option: 
#</p>

#--with-gcc-arch=native 
##<p>
#
#  Ensure GCC optimizes for the current system. If this is not specified, the 
# system is guessed and the code generated may not be correct. If the generated 
# code will be copied from the native system to a less capable system, use the 
# less capable system as a parameter. For details about alternative system types, 
# see [the x86 options in the GCC manual](https://gcc.gnu.org/onlinedocs/gcc-14.2.0/gcc/x86-Options.html)
#  . 
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

# ==== 8.50.2. Contents of Libffi ====

#  Installed library: libffi.so
# ====== Short Descriptions ======

#--------------------------------------------
# | libffi                                   | Contains the foreign function interface API functions
#--------------------------------------------
cd $topdir
rm -rf $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt
