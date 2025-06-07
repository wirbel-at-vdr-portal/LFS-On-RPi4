topdir=$(pwd)
err=0
set -e
chapter=hwdata-0.395
err_report() {
    echo "chapter $chapter: $(date +'%Y.%m.%d %H:%M:%S') Error $? on line $1" | tee >> $topdir/log.txt
}
trap 'err_report $LINENO' ERR
echo "---------" >> $topdir/log.txt
echo chapter $chapter: start = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt




srcdir=../../src/hwdata-0.395
tar xf ../../src/hwdata-0.395.tar.gz -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir











# Introduction to hwdata
# 
# The hwdata package contains current PCI and vendor id data.
# [Note] Note
# 
# Development versions of BLFS may not build or run some packages properly if LFS or dependencies have been updated since the most recent stable versions of the books.
# Package Information
# 
#     Download (HTTP): https://github.com/vcrhonek/hwdata/archive/v0.395/hwdata-0.395.tar.gz
# 
#     Download MD5 sum: 17159109dcd7e09c92dea86882b56710
# 
#     Download size: 2.4 MB
# 
#     Estimated disk space required: 9.7 MB
# 
#     Estimated build time: less than 0.1 SBU
# 
# Installation of hwdata
# 
# Install hwdata by running the following commands:

./configure --prefix=/usr --disable-blacklist

# This package does not come with a test suite.
# 
# Now, as the root user:

make install

# Contents
# Installed Programs:
# None
# Installed Library:
# None
# Installed Directory:
# /usr/share/hwdata








cd $topdir
rm -rf $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt

