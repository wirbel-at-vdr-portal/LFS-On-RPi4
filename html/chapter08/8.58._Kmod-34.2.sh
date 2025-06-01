#!/usr/bin/bash

# ===== 8.58. Kmod-34.2 =====
topdir=$(pwd)
err=0
set -e
chapter=8058
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



srcdir=../../src/kmod-34.2
tar xf ../../src/kmod-34.2.tar.xz -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir

#<p>
#
#  The Kmod package contains libraries and utilities for loading kernel modules 
#</p>

#  Approximate build time: less than 0.1 SBU
#  Required disk space: 11 MB
# ==== 8.58.1. Installation of Kmod ====
#<p>
#
#  Prepare Kmod for compilation: 
#</p>

#********<pre>***********
mkdir -p build
cd       build

meson setup --prefix=/usr ..    \
            --buildtype=release \
            -D manpages=false
#********</pre>**********
#<p>
#
#  The meaning of the configure options: 
#</p>

#-D manpages=false 
##<p>
#
#  This option disables generating the man pages which requires an external 
# program. 
#</p>
#<p>
#
#  Compile the package: 
#</p>

#********<pre>***********
ninja
#********</pre>**********
#<p>
#
#  The test suite of this package requires raw kernel headers (not the “sanitized”
#  kernel headers installed earlier), which are beyond the scope of LFS. 
#</p>
#<p>
#
#  Now install the package: 
#</p>

#********<pre>***********
ninja install
#********</pre>**********

# ==== 8.58.2. Contents of Kmod ====

#  Installed programs: depmod (link to kmod), insmod (link to kmod), kmod, lsmod (link to kmod), modinfo (link to kmod), modprobe (link to kmod), and rmmod (link to kmod)
#  Installed library: libkmod.so
# ====== Short Descriptions ======

#--------------------------------------------
# | depmod                                   | Creates a dependency file based on the symbols it finds in the existing set of modules; this dependency file is used bymodprobe                                to automatically load the required modules
# | insmod                                   | Installs a loadable module in the running kernel
# | kmod                                     | Loads and unloads kernel modules        
# | lsmod                                    | Lists currently loaded modules          
# | modinfo                                  | Examines an object file associated with a kernel module and displays any information that it can glean
# | modprobe                                 | Uses a dependency file, created by      depmod                                  , to automatically load relevant modules
# | rmmod                                    | Unloads modules from the running kernel 
# | libkmod                                  | This library is used by other programs to load and unload kernel modules
#--------------------------------------------
cd $topdir
rm -rf $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt
