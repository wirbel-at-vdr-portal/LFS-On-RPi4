#!/usr/bin/bash

# ===== 8.25. Acl-2.3.2 =====
topdir=$(pwd)
err=0
set -e
chapter=8025
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



srcdir=../../src/acl-2.3.2
tar xf ../../src/acl-2.3.2.tar.xz -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir

#<p>
#
#  The Acl package contains utilities to administer Access Control Lists, which 
# are used to define fine-grained discretionary access rights for files and 
# directories. 
#</p>

#  Approximate build time: less than 0.1 SBU
#  Required disk space: 6.5 MB
# ==== 8.25.1. Installation of Acl ====
#<p>
#
#  Prepare Acl for compilation: 
#</p>

#********<pre>***********
./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/acl-2.3.2
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
#  The Acl tests must be run on a filesystem that supports access controls. To 
# test the results, issue: 
#</p>

#********<pre>***********
#make check
#********</pre>**********
#<p>
#
#  One test named test/cp.test 
#  is known to fail because Coreutils
#  is not built with the Acl
#  support yet. 
#</p>
#<p>
#
#  Install the package: 
#</p>

#********<pre>***********
make install
#********</pre>**********

# ==== 8.25.2. Contents of Acl ====

#  Installed programs: chacl, getfacl, and setfacl
#  Installed library: libacl.so
#  Installed directories: /usr/include/acl and /usr/share/doc/acl-2.3.2
# ====== Short Descriptions ======

#--------------------------------------------
# | chacl                                    | Changes the access control list of a file or directory
# | getfacl                                  | Gets file access control lists          
# | setfacl                                  | Sets file access control lists          
# | libacl                                   | Contains the library functions for manipulating Access Control Lists
#--------------------------------------------
cd $topdir
rm -rf $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt
