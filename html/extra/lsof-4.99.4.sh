topdir=$(pwd)
err=0
set -e
chapter=lsof-4.99.4
err_report() {
    echo "chapter $chapter: $(date +'%Y.%m.%d %H:%M:%S') Error $? on line $1" | tee >> $topdir/log.txt
}
trap 'err_report $LINENO' ERR
echo "---------" >> $topdir/log.txt
echo chapter $chapter: start = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt




srcdir=../../src/lsof-4.99.4
tar xf ../../src/lsof-4.99.4.tar.gz -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir















# Introduction to lsof
# 
# The lsof package is useful to LiSt Open Files for a given running application or process.
# [Note] Note
# 
# Development versions of BLFS may not build or run some packages properly if LFS or dependencies have been updated since the most recent stable versions of the books.
# Package Information
# 
#     Download (HTTP): https://github.com/lsof-org/lsof/releases/download/4.99.4/lsof-4.99.4.tar.gz
# 
#     Download MD5 sum: 4bb529a53973276c07a1cf38564fd52c
# 
#     Download size: 1.1 MB
# 
#     Estimated disk space required: 13 MB (with tests)
# 
#     Estimated build time: 0.6 SBU (with tests)
# 
# lsof Dependencies
# Required
# 
# libtirpc-1.3.6
# Optional
# 
# Nmap-7.97 (with a symbolic link nc pointing to ncat in /usr/bin; used in tests)
# Kernel Configuration
# 
# To run the tests, the following option should be enabled in the kernel configuration:
# 
# General setup --->
#   [*] POSIX Message Queues                                        [POSIX_MQUEUE]
# 
# Installation of lsof
# 
# Install lsof by running the following commands:

./configure --prefix=/usr --disable-static &&
make

# The tests should be run as the root user. They require that the POSIX message queues are enabled in the kernel, and that Nmap-7.97 be installed with a symbolic link /usr/bin/nc pointing to ncat.
# 
# make check
# 
# Now, as the root user:

make install

# Command Explanations
# 
# --disable-static: This switch prevents installation of static versions of the libraries.
# Contents
# Installed Program:
# lsof
# Installed Libraries:
# liblsof.so
# Installed Directories:
# None
# Short Descriptions
# 
# lsof
# 	
# 
# lists open files for running processes
# 
# liblsof.so
# 	
# 
# contains an interface for applications to list open files
# 





cd $topdir
rm -rf $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt

