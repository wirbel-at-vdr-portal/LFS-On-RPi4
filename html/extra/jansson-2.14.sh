topdir=$(pwd)
err=0
set -e
chapter=jansson-2.14
err_report() {
    echo "chapter $chapter: $(date +'%Y.%m.%d %H:%M:%S') Error $? on line $1" | tee >> $topdir/log.txt
}
trap 'err_report $LINENO' ERR
echo "---------" >> $topdir/log.txt
echo chapter $chapter: start = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt




srcdir=../../src/jansson-2.14
tar xf ../../src/jansson-2.14.tar.bz2 -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir







# Introduction to Jansson
# 
# The Jansson package contains a library used to encode, decode, and manipulate JSON data.
# [Note] Note
# 
# Development versions of BLFS may not build or run some packages properly if LFS or dependencies have been updated since the most recent stable versions of the books.
# Package Information
# 
#     Download (HTTP): https://github.com/akheron/jansson/releases/download/v2.14/jansson-2.14.tar.bz2
# 
#     Download MD5 sum: 3f90473d7d54ebd1cb6a2757396641df
# 
#     Download size: 424 KB
# 
#     Estimated disk space required: 5.6 MB (add 1.9 MB for tests)
# 
#     Estimated build time: 0.1 SBU (with tests)
# 
# Installation of Jansson
# 
# First fix one of the tests:

sed -e "/DT/s;| sort;| sed 's/@@libjansson.*//' &;" \
    -i test/suites/api/check-exports

# Install jansson by running the following commands:

./configure --prefix=/usr --disable-static &&
make -j4

# To test the results, issue: make check.
# 
# Now, as the root user:

make install

# Contents
# Installed Programs:
# None
# Installed Library:
# libjansson.so
# Installed Directories:
# None
# Short Descriptions
# 
# libjansson.so
# 	
# 
# contains an API for encoding, decoding, and manipulating JSON data 








cd $topdir
rm -rf $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt

