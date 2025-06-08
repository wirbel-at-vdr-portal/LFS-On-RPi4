topdir=$(pwd)
err=0
set -e
chapter=libuv-v1.51.0

err_report() {
    echo "chapter $chapter: $(date +'%Y.%m.%d %H:%M:%S') Error $? on line $1" | tee >> $topdir/log.txt
}
trap 'err_report $LINENO' ERR
echo "---------" >> $topdir/log.txt
echo chapter $chapter: start = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt




srcdir=../../src/libuv-v1.51.0
tar xf ../../src/libuv-v1.51.0.tar.gz -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir




# Introduction to libuv
# 
# The libuv package is a multi-platform support library with a focus on asynchronous I/O.
# [Note] Note
# 
# Development versions of BLFS may not build or run some packages properly if LFS or dependencies have been updated since the most recent stable versions of the books.
# Package Information
# 
#     Download (HTTP): https://dist.libuv.org/dist/v1.51.0/libuv-v1.51.0.tar.gz
# 
#     Download MD5 sum: 5e0109e19c3fed3a8cbecb958de39afa
# 
#     Download size: 1.3 MB
# 
#     Estimated disk space required: 31 MB (with tests and man page)
# 
#     Estimated build time: 0.5 SBU (with tests and man page)
# 
# libuv Dependencies
# Optional
# 
# sphinx-8.2.3
# Installation of libuv
# 
# Install libuv by running the following commands:
# [Caution] Caution
# 
# The sh autogen.sh command below fails if the ACLOCAL environment variable is set as specified in Xorg-7. If it is used, ACLOCAL needs to be unset for this package and then reset for other packages.

sh autogen.sh                              &&
./configure --prefix=/usr --disable-static &&
make 

# If you installed the optional sphinx-8.2.3 python module, create the man page:
# 
# make man -C docs
# 
# If you want to run the tests, run: make check as a non-root user.
# 
# Now, as the root user:

make install

# If you built the man page, install it as the root user:
# 
# install -Dm644 docs/build/man/libuv.1 /usr/share/man/man1
# 
# Contents
# Installed Programs:
# None
# Installed Library:
# libuv.so
# Installed Directory:
# /usr/include/uv
# Short Descriptions
# 
# libuv.so
# 	
# 
# contains API functions for asynchronous I/O operations 
# 
# 










cd $topdir
rm -rf $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt

