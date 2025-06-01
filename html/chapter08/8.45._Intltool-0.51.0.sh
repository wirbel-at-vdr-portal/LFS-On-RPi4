#!/usr/bin/bash

# ===== 8.45. Intltool-0.51.0 =====
topdir=$(pwd)
err=0
set -e
chapter=8045
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



srcdir=../../src/intltool-0.51.0
tar xf ../../src/intltool-0.51.0.tar.gz -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir

#<p>
#
#  The Intltool is an internationalization tool used for extracting translatable 
# strings from source files. 
#</p>

#  Approximate build time: less than 0.1 SBU
#  Required disk space: 1.5 MB
# ==== 8.45.1. Installation of Intltool ====
#<p>
#
#  First fix a warning that is caused by perl-5.22 and later: 
#</p>

#********<pre>***********
sed -i 's:\\\${:\\\$\\{:' intltool-update.in
#********</pre>**********

# ====== Note ======
#<p>
#
#  The above regular expression looks unusual because of all the backslashes. 
# What it does is add a backslash before the right brace character in the 
# sequence '\${' resulting in '\$\{'. 
#</p>
#<p>
#
#  Prepare Intltool for compilation: 
#</p>

#********<pre>***********
./configure --prefix=/usr
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
install -v -Dm644 doc/I18N-HOWTO /usr/share/doc/intltool-0.51.0/I18N-HOWTO
#********</pre>**********

# ==== 8.45.2. Contents of Intltool ====

#  Installed programs: intltool-extract, intltool-merge, intltool-prepare, intltool-update, and intltoolize
#  Installed directories: /usr/share/doc/intltool-0.51.0 and /usr/share/intltool
# ====== Short Descriptions ======

#--------------------------------------------
# | intltoolize                              | Prepares a package to use intltool      
# | intltool-extract                         | Generates header files that can be read bygettext                                 
# | intltool-merge                           | Merges translated strings into various file types
# | intltool-prepare                         | Updates pot files and merges them with translation files
# | intltool-update                          | Updates the po template files and merges them with the translations
#--------------------------------------------
cd $topdir
rm -rf $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt
