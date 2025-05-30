#!/usr/bin/bash

# ===== 6.3. Ncurses-6.5 =====
topdir=$(pwd)
err=0
set -e
chapter=6003
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

srcdir=../../src/ncurses-6.5
tar xf ../../src/ncurses-6.5.tar.gz -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir

#<p>
#
#  The Ncurses package contains libraries for terminal-independent handling of 
# character screens. 
#</p>

#  Approximate build time: 0.4 SBU
#  Required disk space: 53 MB
# ==== 6.3.1. Installation of Ncurses ====
#<p>
#
#  First, run the following commands to build the “tic”
#  program on the build host: 
#</p>

#********<pre>***********
mkdir build
pushd build
  ../configure AWK=gawk
  make -C include
  make -C progs tic
popd
#********</pre>**********
#<p>
#
#  Prepare Ncurses for compilation: 
#</p>

#********<pre>***********
./configure --prefix=/usr                \
            --host=$LFS_TGT              \
            --build=$(./config.guess)    \
            --mandir=/usr/share/man      \
            --with-manpage-format=normal \
            --with-shared                \
            --without-normal             \
            --with-cxx-shared            \
            --without-debug              \
            --without-ada                \
            --disable-stripping          \
            AWK=gawk
#********</pre>**********
#<p>
#
#  The meaning of the new configure options: 
#</p>

#--with-manpage-format=normal 
##<p>
#
#  This prevents Ncurses from installing compressed manual pages, which may 
# happen if the host distribution itself has compressed manual pages. 
#</p>

#--with-shared 
##<p>
#
#  This makes Ncurses build and install shared C libraries. 
#</p>

#--without-normal 
##<p>
#
#  This prevents Ncurses from building and installing static C libraries. 
#</p>

#--without-debug 
##<p>
#
#  This prevents Ncurses from building and installing debug libraries. 
#</p>

#--with-cxx-shared 
##<p>
#
#  This makes Ncurses build and install shared C++ bindings. It also prevents it 
# building and installing static C++ bindings. 
#</p>

#--without-ada 
##<p>
#
#  This ensures that Ncurses does not build support for the Ada compiler, which 
# may be present on the host but will not be available once we enter the chroot
#  environment. 
#</p>

#--disable-stripping 
##<p>
#
#  This switch prevents the building system from using the strip
#  program from the host. Using host tools on cross-compiled programs can cause 
# failure. 
#</p>

#AWK=gawk 
##<p>
#
#  This switch prevents the building system from using the mawk
#  program from the host. Some versions of mawk
#  can cause this package to fail to build. 
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
make DESTDIR=$LFS TIC_PATH=$(pwd)/build/progs/tic install
ln -sv libncursesw.so $LFS/usr/lib/libncurses.so
sed -e 's/^#if.*XOPEN.*$/#if 1/' \
    -i $LFS/usr/include/curses.h
#********</pre>**********
#<p>
#
#  The meaning of the install options: 
#</p>

#TIC_PATH=$(pwd)/build/progs/tic 
##<p>
#
#  We need to pass the path of the newly built tic
#  program that runs on the building machine, so the terminal database can be 
# created without errors. 
#</p>

#ln -sv libncursesw.so $LFS/usr/lib/libncurses.so
##<p>
#
#  The libncurses.so 
#  library is needed by a few packages we will build soon. We create this symlink 
# to use libncursesw.so 
#  as a replacement. 
#</p>

#sed -e 's/^#if.*XOPEN.*$/#if 1/' ...
##<p>
#
#  The header file curses.h 
#  contains the definition of various Ncurses data structures. With different 
# preprocessor macro definitions two different sets of the data structure 
# definition may be used: the 8-bit definition is compatible with libncurses.so 
#  and the wide-character definition is compatible with libncursesw.so 
#  . Since we are using libncursesw.so 
#  as a replacement of libncurses.so 
#  , edit the header file so it will always use the wide-character data structure 
# definition compatible with libncursesw.so 
#  . 
#</p>
#<p>
#
#  Details on this package are located in [Section 8.30.2, “Contents of Ncurses.”](../chapter08/ncurses.html#contents-ncurses)
#</p>

cd $topdir
rm -rf $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt
