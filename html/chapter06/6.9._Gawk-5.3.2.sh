#!/usr/bin/bash

# ===== 6.9. Gawk-5.3.2 =====
topdir=$(pwd)
err=0
set -e
chapter=6009
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

srcdir=../../src/gawk-5.3.2
tar xf ../../src/gawk-5.3.2.tar.xz -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir

#<p>
#
#  The Gawk package contains programs for manipulating text files. 
#</p>

#  Approximate build time: 0.1 SBU
#  Required disk space: 47 MB
# ==== 6.9.1. Installation of Gawk ====
#<p>
#
#  First, ensure some unneeded files are not installed: 
#</p>

#********<pre>***********
sed -i 's/extras//' Makefile.in
#********</pre>**********
#<p>
#
#  Prepare Gawk for compilation: 
#</p>

#********<pre>***********
./configure --prefix=/usr   \
            --host=$LFS_TGT \
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
#  Details on this package are located in [Section 8.61.2, “Contents of Gawk.”](../chapter08/gawk.html#contents-gawk)
#</p>

cd $topdir
rm -rf $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt
