topdir=$(pwd)
err=0
set -e
chapter=nasm-2.16.03
err_report() {
    echo "chapter $chapter: $(date +'%Y.%m.%d %H:%M:%S') Error $? on line $1" | tee >> $topdir/log.txt
}
trap 'err_report $LINENO' ERR
echo "---------" >> $topdir/log.txt
echo chapter $chapter: start = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt




srcdir=../../src/nasm-2.16.03
tar xf ../../src/nasm-2.16.03.tar.xz -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir











# Introduction to NASM
# 
# NASM (Netwide Assembler) is an 80x86 assembler designed for portability and modularity. It includes a disassembler as well.
# [Note] Note
# 
# Development versions of BLFS may not build or run some packages properly if LFS or dependencies have been updated since the most recent stable versions of the books.
# Package Information
# 
#     Download (HTTP): https://www.nasm.us/pub/nasm/releasebuilds/2.16.03/nasm-2.16.03.tar.xz
# 
#     Download MD5 sum: 2b8c72c52eee4f20085065e68ac83b55
# 
#     Download size: 1008.1 KB
# 
#     Estimated disk space required: 41 MB
# 
#     Estimated build time: 0.2 SBU
# 
# Additional Downloads
# 
#     Optional documentation: https://www.nasm.us/pub/nasm/releasebuilds/2.16.03/nasm-2.16.03-xdoc.tar.xz
# 
# NASM Dependencies
# Optional (for generating documentation):
# 
# asciidoc-10.2.1 and xmlto-0.0.29
# Installation of NASM
# 
# If you downloaded the optional documentation, put it into the source tree:
# 
# tar -xf ../nasm-2.16.03-xdoc.tar.xz --strip-components=1
# 
# Install NASM by running the following commands:

./configure --prefix=/usr &&
make

# This package does not come with a test suite.
# 
# Now, as the root user:

make install

# If you downloaded the optional documentation, install it with the following instructions as the root user:
# 
# install -m755 -d         /usr/share/doc/nasm-2.16.03/html  &&
# cp -v doc/html/*.html    /usr/share/doc/nasm-2.16.03/html  &&
# cp -v doc/*.{txt,ps,pdf} /usr/share/doc/nasm-2.16.03
# 
# Contents
# Installed Programs:
# nasm and ndisasm
# Installed Libraries:
# None
# Installed Directory:
# /usr/share/doc/nasm-2.16.03
# Short Descriptions
# 
# nasm
# 	
# 
# is a portable 80x86 assembler
# 
# ndisasm
# 	
# 
# is an 80x86 binary file disassembler 
# 








cd $topdir
rm -rf $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt

