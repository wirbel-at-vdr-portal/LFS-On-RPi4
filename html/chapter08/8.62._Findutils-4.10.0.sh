#!/usr/bin/bash

# ===== 8.62. Findutils-4.10.0 =====
topdir=$(pwd)
err=0
set -e
chapter=8062
err_report() {
    echo "chapter $chapter: $(date +'%Y.%m.%d %H:%M:%S') Error $? on line $1" | tee >> $topdir/log.txt
}
trap 'err_report $LINENO' ERR
echo "---------" >> $topdir/log.txt
echo chapter $chapter: start = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt






srcdir=../../src/findutils-4.10.0
tar xf ../../src/findutils-4.10.0.tar.xz -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir

#<p>
#
#  The Findutils package contains programs to find files. Programs are provided 
# to search through all the files in a directory tree and to create, maintain, 
# and search a database (often faster than the recursive find, but unreliable 
# unless the database has been updated recently). Findutils also supplies the xargs
#  program, which can be used to run a specified command on each file selected by 
# a search. 
#</p>

#  Approximate build time: 0.7 SBU
#  Required disk space: 63 MB
# ==== 8.62.1. Installation of Findutils ====
#<p>
#
#  Prepare Findutils for compilation: 
#</p>

#********<pre>***********
./configure --prefix=/usr --localstatedir=/var/lib/locate
#********</pre>**********
#<p>
#
#  The meaning of the configure options: 
#</p>

#--localstatedir 
##<p>
#
#  This option moves the locate
#  database to /var/lib/locate 
#  , which is the FHS-compliant location. 
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
chown -R tester .
su tester -c "PATH=$PATH #make check"
#********</pre>**********
#<p>
#
#  Install the package: 
#</p>

#********<pre>***********
make install
#********</pre>**********

# ==== 8.62.2. Contents of Findutils ====

#  Installed programs: find, locate, updatedb, and xargs
#  Installed directory: /var/lib/locate
# ====== Short Descriptions ======

#--------------------------------------------
# | find                                     | Searches given directory trees for files matching the specified criteria
# | locate                                   | Searches through a database of file names and reports the names that contain a given string or match a given pattern
# | updatedb                                 | Updates the                             locate                                  database; it scans the entire file system (including other file systems that are currently mounted, unless told not to) and puts every file name it finds into the database
# | xargs                                    | Can be used to apply a given command to a list of files
#--------------------------------------------
cd $topdir
rm -rf $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt
