topdir=$(pwd)
err=0
set -e
chapter=libusb-1.0.28
err_report() {
    echo "chapter $chapter: $(date +'%Y.%m.%d %H:%M:%S') Error $? on line $1" | tee >> $topdir/log.txt
}
trap 'err_report $LINENO' ERR
echo "---------" >> $topdir/log.txt
echo chapter $chapter: start = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt




srcdir=../../src/libusb-1.0.28
tar xf ../../src/libusb-1.0.28.tar.bz2 -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir












# Introduction to libusb
# 
# The libusb package contains a library used by some applications for USB device access.
# [Note] Note
# 
# Development versions of BLFS may not build or run some packages properly if LFS or dependencies have been updated since the most recent stable versions of the books.
# Package Information
# 
#     Download (HTTP): https://github.com/libusb/libusb/releases/download/v1.0.28/libusb-1.0.28.tar.bz2
# 
#     Download MD5 sum: 4022135a84975b292cf48381fbc8ffd8
# 
#     Download size: 644 KB
# 
#     Estimated disk space required: 5.7 MB
# 
#     Estimated build time: less than 0.1 SBU
# 
# libusb Dependencies
# Optional
# 
# Doxygen-1.14.0
# Configuring Libusb
# 
# To access raw USB devices (those not treated as a disk by the mass-storage driver), appropriate support must be available in the kernel. Check your kernel configuration:
# 
# Device Drivers --->
#   [*] USB support --->                                             [USB_SUPPORT]
#     <*/M>   Support for Host-side USB                                      [USB]
#     [*]     PCI based USB host interface                               [USB_PCI]
#     # These are most common USB controller drivers for PC-like systems.
#     # For modern systems often [USB_XHCI_HCD] is the only one needed
#     # even if the system has USB 2.0 ports:
#     < /*/M> xHCI HCD (USB 3.0) support                            [USB_XHCI_HCD]
#     < /*/M> EHCI HCD (USB 2.0) support                            [USB_EHCI_HCD]
#     < /*/M> OHCI HCD (USB 1.1) support                            [USB_OHCI_HCD]
# 
# For more details on setting up USB devices, see the section called “USB Device Issues”.
# Installation of libusb
# 
# Install libusb by running the following commands:

./configure --prefix=/usr --disable-static &&
make

# If Doxygen is installed and you wish to build the API documentation, issue the following commands:
# 
# pushd doc                &&
#   doxygen -u doxygen.cfg &&
#   make docs              &&
# popd
# 
# This package does not come with a test suite.
# 
# Now, as the root user:

make install

# If you built the API documentation, install it using the following commands as the root user:
# 
# install -v -d -m755 /usr/share/doc/libusb-1.0.28/apidocs &&
# install -v -m644    doc/api-1.0/* \
#                     /usr/share/doc/libusb-1.0.28/apidocs
# 
# Contents
# Installed Programs:
# None
# Installed Library:
# libusb-1.0.so
# Installed Directories:
# /usr/include/libusb-1.0 and /usr/share/doc/libusb-1.0.28
# Short Descriptions
# 
# libusb-1.0.so
# 	
# 
# contains API functions used for accessing USB hardware 







cd $topdir
rm -rf $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt

