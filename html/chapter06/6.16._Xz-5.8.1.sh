#!/usr/bin/bash

# ===== 6.16. Xz-5.8.1 =====
topdir=$(pwd)
err=0
set -e
chapter=6016
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

srcdir=../../src/xz-5.8.1
tar xf ../../src/xz-5.8.1.tar.xz -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir

#<p>
#
#  The Xz package contains programs for compressing and decompressing files. It 
# provides capabilities for the lzma and the newer xz compression formats. 
# Compressing text files with xz
#  yields a better compression percentage than with the traditional gzip
#  or bzip2
#  commands. 
#</p>

#  Approximate build time: 0.1 SBU
#  Required disk space: 21 MB
# ==== 6.16.1. Installation of Xz ====
#<p>
#
#  Prepare Xz for compilation: 
#</p>

#********<pre>***********
./configure --prefix=/usr                     \
            --host=$LFS_TGT                   \
            --build=$(build-aux/config.guess) \
            --disable-static                  \
            --docdir=/usr/share/doc/xz-5.8.1
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
#  Remove the libtool archive file because it is harmful for cross compilation: 
#</p>

#********<pre>***********
rm -v $LFS/usr/lib/liblzma.la
#********</pre>**********
#<p>
#
#  Details on this package are located in [Section 8.8.2, “Contents of Xz.”](../chapter08/xz.html#contents-xz)
#</p>

cd $topdir
rm -rf $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt
