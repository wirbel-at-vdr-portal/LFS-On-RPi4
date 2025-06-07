topdir=$(pwd)
err=0
set -e
chapter=cpio-2.15
err_report() {
    echo "chapter $chapter: $(date +'%Y.%m.%d %H:%M:%S') Error $? on line $1" | tee >> $topdir/log.txt
}
trap 'err_report $LINENO' ERR
echo "---------" >> $topdir/log.txt
echo chapter $chapter: start = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt




srcdir=../../src/cpio-2.15
tar xf ../../src/cpio-2.15.tar.bz2 -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir




# Introduction to cpio
# 
# The cpio package contains tools for archiving.
# [Note] Note
# 
# Development versions of BLFS may not build or run some packages properly if LFS or dependencies have been updated since the most recent stable versions of the books.
# Package Information
# 
#     Download (HTTP): https://ftp.gnu.org/gnu/cpio/cpio-2.15.tar.bz2
# 
#     Download MD5 sum: 3394d444ca1905ea56c94b628b706a0b
# 
#     Download size: 1.6 MB
# 
#     Estimated disk space required: 21 MB (with tests and docs)
# 
#     Estimated build time: 0.3 SBU (with tests and docs)
# 
# CPIO Dependencies
# Optional
# 
# texlive-20250308 (or install-tl-unx)
# Installation of cpio
# 
# Add a workaround for an issue shown by gcc15:

sed -e "/^extern int (\*xstat)/s/()/(const char * restrict,  struct stat * restrict)/" \
    -i src/extern.h
sed -e "/^int (\*xstat)/s/()/(const char * restrict,  struct stat * restrict)/" \
    -i src/global.c

# Install cpio by running the following commands:

./configure --prefix=/usr \
            --enable-mt   \
            --with-rmt=/usr/libexec/rmt &&
make &&
makeinfo --html            -o doc/html      doc/cpio.texi &&
makeinfo --html --no-split -o doc/cpio.html doc/cpio.texi &&
makeinfo --plaintext       -o doc/cpio.txt  doc/cpio.texi

# If you have texlive-20250308 installed and wish to create PDF or Postscript documentation, issue one or both of the following commands:
# 
# make -C doc pdf &&
# make -C doc ps
# 
# To test the results, issue: make check.
# 
# Now, as the root user:

make install &&
install -v -m755 -d /usr/share/doc/cpio-2.15/html &&
install -v -m644    doc/html/* \
                    /usr/share/doc/cpio-2.15/html &&
install -v -m644    doc/cpio.{html,txt} \
                    /usr/share/doc/cpio-2.15

# If you built PDF or Postscript documentation, install it by issuing the following commands as the root user:
# 
# install -v -m644 doc/cpio.{pdf,ps,dvi} \
#                  /usr/share/doc/cpio-2.15
# 
# Command Explanations
# 
# --enable-mt: This parameter forces the building and installation of the mt program.
# 
# --with-rmt=/usr/libexec/rmt: This parameter inhibits building the rmt program as it is already installed by the Tar package in LFS.
# Contents
# Installed Programs:
# cpio and mt
# Installed Libraries:
# None
# Installed Directories:
# /usr/share/doc/cpio-2.15
# Short Descriptions
# 
# cpio
# 	
# 
# copies files to and from archives
# 
# mt
# 	
# 
# controls magnetic tape drive operations 
# 


cd $topdir
rm -rfv $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt

