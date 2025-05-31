#!/usr/bin/bash

# ===== 7.12. Util-linux-2.41 =====
topdir=$(pwd)
err=0
set -e
chapter=7012
err_report() {
    echo "chapter $chapter: $(date +'%Y.%m.%d %H:%M:%S') Error $? on line $1" | tee >> $topdir/log.txt
}
trap 'err_report $LINENO' ERR
echo "---------" >> $topdir/log.txt
echo chapter $chapter: start = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt


srcdir=../src/util-linux-2.41
tar xf ../src/util-linux-2.41.tar.xz -C ../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir

#<p>
#
#  The Util-linux package contains miscellaneous utility programs. 
#</p>

#  Approximate build time: 0.2 SBU
#  Required disk space: 182 MB
# ==== 7.12.1. Installation of Util-linux ====
#<p>
#
#  The FHS recommends using the /var/lib/hwclock 
#  directory instead of the usual /etc 
#  directory as the location for the adjtime 
#  file. Create this directory with: 
#</p>

#********<pre>***********
mkdir -pv /var/lib/hwclock
#********</pre>**********
#<p>
#
#  Prepare Util-linux for compilation: 
#</p>

#********<pre>***********
./configure --libdir=/usr/lib     \
            --runstatedir=/run    \
            --disable-chfn-chsh   \
            --disable-login       \
            --disable-nologin     \
            --disable-su          \
            --disable-setpriv     \
            --disable-runuser     \
            --disable-pylibmount  \
            --disable-static      \
            --disable-liblastlog2 \
            --without-python      \
            ADJTIME_PATH=/var/lib/hwclock/adjtime \
            --docdir=/usr/share/doc/util-linux-2.41
#********</pre>**********
#<p>
#
#  The meaning of the configure options: 
#</p>

#ADJTIME_PATH=/var/lib/hwclock/adjtime 
##<p>
#
#  This sets the location of the file recording information about the hardware 
# clock in accordance to the FHS. This is not strictly needed for this temporary 
# tool, but it prevents creating a file at another location, which would not be 
# overwritten or removed when building the final util-linux package. 
#</p>

#--libdir=/usr/lib 
##<p>
#
#  This switch ensures the .so 
#  symlinks targeting the shared library file in the same directory ( /usr/lib 
#  ) directly. 
#</p>

#--disable-* 
##<p>
#
#  These switches prevent warnings about building components that require 
# packages not in LFS or not installed yet. 
#</p>

#--without-python 
##<p>
#
#  This switch disables using Python
#  . It avoids trying to build unneeded bindings. 
#</p>

#runstatedir=/run 
##<p>
#
#  This switch sets the location of the socket used by uuidd
#  and libuuid 
#  correctly. 
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
make install
#********</pre>**********
#<p>
#
#  Details on this package are located in [Section 8.79.2, “Contents of Util-linux.”](../chapter08/util-linux.html#contents-utillinux)
#</p>

cd $topdir
rm -rf $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt
