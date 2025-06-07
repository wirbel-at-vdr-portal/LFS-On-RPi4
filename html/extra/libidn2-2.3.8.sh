topdir=$(pwd)
err=0
set -e
chapter=libidn2-2.3.8
err_report() {
    echo "chapter $chapter: $(date +'%Y.%m.%d %H:%M:%S') Error $? on line $1" | tee >> $topdir/log.txt
}
trap 'err_report $LINENO' ERR
echo "---------" >> $topdir/log.txt
echo chapter $chapter: start = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt




srcdir=../../src/libidn2-2.3.8
tar xf ../../src/libidn2-2.3.8.tar.gz -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir






# Introduction to libidn2
# 
# libidn2 is a package designed for internationalized string handling based on standards from the Internet Engineering Task Force (IETF)'s IDN working group, designed for internationalized domain names.
# [Note] Note
# 
# Development versions of BLFS may not build or run some packages properly if LFS or dependencies have been updated since the most recent stable versions of the books.
# Package Information
# 
#     Download (HTTP): https://ftp.gnu.org/gnu/libidn/libidn2-2.3.8.tar.gz
# 
#     Download MD5 sum: a8e113e040d57a523684e141970eea7a
# 
#     Download size: 2.1 MB
# 
#     Estimated disk space required: 21 MB (add 3 MB for tests)
# 
#     Estimated build time: 0.1 SBU (add 0.6 SBU for tests)
# 
# libidn2 Dependencies
# Recommended
# 
# libunistring-1.3
# Optional
# 
# git-2.49.0 and GTK-Doc-1.34.0
# Installation of libidn2
# 
# Install libidn2 by running the following commands:

./configure --prefix=/usr --disable-static &&
make -j4

# To test the results, issue: make check.
# 
# Now, as the root user:

make install

# Command Explanations
# 
# --disable-static: This switch prevents installation of static versions of the libraries.
# 
# --enable-gtk-doc: Use this parameter if GTK-Doc is installed and you wish to rebuild and install the API documentation.
# Contents
# Installed Program:
# idn2
# Installed Library:
# libidn2.so
# Installed Directory:
# /usr/share/gtk-doc/html/libidn2
# Short Descriptions
# 
# idn2
# 	
# 
# is a command line interface to the internationalized domain library
# 
# libidn2.so
# 	
# 
# contains a generic Stringprep implementation used for internationalized string handling 






cd $topdir
rm -rf $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt

