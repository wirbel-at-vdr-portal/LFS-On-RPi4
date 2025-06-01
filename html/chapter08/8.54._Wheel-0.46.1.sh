#!/usr/bin/bash

# ===== 8.54. Wheel-0.46.1 =====
topdir=$(pwd)
err=0
set -e
chapter=8054
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



srcdir=../../src/wheel-0.46.1
tar xf ../../src/wheel-0.46.1.tar.gz -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir

#<p>
#
#  Wheel is a Python library that is the reference implementation of the Python 
# wheel packaging standard. 
#</p>

#  Approximate build time: less than 0.1 SBU
#  Required disk space: 1.6 MB
# ==== 8.54.1. Installation of Wheel ====
#<p>
#
#  Compile Wheel with the following command: 
#</p>

#********<pre>***********
pip3 wheel -w dist --no-cache-dir --no-build-isolation --no-deps $PWD
#********</pre>**********
#<p>
#
#  Install Wheel with the following command: 
#</p>

#********<pre>***********
pip3 install --no-index --find-links dist wheel
#********</pre>**********

# ==== 8.54.2. Contents of Wheel ====

#  Installed program: wheel
#  Installed directories: /usr/lib/python3.13/site-packages/wheel and /usr/lib/python3.13/site-packages/wheel-0.46.1.dist-info
# ====== Short Descriptions ======

#--------------------------------------------
# | wheel                                    | is a utility to unpack, pack, or convert wheel archives
#--------------------------------------------
cd $topdir
rm -rf $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt
