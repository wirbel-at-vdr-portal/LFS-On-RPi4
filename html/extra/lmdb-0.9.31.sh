topdir=$(pwd)
err=0
set -e
chapter=lmdb-0.9.31
err_report() {
    echo "chapter $chapter: $(date +'%Y.%m.%d %H:%M:%S') Error $? on line $1" | tee >> $topdir/log.txt
}
trap 'err_report $LINENO' ERR
echo "---------" >> $topdir/log.txt
echo chapter $chapter: start = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt




srcdir=../../src/lmdb-LMDB_0.9.31
tar xf ../../src/lmdb-LMDB_0.9.31.tar.gz -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir







# Introduction to lmdb
# 
# The lmdb package is a fast, compact, key-value embedded data store. It uses memory-mapped files, so it has the read performance of a pure in-memory database while still offering the persistence of standard disk-based databases, and is only limited to the size of the virtual address space
# [Note] Note
# 
# Development versions of BLFS may not build or run some packages properly if LFS or dependencies have been updated since the most recent stable versions of the books.
# Package Information
# 
#     Download (HTTP): https://github.com/LMDB/lmdb/archive/LMDB_0.9.31.tar.gz
# 
#     Download MD5 sum: 9d7f059b1624d0a4d4b2f1781d08d600
# 
#     Download size: 144 KB
# 
#     Estimated disk space required: 4.7 MB
# 
#     Estimated build time: less than 0.1 SBU
# 
# Installation of lmdb
# [Note] Note
# 
# This package extracts to lmdb-LMDB_0.9.31.
# 
# Install lmdb by running the following commands:

cd libraries/liblmdb &&
make                 &&
sed -i 's| liblmdb.a||' Makefile

# This package does not come with a test suite.
# 
# Now, as the root user:
# 
make prefix=/usr install
# 
# Command Explanations
# 
# sed ... liblmdb.a ... Makefile: The package executables use a static library so it must be created. This command suppresses installation of the static library.
# Contents
# Installed Program:
# mdb_copy, mdb_dump, mdb_load, and mdb_stat
# Installed Library:
# liblmdb.so
# Installed Directories:
# None
# Short Descriptions
# 
# mdb_copy
# 	
# 
# copies an LMDB environment from one database to another, including the option to compact the database
# 
# mdb_dump
# 	
# 
# reads a database and writes its contents to standard output using a portable flat-text format, which can be interpreted by mdb_load
# 
# mdb_load
# 	
# 
# imports a database from standard input or from a file
# 
# mdb_stat
# 	
# 
# displays the status of a LMDB environment
# 
# liblmdb.so
# 	
# 
# provides functions for accessing a LMDB database 










cd $topdir
rm -rf $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt

