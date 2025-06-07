topdir=$(pwd)
err=0
set -e
chapter=nspr-4.36
err_report() {
    echo "chapter $chapter: $(date +'%Y.%m.%d %H:%M:%S') Error $? on line $1" | tee >> $topdir/log.txt
}
trap 'err_report $LINENO' ERR
echo "---------" >> $topdir/log.txt
echo chapter $chapter: start = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt




srcdir=../../src/nspr-4.36
tar xf ../../src/nspr-4.36.tar.gz -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir


#Introduction to NSPR
#
#Netscape Portable Runtime (NSPR) provides a platform-neutral API for system level and libc like functions.
#[Note] Note
#
#Development versions of BLFS may not build or run some packages properly if LFS or dependencies have been updated since the most recent stable versions of the books.
#Package Information
#
#    Download (HTTP): https://archive.mozilla.org/pub/nspr/releases/v4.36/src/nspr-4.36.tar.gz
#
#    Download MD5 sum: 87a41a0773ab2a5f5c8f01aec16df24c
#
#    Download size: 1.0 MB
#
#    Estimated disk space required: 9.9 MB
#
#    Estimated build time: less than 0.1 SBU
#
#Installation of NSPR
#
#Install NSPR by running the following commands:

cd nspr &&

sed -i '/^RELEASE/s|^|#|' pr/src/misc/Makefile.in &&
sed -i 's|$(LIBRARY) ||'  config/rules.mk         &&

./configure --prefix=/usr   \
            --with-mozilla  \
            --with-pthreads \
            $([ $(uname -m) = x86_64 ] && echo --enable-64bit) &&
make

#The test suite is designed for testing changes to nss or nspr and is not particularly useful for checking a released version (e.g. it needs to be run on a non-optimized build with both nss and nspr directories existing alongside each other). For further details, see the Editor Notes for nss at https://wiki.linuxfromscratch.org/blfs/wiki/nss
#
#Now, as the root user:

make install

#Command Explanations
#
#sed -ri '/^RELEASE/s/^/#/' pr/src/misc/Makefile.in: This sed disables installing two unneeded scripts.
#
#sed -i 's#$(LIBRARY) ##' config/rules.mk: This sed disables installing the static libraries.
#
#--with-mozilla: This parameter adds Mozilla support to the libraries (required if you want to build any other Mozilla products and link them to these libraries).
#
#--with-pthreads: This parameter forces use of the system pthread library.
#
#--enable-64bit: The --enable-64bit parameter is required on an x86_64 system to prevent configure failing with a claim that this is a system without pthread support. The [ $(uname -m) = x86_64 ] test ensures it has no effect on a 32 bit system.
#Contents
#Installed Programs:
#nspr-config
#Installed Libraries:
#libnspr4.so, libplc4.so, and libplds4.so
#Installed Directories:
#/usr/include/nspr
#Short Descriptions
#
#nspr-config
#	
#
#provides compiler and linker options to other packages that use NSPR
#
#libnspr4.so
#	
#
#contains functions that provide platform independence for non-GUI operating system facilities such as threads, thread synchronization, normal file and network I/O, interval timing and calendar time, basic memory management and shared library linking
#
#libplc4.so
#	
#
#contains functions that implement many of the features offered by libnspr4
#
#libplds4.so
#	
#
#contains functions that provide data structures 


cd $topdir
rm -rfv $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt

