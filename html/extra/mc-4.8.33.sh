topdir=$(pwd)
err=0
set -e
chapter=mc-4.8.33
err_report() {
    echo "chapter $chapter: $(date +'%Y.%m.%d %H:%M:%S') Error $? on line $1" | tee >> $topdir/log.txt
}
trap 'err_report $LINENO' ERR
echo "---------" >> $topdir/log.txt
echo chapter $chapter: start = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt




srcdir=../../src/mc-4.8.33
tar xf ../../src/mc-4.8.33.tar.xz -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir








# Introduction to MC
# 
# MC (Midnight Commander) is a text-mode full-screen file manager and visual shell. It provides a clear, user-friendly, and somewhat protected interface to a Unix system while making many frequent file operations more efficient and preserving the full power of the command prompt.
# [Note] Note
# 
# Development versions of BLFS may not build or run some packages properly if LFS or dependencies have been updated since the most recent stable versions of the books.
# Package Information
# 
#     Download (HTTP): http://ftp.midnight-commander.org/mc-4.8.33.tar.xz
# 
#     Download MD5 sum: b3596c1f092b9822a6cd9c9a1aef8dde
# 
#     Download size: 2.3 MB
# 
#     Estimated disk space required: 71 MB (add 97 MB for tests)
# 
#     Estimated build time: 0.3 SBU (using parallelism=4; add 0.1 SBU for tests)
# 
# MC Dependencies
# Required
# 
# GLib-2.84.2
# Recommended
# 
# slang-2.3.3
# Optional
# 
# Doxygen-1.14.0, GPM-1.20.7, Graphviz-12.2.1, libarchive-3.8.0, libssh2-1.11.1, pcre2-10.45, Ruby-3.4.4, a graphical environment, and Zip-3.0
# Installation of MC
# 
# Install MC by running the following commands:

./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --enable-charset  &&
make -j4

# To test the results, issue: make check.
# 
# Now, as the root user:

make install

# Command Explanations
# 
# --sysconfdir=/etc: This switch places the global configuration directory in /etc.
# 
# --enable-charset: This switch adds support to mcedit for editing files in encodings different from the one implied by the current locale.
# 
# --with-screen=ncurses: Use this if you don't have slang-2.3.3 installed.
# 
# --with-search-engine=pcre2: Use this switch if you would prefer to use pcre2-10.45 instead of GLib for the built-in search engine.
# Configuring MC
# Config Files
# 
# ~/.config/mc/*
# Configuration Information
# 
# The ~/.config/mc directory and its contents are created when you start mc for the first time. Then you can edit the main ~/.config/mc/ini configuration file manually or through the MC shell. Consult the mc(1) man page for details.
# Contents
# Installed Programs:
# mc and the symlinks mcdiff, mcedit and mcview
# Installed Libraries:
# None
# Installed Directories:
# /etc/mc and /usr/{libexec,share}/mc
# Short Descriptions
# 
# mc
# 	
# 
# is a visual shell
# 
# mcdiff
# 	
# 
# is an internal visual diff tool
# 
# mcedit
# 	
# 
# is an internal file editor
# 
# mcview
# 	
# 
# is an internal file viewer 






cd $topdir
rm -rf $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt

