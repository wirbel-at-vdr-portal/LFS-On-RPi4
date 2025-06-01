#!/usr/bin/bash

# ===== 8.60. Diffutils-3.12 =====
topdir=$(pwd)
err=0
set -e
chapter=8060
err_report() {
    echo "chapter $chapter: $(date +'%Y.%m.%d %H:%M:%S') Error $? on line $1" | tee >> $topdir/log.txt
}
trap 'err_report $LINENO' ERR
echo "---------" >> $topdir/log.txt
echo chapter $chapter: start = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt






srcdir=../../src/diffutils-3.12
tar xf ../../src/diffutils-3.12.tar.xz -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir

#<p>
#
#  The Diffutils package contains programs that show the differences between 
# files or directories. 
#</p>

#  Approximate build time: 0.4 SBU
#  Required disk space: 50 MB
# ==== 8.60.1. Installation of Diffutils ====
#<p>
#
#  Prepare Diffutils for compilation: 
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

# ==== 8.60.2. Contents of Diffutils ====

#  Installed programs: cmp, diff, diff3, and sdiff
# ====== Short Descriptions ======

#--------------------------------------------
# | cmp                                      | Compares two files and reports any differences byte by byte
# | diff                                     | Compares two files or directories and reports which lines in the files differ
# | diff3                                    | Compares three files line by line       
# | sdiff                                    | Merges two files and interactively outputs the results
#--------------------------------------------
cd $topdir
rm -rf $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt
