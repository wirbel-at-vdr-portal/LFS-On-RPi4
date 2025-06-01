#!/usr/bin/bash

# ===== 8.34. Bison-3.8.2 =====
topdir=$(pwd)
err=0
set -e
chapter=8034
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



srcdir=../../src/bison-3.8.2
tar xf ../../src/bison-3.8.2.tar.xz -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir

#<p>
#
#  The Bison package contains a parser generator. 
#</p>

#  Approximate build time: 2.1 SBU
#  Required disk space: 62 MB
# ==== 8.34.1. Installation of Bison ====
#<p>
#
#  Prepare Bison for compilation: 
#</p>

#********<pre>***********
./configure --prefix=/usr --docdir=/usr/share/doc/bison-3.8.2
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
#  To test the results, issue: 
#</p>

#********<pre>***********
#make check
#********</pre>**********
#<p>
#
#  Install the package: 
#</p>

#********<pre>***********
make install
#********</pre>**********

# ==== 8.34.2. Contents of Bison ====

#  Installed programs: bison and yacc
#  Installed library: liby.a
#  Installed directory: /usr/share/bison
# ====== Short Descriptions ======

#--------------------------------------------
# | bison                                    | Generates, from a series of rules, a program for analyzing the structure of text files; Bison is a replacement for Yacc (Yet Another Compiler Compiler)
# | yacc                                     | A wrapper for                           bison                                   , meant for programs that still call    yacc                                    instead of                              bison                                   ; it calls                              bison                                   with the                                -y                                      option                                  
# | liby                                     | The Yacc library containing implementations of Yacc-compatibleyyerror                                 and                                     main                                    functions; this library is normally not very useful, but POSIX requires it
#--------------------------------------------
cd $topdir
rm -rf $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt
