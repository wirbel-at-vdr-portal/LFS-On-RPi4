#!/usr/bin/bash

# ===== 7.7. Gettext-0.25 =====
topdir=$(pwd)
err=0
set -e
chapter=7007
err_report() {
    echo "chapter $chapter: $(date +'%Y.%m.%d %H:%M:%S') Error $? on line $1" | tee >> $topdir/log.txt
}
trap 'err_report $LINENO' ERR
echo "---------" >> $topdir/log.txt
echo chapter $chapter: start = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt


srcdir=../src/gettext-0.25
tar xf ../src/gettext-0.25.tar.xz -C ../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir

#<p>
#
#  The Gettext package contains utilities for internationalization and 
# localization. These allow programs to be compiled with NLS (Native Language 
# Support), enabling them to output messages in the user's native language. 
#</p>

#  Approximate build time: 1.3 SBU
#  Required disk space: 349 MB
# ==== 7.7.1. Installation of Gettext ====
#<p>
#
#  For our temporary set of tools, we only need to install three programs from 
# Gettext. 
#</p>
#<p>
#
#  Prepare Gettext for compilation: 
#</p>

#********<pre>***********
./configure --disable-shared
#********</pre>**********
#<p>
#
#  The meaning of the configure option: 
#</p>

#--disable-shared 
##<p>
#
#  We do not need to install any of the shared Gettext libraries at this time, 
# therefore there is no need to build them. 
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
#  Install the msgfmt
#  , msgmerge
#  , and xgettext
#  programs: 
#</p>

#********<pre>***********
cp -v gettext-tools/src/{msgfmt,msgmerge,xgettext} /usr/bin
#********</pre>**********
#<p>
#
#  Details on this package are located in [Section 8.33.2, “Contents of Gettext.”](../chapter08/gettext.html#contents-gettext)
#</p>

cd $topdir
rm -rf $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt
