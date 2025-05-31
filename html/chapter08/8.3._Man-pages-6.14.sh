#!/usr/bin/bash

# ===== 8.3. Man-pages-6.14 =====
topdir=$(pwd)
err=0
set -e
chapter=8003
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



srcdir=../../src/man-pages-6.14
tar xf ../../src/man-pages-6.14.tar.xz -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir

#<p>
#
#  The Man-pages package contains over 2,400 man pages. 
#</p>

#  Approximate build time: 0.1 SBU
#  Required disk space: 52 MB
# ==== 8.3.1. Installation of Man-pages ====
#<p>
#
#  Remove two man pages for password hashing functions. Libxcrypt
#  will provide a better version of these man pages: 
#</p>

#********<pre>***********
rm -v man3/crypt*
#********</pre>**********
#<p>
#
#  Install Man-pages by running: 
#</p>

#********<pre>***********
make -R GIT=false prefix=/usr install
#********</pre>**********
#<p>
#
#  The meaning of the options: 
#</p>

#-R 
##<p>
#
#  This prevents make
#  from setting any built-in variables. The building system of man-pages does not 
# work well with built-in variables, but currently there is no way to disable 
# them except passing -R 
#  explicitly via the command line. 
#</p>

#GIT=false 
##<p>
#
#  This prevents the building system from emitting many git: command not found 
#  warnings lines. 
#</p>

# ==== 8.3.2. Contents of Man-pages ====

#  Installed files: various man pages
# ====== Short Descriptions ======

#--------------------------------------------
# | man pages                                | Describe C programming language functions, important device files, and significant configuration files
#--------------------------------------------
cd $topdir
rm -rfv $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt
