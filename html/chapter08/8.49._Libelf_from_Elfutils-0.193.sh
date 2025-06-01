#!/usr/bin/bash

# ===== 8.49. Libelf from Elfutils-0.193 =====
topdir=$(pwd)
err=0
set -e
chapter=8049
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



srcdir=../../src/elfutils-0.193
tar xf ../../src/elfutils-0.193.tar.bz2 -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir

#<p>
#
#  Libelf is a library for handling ELF (Executable and Linkable Format) files. 
#</p>

#  Approximate build time: 0.3 SBU
#  Required disk space: 135 MB
# ==== 8.49.1. Installation of Libelf ====
#<p>
#
#  Libelf is part of the elfutils-0.193 package. Use the elfutils-0.193.tar.bz2 
# file as the source tarball. 
#</p>
#<p>
#
#  Prepare Libelf for compilation: 
#</p>

#********<pre>***********
./configure --prefix=/usr        \
            --disable-debuginfod \
            --enable-libdebuginfod=dummy
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
#  Two tests are known to fail, dwarf_srclang_check and 
# run-backtrace-native-core.sh. 
#</p>
#<p>
#
#  Install only Libelf: 
#</p>

#********<pre>***********
make -C libelf install
install -vm644 config/libelf.pc /usr/lib/pkgconfig
rm /usr/lib/libelf.a
#********</pre>**********

# ==== 8.49.2. Contents of Libelf ====

#  Installed library: libelf.so
#  Installed directory: /usr/include/elfutils
# ====== Short Descriptions ======

#--------------------------------------------
# | libelf.so                                | Contains API functions to handle ELF object files
#--------------------------------------------
cd $topdir
rm -rf $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt
