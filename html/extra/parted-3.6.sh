topdir=$(pwd)
err=0
set -e
chapter=parted-3.6
err_report() {
    echo "chapter $chapter: $(date +'%Y.%m.%d %H:%M:%S') Error $? on line $1" | tee >> $topdir/log.txt
}
trap 'err_report $LINENO' ERR
echo "---------" >> $topdir/log.txt
echo chapter $chapter: start = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt




srcdir=../../src/parted-3.6
tar xf ../../src/parted-3.6.tar.xz -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir








# Introduction to parted
# 
# The Parted package is a disk partitioning and partition resizing tool.
# [Note] Note
# 
# Development versions of BLFS may not build or run some packages properly if LFS or dependencies have been updated since the most recent stable versions of the books.
# Package Information
# 
#     Download (HTTP): https://ftp.gnu.org/gnu/parted/parted-3.6.tar.xz
# 
#     Download MD5 sum: 93d2d8f22baebc5eb65b85da05a79e4e
# 
#     Download size: 1.8 MB
# 
#     Estimated disk space required: 29 MB (additional 3 MB for the tests and additional 2 MB for optional PDF and Postscript documentation)
# 
#     Estimated build time: 0.3 SBU (additional 3.6 SBU for the tests)
# 
# Parted Dependencies
# Recommended
# 
# LVM2-2.03.32 (device-mapper, required if building udisks)
# Optional
# 
# dosfstools-4.2, texlive-20250308 (or install-tl-unx), and Digest::CRC (for tests)
# Optional Kernel Configuration for Tests
# 
# About 20 % more tests are run if the following kernel module is built:
# 
# Device Drivers --->
#   SCSI device support --->
#     [*] SCSI low-level drivers --->                              [SCSI_LOWLEVEL]
#       <M> SCSI debugging host and device simulator                  [SCSI_DEBUG]
# 
# Installation of parted
# 
# First, make the package compatible with gcc-15:

sed -i 's/do_version ()/do_version (PedDevice** dev, PedDisk** diskp)/' parted/parted.c

# Install Parted by running the following commands:

./configure --prefix=/usr --disable-static --disable-device-mapper &&
make &&

make -C doc html                                       &&
makeinfo --html      -o doc/html       doc/parted.texi &&
makeinfo --plaintext -o doc/parted.txt doc/parted.texi

# If you have texlive-20250308 installed and wish to create PDF and Postscript documentation issue the following commands:
# 
# cp build-aux/texinfo.tex doc               &&
# texi2pdf -o doc/parted.pdf doc/parted.texi &&
# texi2dvi -o doc/parted.dvi doc/parted.texi &&
# dvips    -o doc/parted.ps  doc/parted.dvi
# 
# To test the results, issue, as the root user:
# 
# make check
# 
# [Note] Note
# 
# Many tests are skipped if not run as the root user.
# 
# Now, as the root user:

make install &&
install -v -m755 -d /usr/share/doc/parted-3.6/html &&
install -v -m644    doc/html/* \
                    /usr/share/doc/parted-3.6/html &&
install -v -m644    doc/{FAT,API,parted.{txt,html}} \
                    /usr/share/doc/parted-3.6

# Install the optional PDF and Postscript documentation by issuing the following command as the root user:
# 
# install -v -m644 doc/FAT doc/API doc/parted.{pdf,ps,dvi} \
#                     /usr/share/doc/parted-3.6
# 
# Command Explanations
# 
# --disable-static: This switch prevents installation of static versions of the libraries.
# 
# --disable-device-mapper: This option disables device mapper support. Add this parameter if you have not installed LVM2.
# Contents
# Installed Programs:
# parted and partprobe
# Installed Libraries:
# libparted.so and libparted-fs-resize.so
# Installed Directories:
# /usr/include/parted and /usr/share/doc/parted-3.6
# Short Descriptions
# 
# parted
# 	
# 
# is a partition manipulation program
# 
# partprobe
# 	
# 
# informs the OS of partition table changes
# 
# libparted.so
# 	
# 
# contains the Parted API functions 
# 








cd $topdir
rm -rf $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt

