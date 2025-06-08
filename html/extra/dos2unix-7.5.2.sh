topdir=$(pwd)
err=0
set -e
chapter=dos2unix-7.5.2
err_report() {
    echo "chapter $chapter: $(date +'%Y.%m.%d %H:%M:%S') Error $? on line $1" | tee >> $topdir/log.txt
}
trap 'err_report $LINENO' ERR
echo "---------" >> $topdir/log.txt
echo chapter $chapter: start = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt




srcdir=../../src/dos2unix-7.5.2
tar xf ../../src/dos2unix-7.5.2.tar.gz -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir












# Introduction to dos2unix
# 
# The dos2unix package contains an any-to-any text format converter.
# [Note] Note
# 
# Development versions of BLFS may not build or run some packages properly if LFS or dependencies have been updated since the most recent stable versions of the books.
# Package Information
# 
#     Download (HTTP): https://downloads.sourceforge.net/dos2unix/dos2unix-7.5.2.tar.gz
# 
#     Download MD5 sum: 646272020848c9b673de24c4e8e3422e
# 
#     Download size: 972 KB
# 
#     Estimated disk space required: 7.2 MB (with tests)
# 
#     Estimated build time: less than 0.1 SBU (with tests)
# 
# Installation of dos2unix
# 
# Build dos2unix by running the following commands:

make

# To test the results, issue: make check.
# 
# Now, as the root user:

make install

# Contents
# Installed Program:
# dos2unix, mac2unix, unix2dos, and unix2mac
# Installed Libraries:
# None
# Installed Directories:
# /usr/share/doc/dos2unix-7.5.2
# Short Descriptions
# 
# dos2unix
# 	
# 
# converts plain text files in DOS format to Unix format
# 
# mac2unix
# 	
# 
# converts plain text files in Mac format to Unix format
# 
# unix2dos
# 	
# 
# converts plain text files in Unix format to DOS format
# 
# unix2mac
# 	
# 
# converts plain text files in Unix format to Mac format 
# 







cd $topdir
rm -rf $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt

