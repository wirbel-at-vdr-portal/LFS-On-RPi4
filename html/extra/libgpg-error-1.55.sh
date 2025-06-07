topdir=$(pwd)
err=0
set -e
chapter=libgpg-error-1.55
err_report() {
    echo "chapter $chapter: $(date +'%Y.%m.%d %H:%M:%S') Error $? on line $1" | tee >> $topdir/log.txt
}
trap 'err_report $LINENO' ERR
echo "---------" >> $topdir/log.txt
echo chapter $chapter: start = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt




srcdir=../../src/libgpg-error-1.55
tar xf ../../src/libgpg-error-1.55.tar.bz2 -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir









# Introduction to libgpg-error
# 
# The libgpg-error package contains a library that defines common error values for all GnuPG components.
# [Note] Note
# 
# Development versions of BLFS may not build or run some packages properly if LFS or dependencies have been updated since the most recent stable versions of the books.
# Package Information
# 
#     Download (HTTP): https://www.gnupg.org/ftp/gcrypt/libgpg-error/libgpg-error-1.55.tar.bz2
# 
#     Download MD5 sum: 0430e56fd67d0751b83fc18b0f56a084
# 
#     Download size: 1.1 MB
# 
#     Estimated disk space required: 12 MB (with tests)
# 
#     Estimated build time: 0.3 SBU (with tests)
# 
# Installation of libgpg-error
# 
# Install libgpg-error by running the following commands:

./configure --prefix=/usr &&
make

# To test the results, issue: make check.
# 
# Now, as the root user:

make install &&
install -v -m644 -D README /usr/share/doc/libgpg-error-1.55/README

# Contents
# Installed Programs:
# gpg-error, gpgrt-config, and yat2m
# Installed Library:
# libgpg-error.so
# Installed Directories:
# /usr/share/common-lisp/source/gpg-error, /usr/share/libgpg-error, and /usr/share/doc/libgpg-error-1.55
# Short Descriptions
# 
# gpg-error
# 	
# 
# is used to determine libgpg-error error codes
# 
# gpgrt-config
# 	
# 
# is a pkg-config style tool for querying the information about installed version of libgpg-error
# 
# yat2m
# 	
# 
# extracts man pages from a Texinfo source
# 
# libgpg-error.so
# 	
# 
# contains the libgpg-error API functions 





cd $topdir
rm -rf $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt

