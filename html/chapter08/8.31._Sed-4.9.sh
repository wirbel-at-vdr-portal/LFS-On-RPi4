#!/usr/bin/bash

# ===== 8.31. Sed-4.9 =====
topdir=$(pwd)
err=0
set -e
chapter=8031
err_report() {
    echo "chapter $chapter: $(date +'%Y.%m.%d %H:%M:%S') Error $? on line $1" | tee >> $topdir/log.txt
}
trap 'err_report $LINENO' ERR
echo "---------" >> $topdir/log.txt
echo chapter $chapter: start = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt




if [ "$EUID" -ne "0" ]; then
  echo "ERROR: Please run as root, not as user id = $EUID";stop
  exit 1
fi

grep -q $LFS/dev/pts /proc/mounts || err=1
if [ "$err" -eq "1" ]; then
  echo "ERROR: The '$LFS/dev/pts' partition must be mounted.";stop
  exit 1
fi

grep -q $LFS/dev /proc/mounts || err=1
if [ "$err" -eq "1" ]; then
  echo "ERROR: The '$LFS/dev' partition must be mounted.";stop
  exit 1
fi

grep -q $LFS/proc /proc/mounts || err=1
if [ "$err" -eq "1" ]; then
  echo "ERROR: The '$LFS/proc' partition must be mounted.";stop
  exit 1
fi

grep -q $LFS/sys /proc/mounts || err=1
if [ "$err" -eq "1" ]; then
  echo "ERROR: The '$LFS/sys' partition must be mounted.";stop
  exit 1
fi

grep -q $LFS/run /proc/mounts || err=1
if [ "$err" -eq "1" ]; then
  echo "ERROR: The '$LFS/run' partition must be mounted.";stop
  exit 1
fi



srcdir=../../src/sed-4.9
tar xf ../../src/sed-4.9.tar.xz -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir

#<p>
#
#  The Sed package contains a stream editor. 
#</p>

#  Approximate build time: 0.3 SBU
#  Required disk space: 30 MB
# ==== 8.31.1. Installation of Sed ====
#<p>
#
#  Prepare Sed for compilation: 
#</p>

#********<pre>***********
./configure --prefix=/usr
#********</pre>**********
#<p>
#
#  Compile the package and generate the HTML documentation: 
#</p>

#********<pre>***********
make
make html
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
#  Install the package and its documentation: 
#</p>

#********<pre>***********
make install
install -d -m755           /usr/share/doc/sed-4.9
install -m644 doc/sed.html /usr/share/doc/sed-4.9
#********</pre>**********

# ==== 8.31.2. Contents of Sed ====

#  Installed program: sed
#  Installed directory: /usr/share/doc/sed-4.9
# ====== Short Descriptions ======

#--------------------------------------------
# | sed                                      | Filters and transforms text files in a single pass
#--------------------------------------------
cd $topdir
rm -rf $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt
