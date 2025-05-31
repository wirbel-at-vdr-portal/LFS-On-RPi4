#!/usr/bin/bash

# ===== 7.10. Python-3.13.3 =====
topdir=$(pwd)
err=0
set -e
chapter=7010
err_report() {
    echo "chapter $chapter: $(date +'%Y.%m.%d %H:%M:%S') Error $? on line $1" | tee >> $topdir/log.txt
}
trap 'err_report $LINENO' ERR
echo "---------" >> $topdir/log.txt
echo chapter $chapter: start = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt


srcdir=../src/Python-3.13.3
tar xf ../src/Python-3.13.3.tar.xz -C ../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir

#<p>
#
#  The Python 3 package contains the Python development environment. It is useful 
# for object-oriented programming, writing scripts, prototyping large programs, 
# and developing entire applications. Python is an interpreted computer language. 
#</p>

#  Approximate build time: 0.5 SBU
#  Required disk space: 634 MB
# ==== 7.10.1. Installation of Python ====

# ====== Note ======
#<p>
#
#  There are two package files whose name starts with the “python”
#  prefix. The one to extract from is Python-3.13.3.tar.xz 
#  (notice the uppercase first letter). 
#</p>
#<p>
#
#  Prepare Python for compilation: 
#</p>

#********<pre>***********
./configure --prefix=/usr   \
            --enable-shared \
            --without-ensurepip
#********</pre>**********
#<p>
#
#  The meaning of the configure option: 
#</p>

#--enable-shared 
##<p>
#
#  This switch prevents installation of static libraries. 
#</p>

#--without-ensurepip 
##<p>
#
#  This switch disables the Python package installer, which is not needed at this 
# stage. 
#</p>
#<p>
#
#  Compile the package: 
#</p>

#********<pre>***********
make
#********</pre>**********

# ====== Note ======
#<p>
#
#  Some Python 3 modules can't be built now because the dependencies are not 
# installed yet. For the ssl 
#  module, a message Python requires a OpenSSL 1.1.1 or newer 
#  is outputted. The message should be ignored. Just make sure the toplevel make
#  command has not failed. The optional modules are not needed now and they will 
# be built in [Chapter 8](../chapter08/chapter08.html)
#  . 
#</p>
#<p>
#
#  Install the package: 
#</p>

#********<pre>***********
make install
#********</pre>**********
#<p>
#
#  Details on this package are located in [Section 8.51.2, “Contents of Python 3.”](../chapter08/Python.html#contents-python)
#</p>

cd $topdir
rm -rf $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt
