topdir=$(pwd)
err=0
set -e
chapter=cmake-4.0.2
err_report() {
    echo "chapter $chapter: $(date +'%Y.%m.%d %H:%M:%S') Error $? on line $1" | tee >> $topdir/log.txt
}
trap 'err_report $LINENO' ERR
echo "---------" >> $topdir/log.txt
echo chapter $chapter: start = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt




srcdir=../../src/cmake-4.0.2
tar xf ../../src/cmake-4.0.2.tar.gz -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir








#  Package Information
# 
#     Download (HTTP): https://cmake.org/files/v4.0/cmake-4.0.2.tar.gz
# 
#     Download MD5 sum: a37516d25a4a48e49423c52c204a336d
# 
#     Download size: 11 MB
# 
#     Estimated disk space required: 483 MB (add 1.4 GB for tests)
# 
#     Estimated build time: 2.0 SBU (add 4.9 SBU for tests, both using parallelism=4)
# 
# CMake Dependencies
# Recommended
# 
# cURL-8.14.1, libarchive-3.8.1, libuv-1.51.0, and nghttp2-1.65.0
# Optional
# 
# GCC-15.1.0 (for gfortran), git-2.49.0 (for use during tests), mercurial-7.0.1 (for use during tests), OpenJDK-24.0.1 (for use during tests), Qt-6.9.1 (for the Qt-based GUI), sphinx-8.2.3 (for building documents), Subversion-1.14.5 (for testing), cppdap, jsoncpp, and rhash
# Installation of CMake
# 
# Install CMake by running the following commands:

sed -i '/"lib64"/s/64//' Modules/GNUInstallDirs.cmake &&

./bootstrap --prefix=/usr        \
            --system-libs        \
            --mandir=/share/man  \
            --no-system-jsoncpp  \
            --no-system-cppdap   \
            --no-system-librhash \
            --docdir=/share/doc/cmake-4.0.2 &&
make

# To test the results, issue: bin/ctest -j$(nproc). Replace $(nproc) with an integer between 1 and the number of system logical cores if you don't want to use all.
# 
# If you want to investigate a problem with a given "problem1-test", use bin/ctest -R "problem1-test" and, to omit it, use bin/ctest -E "problem1-test". These options can be used together: bin/ctest -R "problem1-test" -E "problem2-test". Option -N can be used to display all available tests, and you can run bin/ctest for a sub-set of tests by using separated by spaces names or numbers as options. Option --help can be used to show all options.
# 
# Now, as the root user:

make install

# Command Explanations
# 
# sed ... Modules/GNUInstallDirs.cmake: This command disables applications using cmake from attempting to install files in /usr/lib64/.
# 
# --system-libs: This switch forces the build system to link against the system installed version for all needed libraries but those explicitly specified via a --no-system-* option.
# 
# --no-system-jsoncpp and --no-system-cppdap: These switches remove the JSON-C++ library from the list of system libraries. A bundled version of that library is used instead.
# 
# --no-system-librhash: This switch removes the librhash library from the list of system libraries used. A bundled version of that library is used instead.
# 
# --no-system-{curl,libarchive,libuv,nghttp2}: Use the corresponding option in the list for the bootstrap if one of the recommended dependencies is not installed. A bundled version of the dependency will be used instead.
# 
# --qt-gui: This switch enables building the Qt-based GUI for CMake.
# 
# --parallel=: This switch enables performing the CMake bootstrap with multiple jobs at one time. It's not needed if the MAKEFLAGS variable has been already set for using multiple processors following Using Multiple Processors.
# Contents
# Installed Programs:
# ccmake, cmake, cmake-gui (optional), cpack, and ctest
# Installed Libraries:
# None
# Installed Directories:
# /usr/share/cmake-4.0 and /usr/share/doc/cmake-4.0.2
# Short Descriptions
# 
# ccmake
# 	
# 
# is a curses based interactive frontend to cmake
# 
# cmake
# 	
# 
# is the makefile generator
# 
# cmake-gui
# 	
# 
# (optional) is the Qt-based frontend to cmake
# 
# cpack
# 	
# 
# is the CMake packaging program
# 
# ctest
# 	
# 
# is a testing utility for cmake-generated build trees 
# 










cd $topdir
rm -rf $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt

