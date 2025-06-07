topdir=$(pwd)
err=0
set -e
chapter=gnutls-3.8.9
err_report() {
    echo "chapter $chapter: $(date +'%Y.%m.%d %H:%M:%S') Error $? on line $1" | tee >> $topdir/log.txt
}
trap 'err_report $LINENO' ERR
echo "---------" >> $topdir/log.txt
echo chapter $chapter: start = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt




srcdir=../../src/gnutls-3.8.9
tar xf ../../src/gnutls-3.8.9.tar.xz -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir






# Introduction to GnuTLS
# 
# The GnuTLS package contains libraries and userspace tools which provide a secure layer over a reliable transport layer. Currently the GnuTLS library implements the proposed standards by the IETF's TLS working group. Quoting from the TLS 1.3 protocol specification :
# 
# “ TLS allows client/server applications to communicate over the Internet in a way that is designed to prevent eavesdropping, tampering, and message forgery. ”
# 
# GnuTLS provides support for TLS 1.3, TLS 1.2, TLS 1.1, TLS 1.0, and (optionally) SSL 3.0 protocols. It also supports TLS extensions, including server name and max record size. Additionally, the library supports authentication using the SRP protocol, X.509 certificates, and OpenPGP keys, along with support for the TLS Pre-Shared-Keys (PSK) extension, the Inner Application (TLS/IA) extension, and X.509 and OpenPGP certificate handling.
# [Note] Note
# 
# Development versions of BLFS may not build or run some packages properly if LFS or dependencies have been updated since the most recent stable versions of the books.
# Package Information
# 
#     Download (HTTP): https://www.gnupg.org/ftp/gcrypt/gnutls/v3.8/gnutls-3.8.9.tar.xz
# 
#     Download MD5 sum: 33f4c800c20af2983c45223a803da865
# 
#     Download size: 6.5 MB
# 
#     Estimated disk space required: 178 MB (add 111 MB for tests)
# 
#     Estimated build time: 0.6 SBU (add 1.4 SBU for tests; both using parallelism=8)
# 
# GnuTLS Dependencies
# Required
# 
# Nettle-3.10.1
# Recommended
# 
# make-ca-1.16, libunistring-1.3, libtasn1-4.20.0, and p11-kit-0.25.5
# Optional
# 
# Brotli-1.1.0, Doxygen-1.14.0, GTK-Doc-1.34.0, libidn-1.43 or libidn2-2.3.8, libseccomp-2.6.0, Net-tools-2.10 (used during the test suite), texlive-20250308 or install-tl-unx, Unbound-1.23.0 (to build the DANE library), Valgrind-3.25.1 (used during the test suite), autogen, cmocka and datefudge (used during the test suite if the DANE library is built), leancrypto, liboqs, and Trousers (Trusted Platform Module support)
# [Note] Note
# 
# Note that if you do not install libtasn1-4.20.0, a version shipped in the GnuTLS tarball will be used instead.
# Installation of GnuTLS
# 
# Install GnuTLS by running the following commands:

./configure --prefix=/usr \
            --docdir=/usr/share/doc/gnutls-3.8.9 \
            --with-default-trust-store-pkcs11="pkcs11:" &&
make -j8

# To test the results, now issue: make check.
# 
# Now, install the package as the root user:

make install

# Command Explanations
# 
# --with-default-trust-store-pkcs11="pkcs11:": This switch tells gnutls to use the PKCS #11 trust store as the default trust. Omit this switch if p11-kit-0.25.5 is not installed.
# 
# --with-default-trust-store-file=/etc/pki/tls/certs/ca-bundle.crt: This switch tells configure where to find the legacy CA certificate bundle and to use it instead of PKCS #11 module by default. Use this if p11-kit-0.25.5 is not installed.
# 
# --enable-gtk-doc: Use this parameter if GTK-Doc is installed and you wish to rebuild and install the API documentation.
# 
# --enable-openssl-compatibility: Use this switch if you wish to build the OpenSSL compatibility library.
# 
# --without-p11-kit: Use this switch if you have not installed p11-kit-0.25.5.
# 
# --with-included-unistring: This switch uses the bundled version of libunistring, instead of the system one. Use this switch if you have not installed libunistring-1.3.
# 
# --disable-dsa: This switch completely disables DSA algorithm support.
# Contents
# Installed Programs:
# certtool, danetool, gnutls-cli, gnutls-cli-debug, gnutls-serv, ocsptool, p11tool, psktool, and srptool
# Installed Libraries:
# libgnutls.so, libgnutls-dane.so, libgnutlsxx.so, and libgnutls-openssl.so (optional)
# Installed Directories:
# /usr/include/gnutls and /usr/share/doc/gnutls-3.8.9
# Short Descriptions
# 
# certtool
# 	
# 
# is used to generate X.509 certificates, certificate requests, and private keys
# 
# danetool
# 	
# 
# is a tool used to generate and check DNS resource records for the DANE protocol
# 
# gnutls-cli
# 	
# 
# is a simple client program to set up a TLS connection to some other computer
# 
# gnutls-cli-debug
# 	
# 
# is a simple client program to set up a TLS connection to some other computer and produces very verbose progress results
# 
# gnutls-serv
# 	
# 
# is a simple server program that listens to incoming TLS connections
# 
# ocsptool
# 	
# 
# is a program that can parse and print information about OCSP requests/responses, generate requests and verify responses
# 
# p11tool
# 	
# 
# is a program that allows handling data from PKCS #11 smart cards and security modules
# 
# psktool
# 	
# 
# is a simple program that generates random keys for use with TLS-PSK
# 
# srptool
# 	
# 
# is a simple program that emulates the programs in the Stanford SRP (Secure Remote Password) libraries using GnuTLS
# 
# libgnutls.so
# 	
# 
# contains the core API functions and X.509 certificate API functions 





cd $topdir
rm -rfv $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt

