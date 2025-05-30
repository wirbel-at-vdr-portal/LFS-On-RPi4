#!/usr/bin/bash

# ===== 6.6. Diffutils-3.12 =====
topdir=$(pwd)
err=0
set -e
chapter=6006
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

srcdir=../../src/diffutils-3.12
tar xf ../../src/diffutils-3.12.tar.xz -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir

#<p>
#
#  The Diffutils package contains programs that show the differences between 
# files or directories. 
#</p>

#  Approximate build time: 0.1 SBU
#  Required disk space: 35 MB
# ==== 6.6.1. Installation of Diffutils ====
#<p>
#
#  Prepare Diffutils for compilation: 
#</p>

#********<pre>***********
./configure --prefix=/usr   \
            --host=$LFS_TGT \
            gl_cv_func_strcasecmp_works=y \
            --build=$(./build-aux/config.guess)
#********</pre>**********
#<p>
#
#  The meaning of the configure options: 
#</p>

#gl_cv_func_strcasecmp_works=y 
##<p>
#
#  This option specify the result of a check for the strcasecmp 
#  . The check requires running a compiled C program, and this is impossible 
# during cross-compilation because in general a cross-compiled program cannot run 
# on the host distro. Normally for such a check the configure
#  script would use a fall-back value for cross-compilation, but the fall-back 
# value for this check is absent and the configure
#  script would have no value to use and error out. The upstream has already 
# fixed the issue, but to apply the fix we'd need to run autoconf
#  that the host distro may lack. So we just specify the check result ( y 
#  as we know the strcasecmp 
#  function in Glibc-2.41 works fine) instead, then configure
#  will just use the specified value and skip the check. 
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
#  Details on this package are located in [Section 8.60.2, “Contents of Diffutils.”](../chapter08/diffutils.html#contents-diffutils)
#</p>

cd $topdir
rm -rf $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt
