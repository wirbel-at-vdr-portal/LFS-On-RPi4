#!/usr/bin/bash

# ===== 8.68. Libpipeline-1.5.8 =====
topdir=$(pwd)
err=0
set -e
chapter=8068
err_report() {
    echo "chapter $chapter: $(date +'%Y.%m.%d %H:%M:%S') Error $? on line $1" | tee >> $topdir/log.txt
}
trap 'err_report $LINENO' ERR
echo "---------" >> $topdir/log.txt
echo chapter $chapter: start = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt






srcdir=../../src/libpipeline-1.5.8
tar xf ../../src/libpipeline-1.5.8.tar.gz -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir

#<p>
#
#  The Libpipeline package contains a library for manipulating pipelines of 
# subprocesses in a flexible and convenient way. 
#</p>

#  Approximate build time: 0.1 SBU
#  Required disk space: 11 MB
# ==== 8.68.1. Installation of Libpipeline ====
#<p>
#
#  Prepare Libpipeline for compilation: 
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

# ==== 8.68.2. Contents of Libpipeline ====

#  Installed library: libpipeline.so
# ====== Short Descriptions ======

#--------------------------------------------
# | libpipeline                              | This library is used to safely construct pipelines between subprocesses
#--------------------------------------------
cd $topdir
rm -rf $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt
