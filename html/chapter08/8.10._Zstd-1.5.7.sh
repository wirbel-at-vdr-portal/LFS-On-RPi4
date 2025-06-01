#!/usr/bin/bash

# ===== 8.10. Zstd-1.5.7 =====
topdir=$(pwd)
err=0
set -e
chapter=8010
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



srcdir=../../src/zstd-1.5.7
tar xf ../../src/zstd-1.5.7.tar.gz -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir

#<p>
#
#  Zstandard is a real-time compression algorithm, providing high compression 
# ratios. It offers a very wide range of compression / speed trade-offs, while 
# being backed by a very fast decoder. 
#</p>

#  Approximate build time: 0.4 SBU
#  Required disk space: 85 MB
# ==== 8.10.1. Installation of Zstd ====
#<p>
#
#  Compile the package: 
#</p>

#********<pre>***********
make prefix=/usr
#********</pre>**********

# ====== Note ======
#<p>
#
#  In the test output there are several places that indicate 'failed'. These are 
# expected and only 'FAIL' is an actual test failure. There should be no test 
# failures. 
#</p>
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
make prefix=/usr install
#********</pre>**********
#<p>
#
#  Remove the static library: 
#</p>

#********<pre>***********
rm -v /usr/lib/libzstd.a
#********</pre>**********

# ==== 8.10.2. Contents of Zstd ====

#  Installed programs: zstd, zstdcat (link to zstd), zstdgrep, zstdless, zstdmt (link to zstd), and unzstd (link to zstd)
#  Installed library: libzstd.so
# ====== Short Descriptions ======

#--------------------------------------------
# | zstd                                     | Compresses or decompresses files using the ZSTD format
# | zstdgrep                                 | Runs                                    grep                                    on ZSTD compressed files                
# | zstdless                                 | Runs                                    less                                    on ZSTD compressed files                
# | libzstd                                  | The library implementing lossless data compression, using the ZSTD algorithm
#--------------------------------------------
cd $topdir
rm -rf $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt
