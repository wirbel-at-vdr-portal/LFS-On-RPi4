#!/usr/bin/bash

# ===== 8.47. Automake-1.17 =====
topdir=$(pwd)
err=0
set -e
chapter=8047
err_report() {
    echo "chapter $chapter: $(date +'%Y.%m.%d %H:%M:%S') Error $? on line $1" | tee >> $topdir/log.txt
}
trap 'err_report $LINENO' ERR
echo "---------" >> $topdir/log.txt
echo chapter $chapter: start = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt




if [ "$EUID" -ne "0" ]; then
  echo "ERROR: Please run as root, not as user id = $EUID";stop
  exit 1
fi

grep -q $LFS/dev/pts /proc/mounts || err=1
if [ "$err" -eq "1" ]; then
  echo "ERROR: The '$LFS/dev/pts' partition must be mounted.";stop
  exit 1
fi

grep -q $LFS/dev /proc/mounts || err=1
if [ "$err" -eq "1" ]; then
  echo "ERROR: The '$LFS/dev' partition must be mounted.";stop
  exit 1
fi

grep -q $LFS/proc /proc/mounts || err=1
if [ "$err" -eq "1" ]; then
  echo "ERROR: The '$LFS/proc' partition must be mounted.";stop
  exit 1
fi

grep -q $LFS/sys /proc/mounts || err=1
if [ "$err" -eq "1" ]; then
  echo "ERROR: The '$LFS/sys' partition must be mounted.";stop
  exit 1
fi

grep -q $LFS/run /proc/mounts || err=1
if [ "$err" -eq "1" ]; then
  echo "ERROR: The '$LFS/run' partition must be mounted.";stop
  exit 1
fi



srcdir=../../src/automake-1.17
tar xf ../../src/automake-1.17.tar.xz -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir

#<p>
#
#  The Automake package contains programs for generating Makefiles for use with 
# Autoconf. 
#</p>

#  Approximate build time: less than 0.1 SBU (about 1.1 SBU with tests)
#  Required disk space: 121 MB
# ==== 8.47.1. Installation of Automake ====
#<p>
#
#  Prepare Automake for compilation: 
#</p>

#********<pre>***********
./configure --prefix=/usr --docdir=/usr/share/doc/automake-1.17
#********</pre>**********
#<p>
#
#  Compile the package: 
#</p>

#********<pre>***********
make
#********</pre>**********
#<p>
#
#  Using four parallel jobs speeds up the tests, even on systems with less 
# logical cores, due to internal delays in individual tests. To test the results, 
# issue: 
#</p>

#********<pre>***********
make -j$(($(nproc)>4?$(nproc):4)) check
#********</pre>**********
#<p>
#
#  Replace $((...)) 
#  with the number of logical cores you want to use if you don't want to use all. 
#</p>
#<p>
#
#  Install the package: 
#</p>

#********<pre>***********
make install
#********</pre>**********

# ==== 8.47.2. Contents of Automake ====

#  Installed programs: aclocal, aclocal-1.17 (hard linked with aclocal), automake, and automake-1.17 (hard linked with automake)
#  Installed directories: /usr/share/aclocal-1.17, /usr/share/automake-1.17, and /usr/share/doc/automake-1.17
# ====== Short Descriptions ======

#--------------------------------------------
# | aclocal                                  | Generates                               aclocal.m4                              files based on the contents of          configure.in                            files                                   
# | aclocal-1.17                             | A hard link to                          aclocal                                 
# | automake                                 | A tool for automatically generating     Makefile.in                             files from                              Makefile.am                             files [To create all the                Makefile.in                             files for a package, run this program in the top-level directory. By scanning theconfigure.in                            file, it automatically finds each appropriateMakefile.am                             file and generates the corresponding    Makefile.in                             file.]                                  
# | automake-1.17                            | A hard link to                          automake                                
#--------------------------------------------
cd $topdir
rm -rf $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt
