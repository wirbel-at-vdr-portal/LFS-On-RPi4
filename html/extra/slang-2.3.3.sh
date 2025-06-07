topdir=$(pwd)
err=0
set -e
chapter=slang-2.3.3
err_report() {
    echo "chapter $chapter: $(date +'%Y.%m.%d %H:%M:%S') Error $? on line $1" | tee >> $topdir/log.txt
}
trap 'err_report $LINENO' ERR
echo "---------" >> $topdir/log.txt
echo chapter $chapter: start = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt




srcdir=../../src/slang-2.3.3
tar xf ../../src/slang-2.3.3.tar.bz2 -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir









# Introduction to slang
# 
# S-Lang (slang) is an interpreted language that may be embedded into an application to make the application extensible. It provides facilities required by interactive applications such as display/screen management, keyboard input and keymaps.
# [Note] Note
# 
# Development versions of BLFS may not build or run some packages properly if LFS or dependencies have been updated since the most recent stable versions of the books.
# Package Information
# 
#     Download (HTTP): https://www.jedsoft.org/releases/slang/slang-2.3.3.tar.bz2
# 
#     Download MD5 sum: 69015c8300088373eb65ffcc6ed4db8c
# 
#     Download size: 1.6 MB
# 
#     Estimated disk space required: 22 MB (add 15 MB for tests)
# 
#     Estimated build time: 0.4 SBU (add 0.5 SBU for tests)
# 
# Slang Dependencies
# Optional
# 
# libpng-1.6.48 and Oniguruma
# Installation of Slang
# [Note] Note
# 
# This package does not support parallel build.
# 
# Install slang by running the following commands:

./configure --prefix=/usr       \
            --sysconfdir=/etc   \
            --with-readline=gnu &&
make -j1 RPATH=

# To test the results, issue: LC_ALL=C make check.
# 
# Now, as the root user:

make install_doc_dir=/usr/share/doc/slang-2.3.3   \
     SLSH_DOC_DIR=/usr/share/doc/slang-2.3.3/slsh \
     RPATH= install

# Command Explanations
# 
# --with-readline=gnu: This parameter sets GNU Readline to be used by the parser interface instead of the slang internal version.
# 
# RPATH=: This overridden make variable prevents hard coding library search paths (rpath) into the binary executable files and shared libraries. This package does not need rpath for an installation into the standard location, and rpath may sometimes cause unwanted effects or even security issues.
# 
# install_doc_dir=/usr/share/doc/slang-2.3.3 SLSH_DOC_DIR=/usr/share/doc/slang-2.3.3/slsh: These overridden make variables ensure installing this package with a versioned documentation installation directory.
# Configuring slang
# Config Files
# 
# ~/.slshrc and /etc/slsh.rc
# Contents
# Installed Program:
# slsh
# Installed Libraries:
# libslang.so and numerous support modules
# Installed Directories:
# /usr/lib/slang, /usr/share/doc/slang-2.3.3 and /usr/share/slsh
# Short Descriptions
# 
# slsh
# 	
# 
# is a simple program for interpreting slang scripts. It supports dynamic loading of slang modules and includes a Readline interface for interactive use 



cd $topdir
rm -rf $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt

