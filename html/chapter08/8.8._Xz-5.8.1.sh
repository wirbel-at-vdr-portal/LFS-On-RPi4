#!/usr/bin/bash

# ===== 8.8. Xz-5.8.1 =====
topdir=$(pwd)
err=0
set -e
chapter=8008
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



srcdir=../../src/xz-5.8.1
tar xf ../../src/xz-5.8.1.tar.xz -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir

#<p>
#
#  The Xz package contains programs for compressing and decompressing files. It 
# provides capabilities for the lzma and the newer xz compression formats. 
# Compressing text files with xz
#  yields a better compression percentage than with the traditional gzip
#  or bzip2
#  commands. 
#</p>

#  Approximate build time: 0.1 SBU
#  Required disk space: 21 MB
# ==== 8.8.1. Installation of Xz ====
#<p>
#
#  Prepare Xz for compilation with: 
#</p>

#********<pre>***********
./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/xz-5.8.1
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

# ==== 8.8.2. Contents of Xz ====

#  Installed programs: lzcat (link to xz), lzcmp (link to xzdiff), lzdiff (link to xzdiff), lzegrep (link to xzgrep), lzfgrep (link to xzgrep), lzgrep (link to xzgrep), lzless (link to xzless), lzma (link to xz), lzmadec, lzmainfo, lzmore (link to xzmore), unlzma (link to xz), unxz (link to xz), xz, xzcat (link to xz), xzcmp (link to xzdiff), xzdec, xzdiff, xzegrep (link to xzgrep), xzfgrep (link to xzgrep), xzgrep, xzless, and xzmore
#  Installed libraries: liblzma.so
#  Installed directories: /usr/include/lzma and /usr/share/doc/xz-5.8.1
# ====== Short Descriptions ======

#--------------------------------------------
# | lzcat                                    | Decompresses to standard output         
# | lzcmp                                    | Runs                                    cmp                                     on LZMA compressed files                
# | lzdiff                                   | Runs                                    diff                                    on LZMA compressed files                
# | lzegrep                                  | Runs                                    egrep                                   on LZMA compressed files                
# | lzfgrep                                  | Runs                                    fgrep                                   on LZMA compressed files                
# | lzgrep                                   | Runs                                    grep                                    on LZMA compressed files                
# | lzless                                   | Runs                                    less                                    on LZMA compressed files                
# | lzma                                     | Compresses or decompresses files using the LZMA format
# | lzmadec                                  | A small and fast decoder for LZMA compressed files
# | lzmainfo                                 | Shows information stored in the LZMA compressed file header
# | lzmore                                   | Runs                                    more                                    on LZMA compressed files                
# | unlzma                                   | Decompresses files using the LZMA format
# | unxz                                     | Decompresses files using the XZ format  
# | xz                                       | Compresses or decompresses files using the XZ format
# | xzcat                                    | Decompresses to standard output         
# | xzcmp                                    | Runs                                    cmp                                     on XZ compressed files                  
# | xzdec                                    | A small and fast decoder for XZ compressed files
# | xzdiff                                   | Runs                                    diff                                    on XZ compressed files                  
# | xzegrep                                  | Runs                                    egrep                                   on XZ compressed files                  
# | xzfgrep                                  | Runs                                    fgrep                                   on XZ compressed files                  
# | xzgrep                                   | Runs                                    grep                                    on XZ compressed files                  
# | xzless                                   | Runs                                    less                                    on XZ compressed files                  
# | xzmore                                   | Runs                                    more                                    on XZ compressed files                  
# | liblzma                                  | The library implementing lossless, block-sorting data compression, using the Lempel-Ziv-Markov chain algorithm
#--------------------------------------------
cd $topdir
rm -rf $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt
