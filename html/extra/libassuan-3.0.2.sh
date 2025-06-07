topdir=$(pwd)
err=0
set -e
chapter=libassuan-3.0.2
err_report() {
    echo "chapter $chapter: $(date +'%Y.%m.%d %H:%M:%S') Error $? on line $1" | tee >> $topdir/log.txt
}
trap 'err_report $LINENO' ERR
echo "---------" >> $topdir/log.txt
echo chapter $chapter: start = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt




srcdir=../../src/libassuan-3.0.2
tar xf ../../src/libassuan-3.0.2.tar.bz2 -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir







# Introduction to libassuan
# 
# The libassuan package contains an inter process communication library used by some of the other GnuPG related packages. libassuan's primary use is to allow a client to interact with a non-persistent server. libassuan is not, however, limited to use with GnuPG servers and clients. It was designed to be flexible enough to meet the demands of many transaction based environments with non-persistent servers.
# [Note] Note
# 
# Development versions of BLFS may not build or run some packages properly if LFS or dependencies have been updated since the most recent stable versions of the books.
# Package Information
# 
#     Download (HTTP): https://www.gnupg.org/ftp/gcrypt/libassuan/libassuan-3.0.2.tar.bz2
# 
#     Download MD5 sum: c6f1bf4bd2aaa79cd1635dcc070ba51a
# 
#     Download size: 580 KB
# 
#     Estimated disk space required: 6.5 MB (with tests, add 3.4 MB for pdf documentation)
# 
#     Estimated build time: 0.1 SBU (with tests and html documentation)
# 
# libassuan Dependencies
# Required
# 
# libgpg-error-1.55
# Optional
# 
# texlive-20250308 (or install-tl-unx)
# Installation of libassuan
# 
# Install libassuan by running the following commands:
# 
./configure --prefix=/usr &&
make -j8

#make -C doc html                                                       &&
#makeinfo --html --no-split -o doc/assuan_nochunks.html doc/assuan.texi &&
#makeinfo --plaintext       -o doc/assuan.txt           doc/assuan.texi

# The above commands build the documentation in html and plaintext formats. If you wish to build alternate formats of the documentation, you must have texlive-20250308 installed and issue the following commands:
# 
# make -C doc pdf ps
# 
# To test the results, issue: make check.
# 
# Now, as the root user:

make install

# install -v -dm755   /usr/share/doc/libassuan-3.0.2/html &&
# install -v -m644 doc/assuan.html/* \
#                     /usr/share/doc/libassuan-3.0.2/html &&
# install -v -m644 doc/assuan_nochunks.html \
#                     /usr/share/doc/libassuan-3.0.2      &&
# install -v -m644 doc/assuan.{txt,texi} \
#                     /usr/share/doc/libassuan-3.0.2
# 
# If you built alternate formats of the documentation, install them by running the following commands as the root user:
# 
# install -v -m644  doc/assuan.{pdf,ps,dvi} \
#                   /usr/share/doc/libassuan-3.0.2
# 
# Contents
# Installed Program:
# None
# Installed Library:
# libassuan.so
# Installed Directory:
# /usr/share/doc/libassuan-3.0.2
# Short Descriptions
# 
# libassuan.so
# 	
# 
# is an inter process communication library which implements the Assuan protocol 








cd $topdir
rm -rf $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt

