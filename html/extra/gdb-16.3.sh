topdir=$(pwd)
err=0
set -e
chapter=gdb-16.3
err_report() {
    echo "chapter $chapter: $(date +'%Y.%m.%d %H:%M:%S') Error $? on line $1" | tee >> $topdir/log.txt
}
trap 'err_report $LINENO' ERR
echo "---------" >> $topdir/log.txt
echo chapter $chapter: start = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt




srcdir=../../src/gdb-16.3
tar xf ../../src/gdb-16.3.tar.xz -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir









# Introduction to GDB
# 
# GDB, the GNU Project debugger, allows you to see what is going on “inside” another program while it executes -- or what another program was doing at the moment it crashed. Note that GDB is most effective when tracing programs and libraries that were built with debugging symbols and not stripped.
# [Note] Note
# 
# Development versions of BLFS may not build or run some packages properly if LFS or dependencies have been updated since the most recent stable versions of the books.
# Package Information
# 
#     Download (HTTP): https://ftp.gnu.org/gnu/gdb/gdb-16.3.tar.xz
# 
#     Download MD5 sum: f7a7e2d0a6d28622ac69a3623b23876b
# 
#     Download size: 23 MB
# 
#     Estimated disk space required: 853 MB (add 825 MB for docs; add 860 MB for tests)
# 
#     Estimated build time: 1.1 SBU (add 1.0 SBU for docs; add 3.5 SBU tests; all using parallelism=8)
# 
# GDB Dependencies
# Recommended Runtime Dependency
# 
# six-1.17.0 (Python 3 module, required at run-time to use GDB scripts from various LFS/BLFS packages with Python 3 installed in LFS)
# Optional
# 
# Doxygen-1.14.0, GCC-15.1.0 (ada, gfortran, and go are used for tests), Guile-3.0.10, rustc-1.87.0 (used for some tests), Valgrind-3.25.1, and SystemTap (run-time, used for tests)
# Installation of GDB
# 
# Install GDB by running the following commands:

mkdir build &&
cd    build &&

../configure --prefix=/usr          \
             --with-system-readline \
             --with-python=/usr/bin/python3 &&
make -j8

# Optionally, to build the API documentation using Doxygen-1.14.0, run:
# 
# make -C gdb/doc doxy
# 
# Running the tests is not recommended. The results vary a lot depending on the system architecture and what optional dependencies are installed and what version of gcc is being used. On one system tested, there were 140 unexpected failures (out of over 108,000 tests) and on another system there were "only" 14 unexpected failures. The time to run the tests varies from approximately 3 SBU to over 15 SBU when using -j8. This depends on number of tests that time out as well as other factors.
# [Tip] Tip
# 
# With a plain make check, there are many warning messages about a missing global configuration file. These can be avoided by running touch global.exp and prepending the make check command with DEJAGNU=$PWD/global.exp. In addition the tests can be speeded up considerably by using the make option "-j<N>" where <N> is the number of cores on your system. At times though, using parallelism may result in strange failures.
# 
# To test the results anyway, issue:
# 
# pushd gdb/testsuite &&
# make  site.exp      &&
# echo  "set gdb_test_timeout 30" >> site.exp &&
# make check 2>1 | tee gdb-check.log
# popd
# 
# See gdb/testsuite/README and TestingGDB. There are many additional problems with the test suite:
# 
#     Clean directories are needed if re-running the tests. For that reason, make a copy of the compiled source code directory before the tests in case you need to run the tests again.
# 
#     Results can also depend on installed compilers.
# 
#     On some AMD-based systems, over 200 additional tests may fail due to a difference in the threading implementation on those CPUs.
# 
#     For gdb-16.1, using an Intel Xeon E5-1650 v3, there were 14 unexpected failures out of over 120,000 tests.
# 
#     Four tests in the gdb.base/step-over-syscall.exp suite are known to fail due to changes in Linux 6.13 and glibc-2.41.
# 
# Now, as the root user:

make -C gdb install
make -C gdbserver install

# If you have built the API documentation, it is now in gdb/doc/doxy. You can install it (as the root user):
# 
# install -d /usr/share/doc/gdb-16.3 &&
# rm -rf gdb/doc/doxy/xml &&
# cp -Rv gdb/doc/doxy /usr/share/doc/gdb-16.3
# 
# Command Explanations
# 
# --with-system-readline: This switch forces GDB to use the copy of Readline installed in LFS.
# 
# --with-python=/usr/bin/python3: This switch forces GDB to use Python 3.
# Contents
# Installed Programs:
# gcore, gdb, gdbserver, gdb-add-index, and gstack
# Installed Library:
# libinproctrace.so
# Installed Directories:
# /usr/{include,share}/gdb and /usr/share/doc/gdb-16.3
# Short Descriptions
# 
# gcore
# 	
# 
# generates a core dump of a running program
# 
# gdb
# 	
# 
# is the GNU Debugger
# 
# gdbserver
# 	
# 
# is a remote server for the GNU debugger (it allows programs to be debugged from a different machine)
# 
# gdb-add-index
# 	
# 
# Allows adding index files to ELF binaries. This speeds up gdb start on large programs.
# 
# gstack
# 	
# 
# prints a stack trace from a program which is currently running
# 
# libinproctrace.so
#	
#
# contains functions for the in-process tracing agent. The agent allows for installing fast tracepoints, listing static tracepoint markers, probing static tracepoints markers, and starting trace monitoring.  






cd $topdir
rm -rf $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt

