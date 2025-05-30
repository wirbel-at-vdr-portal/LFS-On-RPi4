#!/usr/bin/bash

# ===== 6.5. Coreutils-9.7 =====
topdir=$(pwd)
err=0
set -e
chapter=6005
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

srcdir=../../src/coreutils-9.7
tar xf ../../src/coreutils-9.7.tar.xz -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir

#<p>
#
#  The Coreutils package contains the basic utility programs needed by every 
# operating system. 
#</p>

#  Approximate build time: 0.3 SBU
#  Required disk space: 181 MB
# ==== 6.5.1. Installation of Coreutils ====
#<p>
#
#  Prepare Coreutils for compilation: 
#</p>

#********<pre>***********
./configure --prefix=/usr                     \
            --host=$LFS_TGT                   \
            --build=$(build-aux/config.guess) \
            --enable-install-program=hostname \
            --enable-no-install-program=kill,uptime
#********</pre>**********
#<p>
#
#  The meaning of the configure options: 
#</p>

#--enable-install-program=hostname 
##<p>
#
#  This enables the hostname
#  binary to be built and installed – it is disabled by default but is required 
# by the Perl test suite. 
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
#  Move programs to their final expected locations. Although this is not 
# necessary in this temporary environment, we must do so because some programs 
# hardcode executable locations: 
#</p>

#********<pre>***********
mv -v $LFS/usr/bin/chroot              $LFS/usr/sbin
mkdir -pv $LFS/usr/share/man/man8
mv -v $LFS/usr/share/man/man1/chroot.1 $LFS/usr/share/man/man8/chroot.8
sed -i 's/"1"/"8"/'                    $LFS/usr/share/man/man8/chroot.8
#********</pre>**********
#<p>
#
#  Details on this package are located in [Section 8.59.2, “Contents of Coreutils.”](../chapter08/coreutils.html#contents-coreutils)
#</p>

cd $topdir
rm -rf $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt
