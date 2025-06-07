topdir=$(pwd)
err=0
set -e
chapter=libtirpc-1.3.6
err_report() {
    echo "chapter $chapter: $(date +'%Y.%m.%d %H:%M:%S') Error $? on line $1" | tee >> $topdir/log.txt
}
trap 'err_report $LINENO' ERR
echo "---------" >> $topdir/log.txt
echo chapter $chapter: start = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt




srcdir=../../src/libtirpc-1.3.6
tar xf ../../src/libtirpc-1.3.6.tar.bz2 -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir






# Introduction to libtirpc
# 
# The libtirpc package contains libraries that support programs that use the Remote Procedure Call (RPC) API. It replaces the RPC, but not the NIS library entries that used to be in glibc.
# [Note] Note
# 
# Development versions of BLFS may not build or run some packages properly if LFS or dependencies have been updated since the most recent stable versions of the books.
# Package Information
# 
#     Download (HTTP): https://downloads.sourceforge.net/libtirpc/libtirpc-1.3.6.tar.bz2
# 
#     Download MD5 sum: 8de9e6af16c4bc65ba40d0924745f5b7
# 
#     Download size: 553 KB
# 
#     Estimated disk space required: 7.4 MB
# 
#     Estimated build time: less than 0.1 SBU
# 
# libtirpc Dependencies
# Optional
# 
# MIT Kerberos V5-1.21.3 for the GSSAPI
# Installation of libtirpc
# [Note] Note
# 
# If updating this package, you will also need to update any existing version of rpcbind-1.2.7

./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --disable-static  \
            --disable-gssapi  &&
make -j8

# This package does not come with a test suite.
# 
# Now, as the root user:

make install

# Command Explanations
# 
# --disable-static: This switch prevents installation of static versions of the libraries.
# 
# --disable-gssapi: This switch is needed if no GSSAPI is installed. Remove this switch if you have one installed (for example MIT Kerberos V5-1.21.3) and you wish to use it.
# Contents
# Installed Programs:
# None
# Installed Libraries:
# libtirpc.so
# Installed Directory:
# /usr/include/tirpc
# Short Descriptions
# 
# libtirpc.so
# 	
# 
# provides the Remote Procedure Call (RPC) API functions required by other programs 





cd $topdir
rm -rfv $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt

