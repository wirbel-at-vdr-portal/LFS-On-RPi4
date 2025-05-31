#!/usr/bin/bash

# ===== 7.11. Texinfo-7.2 =====
topdir=$(pwd)
err=0
set -e
chapter=7011
err_report() {
    echo "chapter $chapter: $(date +'%Y.%m.%d %H:%M:%S') Error $? on line $1" | tee >> $topdir/log.txt
}
trap 'err_report $LINENO' ERR
echo "---------" >> $topdir/log.txt
echo chapter $chapter: start = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt


srcdir=../src/texinfo-7.2
tar xf ../src/texinfo-7.2.tar.xz -C ../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir

#<p>
#
#  The Texinfo package contains programs for reading, writing, and converting 
# info pages. 
#</p>

#  Approximate build time: 0.2 SBU
#  Required disk space: 152 MB
# ==== 7.11.1. Installation of Texinfo ====
#<p>
#
#  Prepare Texinfo for compilation: 
#</p>

#********<pre>***********
./configure --prefix=/usr
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
make install
#********</pre>**********
#<p>
#
#  Details on this package are located in [Section 8.72.2, “Contents of Texinfo.”](../chapter08/texinfo.html#contents-texinfo)
#</p>

cd $topdir
rm -rf $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt
