#!/usr/bin/bash

# ===== 8.35. Grep-3.12 =====
topdir=$(pwd)
err=0
set -e
chapter=8035
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



srcdir=../../src/grep-3.12
tar xf ../../src/grep-3.12.tar.xz -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir

#<p>
#
#  The Grep package contains programs for searching through the contents of 
# files. 
#</p>

#  Approximate build time: 0.4 SBU
#  Required disk space: 39 MB
# ==== 8.35.1. Installation of Grep ====
#<p>
#
#  First, remove a warning about using egrep and fgrep that makes tests on some 
# packages fail: 
#</p>

#********<pre>***********
sed -i "s/echo/#echo/" src/egrep.sh
#********</pre>**********
#<p>
#
#  Prepare Grep for compilation: 
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

# ==== 8.35.2. Contents of Grep ====

#  Installed programs: egrep, fgrep, and grep
# ====== Short Descriptions ======

#--------------------------------------------
# | egrep                                    | Prints lines matching an extended regular expression. It is obsolete, usegrep -E                                 instead                                 
# | fgrep                                    | Prints lines matching a list of fixed strings. It is obsolete, usegrep -F                                 instead                                 
# | grep                                     | Prints lines matching a basic regular expression
#--------------------------------------------
cd $topdir
rm -rf $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt
