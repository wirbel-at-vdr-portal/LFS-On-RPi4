topdir=$(pwd)
err=0
set -e
chapter=Nettle-3.10.1
err_report() {
    echo "chapter $chapter: $(date +'%Y.%m.%d %H:%M:%S') Error $? on line $1" | tee >> $topdir/log.txt
}
trap 'err_report $LINENO' ERR
echo "---------" >> $topdir/log.txt
echo chapter $chapter: start = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt




srcdir=../../src/nettle-3.10.1
tar xf ../../src/nettle-3.10.1.tar.gz -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir






# Introduction to Nettle
# 
# The Nettle package contains a low-level cryptographic library that is designed to fit easily in many contexts.
# [Note] Note
# 
# Development versions of BLFS may not build or run some packages properly if LFS or dependencies have been updated since the most recent stable versions of the books.
# Package Information
# 
#     Download (HTTP): https://ftp.gnu.org/gnu/nettle/nettle-3.10.1.tar.gz
# 
#     Download MD5 sum: c3dc1729cfa65fcabe2023dfbff60beb
# 
#     Download size: 2.5 MB
# 
#     Estimated disk space required: 100 MB (with tests)
# 
#     Estimated build time: 0.2 SBU (with tests; both using parallelism=4)
# 
# Nettle Dependencies
# Optional
# 
# Valgrind-3.25.1 (optional for the tests)
# Installation of Nettle
# 
# Install Nettle by running the following commands:
# 
./configure --prefix=/usr --disable-static &&
make -j4

# To test the results, issue: make check.
# 
# Now, as the root user:

make install &&
chmod   -v   755 /usr/lib/lib{hogweed,nettle}.so &&
install -v -m755 -d /usr/share/doc/nettle-3.10.1 &&
install -v -m644 nettle.{html,pdf} /usr/share/doc/nettle-3.10.1

# Command Explanations
# 
# --disable-static: This switch prevents installation of static versions of the libraries.
# Contents
# Installed Programs:
# nettle-hash, nettle-lfib-stream, nettle-pbkdf2, pkcs1-conv and sexp-conv
# Installed Libraries:
# libhogweed.so and libnettle.so
# Installed Directory:
# /usr/include/nettle and /usr/share/doc/nettle-3.10.1
# Short Descriptions
# 
# nettle-hash
# 	
# 
# calculates a hash value using a specified algorithm
# 
# nettle-lfib-stream
# 	
# 
# outputs a sequence of pseudorandom (non-cryptographic) bytes, using Knuth's lagged fibonacci generator. The stream is useful for testing, but should not be used to generate cryptographic keys or anything else that needs real randomness
# 
# nettle-pbkdf2
# 	
# 
# is a password-based key derivation function that takes a password or a passphrase as input and returns a strengthened password, which is protected against pre-computation attacks by using salting and other expensive computations.
# 
# pkcs1-conv
# 	
# 
# converts private and public RSA keys from PKCS #1 format to sexp format
# 
# sexp-conv
# 	
# 
# converts an s-expression to a different encoding 




cd $topdir
rm -rfv $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt

