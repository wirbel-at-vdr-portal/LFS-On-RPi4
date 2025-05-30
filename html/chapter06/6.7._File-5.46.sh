#!/usr/bin/bash

# ===== 6.7. File-5.46 =====
topdir=$(pwd)
err=0
set -e
chapter=6007
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

srcdir=../../src/file-5.46
tar xf ../../src/file-5.46.tar.gz -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir

#<p>
#
#  The File package contains a utility for determining the type of a given file 
# or files. 
#</p>

#  Approximate build time: 0.1 SBU
#  Required disk space: 42 MB
# ==== 6.7.1. Installation of File ====
#<p>
#
#  The file
#  command on the build host needs to be the same version as the one we are 
# building in order to create the signature file. Run the following commands to 
# make a temporary copy of the file
#  command: 
#</p>

#********<pre>***********
mkdir build
pushd build
  ../configure --disable-bzlib      \
               --disable-libseccomp \
               --disable-xzlib      \
               --disable-zlib
  make
popd
#********</pre>**********
#<p>
#
#  The meaning of the new configure option: 
#</p>

#--disable-* 
##<p>
#
#  The configuration script attempts to use some packages from the host 
# distribution if the corresponding library files exist. It may cause compilation 
# failure if a library file exists, but the corresponding header files do not. 
# These options prevent using these unneeded capabilities from the host. 
#</p>
#<p>
#
#  Prepare File for compilation: 
#</p>

#********<pre>***********
./configure --prefix=/usr --host=$LFS_TGT --build=$(./config.guess)
#********</pre>**********
#<p>
#
#  Compile the package: 
#</p>

#********<pre>***********
make FILE_COMPILE=$(pwd)/build/src/file
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
#  Remove the libtool archive file because it is harmful for cross compilation: 
#</p>

#********<pre>***********
rm -v $LFS/usr/lib/libmagic.la
#********</pre>**********
#<p>
#
#  Details on this package are located in [Section 8.11.2, “Contents of File.”](../chapter08/file.html#contents-file)
#</p>

cd $topdir
rm -rf $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt
