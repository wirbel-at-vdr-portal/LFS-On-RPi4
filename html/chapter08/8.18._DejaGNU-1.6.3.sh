#!/usr/bin/bash

# ===== 8.18. DejaGNU-1.6.3 =====
topdir=$(pwd)
err=0
set -e
chapter=8018
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



srcdir=../../src/dejagnu-1.6.3
tar xf ../../src/dejagnu-1.6.3.tar.gz -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir

#<p>
#
#  The DejaGnu
#  package contains a framework for running test suites on GNU tools. It is 
# written in expect
#  , which itself uses Tcl
#  (Tool Command Language). 
#</p>

#  Approximate build time: less than 0.1 SBU
#  Required disk space: 6.9 MB
# ==== 8.18.1. Installation of DejaGNU ====
#<p>
#
#  The upstream recommends building DejaGNU in a dedicated build directory: 
#</p>

#********<pre>***********
mkdir -v build
cd       build
#********</pre>**********
#<p>
#
#  Prepare DejaGNU for compilation: 
#</p>

#********<pre>***********
../configure --prefix=/usr
makeinfo --html --no-split -o doc/dejagnu.html ../doc/dejagnu.texi
makeinfo --plaintext       -o doc/dejagnu.txt  ../doc/dejagnu.texi
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
install -v -dm755  /usr/share/doc/dejagnu-1.6.3
install -v -m644   doc/dejagnu.{html,txt} /usr/share/doc/dejagnu-1.6.3
#********</pre>**********

# ==== 8.18.2. Contents of DejaGNU ====

#  Installed program: dejagnu and runtest
# ====== Short Descriptions ======

#--------------------------------------------
# | dejagnu                                  | DejaGNU auxiliary command launcher      
# | runtest                                  | A wrapper script that locates the properexpect                                  shell and then runs DejaGNU             
#--------------------------------------------
cd $topdir
rm -rf $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt
