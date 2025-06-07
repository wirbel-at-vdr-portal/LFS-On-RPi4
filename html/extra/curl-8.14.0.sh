topdir=$(pwd)
err=0
set -e
chapter=curl-8.14.0
err_report() {
    echo "chapter $chapter: $(date +'%Y.%m.%d %H:%M:%S') Error $? on line $1" | tee >> $topdir/log.txt
}
trap 'err_report $LINENO' ERR
echo "---------" >> $topdir/log.txt
echo chapter $chapter: start = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt




srcdir=../../src/curl-8.14.0
tar xf ../../src/curl-8.14.0.tar.xz -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir







# Introduction to cURL
# 
# The cURL package contains an utility and a library used for transferring files with URL syntax to any of the following protocols: DICT, FILE, FTP, FTPS, GOPHER, GOPHERS, HTTP, HTTPS, IMAP, IMAPS, LDAP, LDAPS, MQTT, POP3, POP3S, RTSP, SMB, SMBS, SMTP, SMPTS, TELNET, and TFTP. Its ability to both download and upload files can be incorporated into other programs to support functions like streaming media.
# [Note] Note
# 
# Development versions of BLFS may not build or run some packages properly if LFS or dependencies have been updated since the most recent stable versions of the books.
# Package Information
# 
#     Download (HTTP): https://curl.se/download/curl-8.14.0.tar.xz
# 
#     Download MD5 sum: 34a7f339efbb60bf872022ac8bdfe2b1
# 
#     Download size: 2.7 MB
# 
#     Estimated disk space required: 52 MB (add 68 MB for tests)
# 
#     Estimated build time: 0.2 SBU (add 4.9 SBU for tests (without valgrind, add 19 SBU with valgrind) all using parallelism=4)
# 
# Additional Downloads
# 
#     Required patch: https://www.linuxfromscratch.org/patches/blfs/svn/curl-8.14.0-upstream_fix-1.patch
# 
# cURL Dependencies
# Recommended
# 
# libpsl-0.21.5
# [Note] Note
# 
# While there is an option to build the package without libpsl, both the upstream developers and the BLFS editors alike highly recommend not disabling support for libpsl due to severe security implications.
# Recommended at runtime
# 
# make-ca-1.16
# Optional
# 
# Brotli-1.1.0, c-ares-1.34.5, GnuTLS-3.8.9, libidn2-2.3.8, libssh2-1.11.1, MIT Kerberos V5-1.21.3, nghttp2-1.65.0, OpenLDAP-2.6.10, Samba-4.22.1 (runtime, for NTLM authentication), gsasl, impacket, libmetalink, librtmp, ngtcp2, quiche, and SPNEGO
# Optional if Running the Test Suite
# 
# Apache-2.4.63 and stunnel-5.75 (for the HTTPS and FTPS tests), OpenSSH-10.0p1, and Valgrind-3.25.1 (this will slow the tests down and may cause failures)
# Installation of cURL
# 
# First, apply a patch from upstream:

patch -Np1 -i ../curl-8.14.0-upstream_fix-1.patch

# Install cURL by running the following commands:

./configure --prefix=/usr    \
            --disable-static \
            --with-openssl   \
            --with-ca-path=/etc/ssl/certs &&
make -j8

# To run the test suite, issue: make test. Some tests are flaky, so if some tests have failed it's possible to run a test again with: (cd tests; ./runtests.pl <test ID>) (the ID of failed tests are shown in the “These test cases failed:” message). If you run the tests after the package has been installed, some tests may fail because the man pages were deleted by the 'find' command in the installation instructions below.
# 
# Now, as the root user:
# 
make install &&

rm -rf docs/examples/.deps &&

find docs \( -name Makefile\* -o  \
             -name \*.1       -o  \
             -name \*.3       -o  \
             -name CMakeLists.txt \) -delete &&

cp -v -R docs -T /usr/share/doc/curl-8.14.0

# To run some simple verification tests on the newly installed curl, issue the following commands: curl --trace-ascii debugdump.txt https://www.example.com/ and curl --trace-ascii d.txt --trace-time https://example.com/. Inspect the locally created trace files debugdump.txt and d.txt, which contains version information, downloaded files information, etc. One file has the time for each action logged.
# Command Explanations
# 
# --disable-static: This switch prevents installation of static versions of the libraries.
# 
# --with-ca-path=/etc/ssl/certs: This switch sets the location of the BLFS Certificate Authority store.
# 
# --with-openssl: This parameter chooses OpenSSL as SSL/TLS implementation. This option is not needed if --with-gnutls is selected instead.
# 
# --with-gssapi: This parameter adds Kerberos 5 support to libcurl.
# 
# --with-gnutls: Use this switch to build with GnuTLS support instead of OpenSSL for SSL/TLS.
# 
# --with-ca-bundle=/etc/pki/tls/certs/ca-bundle.crt: Use this switch instead of --with-ca-path if building with GnuTLS support instead of OpenSSL for SSL/TLS.
# 
# --with-libssh2: This parameter adds SSH support to cURL. This is disabled by default.
# 
# --enable-ares: This parameter adds support for DNS resolution through the c-ares library.
# 
# find docs ... -exec rm {} \;: This command removes Makefiles and man files from the documentation directory that would otherwise be installed by the commands that follow.
# Contents
# Installed Programs:
# curl and curl-config
# Installed Library:
# libcurl.so
# Installed Directories:
# /usr/include/curl and /usr/share/doc/curl-8.14.0
# Short Descriptions
# 
# curl
# 	
# 
# is a command line tool for transferring files with URL syntax
# 
# curl-config
# 	
# 
# prints information about the last compile, like libraries linked to and prefix setting
# 
# libcurl.so
# 	
# 
# provides the API functions required by curl and other programs 









cd $topdir
rm -rf $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt

