topdir=$(pwd)
err=0
set -e
chapter=gptfdisk-1.0.10
err_report() {
    echo "chapter $chapter: $(date +'%Y.%m.%d %H:%M:%S') Error $? on line $1" | tee >> $topdir/log.txt
}
trap 'err_report $LINENO' ERR
echo "---------" >> $topdir/log.txt
echo chapter $chapter: start = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt




srcdir=../../src/gptfdisk-1.0.10
tar xf ../../src/gptfdisk-1.0.10.tar.gz -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir










# Introduction to gptfdisk
# 
# The gptfdisk package is a set of programs for creation and maintenance of GUID Partition Table (GPT) disk drives. A GPT partitioned disk is required for drives greater than 2 TB and is a modern replacement for legacy PC-BIOS partitioned disk drives that use a Master Boot Record (MBR). The main program, gdisk, has an interface similar to the classic fdisk program.
# [Note] Note
# 
# Development versions of BLFS may not build or run some packages properly if LFS or dependencies have been updated since the most recent stable versions of the books.
# Package Information
# 
#     Download (HTTP): https://downloads.sourceforge.net/gptfdisk/gptfdisk-1.0.10.tar.gz
# 
#     Download MD5 sum: 1970269eb7a97560e238611524b7797a
# 
#     Download size: 216 KB
# 
#     Estimated disk space required: 2.4 MB
# 
#     Estimated build time: less than 0.1 SBU (add 0.2 SBU for tests)
# 
# Additional Downloads
# 
#     Recommended patch: https://www.linuxfromscratch.org/patches/blfs/svn/gptfdisk-1.0.10-convenience-1.patch
# 
# gptfdisk Dependencies
# Required
# 
# popt-1.19
# Optional
# 
# ICU-77.1
# Installation of gptfdisk
# 
# The gptfdisk package comes with a rudimentary Makefile.
# First we update it to provide a simple build and install interface
# and fix the location of a header file and fix some minor location issues.
# Install gptfdisk by running the following commands:

patch -Np1 -i ../gptfdisk-1.0.10-convenience-1.patch &&
sed -i 's|ncursesw/||' gptcurses.cc &&
sed -i 's|sbin|usr/sbin|' Makefile  &&

make

# To test the results, issue: make test.
# 
# Now, as the root user:

make install

# Command Explanations
# 
# patch -Np1 ...: This patch modifies the Makefile file so that it provides an “install” target.
# Contents
# Installed Programs:
# cgdisk, gdisk, fixparts, and sgdisk
# Short Descriptions
# 
# cgdisk
# 	
# 
# is an ncurses-based tool for manipulating GPT partitions
# 
# gdisk
# 	
# 
# is an interactive text-mode tool for manipulating GPT partitions
# 
# fixparts
# 	
# 
# repairs mis-formatted MBR based disk partitions
# 
# sgdisk
# 	
# 
# is a partition manipulation program for GPT partitions similar to sfdisk 
# 








cd $topdir
rm -rf $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt

