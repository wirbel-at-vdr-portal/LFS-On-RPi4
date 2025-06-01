#!/usr/bin/bash

# ===== 8.75. Jinja2-3.1.6 =====
topdir=$(pwd)
err=0
set -e
chapter=8075
err_report() {
    echo "chapter $chapter: $(date +'%Y.%m.%d %H:%M:%S') Error $? on line $1" | tee >> $topdir/log.txt
}
trap 'err_report $LINENO' ERR
echo "---------" >> $topdir/log.txt
echo chapter $chapter: start = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt






srcdir=../../src/jinja2-3.1.6
tar xf ../../src/jinja2-3.1.6.tar.gz -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir

#<p>
#
#  Jinja2 is a Python module that implements a simple pythonic template language. 
#</p>

#  Approximate build time: less than 0.1 SBU
#  Required disk space: 2.5 MB
# ==== 8.75.1. Installation of Jinja2 ====
#<p>
#
#  Build the package: 
#</p>

#********<pre>***********
pip3 wheel -w dist --no-cache-dir --no-build-isolation --no-deps $PWD
#********</pre>**********
#<p>
#
#  Install the package: 
#</p>

#********<pre>***********
pip3 install --no-index --find-links dist Jinja2
#********</pre>**********

# ==== 8.75.2. Contents of Jinja2 ====

#  Installed directory: /usr/lib/python3.13/site-packages/Jinja2-3.1.6.dist-info
cd $topdir
rm -rf $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt
