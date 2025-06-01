#!/usr/bin/bash

# ===== 8.71. Tar-1.35 =====
topdir=$(pwd)
err=0
set -e
chapter=8071
err_report() {
    echo "chapter $chapter: $(date +'%Y.%m.%d %H:%M:%S') Error $? on line $1" | tee >> $topdir/log.txt
}
trap 'err_report $LINENO' ERR
echo "---------" >> $topdir/log.txt
echo chapter $chapter: start = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt






srcdir=../../src/tar-1.35
tar xf ../../src/tar-1.35.tar.xz -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir

#<p>
#
#  The Tar package provides the ability to create tar archives as well as perform 
# various other kinds of archive manipulation. Tar can be used on previously 
# created archives to extract files, to store additional files, or to update or 
# list files which were already stored. 
#</p>

#  Approximate build time: 0.6 SBU
#  Required disk space: 43 MB
# ==== 8.71.1. Installation of Tar ====
#<p>
#
#  Prepare Tar for compilation: 
#</p>

#********<pre>***********
FORCE_UNSAFE_CONFIGURE=1  \
./configure --prefix=/usr
#********</pre>**********
#<p>
#
#  The meaning of the configure option: 
#</p>

#FORCE_UNSAFE_CONFIGURE=1 
##<p>
#
#  This forces the test for mknod 
#  to be run as root 
#  . It is generally considered dangerous to run this test as the root 
#  user, but as it is being run on a system that has only been partially built, 
# overriding it is OK. 
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
#  One test, capabilities: binary store/restore, is known to fail if it is run 
# because LFS lacks selinux, but will be skipped if the host kernel does not 
# support extended attributes or security labels on the filesystem used for 
# building LFS. 
#</p>
#<p>
#
#  Install the package: 
#</p>

#********<pre>***********
make install
make -C doc install-html docdir=/usr/share/doc/tar-1.35
#********</pre>**********

# ==== 8.71.2. Contents of Tar ====

#  Installed programs: tar
#  Installed directory: /usr/share/doc/tar-1.35
# ====== Short Descriptions ======

#--------------------------------------------
# | tar                                      | Creates, extracts files from, and lists the contents of archives, also known as tarballs
#--------------------------------------------
cd $topdir
rm -rf $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt
