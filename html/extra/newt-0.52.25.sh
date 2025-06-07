topdir=$(pwd)
err=0
set -e
chapter=newt-0.52.25
err_report() {
    echo "chapter $chapter: $(date +'%Y.%m.%d %H:%M:%S') Error $? on line $1" | tee >> $topdir/log.txt
}
trap 'err_report $LINENO' ERR
echo "---------" >> $topdir/log.txt
echo chapter $chapter: start = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt




srcdir=../../src/newt-0.52.25
tar xf ../../src/newt-0.52.25.tar.gz -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir





# Introduction to newt
# 
# Newt is a programming library for color text mode, widget based user interfaces. It can be used to add stacked windows, entry widgets, checkboxes, radio buttons, labels, plain text fields, scrollbars, etc., to text mode user interfaces. Newt is based on the S-Lang library.
# [Note] Note
# 
# Development versions of BLFS may not build or run some packages properly if LFS or dependencies have been updated since the most recent stable versions of the books.
# Package Information
# 
#     Download (HTTP): https://releases.pagure.org/newt/newt-0.52.25.tar.gz
# 
#     Download MD5 sum: cca66ed1d8774fb9e3f6a33525de416d
# 
#     Download size: 176 KB
# 
#     Estimated disk space required: 3.0 MB
# 
#     Estimated build time: less than 0.1 SBU
# 
# Newt Dependencies
# Required
# 
# popt-1.19 and slang-2.3.3
# Recommended
# 
# GPM-1.20.7 (runtime)
# Installation of newt
# 
# Install newt by running the following command:

sed -e '/install -m 644 $(LIBNEWT)/ s/^/#/' \
    -e '/$(LIBNEWT):/,/rv/ s/^/#/'          \
    -e 's/$(LIBNEWT)/$(LIBNEWTSH)/g'        \
    -i Makefile.in                          &&

./configure --prefix=/usr      \
            --with-gpm-support \
            --with-python=python3.13 &&
make -j4

# This package does not come with a test suite.

# Now, as the root user:

make install

# Command Explanations
# 
# sed -e ... -i Makefile.in: Disables installation of a static library.
# 
# --with-gpm-support: This switch enables mouse support for newt applications through GPM.
# 
# --with-python=python3.13: By giving explicitly the name of the directory where python modules reside, this switch prevents building the python2 module.
# Contents
# Installed Programs:
# whiptail
# Installed Library:
# libnewt.so, whiptcl.so, and /usr/lib/python3.13/site-packages/_snack.so
# Installed Directories:
# None
# Short Descriptions
# 
# whiptail
# 	
# 
# displays dialog boxes from shell scripts
# 
# libnewt.so
# 	
# 
# is the library for color text mode, widget based user interfaces
# 





cd $topdir
rm -rfv $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt

