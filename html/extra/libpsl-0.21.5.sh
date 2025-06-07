topdir=$(pwd)
err=0
set -e
chapter=libpsl-0.21.5
err_report() {
    echo "chapter $chapter: $(date +'%Y.%m.%d %H:%M:%S') Error $? on line $1" | tee >> $topdir/log.txt
}
trap 'err_report $LINENO' ERR
echo "---------" >> $topdir/log.txt
echo chapter $chapter: start = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt




srcdir=../../src/libpsl-0.21.5
tar xf ../../src/libpsl-0.21.5.tar.gz -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir







# Introduction to libpsl
# 
# The libpsl package provides a library for accessing and resolving information from the Public Suffix List (PSL). The PSL is a set of domain names beyond the standard suffixes, such as .com.
# [Note] Note
# 
# Development versions of BLFS may not build or run some packages properly if LFS or dependencies have been updated since the most recent stable versions of the books.
# Package Information
# 
#     Download (HTTP): https://github.com/rockdaboot/libpsl/releases/download/0.21.5/libpsl-0.21.5.tar.gz
# 
#     Download MD5 sum: 870a798ee9860b6e77896548428dba7b
# 
#     Download size: 7.3 MB
# 
#     Estimated disk space required: 50 MB
# 
#     Estimated build time: less than 0.1 SBU (including tests)
# 
# libpsl Dependencies
# Recommended
# 
# libidn2-2.3.8 and libunistring-1.3
# Optional
# 
# GTK-Doc-1.34.0 (for documentation), ICU-77.1 (may be used instead of libidn2), libidn-1.43 (may be used instead of libidn2), Valgrind-3.25.1 (for tests)
# Installation of libpsl
# 
# Install libpsl by running the following commands:

mkdir build &&
cd    build &&

meson setup --prefix=/usr --buildtype=release &&

ninja

# To test the results, issue: ninja test.
# 
# Now, as the root user:

ninja install

# Command Explanations
# 
# --buildtype=release: Specify a buildtype suitable for stable releases of the package, as the default may produce unoptimized binaries.
# Contents
# Installed Program:
# psl
# Installed Library:
# libpsl.so
# Installed Directories:
# None
# Short Descriptions
# 
# psl
# 	
# 
# queries the Public Suffix List
# 
# libpsl.so
# 	
# 
# contains a library used to access the Public Suffix List 






cd $topdir
rm -rf $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt

