#!/usr/bin/bash

# ===== 8.48. OpenSSL-3.5.0 =====
topdir=$(pwd)
err=0
set -e
chapter=8048
err_report() {
    echo "chapter $chapter: $(date +'%Y.%m.%d %H:%M:%S') Error $? on line $1" | tee >> $topdir/log.txt
}
trap 'err_report $LINENO' ERR
echo "---------" >> $topdir/log.txt
echo chapter $chapter: start = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt




if [ "$EUID" -ne "0" ]; then
  echo "ERROR: Please run as root, not as user id = $EUID";stop
  exit 1
fi

grep -q $LFS/dev/pts /proc/mounts || err=1
if [ "$err" -eq "1" ]; then
  echo "ERROR: The '$LFS/dev/pts' partition must be mounted.";stop
  exit 1
fi

grep -q $LFS/dev /proc/mounts || err=1
if [ "$err" -eq "1" ]; then
  echo "ERROR: The '$LFS/dev' partition must be mounted.";stop
  exit 1
fi

grep -q $LFS/proc /proc/mounts || err=1
if [ "$err" -eq "1" ]; then
  echo "ERROR: The '$LFS/proc' partition must be mounted.";stop
  exit 1
fi

grep -q $LFS/sys /proc/mounts || err=1
if [ "$err" -eq "1" ]; then
  echo "ERROR: The '$LFS/sys' partition must be mounted.";stop
  exit 1
fi

grep -q $LFS/run /proc/mounts || err=1
if [ "$err" -eq "1" ]; then
  echo "ERROR: The '$LFS/run' partition must be mounted.";stop
  exit 1
fi



srcdir=../../src/openssl-3.5.0
tar xf ../../src/openssl-3.5.0.tar.gz -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir

#<p>
#
#  The OpenSSL package contains management tools and libraries relating to 
# cryptography. These are useful for providing cryptographic functions to other 
# packages, such as OpenSSH, email applications, and web browsers (for accessing 
# HTTPS sites). 
#</p>

#  Approximate build time: 1.8 SBU
#  Required disk space: 920 MB
# ==== 8.48.1. Installation of OpenSSL ====
#<p>
#
#  Prepare OpenSSL for compilation: 
#</p>

#********<pre>***********
./config --prefix=/usr         \
         --openssldir=/etc/ssl \
         --libdir=lib          \
         shared                \
         zlib-dynamic
#********</pre>**********
#<p>
#
#  Compile the package: 
#</p>

#********<pre>***********
make
#********</pre>**********
#<p>
#
#  To test the results, issue: 
#</p>

#********<pre>***********
#HARNESS_JOBS=$(nproc) make test
#********</pre>**********
#<p>
#
#  One test, 30-test_afalg.t, is known to fail if the host kernel does not have CONFIG_CRYPTO_USER_API_SKCIPHER 
#  enabled, or does not have any options providing an AES with CBC implementation 
# (for example, the combination of CONFIG_CRYPTO_AES 
#  and CONFIG_CRYPTO_CBC 
#  , or CONFIG_CRYPTO_AES_NI_INTEL 
#  if the CPU supports AES-NI) enabled. If it fails, it can safely be ignored. 
#</p>
#<p>
#
#  Install the package: 
#</p>

#********<pre>***********
sed -i '/INSTALL_LIBS/s/libcrypto.a libssl.a//' Makefile
make MANSUFFIX=ssl install
#********</pre>**********
#<p>
#
#  Add the version to the documentation directory name, to be consistent with 
# other packages: 
#</p>

#********<pre>***********
mv -v /usr/share/doc/openssl /usr/share/doc/openssl-3.5.0
#********</pre>**********
#<p>
#
#  If desired, install some additional documentation: 
#</p>

#********<pre>***********
#cp -vfr doc/* /usr/share/doc/openssl-3.5.0
#********</pre>**********

# ====== Note ======
#<p>
#
#  You should update OpenSSL when a new version which fixes vulnerabilities is 
# announced. Since OpenSSL 3.0.0, the OpenSSL versioning scheme follows the 
# MAJOR.MINOR.PATCH format. API/ABI compatibility is guaranteed for the same 
# MAJOR version number. Because LFS installs only the shared libraries, there is 
# no need to recompile packages which link to libcrypto.so 
#  or libssl.so when upgrading to a version with the same MAJOR version number
#  . 
#</p>
#<p>
#
#  However, any running programs linked to those libraries need to be stopped and 
# restarted. Read the related entries in [Section 8.2.1, “Upgrade Issues”](pkgmgt.html#pkgmgmt-upgrade-issues)
#  for details. 
#</p>

# ==== 8.48.2. Contents of OpenSSL ====

#  Installed programs: c_rehash and openssl
#  Installed libraries: libcrypto.so and libssl.so
#  Installed directories: /etc/ssl, /usr/include/openssl, /usr/lib/engines and /usr/share/doc/openssl-3.5.0
# ====== Short Descriptions ======

#--------------------------------------------
# | c_rehash                                 | is a                                    Perl                                    script that scans all files in a directory and adds symbolic links to their hash values. Use ofc_rehash                                is considered obsolete and should be replaced byopenssl rehash                          command                                 
# | openssl                                  | is a command-line tool for using the various cryptography functions ofOpenSSL                                 's crypto library from the shell. It can be used for various functions which are documented in[openssl(1)](https://man.archlinux.org/man/openssl.1)
# | libcrypto.so                             | implements a wide range of cryptographic algorithms used in various Internet standards. The services provided by this library are used by theOpenSSL                                 implementations of SSL, TLS and S/MIME, and they have also been used to implementOpenSSH                                 ,                                       OpenPGP                                 , and other cryptographic standards     
# | libssl.so                                | implements the Transport Layer Security (TLS v1) protocol. It provides a rich API, documentation on which can be found in[ssl(7)](https://man.archlinux.org/man/ssl.7)
#--------------------------------------------
cd $topdir
rm -rf $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt
