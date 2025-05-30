#!/usr/bin/bash

# ===== 6.8. Findutils-4.10.0 =====
topdir=$(pwd)
err=0
set -e
chapter=6008
err_report() {
    echo "chapter $chapter: $(date +'%Y.%m.%d %H:%M:%S') Error $? on line $1" | tee >> $topdir/log.txt
}
trap 'err_report $LINENO' ERR
echo "---------" >> $topdir/log.txt
echo chapter $chapter: start = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt

if [[ -z "${LFS}" ]]; then
  echo "ERROR: 'LFS' is not set.";stop
  exit 1
fi

grep -q $LFS /proc/mounts || err=1
if [ "$err" -eq "1" ]; then
  echo "ERROR: The '$LFS' partition must be mounted.";stop
  exit 1
fi

if [ "$EUID" -eq "0" ]; then
  echo "ERROR: Please run as user lfs"
  exit 1
fi

srcdir=../../src/findutils-4.10.0
tar xf ../../src/findutils-4.10.0.tar.xz -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir

#<p>
#
#  The Findutils package contains programs to find files. Programs are provided 
# to search through all the files in a directory tree and to create, maintain, 
# and search a database (often faster than the recursive find, but unreliable 
# unless the database has been updated recently). Findutils also supplies the xargs
#  program, which can be used to run a specified command on each file selected by 
# a search. 
#</p>

#  Approximate build time: 0.2 SBU
#  Required disk space: 48 MB
# ==== 6.8.1. Installation of Findutils ====
#<p>
#
#  Prepare Findutils for compilation: 
#</p>

#********<pre>***********
./configure --prefix=/usr                   \
            --localstatedir=/var/lib/locate \
            --host=$LFS_TGT                 \
            --build=$(build-aux/config.guess)
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
#  Install the package: 
#</p>

#********<pre>***********
make DESTDIR=$LFS install
#********</pre>**********
#<p>
#
#  Details on this package are located in [Section 8.62.2, “Contents of Findutils.”](../chapter08/findutils.html#contents-findutils)
#</p>

cd $topdir
rm -rf $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt
