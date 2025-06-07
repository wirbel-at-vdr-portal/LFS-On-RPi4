topdir=$(pwd)
err=0
set -e
chapter=nss-3.112
err_report() {
    echo "chapter $chapter: $(date +'%Y.%m.%d %H:%M:%S') Error $? on line $1" | tee >> $topdir/log.txt
}
trap 'err_report $LINENO' ERR
echo "---------" >> $topdir/log.txt
echo chapter $chapter: start = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt




srcdir=../../src/nss-3.112
tar xf ../../src/nss-3.112.tar.gz -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir



# Introduction to NSS
# 
# The Network Security Services (NSS) package is a set of libraries designed to support cross-platform development of security-enabled client and server applications. Applications built with NSS can support SSL v2 and v3, TLS, PKCS #5, PKCS #7, PKCS #11, PKCS #12, S/MIME, X.509 v3 certificates, and other security standards. This is useful for implementing SSL and S/MIME or other Internet security standards into an application.
# [Note] Note
# 
# Development versions of BLFS may not build or run some packages properly if LFS or dependencies have been updated since the most recent stable versions of the books.
# Package Information
# 
#     Download (HTTP): https://archive.mozilla.org/pub/security/nss/releases/NSS_3_112_RTM/src/nss-3.112.tar.gz
# 
#     Download MD5 sum: 64a1ec06f5ebd0e2dd74ed1fe36e38d0
# 
#     Download size: 73 MB
# 
#     Estimated disk space required: 306 MB (add 144 MB for tests)
# 
#     Estimated build time: 0.7 SBU (with parallelism=4, add 16 SBU for tests on AMD Ryzens or at least 27 SBU on Intel machines)
# 
# Additional Downloads
# 
#     Required patch: https://www.linuxfromscratch.org/patches/blfs/svn/nss-standalone-1.patch
# 
# NSS Dependencies
# Required
# 
# NSPR-4.36
# Recommended
# 
# SQLite-3.50.0 and p11-kit-0.25.5 (runtime)
# 
# Editor Notes: https://wiki.linuxfromscratch.org/blfs/wiki/nss
# Installation of NSS
# 
# Install NSS by running the following commands:

patch -Np1 -i ../nss-standalone-1.patch &&

cd nss &&

make BUILD_OPT=1                      \
  NSPR_INCLUDE_DIR=/usr/include/nspr  \
  USE_SYSTEM_ZLIB=1                   \
  ZLIB_LIBS=-lz                       \
  NSS_ENABLE_WERROR=0                 \
  $([ $(uname -m) = aarch64 ] && echo USE_64=1)
# \
#  $([ -f /usr/include/sqlite3.h ] && echo NSS_USE_SYSTEM_SQLITE=1)

# To run the tests, execute the following commands:
# 
# cd tests &&
# HOST=localhost DOMSUF=localdomain ./all.sh
# cd ../
# 
# [Note] Note
# 
# Some information about the tests:
# 
#     HOST=localhost and DOMSUF=localdomain are required. Without these variables, a FQDN is required to be specified and this generic way should work for everyone, provided localhost.localdomain is defined in /etc/hosts, as done in the LFS book.
# 
#     The tests take a long time to run. If desired there is information in the all.sh script about running subsets of the total test suite.
# 
#     When interrupting the tests, the test suite fails to spin down test servers that are run. This leads to an infinite loop in the tests where the test suite tries to kill a server that doesn't exist anymore because it pulls the wrong PID.
# 
#     Test suite results (in HTML format!) can be found at ../../test_results/security/localhost.1/results.html
# 
#     A few tests might fail on some Intel machines for unknown reasons.
# 
# Now, as the root user:

cd ../dist                                                          &&

install -v -m755 Linux*/lib/*.so              /usr/lib              &&
install -v -m644 Linux*/lib/{*.chk,libcrmf.a} /usr/lib              &&

install -v -m755 -d                           /usr/include/nss      &&
cp -v -RL {public,private}/nss/*              /usr/include/nss      &&

install -v -m755 Linux*/bin/{certutil,nss-config,pk12util} /usr/bin &&

install -v -m644 Linux*/lib/pkgconfig/nss.pc  /usr/lib/pkgconfig

# Command Explanations
# 
# BUILD_OPT=1: This option is passed to make so that the build is performed with no debugging symbols built into the binaries and the default compiler optimizations are used.
# 
# NSPR_INCLUDE_DIR=/usr/include/nspr: This option sets the location of the nspr headers.
# 
# USE_SYSTEM_ZLIB=1: This option is passed to make to ensure that the libssl3.so library is linked to the system installed zlib instead of the in-tree version.
# 
# ZLIB_LIBS=-lz: This option provides the linker flags needed to link to the system zlib.
# 
# $([ $(uname -m) = x86_64 ] && echo USE_64=1): The USE_64=1 option is required on x86_64, otherwise make will try (and fail) to create 32-bit objects. The [ $(uname -m) = x86_64 ] test ensures it has no effect on a 32 bit system.
# 
# ([ -f /usr/include/sqlite3.h ] && echo NSS_USE_SYSTEM_SQLITE=1): This tests if sqlite is installed and if so it echos the option NSS_USE_SYSTEM_SQLITE=1 to make so that libsoftokn3.so will link against the system version of sqlite.
# 
# NSS_DISABLE_GTESTS=1: If you don't need to run NSS test suite, append this option to make command, to prevent the compilation of tests and save some build time.
# Configuring NSS
# 
# If p11-kit-0.25.5 is installed, the p11-kit trust module (/usr/lib/pkcs11/p11-kit-trust.so) can be used as a drop-in replacement for /usr/lib/libnssckbi.so to transparently make the system CAs available to NSS aware applications, rather than the static library provided by /usr/lib/libnssckbi.so. As the root user, execute the following command:

ln -sfv ./pkcs11/p11-kit-trust.so /usr/lib/libnssckbi.so

# Additionally, for dependent applications that do not use the internal database (/usr/lib/libnssckbi.so), the /usr/sbin/make-ca script included on the make-ca-1.16 page can generate a system wide NSS DB with the -n switch, or by modifying the /etc/make-ca/make-ca.conf file.
# Contents
# Installed Programs:
# certutil, nss-config, and pk12util
# Installed Libraries:
# libcrmf.a, libfreebl3.so, libfreeblpriv3.so, libnss3.so, libnssckbi.so, libnssckbi-testlib.so, libnssdbm3.so, libnsssysinit.so, libnssutil3.so, libpkcs11testmodule.so, libsmime3.so, libsoftokn3.so, and libssl3.so
# Installed Directories:
# /usr/include/nss
# Short Descriptions
# 
# certutil
# 	
# 
# is the Mozilla Certificate Database Tool. It is a command-line utility that can create and modify the Netscape Communicator cert8.db and key3.db database files. It can also list, generate, modify, or delete certificates within the cert8.db file and create or change the password, generate new public and private key pairs, display the contents of the key database, or delete key pairs within the key3.db file
# 
# nss-config
# 	
# 
# is used to determine the NSS library settings of the installed NSS libraries
# 
# pk12util
# 	
# 
# is a tool for importing certificates and keys from pkcs #12 files into NSS or exporting them. It can also list certificates and keys in such files 



cd $topdir
rm -rfv $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt

