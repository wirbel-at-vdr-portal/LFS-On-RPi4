#!/usr/bin/bash

# ===== 7.8. Bison-3.8.2 =====
topdir=$(pwd)
err=0
set -e
chapter=7008
err_report() {
    echo "chapter $chapter: $(date +'%Y.%m.%d %H:%M:%S') Error $? on line $1" | tee >> $topdir/log.txt
}
trap 'err_report $LINENO' ERR
echo "---------" >> $topdir/log.txt
echo chapter $chapter: start = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt


srcdir=../src/bison-3.8.2
tar xf ../src/bison-3.8.2.tar.xz -C ../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir

#<p>
#
#  The Bison package contains a parser generator. 
#</p>

#  Approximate build time: 0.2 SBU
#  Required disk space: 58 MB
# ==== 7.8.1. Installation of Bison ====
#<p>
#
#  Prepare Bison for compilation: 
#</p>

#********<pre>***********
./configure --prefix=/usr \
            --docdir=/usr/share/doc/bison-3.8.2
#********</pre>**********
#<p>
#
#  The meaning of the new configure option: 
#</p>

#--docdir=/usr/share/doc/bison-3.8.2 
##<p>
#
#  This tells the build system to install bison documentation into a versioned 
# directory. 
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
#  Install the package: 
#</p>

#********<pre>***********
make install
#********</pre>**********
#<p>
#
#  Details on this package are located in [Section 8.34.2, “Contents of Bison.”](../chapter08/bison.html#contents-bison)
#</p>

cd $topdir
rm -rf $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt
