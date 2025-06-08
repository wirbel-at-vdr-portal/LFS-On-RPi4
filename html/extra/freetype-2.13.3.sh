topdir=$(pwd)
err=0
set -e
chapter=freetype-2.13.3
err_report() {
    echo "chapter $chapter: $(date +'%Y.%m.%d %H:%M:%S') Error $? on line $1" | tee >> $topdir/log.txt
}
trap 'err_report $LINENO' ERR
echo "---------" >> $topdir/log.txt
echo chapter $chapter: start = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt




srcdir=../../src/freetype-2.13.3
# tar xf ../../src/freetype-2.13.3.tar.bz2 -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir







# Introduction to FreeType2
# 
# The FreeType2 package contains a library which allows applications to properly render TrueType fonts.
# [Note] Note
# 
# Development versions of BLFS may not build or run some packages properly if LFS or dependencies have been updated since the most recent stable versions of the books.
# Package Information
# 
#     Download (HTTP): https://downloads.sourceforge.net/freetype/freetype-2.13.3.tar.xz
# 
#     Download MD5 sum: f3b4432c4212064c00500e1ad63fbc64
# 
#     Download size: 2.5 MB
# 
#     Estimated disk space required: 33 MB (with additional documentation)
# 
#     Estimated build time: 0.2 SBU (with additional documentation)
# 
# Additional Downloads
# 
# Additional Documentation
# 
#     Download (HTTP): https://downloads.sourceforge.net/freetype/freetype-doc-2.13.3.tar.xz
# 
#     Download MD5 sum: 6affe0d431939398cc3c7cdd58d824f8
# 
#     Download size: 2.1 MB
# 
# FreeType2 Dependencies
# Recommended
# 
# harfBuzz-11.2.1 (circular: build freetype, then harfbuzz, then reinstall freetype), libpng-1.6.48, and Which-2.23
# Optional
# 
# Brotli-1.1.0 and librsvg-2.60.0
# Optional (for documentation)
# 
# docwriter
# Installation of FreeType2
# 
# If you downloaded the additional documentation, unpack it into the source tree using the following command:
# 
# tar -xf ../freetype-doc-2.13.3.tar.xz --strip-components=2 -C docs
# 
# Install FreeType2 by running the following commands:

sed -ri "s:.*(AUX_MODULES.*valid):\1:" modules.cfg &&

sed -r "s:.*(#.*SUBPIXEL_RENDERING) .*:\1:" \
    -i include/freetype/config/ftoption.h  &&



./configure --prefix=/usr --enable-freetype-config --disable-static &&
make

# This package does not come with a test suite.
# 
# Now, as the root user:

make install

# If you downloaded the optional documentation, install it as the root user:
# 
# cp -v -R docs -T /usr/share/doc/freetype-2.13.3 &&
# rm -v /usr/share/doc/freetype-2.13.3/freetype-config.1
# 
# Command Explanations
# 
# sed -ri ...: First command enables GX/AAT and OpenType table validation and second command enables Subpixel Rendering. Note that Subpixel Rendering may have patent issues. Be sure to read the 'Other patent issues' part of https://freetype.org/patents.html before enabling this option.
# 
# --enable-freetype-config: This switch ensure that the man page for freetype-config is installed.
# 
# --without-harfbuzz: If harfbuzz is installed prior to freetype without freetype support, use this switch to avoid a build failure.
# 
# --disable-static: This switch prevents installation of static versions of the libraries.
# Contents
# Installed Program:
# freetype-config
# Installed Library:
# libfreetype.so
# Installed Directories:
# /usr/include/freetype2 and /usr/share/doc/freetype-2.13.3
# Short Descriptions
# 
# freetype-config
# 	
# 
# is used to get FreeType compilation and linking information
# 
# libfreetype.so
# 	
# 
# contains functions for rendering various font types, such as TrueType and Type1 
# 












cd $topdir
rm -rf $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt

