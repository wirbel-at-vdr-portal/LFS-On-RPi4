topdir=$(pwd)
err=0
set -e
chapter=wget-1.25.0
err_report() {
    echo "chapter $chapter: $(date +'%Y.%m.%d %H:%M:%S') Error $? on line $1" | tee >> $topdir/log.txt
}
trap 'err_report $LINENO' ERR
echo "---------" >> $topdir/log.txt
echo chapter $chapter: start = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt




srcdir=../../src/wget-1.25.0
tar xf ../../src/wget-1.25.0.tar.gz -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir






#Introduction to Wget
#
#The Wget package contains a utility useful for non-interactive downloading of files from the Web.
#[Note] Note
#
#Development versions of BLFS may not build or run some packages properly if LFS or dependencies have been updated since the most recent stable versions of the books.
#Package Information
#
#    Download (HTTP): https://ftp.gnu.org/gnu/wget/wget-1.25.0.tar.gz
#
#    Download MD5 sum: c70ba58b36f944e8ba1d655ace552881
#
#    Download size: 5.0 MB
#
#    Estimated disk space required: 38 MB (add 27 MB for tests)
#
#    Estimated build time: 0.3 SBU (add 0.4 SBU for tests)
#
#Wget Dependencies
#Recommended
#
#libpsl-0.21.5
#Recommended at runtime
#
#make-ca-1.16
#Optional
#
#GnuTLS-3.8.9, HTTP-Daemon-6.16 (for the test suite), IO-Socket-SSL-2.089 (for the test suite), libidn2-2.3.8, libproxy-0.5.9, pcre2-10.45, and Valgrind-3.25.1 (for the test suite)
#Installation of Wget
#
#Install Wget by running the following commands:
#
./configure --prefix=/usr      \
            --sysconfdir=/etc  \
            --with-ssl=openssl &&
make

#To test the results, issue: make check.
#
#Some tests may fail when Valgrind tests are enabled.
#
#Now, as the root user:

make install

#Command Explanations
#
#--sysconfdir=/etc: This relocates the configuration file from /usr/etc to /etc.
#
#--with-ssl=openssl: This allows the program to use openssl instead of GnuTLS-3.8.9.
#
#--enable-libproxy: This switch allows wget to use libproxy for proxy configuration. Use it if you have the libproxy-0.5.9 package installed and wish to use a proxy server.
#
#--enable-valgrind-tests: This allows the tests to be run under valgrind.
#Configuring Wget
#Config Files
#
#/etc/wgetrc and ~/.wgetrc
#Contents
#Installed Program:
#wget
#Installed Libraries:
#None
#Installed Directories:
#None
#Short Descriptions
#
#wget
#	
#
#retrieves files from the Web using the HTTP, HTTPS and FTP protocols. It is designed to be non-interactive, for background or unattended operations 
#

cd $topdir
rm -rfv $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt

