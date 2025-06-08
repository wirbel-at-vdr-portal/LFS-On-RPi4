topdir=$(pwd)
err=0
set -e
chapter=libarchive-3.8.1

err_report() {
    echo "chapter $chapter: $(date +'%Y.%m.%d %H:%M:%S') Error $? on line $1" | tee >> $topdir/log.txt
}
trap 'err_report $LINENO' ERR
echo "---------" >> $topdir/log.txt
echo chapter $chapter: start = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt




srcdir=../../src/libarchive-3.8.1
tar xf ../../src/libarchive-3.8.1.tar.xz -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir





# Introduction to libarchive
# 
# The libarchive library provides a single interface for reading/writing various compression formats.
# [Note] Note
# 
# Development versions of BLFS may not build or run some packages properly if LFS or dependencies have been updated since the most recent stable versions of the books.
# Package Information
# 
#     Download (HTTP): https://github.com/libarchive/libarchive/releases/download/v3.8.1/libarchive-3.8.1.tar.xz
# 
#     Download MD5 sum: 80fd1a7acc4da7c7d4a5f9f96df6e3ff
# 
#     Download size: 5.7 MB
# 
#     Estimated disk space required: 43 MB (add 32 MB for tests)
# 
#     Estimated build time: 0.3 SBU (add 0.8 SBU for tests)
# 
# libarchive Dependencies
# Optional
# 
# libxml2-2.14.3, LZO-2.10, Nettle-3.10.1, and pcre2-10.45
# Installation of libarchive
# 
# Install libarchive by running the following commands:

./configure --prefix=/usr --disable-static &&
make

# To test the results, issue: make check.
# 
# Now, as the root user:

make install

# Still as the root user, create a symlink so we can use bsdunzip as unzip, instead of relying on the unmaintained Unzip package:

ln -sfv bsdunzip /usr/bin/unzip

# [Note] Note
# 
# As discussed in Wrong Filename Encoding, if the Zip archive to be extracted contains any file with a name containing any non-Latin characters, you need to manually specify the encoding of those characters or they will be turned into unreadable sequences in the extracted file name. For example, if a Zip archive created with WinZip, archive.zip, contains a file named with Simplified Chinese characters, the encoding should be CP936 and the -I cp936 option should be used. I.e. the command to extract the archive should be unzip -I cp936 archive.zip.
# Command Explanations
# 
# --disable-static: This switch prevents installation of static versions of the libraries.
# 
# --without-xml2: This switch sets expat for xar archive format support instead of preferred libxml2 if both packages are installed.
# 
# --with-nettle: This switch sets Nettle for crypto support instead of OpenSSL.
# Contents
# Installed Programs:
# bsdcat, bsdcpio, bsdtar, and bsdunzip
# Installed Libraries:
# libarchive.so
# Installed Directories:
# None
# Short Descriptions
# 
# bsdcat
# 	
# 
# expands files to standard output
# 
# bsdcpio
# 	
# 
# is a tool similar to cpio
# 
# bsdtar
# 	
# 
# is a tool similar to GNU tar
# 
# bsdunzip
# 	
# 
# is a tool similar to Info-ZIP unzip
# 
# libarchive.so
# 	
# 
# is a library that can create and read several streaming archive formats 
# 











cd $topdir
rm -rf $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt

