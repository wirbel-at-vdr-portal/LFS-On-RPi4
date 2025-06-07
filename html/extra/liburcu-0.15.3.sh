topdir=$(pwd)
err=0
set -e
chapter=liburcu-0.15.3
err_report() {
    echo "chapter $chapter: $(date +'%Y.%m.%d %H:%M:%S') Error $? on line $1" | tee >> $topdir/log.txt
}
trap 'err_report $LINENO' ERR
echo "---------" >> $topdir/log.txt
echo chapter $chapter: start = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt




srcdir=../../src/userspace-rcu-0.15.3
tar xf ../../src/userspace-rcu-0.15.3.tar.bz2 -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir






# Introduction to liburcu
# 
# The userspace-rcu package provides a set of userspace RCU (read-copy-update) libraries. These data synchronization libraries provide read-side access which scales linearly with the number of cores. It does so by allowing multiples copies of a given data structure to live at the same time, and by monitoring the data structure accesses to detect grace periods after which memory reclamation is possible.
# [Note] Note
# 
# Development versions of BLFS may not build or run some packages properly if LFS or dependencies have been updated since the most recent stable versions of the books.
# Package Information
# 
#     Download (HTTP): https://lttng.org/files/urcu/userspace-rcu-0.15.3.tar.bz2
# 
#     Download MD5 sum: ddbf7f18b5741838c264d146573a46e5
# 
#     Download size: 672 KB
# 
#     Estimated disk space required: 23 MB (with tests)
# 
#     Estimated build time: 0.2 SBU (with tests)
# 
# Installation of liburcu
# 
# Install liburcu by running the following commands:

./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/liburcu-0.15.3 &&
make -j4

# To test the results, issue: make check.
# 
# Now, as the root user:

make install

# Contents
# Installed Programs:
# None
# Installed Libraries:
# liburcu.so, liburcu-bp.so, liburcu-cds.so, liburcu-common.so, liburcu-mb.so, liburcu-memb.so, liburcu-qsbr.so, and liburcu-signal.so
# Installed Directories:
# /usr/include/urcu and /usr/share/doc/liburcu-0.15.3









cd $topdir
rm -rf $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt

