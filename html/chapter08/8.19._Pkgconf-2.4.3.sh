#!/usr/bin/bash

# ===== 8.19. Pkgconf-2.4.3 =====
topdir=$(pwd)
err=0
set -e
chapter=8019
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



srcdir=../../src/pkgconf-2.4.3
tar xf ../../src/pkgconf-2.4.3.tar.xz -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir

#<p>
#
#  The pkgconf package is a successor to pkg-config and contains a tool for 
# passing the include path and/or library paths to build tools during the 
# configure and make phases of package installations. 
#</p>

#  Approximate build time: less than 0.1 SBU
#  Required disk space: 4.7 MB
# ==== 8.19.1. Installation of Pkgconf ====
#<p>
#
#  Prepare Pkgconf for compilation: 
#</p>

#********<pre>***********
./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/pkgconf-2.4.3
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
#  Install the package: 
#</p>

#********<pre>***********
make install
#********</pre>**********
#<p>
#
#  To maintain compatibility with the original Pkg-config create two symlinks: 
#</p>

#********<pre>***********
ln -sv pkgconf   /usr/bin/pkg-config
ln -sv pkgconf.1 /usr/share/man/man1/pkg-config.1
#********</pre>**********

# ==== 8.19.2. Contents of Pkgconf ====

#  Installed programs: pkgconf, pkg-config (link to pkgconf), and bomtool
#  Installed library: libpkgconf.so
#  Installed directory: /usr/share/doc/pkgconf-2.4.3
# ====== Short Descriptions ======

#--------------------------------------------
# | pkgconf                                  | Returns meta information for the specified library or package
# | bomtool                                  | Generates a Software Bill Of Materials from pkg-config .pc files
# | libpkgconf                               | Contains most of pkgconf's functionality, while allowing other tools like IDEs and compilers to use its frameworks
#--------------------------------------------
cd $topdir
rm -rf $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt
