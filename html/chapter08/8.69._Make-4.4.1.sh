#!/usr/bin/bash

# ===== 8.69. Make-4.4.1 =====
topdir=$(pwd)
err=0
set -e
chapter=8069
err_report() {
    echo "chapter $chapter: $(date +'%Y.%m.%d %H:%M:%S') Error $? on line $1" | tee >> $topdir/log.txt
}
trap 'err_report $LINENO' ERR
echo "---------" >> $topdir/log.txt
echo chapter $chapter: start = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt






srcdir=../../src/make-4.4.1
tar xf ../../src/make-4.4.1.tar.gz -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir

#<p>
#
#  The Make package contains a program for controlling the generation of 
# executables and other non-source files of a package from source files. 
#</p>

#  Approximate build time: 0.7 SBU
#  Required disk space: 13 MB
# ==== 8.69.1. Installation of Make ====
#<p>
#
#  Prepare Make for compilation: 
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
chown -R tester .
su tester -c "PATH=$PATH #make check"
#********</pre>**********
#<p>
#
#  Install the package: 
#</p>

#********<pre>***********
make install
#********</pre>**********

# ==== 8.69.2. Contents of Make ====

#  Installed program: make
# ====== Short Descriptions ======

#--------------------------------------------
# | make                                     | Automatically determines which pieces of a package need to be (re)compiled and then issues the relevant commands
#--------------------------------------------
cd $topdir
rm -rf $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt
