#!/usr/bin/bash

# ===== 8.7. Bzip2-1.0.8 =====
topdir=$(pwd)
err=0
set -e
chapter=8007
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



srcdir=../../src/bzip2-1.0.8
tar xf ../../src/bzip2-1.0.8.tar.gz -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir

#<p>
#
#  The Bzip2 package contains programs for compressing and decompressing files. 
# Compressing text files with bzip2
#  yields a much better compression percentage than with the traditional gzip
#  . 
#</p>

#  Approximate build time: less than 0.1 SBU
#  Required disk space: 7.2 MB
# ==== 8.7.1. Installation of Bzip2 ====
#<p>
#
#  Apply a patch that will install the documentation for this package: 
#</p>

#********<pre>***********
patch -Np1 -i ../bzip2-1.0.8-install_docs-1.patch
#********</pre>**********
#<p>
#
#  The following command ensures installation of symbolic links are relative: 
#</p>

#********<pre>***********
sed -i 's@\(ln -s -f \)$(PREFIX)/bin/@\1@' Makefile
#********</pre>**********
#<p>
#
#  Ensure the man pages are installed into the correct location: 
#</p>

#********<pre>***********
sed -i "s@(PREFIX)/man@(PREFIX)/share/man@g" Makefile
#********</pre>**********
#<p>
#
#  Prepare Bzip2 for compilation with: 
#</p>

#********<pre>***********
make -f Makefile-libbz2_so
make clean
#********</pre>**********
#<p>
#
#  The meaning of the make parameter: 
#</p>

#-f Makefile-libbz2_so 
##<p>
#
#  This will cause Bzip2 to be built using a different Makefile 
#  file, in this case the Makefile-libbz2_so 
#  file, which creates a dynamic libbz2.so 
#  library and links the Bzip2 utilities against it. 
#</p>
#<p>
#
#  Compile and test the package: 
#</p>

#********<pre>***********
make
#********</pre>**********
#<p>
#
#  Install the programs: 
#</p>

#********<pre>***********
make PREFIX=/usr install
#********</pre>**********
#<p>
#
#  Install the shared library: 
#</p>

#********<pre>***********
cp -av libbz2.so.* /usr/lib
ln -sv libbz2.so.1.0.8 /usr/lib/libbz2.so
#********</pre>**********
#<p>
#
#  Install the shared bzip2
#  binary into the /usr/bin 
#  directory, and replace two copies of bzip2
#  with symlinks: 
#</p>

#********<pre>***********
cp -v bzip2-shared /usr/bin/bzip2
for i in /usr/bin/{bzcat,bunzip2}; do
  ln -sfv bzip2 $i
done
#********</pre>**********
#<p>
#
#  Remove a useless static library: 
#</p>

#********<pre>***********
rm -fv /usr/lib/libbz2.a
#********</pre>**********

# ==== 8.7.2. Contents of Bzip2 ====

#  Installed programs: bunzip2 (link to bzip2), bzcat (link to bzip2), bzcmp (link to bzdiff), bzdiff, bzegrep (link to bzgrep), bzfgrep (link to bzgrep), bzgrep, bzip2, bzip2recover, bzless (link to bzmore), and bzmore
#  Installed libraries: libbz2.so
#  Installed directory: /usr/share/doc/bzip2-1.0.8
# ====== Short Descriptions ======

#--------------------------------------------
# | bunzip2                                  | Decompresses bzipped files              
# | bzcat                                    | Decompresses to standard output         
# | bzcmp                                    | Runs                                    cmp                                     on bzipped files                        
# | bzdiff                                   | Runs                                    diff                                    on bzipped files                        
# | bzegrep                                  | Runs                                    egrep                                   on bzipped files                        
# | bzfgrep                                  | Runs                                    fgrep                                   on bzipped files                        
# | bzgrep                                   | Runs                                    grep                                    on bzipped files                        
# | bzip2                                    | Compresses files using the Burrows-Wheeler block sorting text compression algorithm with Huffman coding; the compression rate is better than that achieved by more conventional compressors using“                                       Lempel-Ziv                              ”                                       algorithms, like                        gzip                                    
# | bzip2recover                             | Tries to recover data from damaged bzipped files
# | bzless                                   | Runs                                    less                                    on bzipped files                        
# | bzmore                                   | Runs                                    more                                    on bzipped files                        
# | libbz2                                   | The library implementing lossless, block-sorting data compression, using the Burrows-Wheeler algorithm
#--------------------------------------------
cd $topdir
rm -rf $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt
