topdir=$(pwd)
err=0
set -e
chapter=libunistring-1.3
err_report() {
    echo "chapter $chapter: $(date +'%Y.%m.%d %H:%M:%S') Error $? on line $1" | tee >> $topdir/log.txt
}
trap 'err_report $LINENO' ERR
echo "---------" >> $topdir/log.txt
echo chapter $chapter: start = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt




srcdir=../../src/libunistring-1.3
tar xf ../../src/libunistring-1.3.tar.xz -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir






# Introduction to libunistring
# 
# libunistring is a library that provides functions for manipulating Unicode strings and for manipulating C strings according to the Unicode standard.
# [Note] Note
# 
# Development versions of BLFS may not build or run some packages properly if LFS or dependencies have been updated since the most recent stable versions of the books.
# Package Information
# 
#     Download (HTTP): https://ftp.gnu.org/gnu/libunistring/libunistring-1.3.tar.xz
# 
#     Download MD5 sum: 57dfd9e4eba93913a564aa14eab8052e
# 
#     Download size: 2.6 MB
# 
#     Estimated disk space required: 58 MB (add 46 MB for tests)
# 
#     Estimated build time: 0.6 SBU (add 0.3 SBU for tests; both using parallelism=4)
# 
# libunistring Dependencies
# Optional
# 
# texlive-20250308 (or install-tl-unx) (to rebuild the documentation)
# Installation of libunistring
# 
# Install libunistring by running the following commands:

./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/libunistring-1.3 &&
make
 
# To test the results, issue: make check.
# 
# Now, as the root user:

make install

# Command Explanations
# 
# --disable-static: This switch prevents installation of static versions of the libraries.
# Contents
# Installed Programs:
# None
# Installed Libraries:
# libunistring.so
# Installed Directory:
# /usr/include/unistring and /usr/share/doc/libunistring-1.3
# Short Descriptions
# 
# libunistring.so
# 	
# 
# provides the unicode string library API 







cd $topdir
rm -rf $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt

