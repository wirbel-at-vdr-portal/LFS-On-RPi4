topdir=$(pwd)
err=0
set -e
chapter=libjpeg-turbo-3.0.1
err_report() {
    echo "chapter $chapter: $(date +'%Y.%m.%d %H:%M:%S') Error $? on line $1" | tee >> $topdir/log.txt
}
trap 'err_report $LINENO' ERR
echo "---------" >> $topdir/log.txt
echo chapter $chapter: start = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt




srcdir=../../src/libjpeg-turbo-3.0.1
tar xf ../../src/libjpeg-turbo-3.0.1.tar.gz -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir











# Introduction to libjpeg-turbo
# 
# libjpeg-turbo is a fork of the original IJG libjpeg which uses SIMD to accelerate baseline JPEG compression and decompression. libjpeg is a library that implements JPEG image encoding, decoding and transcoding.
# [Note] Note
# 
# Development versions of BLFS may not build or run some packages properly if LFS or dependencies have been updated since the most recent stable versions of the books.
# Package Information
# 
#     Download (HTTP): https://downloads.sourceforge.net/libjpeg-turbo/libjpeg-turbo-3.0.1.tar.gz
# 
#     Download MD5 sum: 1fdc6494521a8724f5f7cf39b0f6aff3
# 
#     Download size: 2.7 MB
# 
#     Estimated disk space required: 55 MB (with tests)
# 
#     Estimated build time: 0.5 SBU (with tests; both using parallelism=4)
# 
# libjpeg-turbo Dependencies
# Required
# 
# CMake-4.0.2
# Recommended
# 
# NASM-2.16.03 or yasm-1.3.0 (for building the package with optimized assembly routine)
# Installation of libjpeg-turbo
# 
# Install libjpeg-turbo by running the following commands:

mkdir build &&
cd    build &&

cmake -D CMAKE_INSTALL_PREFIX=/usr        \
      -D CMAKE_BUILD_TYPE=RELEASE         \
      -D ENABLE_STATIC=FALSE              \
      -D CMAKE_INSTALL_DEFAULT_LIBDIR=lib \
      -D CMAKE_POLICY_VERSION_MINIMUM=3.5 \
      -D CMAKE_SKIP_INSTALL_RPATH=ON      \
      -D CMAKE_INSTALL_DOCDIR=/usr/share/doc/libjpeg-turbo-3.0.1 \
      .. &&
make

# To test the results, issue: make test.
# 
# Now, as the root user:

make install

# Command Explanations
# 
# -D CMAKE_POLICY_VERSION_MINIMUM=3.5: This switch allows building this package with cmake-4.0 or newer.
# 
# -D CMAKE_SKIP_INSTALL_RPATH=ON: This switch makes cmake remove hardcoded library search paths (rpath) when installing a binary executable file or a shared library. This package does not need rpath once it's installed into the standard location, and rpath may sometimes cause unwanted effects or even security issues.
# 
# -D WITH_JPEG8=ON: This switch enables compatibility with libjpeg version 8.
# Contents
# Installed Programs:
# cjpeg, djpeg, jpegtran, rdjpgcom, tjbench, and wrjpgcom
# Installed Libraries:
# libjpeg.so and libturbojpeg.so
# Installed Directories:
# /usr/share/doc/libjpeg-turbo-3.0.1
# Short Descriptions
# 
# cjpeg
# 	
# 
# compresses image files to produce a JPEG/JFIF file on the standard output. Currently supported input file formats are: PPM (PBMPLUS color format), PGM (PBMPLUS gray-scale format), BMP, and Targa
# 
# djpeg
# 	
# 
# decompresses image files from JPEG/JFIF format to either PPM (PBMPLUS color format), PGM (PBMPLUS gray-scale format), BMP, or Targa format
# 
# jpegtran
# 	
# 
# is used for lossless transformation of JPEG files
# 
# rdjpgcom
# 	
# 
# displays text comments from within a JPEG file
# 
# tjbench
# 	
# 
# is used to benchmark the performance of libjpeg-turbo
# 
# wrjpgcom
# 	
# 
# inserts text comments into a JPEG file
# 
# libjpeg.so
# 	
# 
# contains functions used for reading and writing JPEG images
# 







cd $topdir
rm -rf $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt

