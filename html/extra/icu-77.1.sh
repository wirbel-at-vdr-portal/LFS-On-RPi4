topdir=$(pwd)
err=0
set -e
chapter=icu-77.1
err_report() {
    echo "chapter $chapter: $(date +'%Y.%m.%d %H:%M:%S') Error $? on line $1" | tee >> $topdir/log.txt
}
trap 'err_report $LINENO' ERR
echo "---------" >> $topdir/log.txt
echo chapter $chapter: start = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt




srcdir=../../src/icu
tar xf ../../src/icu4c-77_1-src.tgz -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir






# Introduction to ICU
# 
# The International Components for Unicode (ICU) package is a mature, widely used set of C/C++ libraries providing Unicode and Globalization support for software applications. ICU is widely portable and gives applications the same results on all platforms.
# [Warning] Warning
# 
# Upgrading this package to a new major version (for example, from 72.1 to 77.1) will require rebuilding many other packages. If some packages that use the libraries built by icu4c-77 are rebuilt, they will use the new libraries while current packages will use the previous libraries. If the Linux application loader (/usr/lib/ld-linux-x86-64.so.2) determines that both the old and new libraries are needed, and a symbol (name of data or function) exists in both versions of the library, all references to the symbol will be resolved to the version appearing earlier in the breadth-first sequence of the dependency graph. This may result in the application failing if the definition of the data or the behavior of the function referred by the symbol differs between two versions. To avoid the issue, users will need to rebuild every package linked to an ICU library as soon as possible once ICU is updated to a new major version.
# 
# To determine what external libraries are needed (directly or indirectly) by an application or a library, run:
# 
# ldd <application or library> 
# 
# or to see only programs and libraries that directly use a library:
# 
# readelf -d  <application or library> | grep NEEDED
# 
# [Note] Note
# 
# Development versions of BLFS may not build or run some packages properly if LFS or dependencies have been updated since the most recent stable versions of the books.
# Package Information
# 
#     Download (HTTP): https://github.com/unicode-org/icu/releases/download/release-77-1/icu4c-77_1-src.tgz
# 
#     Download MD5 sum: bc0132b4c43db8455d2446c3bae58898
# 
#     Download size: 26 MB
# 
#     Estimated disk space required: 397 MB (add 47 MB for tests)
# 
#     Estimated build time: 0.5 SBU (Using parallelism=4; add 1.8 SBU for tests)
# 
# ICU Dependencies
# Optional
# 
# Doxygen-1.14.0 (for documentation)
# Installation of ICU
# [Note] Note
# 
# This package expands to the directory icu.
# 
# A part of a test cannot be run on i686. Avoid executing it when building for that platform:
# 
# case $(uname -m) in
#   i?86) sed -e "s/U_PLATFORM_IS_LINUX_BASED/__X86_64__ \&\& &/" \
#             -i source/test/intltest/ustrtest.cpp ;;
# esac
# 
# Install ICU by running the following commands:

cd source                 &&
./configure --prefix=/usr &&
make -j4

# To test the results, issue: make check. One test (intltest) still fails for unknown reasons on i686 checking some thai conversions.
# 
# Now, as the root user:

make install

# Contents
# Installed Programs:
# derb, escapesrc, genbrk, genccode, gencfu, gencmn, gencnval, gendict, gennorm2, genrb, gensprep, icu-config, icuexportdata, icuinfo, icupkg, makeconv, pkgdata, and uconv
# Installed Libraries:
# libicudata.so, libicui18n.so, libicuio.so, libicutest.so, libicutu.so, and libicuuc.so
# Installed Directories:
# /usr/include/unicode, /usr/lib/icu, and /usr/share/icu
# Short Descriptions
# 
# derb
# 	
# 
# disassembles a resource bundle
# 
# escapesrc
# 	
# 
# converts “\u” escaped characters into unicode characters
# 
# genbrk
# 	
# 
# compiles ICU break iteration rules source files into binary data files
# 
# genccode
# 	
# 
# generates C or platform specific assembly code from an ICU data file
# 
# gencfu
# 	
# 
# reads in Unicode confusable character definitions and writes out the binary data
# 
# gencmn
# 	
# 
# generates an ICU memory-mappable data file
# 
# gencnval
# 	
# 
# compiles the converter's aliases file
# 
# gendict
# 	
# 
# compiles word lists into ICU string trie dictionaries
# 
# gennorm2
# 	
# 
# builds binary data files with Unicode normalization data
# 
# genrb
# 	
# 
# compiles a resource bundle
# 
# gensprep
# 	
# 
# compiles StringPrep data from filtered RFC 3454 files
# 
# icu-config
# 	
# 
# outputs ICU build options
# 
# icuinfo
# 	
# 
# outputs configuration information about the current ICU
# 
# icupkg
# 	
# 
# extracts or modifies an ICU .dat archive
# 
# makeconv
# 	
# 
# compiles a converter table
# 
# pkgdata
# 	
# 
# packages data for use by ICU
# 
# uconv
# 	
# 
# converts data from one encoding to another
# 
# libicudata.so
# 	
# 
# is the data library
# 
# libicui18n.so
# 	
# 
# is the internationalization (i18n) library
# 
# libicuio.so
# 	
# 
# is the ICU I/O (unicode stdio) library
# 
# libicutest.so
# 	
# 
# is the test library
# 
# libicutu.so
# 	
# 
# is the tool utility library
# 
# libicuuc.so
	

is the common library 








cd $topdir
rm -rf $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt

