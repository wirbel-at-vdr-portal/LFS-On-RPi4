#!/usr/bin/bash

# ===== 8.70. Patch-2.8 =====
topdir=$(pwd)
err=0
set -e
chapter=8070
err_report() {
    echo "chapter $chapter: $(date +'%Y.%m.%d %H:%M:%S') Error $? on line $1" | tee >> $topdir/log.txt
}
trap 'err_report $LINENO' ERR
echo "---------" >> $topdir/log.txt
echo chapter $chapter: start = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt






srcdir=../../src/patch-2.8
tar xf ../../src/patch-2.8.tar.xz -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir

#<p>
#
#  The Patch package contains a program for modifying or creating files by 
# applying a “patch”
#  file typically created by the diff
#  program. 
#</p>

#  Approximate build time: 0.2 SBU
#  Required disk space: 12 MB
# ==== 8.70.1. Installation of Patch ====
#<p>
#
#  Prepare Patch for compilation: 
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

# ==== 8.70.2. Contents of Patch ====

#  Installed program: patch
# ====== Short Descriptions ======

#--------------------------------------------
# | patch                                    | Modifies files according to a patch file (A patch file is normally a difference listing created with thediff                                    program. By applying these differences to the original files,patch                                   creates the patched versions.)          
#--------------------------------------------
cd $topdir
rm -rf $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt
