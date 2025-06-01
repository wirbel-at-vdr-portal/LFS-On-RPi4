#!/usr/bin/bash

# ===== 8.12. Readline-8.2.13 =====
topdir=$(pwd)
err=0
set -e
chapter=8012
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



srcdir=../../src/readline-8.2.13
tar xf ../../src/readline-8.2.13.tar.gz -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir

#<p>
#
#  The Readline package is a set of libraries that offer command-line editing and 
# history capabilities. 
#</p>

#  Approximate build time: less than 0.1 SBU
#  Required disk space: 16 MB
# ==== 8.12.1. Installation of Readline ====
#<p>
#
#  Reinstalling Readline will cause the old libraries to be moved to 
# <libraryname>.old. While this is normally not a problem, in some cases it can 
# trigger a linking bug in ldconfig
#  . This can be avoided by issuing the following two seds: 
#</p>

#********<pre>***********
sed -i '/MV.*old/d' Makefile.in
sed -i '/{OLDSUFF}/c:' support/shlib-install
#********</pre>**********
#<p>
#
#  Prevent hard coding library search paths (rpath) into the shared libraries. 
# This package does not need rpath for an installation into the standard 
# location, and rpath may sometimes cause unwanted effects or even security 
# issues: 
#</p>

#********<pre>***********
sed -i 's/-Wl,-rpath,[^ ]*//' support/shobj-conf
#********</pre>**********
#<p>
#
#  Prepare Readline for compilation: 
#</p>

#********<pre>***********
./configure --prefix=/usr    \
            --disable-static \
            --with-curses    \
            --docdir=/usr/share/doc/readline-8.2.13
#********</pre>**********
#<p>
#
#  The meaning of the new configure option: 
#</p>

#--with-curses 
##<p>
#
#  This option tells Readline that it can find the termcap library functions in 
# the curses library, not a separate termcap library. This will generate the 
# correct readline.pc 
#  file. 
#</p>
#<p>
#
#  Compile the package: 
#</p>

#********<pre>***********
make SHLIB_LIBS="-lncursesw"
#********</pre>**********
#<p>
#
#  The meaning of the make option: 
#</p>

#SHLIB_LIBS="-lncursesw" 
##<p>
#
#  This option forces Readline to link against the libncursesw 
#  library. For details see the “Shared Libraries”
#  section in the package's README 
#  file. 
#</p>
#<p>
#
#  This package does not come with a test suite. 
#</p>
#<p>
#
#  Install the package: 
#</p>

#********<pre>***********
make install
#********</pre>**********
#<p>
#
#  If desired, install the documentation: 
#</p>

#********<pre>***********
install -v -m644 doc/*.{ps,pdf,html,dvi} /usr/share/doc/readline-8.2.13
#********</pre>**********

# ==== 8.12.2. Contents of Readline ====

#  Installed libraries: libhistory.so and libreadline.so
#  Installed directories: /usr/include/readline and /usr/share/doc/readline-8.2.13
# ====== Short Descriptions ======

#--------------------------------------------
# | libhistory                               | Provides a consistent user interface for recalling lines of history
# | libreadline                              | Provides a set of commands for manipulating text entered in an interactive session of a program
#--------------------------------------------
cd $topdir
rm -rf $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt
