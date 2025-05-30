#!/usr/bin/bash

# ===== 6.4. Bash-5.2.37 =====
topdir=$(pwd)
err=0
set -e
chapter=6004
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

srcdir=../../src/bash-5.2.37
tar xf ../../src/bash-5.2.37.tar.gz -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir

#<p>
#
#  The Bash package contains the Bourne-Again Shell. 
#</p>

#  Approximate build time: 0.2 SBU
#  Required disk space: 68 MB
# ==== 6.4.1. Installation of Bash ====
#<p>
#
#  Prepare Bash for compilation: 
#</p>

#********<pre>***********
./configure --prefix=/usr                      \
            --build=$(sh support/config.guess) \
            --host=$LFS_TGT                    \
            --without-bash-malloc
#********</pre>**********
#<p>
#
#  The meaning of the configure options: 
#</p>

#--without-bash-malloc 
##<p>
#
#  This option turns off the use of Bash's memory allocation ( malloc 
#  ) function which is known to cause segmentation faults. By turning this option 
# off, Bash will use the malloc 
#  functions from Glibc which are more stable. 
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
#  Make a link for the programs that use sh
#  for a shell: 
#</p>

#********<pre>***********
ln -sv bash $LFS/bin/sh
#********</pre>**********
#<p>
#
#  Details on this package are located in [Section 8.36.2, “Contents of Bash.”](../chapter08/bash.html#contents-bash)
#</p>

cd $topdir
rm -rf $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt
