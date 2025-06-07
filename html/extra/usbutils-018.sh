topdir=$(pwd)
err=0
set -e
chapter=usbutils-018
err_report() {
    echo "chapter $chapter: $(date +'%Y.%m.%d %H:%M:%S') Error $? on line $1" | tee >> $topdir/log.txt
}
trap 'err_report $LINENO' ERR
echo "---------" >> $topdir/log.txt
echo chapter $chapter: start = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt




srcdir=../../src/usbutils-018
tar xf ../../src/usbutils-018.tar.xz -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir














# Introduction to USB Utils
# 
# The USB Utils package contains utilities used to display information about USB buses in the system and the devices connected to them.
# [Note] Note
# 
# Development versions of BLFS may not build or run some packages properly if LFS or dependencies have been updated since the most recent stable versions of the books.
# Package Information
# 
#     Download (HTTP): https://kernel.org/pub/linux/utils/usb/usbutils/usbutils-018.tar.xz
# 
#     Download MD5 sum: 0a351e2241c50a1f026a455dccf24d73
# 
#     Download size: 120 KB
# 
#     Estimated disk space required: 1.9 MB
# 
#     Estimated build time: less than 0.1 SBU
# 
# USB Utils Dependencies
# Required
# 
# libusb-1.0.28
# Recommended
# 
# hwdata-0.395 (runtime)
# Installation of USB Utils
# 
# Install USB Utils by running the following commands:
# 
mkdir build &&
cd    build &&

meson setup ..            \
      --prefix=/usr       \
      --buildtype=release &&

ninja

# This package does not come with a test suite.
# 
# Now, as the root user:

ninja install

# For the usb.ids data file, install the hwdata-0.395 package.
# 
# The script lsusb.py displays information in a more easily readable form than lsusb. To find the options, use lsusb.py -h. One form of use recommended by the developer is lsusb.py -ciu.
# Contents
# Installed Programs:
# lsusb, lsusb.py, usb-devices, and usbhid-dump
# Installed Libraries:
# None
# Installed Directories:
# None
# Short Descriptions
# 
# lsusb
# 	
# 
# is a utility for displaying information about all USB buses in the system and all devices connected to them, but not in human friendly form
# 
# lsusb.py
# 	
# 
# displays information about all USB buses in the system and all devices connected to them in reasonable human friendly form
# 
# usb-devices
# 	
# 
# is a shell script that displays details of USB buses and devices connected to them. It is designed to be used if /proc/bus/usb/devices is not available on your system
# 
# usbhid-dump
# 	
# 
# is used to dump report descriptors and streams from HID (human interface device) interfaces of USB devices  
# 






cd $topdir
rm -rf $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt

