topdir=$(pwd)
err=0
set -e
chapter=pciutils-3.13.0
err_report() {
    echo "chapter $chapter: $(date +'%Y.%m.%d %H:%M:%S') Error $? on line $1" | tee >> $topdir/log.txt
}
trap 'err_report $LINENO' ERR
echo "---------" >> $topdir/log.txt
echo chapter $chapter: start = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt




srcdir=../../src/pciutils-3.13.0
tar xf ../../src/pciutils-3.13.0.tar.gz -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir














# Introduction to PCI Utils
# 
# The PCI Utils package contains a set of programs for listing PCI devices, inspecting their status and setting their configuration registers.
# [Note] Note
# 
# Development versions of BLFS may not build or run some packages properly if LFS or dependencies have been updated since the most recent stable versions of the books.
# Package Information
# 
#     Download (HTTP): https://mj.ucw.cz/download/linux/pci/pciutils-3.13.0.tar.gz
# 
#     Download MD5 sum: 1edb865de7a2de84e67508911010091b
# 
#     Download size: 660 KB
# 
#     Estimated disk space required: 4.9 MB
# 
#     Estimated build time: less than 0.1 SBU
# 
# pciutils Dependencies
# Recommended
# 
# hwdata-0.395 (runtime)
# Installation of PCI Utils
# 
# Prevent the installation of the pci.ids file to avoid a conflict with the hwdata-0.395 package:

sed -r '/INSTALL/{/PCI_IDS|update-pciids /d; s/update-pciids.8//}' \
    -i Makefile

# Install PCI Utils by running the following commands:

make PREFIX=/usr                \
     SHAREDIR=/usr/share/hwdata \
     SHARED=yes

# This package does not come with a test suite.
# 
# Now, as the root user:

make PREFIX=/usr                \
     SHAREDIR=/usr/share/hwdata \
     SHARED=yes                 \
     install install-lib        &&

chmod -v 755 /usr/lib/libpci.so

# Next, install the hwdata-0.395 package for the pci.ids file.
# Command Explanations
# 
# SHARED=yes: This parameter enables building of the shared library instead of the static one.
# Contents
# Installed Programs:
# lspci, pcilmr, and setpci
# Installed Library:
# libpci.so
# Installed Directory:
# /usr/include/pci
# Short Descriptions
# 
# lspci
# 	
# 
# is a utility for displaying information about all PCI buses in the system and all devices connected to them
# 
# pcilmr
# 	
# 
# is a utility for managing PCIe links
# 
# setpci
# 	
# 
# is a utility for querying and configuring PCI devices
# 
# libpci.so
# 	
# 
# is a library that allows applications to access the PCI subsystem 








cd $topdir
rm -rf $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt

