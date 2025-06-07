topdir=$(pwd)
err=0
set -e
chapter=rpcsvc-proto-1.4.4
err_report() {
    echo "chapter $chapter: $(date +'%Y.%m.%d %H:%M:%S') Error $? on line $1" | tee >> $topdir/log.txt
}
trap 'err_report $LINENO' ERR
echo "---------" >> $topdir/log.txt
echo chapter $chapter: start = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt




srcdir=../../src/rpcsvc-proto-1.4.4
tar xf ../../src/rpcsvc-proto-1.4.4.tar.xz -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir






# Introduction to rpcsvc-proto
# 
# The rpcsvc-proto package contains the rcpsvc protocol files and headers, formerly included with glibc, that are not included in replacement libtirpc-1.3.6, along with the rpcgen program.
# [Note] Note
# 
# Development versions of BLFS may not build or run some packages properly if LFS or dependencies have been updated since the most recent stable versions of the books.
# Package Information
# 
#     Download (HTTP): https://github.com/thkukuk/rpcsvc-proto/releases/download/v1.4.4/rpcsvc-proto-1.4.4.tar.xz
# 
#     Download MD5 sum: bf908de360308d909e9cc469402ff2ef
# 
#     Download size: 168 KB
# 
#     Estimated disk space required: 2.2 MB
# 
#     Estimated build time: less than 0.1 SBU
# 
# Installation of rpcsvc-proto
# 
# Install rpcsvc-proto by running the following commands:
# 
./configure --sysconfdir=/etc &&
make
# 
# This package does not come with a test suite.
# 
# Now, as the root user:
# 
make install
# 
# Contents
# Installed Programs:
# rpcgen
# Installed Libraries:
# None
# Installed Directories:
# /usr/include/rpcsvc
# Short Descriptions
# 
# rpcgen
# 	
# 
# Generates C code to implement the RPC protocol 





cd $topdir
rm -rfv $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt

