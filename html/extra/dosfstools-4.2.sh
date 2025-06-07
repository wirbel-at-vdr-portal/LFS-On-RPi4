topdir=$(pwd)
err=0
set -e
chapter=dosfstools-4.2
err_report() {
    echo "chapter $chapter: $(date +'%Y.%m.%d %H:%M:%S') Error $? on line $1" | tee >> $topdir/log.txt
}
trap 'err_report $LINENO' ERR
echo "---------" >> $topdir/log.txt
echo chapter $chapter: start = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt




srcdir=../../src/dosfstools-4.2
tar xf ../../src/dosfstools-4.2.tar.gz -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir






# Introduction to dosfstools
# 
# The dosfstools package contains various utilities for use with the FAT family of file systems.
# [Note] Note
# 
# Development versions of BLFS may not build or run some packages properly if LFS or dependencies have been updated since the most recent stable versions of the books.
# Package Information
# 
#     Download (HTTP): https://github.com/dosfstools/dosfstools/releases/download/v4.2/dosfstools-4.2.tar.gz
# 
#     Download MD5 sum: 49c8e457327dc61efab5b115a27b087a
# 
#     Download size: 314 KB
# 
#     Estimated disk space required: 4.5 MB (with tests)
# 
#     Estimated build time: less than 0.1 SBU
# 
# Kernel Configuration
# 
# Enable the following option in the kernel configuration and recompile the kernel if you need to mount a FAT-family filesystem:
# 
# File systems --->
#   DOS/FAT/EXFAT/NT Filesystems --->
#     < /*/M> MSDOS fs support                                          [MSDOS_FS]
#     <*/M>   VFAT (Windows-95) fs support                               [VFAT_FS]
# 
# Note that CONFIG_MSDOS_FS deliberately does not support long file names. CONFIG_VFAT_FS should be used instead unless you really want to enforce the DOS-style “8.3” file names.
# 
# You can mount a FAT-family filesystem once the kernel supports it. If you don't need to create, check, or relabel a FAT-family system, you may skip this package.
# Installation of dosfstools
# 
# Install dosfstools by running the following commands:

./configure --prefix=/usr            \
            --enable-compat-symlinks \
            --mandir=/usr/share/man  \
            --docdir=/usr/share/doc/dosfstools-4.2 &&
make -j4

# To test the results, issue: make check.
# 
# Now, as the root user:

make install

# Command Explanations
# 
# --enable-compat-symlinks: This switch creates the dosfsck, dosfslabel, fsck.msdos, fsck.vfat, mkdosfs, mkfs.msdos, and mkfs.vfat symlinks required by some programs.
# Contents
# Installed Programs:
# fatlabel, fsck.fat, and mkfs.fat
# Short Descriptions
# 
# fatlabel
# 	
# 
# sets or gets a MS-DOS filesystem label from a given device
# 
# fsck.fat
# 	
# 
# checks and repairs MS-DOS filesystems
# 
# mkfs.fat
# 	
# 
# creates an MS-DOS filesystem under Linux 
# 




cd $topdir
rm -rfv $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt

