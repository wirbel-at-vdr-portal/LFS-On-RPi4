#!/usr/bin/bash

# ===== 8.74. MarkupSafe-3.0.2 =====
topdir=$(pwd)
err=0
set -e
chapter=8074
err_report() {
    echo "chapter $chapter: $(date +'%Y.%m.%d %H:%M:%S') Error $? on line $1" | tee >> $topdir/log.txt
}
trap 'err_report $LINENO' ERR
echo "---------" >> $topdir/log.txt
echo chapter $chapter: start = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt






srcdir=../../src/markupsafe-3.0.2
tar xf ../../src/markupsafe-3.0.2.tar.gz -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir

#<p>
#
#  MarkupSafe is a Python module that implements an XML/HTML/XHTML Markup safe 
# string. 
#</p>

#  Approximate build time: less than 0.1 SBU
#  Required disk space: 500 KB
# ==== 8.74.1. Installation of MarkupSafe ====
#<p>
#
#  Compile MarkupSafe with the following command: 
#</p>

#********<pre>***********
pip3 wheel -w dist --no-cache-dir --no-build-isolation --no-deps $PWD
#********</pre>**********
#<p>
#
#  This package does not come with a test suite. 
#</p>
#<p>
#
#  Install the package: 
#</p>

#********<pre>***********
pip3 install --no-index --find-links dist Markupsafe
#********</pre>**********

# ==== 8.74.2. Contents of MarkupSafe ====

#  Installed directory: /usr/lib/python3.13/site-packages/MarkupSafe-3.0.2.dist-info
cd $topdir
rm -rf $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt
