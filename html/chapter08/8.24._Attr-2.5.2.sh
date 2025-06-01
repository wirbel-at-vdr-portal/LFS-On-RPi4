#!/usr/bin/bash

# ===== 8.24. Attr-2.5.2 =====
topdir=$(pwd)
err=0
set -e
chapter=8024
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



srcdir=../../src/attr-2.5.2
tar xf ../../src/attr-2.5.2.tar.gz -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir

#<p>
#
#  The Attr package contains utilities to administer the extended attributes of 
# filesystem objects. 
#</p>

#  Approximate build time: less than 0.1 SBU
#  Required disk space: 4.1 MB
# ==== 8.24.1. Installation of Attr ====
#<p>
#
#  Prepare Attr for compilation: 
#</p>

#********<pre>***********
./configure --prefix=/usr     \
            --disable-static  \
            --sysconfdir=/etc \
            --docdir=/usr/share/doc/attr-2.5.2
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
#  The tests must be run on a filesystem that supports extended attributes such 
# as the ext2, ext3, or ext4 filesystems. To test the results, issue: 
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

# ==== 8.24.2. Contents of Attr ====

#  Installed programs: attr, getfattr, and setfattr
#  Installed library: libattr.so
#  Installed directories: /usr/include/attr and /usr/share/doc/attr-2.5.2
# ====== Short Descriptions ======

#--------------------------------------------
# | attr                                     | Extends attributes on filesystem objects
# | getfattr                                 | Gets the extended attributes of filesystem objects
# | setfattr                                 | Sets the extended attributes of filesystem objects
# | libattr                                  | Contains the library functions for manipulating extended attributes
#--------------------------------------------
cd $topdir
rm -rf $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt
