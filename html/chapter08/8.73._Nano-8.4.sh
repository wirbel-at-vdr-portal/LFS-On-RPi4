#!/usr/bin/bash

# ===== 8.53. Packaging-25.0 =====
topdir=$(pwd)
err=0
set -e
chapter=8052
err_report() {
    echo "chapter $chapter: $(date +'%Y.%m.%d %H:%M:%S') Error $? on line $1" | tee >> $topdir/log.txt
}
trap 'err_report $LINENO' ERR
echo "---------" >> $topdir/log.txt
echo chapter $chapter: start = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt





srcdir=../../src/nano-8.4
tar xf ../../src/nano-8.4.tar.xz -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir

#<p>
#
# The Nano package contains a small, simple text editor which aims to replace Pico, the default editor in the Pine package.

#  Approximate build time: 0.2 SBU
#  Required disk space: 24 MB
# ====  Installation of Nano ====
#<p>
#
#  Install Nano by running the following commands: 
#</p>

#********<pre>***********
./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --enable-utf8     \
            --docdir=/usr/share/doc/nano-8.4 &&
make
#********</pre>**********
#<p>
#
#  Install the package: 
#</p>

#********<pre>***********
make install &&
install -v -m644 doc/{nano.html,sample.nanorc} /usr/share/doc/nano-8.4
#********</pre>**********

# ====  ====

# Installed Programs:
#   nano and rnano (symlink)
# Installed Libraries:
#   None
# Installed Directories:
#   /usr/share/nano and /usr/share/doc/nano-8.4

cd $topdir
rm -rf $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt

echo "---------" >> $topdir/log.txt
