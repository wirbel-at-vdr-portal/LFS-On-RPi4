#!/usr/bin/bash

# ===== 6.17. Binutils-2.44 - Pass 2 =====
topdir=$(pwd)
err=0
set -e
chapter=6017
err_report() {
    echo "chapter $chapter: $(date +'%Y.%m.%d %H:%M:%S') Error $? on line $1" | tee >> $topdir/log.txt
}
trap 'err_report $LINENO' ERR
echo "---------" >> $topdir/log.txt
echo chapter $chapter: start = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt

if [[ -z "${LFS}" ]]; then
  echo "ERROR: 'LFS' is not set.";stop
  exit 1
fi

grep -q $LFS /proc/mounts || err=1
if [ "$err" -eq "1" ]; then
  echo "ERROR: The '$LFS' partition must be mounted.";stop
  exit 1
fi

if [ "$EUID" -eq "0" ]; then
  echo "ERROR: Please run as user lfs"
  exit 1
fi

srcdir=../../src/binutils-2.44
tar xf ../../src/binutils-2.44.tar.xz -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir

#<p>
#
#  The Binutils package contains a linker, an assembler, and other tools for 
# handling object files. 
#</p>

#  Approximate build time: 0.4 SBU
#  Required disk space: 539 MB
# ==== 6.17.1. Installation of Binutils ====
#<p>
#
#  Binutils building system relies on an shipped libtool copy to link against 
# internal static libraries, but the libiberty and zlib copies shipped in the 
# package do not use libtool. This inconsistency may cause produced binaries 
# mistakenly linked against libraries from the host distro. Work around this 
# issue: 
#</p>

#********<pre>***********
sed '6031s/$add_dir//' -i ltmain.sh
#********</pre>**********
#<p>
#
#  Create a separate build directory again: 
#</p>

#********<pre>***********
mkdir -v build
cd       build
#********</pre>**********
#<p>
#
#  Prepare Binutils for compilation: 
#</p>

#********<pre>***********
../configure                   \
    --prefix=/usr              \
    --build=$(../config.guess) \
    --host=$LFS_TGT            \
    --disable-nls              \
    --enable-shared            \
    --enable-gprofng=no        \
    --disable-werror           \
    --enable-64-bit-bfd        \
    --enable-new-dtags         \
    --enable-default-hash-style=gnu
#********</pre>**********
#<p>
#
#  The meaning of the new configure options: 
#</p>

#--enable-shared 
##<p>
#
#  Builds libbfd 
#  as a shared library. 
#</p>

#--enable-64-bit-bfd 
##<p>
#
#  Enables 64-bit support (on hosts with smaller word sizes). This may not be 
# needed on 64-bit systems, but it does no harm. 
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
#  Install the package: 
#</p>

#********<pre>***********
make DESTDIR=$LFS install
#********</pre>**********
#<p>
#
#  Remove the libtool archive files because they are harmful for cross 
# compilation, and remove unnecessary static libraries: 
#</p>

#********<pre>***********
rm -v $LFS/usr/lib/lib{bfd,ctf,ctf-nobfd,opcodes,sframe}.{a,la}
#********</pre>**********
#<p>
#
#  Details on this package are located in [Section 8.20.2, “Contents of Binutils.”](../chapter08/binutils.html#contents-binutils)
#</p>

cd $topdir
rm -rf $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt
