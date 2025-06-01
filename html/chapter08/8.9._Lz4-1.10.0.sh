#!/usr/bin/bash

# ===== 8.9. Lz4-1.10.0 =====
topdir=$(pwd)
err=0
set -e
chapter=8009
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



srcdir=../../src/lz4-1.10.0
tar xf ../../src/lz4-1.10.0.tar.gz -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir

#<p>
#
#  Lz4 is a lossless compression algorithm, providing compression speed greater 
# than 500 MB/s per core. It features an extremely fast decoder, with speed in 
# multiple GB/s per core. Lz4 can work with Zstandard to allow both algorithms to 
# compress data faster. 
#</p>

#  Approximate build time: 0.1 SBU
#  Required disk space: 4.2 MB
# ==== 8.9.1. Installation of Lz4 ====
#<p>
#
#  Compile the package: 
#</p>

#********<pre>***********
make BUILD_STATIC=no PREFIX=/usr
#********</pre>**********
#<p>
#
#  To test the results, issue: 
#</p>

#********<pre>***********
make -j1 check
#********</pre>**********
#<p>
#
#  Install the package: 
#</p>

#********<pre>***********
make BUILD_STATIC=no PREFIX=/usr install
#********</pre>**********

# ==== 8.9.2. Contents of Lz4 ====

#  Installed programs: lz4, lz4c (link to lz4), lz4cat (link to lz4), and unlz4 (link to lz4)
#  Installed library: liblz4.so
# ====== Short Descriptions ======

#--------------------------------------------
# | lz4                                      | Compresses or decompresses files using the LZ4 format
# | lz4c                                     | Compresses files using the LZ4 format   
# | lz4cat                                   | Lists the contents of a file compressed using the LZ4 format
# | unlz4                                    | Decompresses files using the LZ4 format 
# | liblz4                                   | The library implementing lossless data compression, using the LZ4 algorithm
#--------------------------------------------
cd $topdir
rm -rf $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt
