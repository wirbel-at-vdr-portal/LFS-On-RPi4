#!/usr/bin/bash

# ===== 8.38. GDBM-1.25 =====
topdir=$(pwd)
err=0
set -e
chapter=8038
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



srcdir=../../src/gdbm-1.25
tar xf ../../src/gdbm-1.25.tar.gz -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir

#<p>
#
#  The GDBM package contains the GNU Database Manager. It is a library of 
# database functions that uses extensible hashing and works like the standard 
# UNIX dbm. The library provides primitives for storing key/data pairs, searching 
# and retrieving the data by its key and deleting a key along with its data. 
#</p>

#  Approximate build time: less than 0.1 SBU
#  Required disk space: 13 MB
# ==== 8.38.1. Installation of GDBM ====
#<p>
#
#  Prepare GDBM for compilation: 
#</p>

#********<pre>***********
./configure --prefix=/usr    \
            --disable-static \
            --enable-libgdbm-compat
#********</pre>**********
#<p>
#
#  The meaning of the configure option: 
#</p>

#--enable-libgdbm-compat 
##<p>
#
#  This switch enables building the libgdbm compatibility library. Some packages 
# outside of LFS may require the older DBM routines it provides. 
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

# ==== 8.38.2. Contents of GDBM ====

#  Installed programs: gdbm_dump, gdbm_load, and gdbmtool
#  Installed libraries: libgdbm.so and libgdbm_compat.so
# ====== Short Descriptions ======

#--------------------------------------------
# | gdbm_dump                                | Dumps a GDBM database to a file         
# | gdbm_load                                | Recreates a GDBM database from a dump file
# | gdbmtool                                 | Tests and modifies a GDBM database      
# | libgdbm                                  | Contains functions to manipulate a hashed database
# | libgdbm_compat                           | Compatibility library containing older DBM functions
#--------------------------------------------
cd $topdir
rm -rf $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt
