topdir=$(pwd)
err=0
set -e
chapter=popt-1.19
err_report() {
    echo "chapter $chapter: $(date +'%Y.%m.%d %H:%M:%S') Error $? on line $1" | tee >> $topdir/log.txt
}
trap 'err_report $LINENO' ERR
echo "---------" >> $topdir/log.txt
echo chapter $chapter: start = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt




srcdir=../../src/popt-1.19
tar xf ../../src/popt-1.19.tar.gz -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir





# Introduction to Popt
# 
# The popt package contains the popt libraries which are used by some programs to parse command-line options.
# [Note] Note
# 
# Development versions of BLFS may not build or run some packages properly if LFS or dependencies have been updated since the most recent stable versions of the books.
# Package Information
# 
#     Download (HTTP): https://ftp.osuosl.org/pub/rpm/popt/releases/popt-1.x/popt-1.19.tar.gz
# 
#     Download MD5 sum: eaa2135fddb6eb03f2c87ee1823e5a78
# 
#     Download size: 584 KB
# 
#     Estimated disk space required: 6.9 MB (includes installing documentation and tests)
# 
#     Estimated build time: less than 0.1 SBU (with tests)
# 
# popt Dependencies
# Optional
# 
# Doxygen-1.14.0 (for generating documentation)
# Installation of Popt
# 
# Install popt by running the following commands:

./configure --prefix=/usr --disable-static &&
make -j4

# If you have Doxygen-1.14.0 installed and wish to build the API documentation, issue:
# 
# sed -i 's@\./@src/@' Doxyfile &&
# doxygen
# 
# To test the results, issue: make check.
# 
# Now, as the root user:

make install

# If you built the API documentation, install it using the following commands issued by the root user:
# 
# install -v -m755 -d /usr/share/doc/popt-1.19 &&
# install -v -m644 doxygen/html/* /usr/share/doc/popt-1.19
# 
# Command Explanations
# 
# --disable-static: This switch prevents installation of static versions of the libraries.
# Contents
# Installed Programs:
# None
# Installed Library:
# libpopt.so
# Installed Directories:
# /usr/share/doc/popt-1.19
# Short Descriptions
# 
# libpopt.so
# 

is used to parse command-line options 






cd $topdir
rm -rfv $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt

