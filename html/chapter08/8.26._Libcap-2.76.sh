#!/usr/bin/bash

# ===== 8.26. Libcap-2.76 =====
topdir=$(pwd)
err=0
set -e
chapter=8026
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



srcdir=../../src/libcap-2.76
tar xf ../../src/libcap-2.76.tar.xz -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir

#<p>
#
#  The Libcap package implements the userspace interface to the POSIX 1003.1e 
# capabilities available in Linux kernels. These capabilities partition the 
# all-powerful root privilege into a set of distinct privileges. 
#</p>

#  Approximate build time: less than 0.1 SBU
#  Required disk space: 3.0 MB
# ==== 8.26.1. Installation of Libcap ====
#<p>
#
#  Prevent static libraries from being installed: 
#</p>

#********<pre>***********
sed -i '/install -m.*STA/d' libcap/Makefile
#********</pre>**********
#<p>
#
#  Compile the package: 
#</p>

#********<pre>***********
make prefix=/usr lib=lib
#********</pre>**********
#<p>
#
#  The meaning of the make option: 
#</p>

#lib=lib 
##<p>
#
#  This parameter sets the library directory to /usr/lib 
#  rather than /usr/lib64 
#  on x86_64. It has no effect on x86. 
#</p>
#<p>
#
#  To test the results, issue: 
#</p>

#********<pre>***********
make test
#********</pre>**********
#<p>
#
#  Install the package: 
#</p>

#********<pre>***********
make prefix=/usr lib=lib install
#********</pre>**********

# ==== 8.26.2. Contents of Libcap ====

#  Installed programs: capsh, getcap, getpcaps, and setcap
#  Installed library: libcap.so and libpsx.so
# ====== Short Descriptions ======

#--------------------------------------------
# | capsh                                    | A shell wrapper to explore and constrain capability support
# | getcap                                   | Examines file capabilities              
# | getpcaps                                 | Displays the capabilities of the queried process(es)
# | setcap                                   | Sets file capabilities                  
# | libcap                                   | Contains the library functions for manipulating POSIX 1003.1e capabilities
# | libpsx                                   | Contains functions to support POSIX semantics for syscalls associated with the pthread library
#--------------------------------------------
cd $topdir
rm -rf $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt
