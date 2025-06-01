#!/usr/bin/bash

# ===== 8.42. Less-668 =====
topdir=$(pwd)
err=0
set -e
chapter=8042
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



srcdir=../../src/less-668
tar xf ../../src/less-668.tar.gz -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir

#<p>
#
#  The Less package contains a text file viewer. 
#</p>

#  Approximate build time: less than 0.1 SBU
#  Required disk space: 14 MB
# ==== 8.42.1. Installation of Less ====
#<p>
#
#  Prepare Less for compilation: 
#</p>

#********<pre>***********
./configure --prefix=/usr --sysconfdir=/etc
#********</pre>**********
#<p>
#
#  The meaning of the configure options: 
#</p>

#--sysconfdir=/etc 
##<p>
#
#  This option tells the programs created by the package to look in /etc 
#  for the configuration files. 
#</p>
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

# ==== 8.42.2. Contents of Less ====

#  Installed programs: less, lessecho, and lesskey
# ====== Short Descriptions ======

#--------------------------------------------
# | less                                     | A file viewer or pager; it displays the contents of the given file, letting the user scroll, find strings, and jump to marks
# | lessecho                                 | Needed to expand meta-characters, such as*                                       and                                     ?                                       , in filenames on Unix systems          
# | lesskey                                  | Used to specify the key bindings for    less                                    
#--------------------------------------------
cd $topdir
rm -rf $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt
