#!/usr/bin/bash

# ===== 8.61. Gawk-5.3.2 =====
topdir=$(pwd)
err=0
set -e
chapter=8061
err_report() {
    echo "chapter $chapter: $(date +'%Y.%m.%d %H:%M:%S') Error $? on line $1" | tee >> $topdir/log.txt
}
trap 'err_report $LINENO' ERR
echo "---------" >> $topdir/log.txt
echo chapter $chapter: start = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt






srcdir=../../src/gawk-5.3.2
tar xf ../../src/gawk-5.3.2.tar.xz -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir

#<p>
#
#  The Gawk package contains programs for manipulating text files. 
#</p>

#  Approximate build time: 0.2 SBU
#  Required disk space: 43 MB
# ==== 8.61.1. Installation of Gawk ====
#<p>
#
#  First, ensure some unneeded files are not installed: 
#</p>

#********<pre>***********
sed -i 's/extras//' Makefile.in
#********</pre>**********
#<p>
#
#  Prepare Gawk for compilation: 
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
chown -R tester .
su tester -c "PATH=$PATH #make check"
#********</pre>**********
#<p>
#
#  Install the package: 
#</p>

#********<pre>***********
rm -f /usr/bin/gawk-5.3.2
make install
#********</pre>**********
#<p>
#
#  The meaning of the command: 
#</p>

#rm -f /usr/bin/gawk-5.3.2
##<p>
#
#  The building system will not recreate the hard link gawk-5.3.2 
#  if it already exists. Remove it to ensure that the previous hard link 
# installed in [Section 6.9, “Gawk-5.3.2”](../chapter06/gawk.html)
#  is updated here. 
#</p>
#<p>
#
#  The installation process already created awk
#  as a symlink to gawk
#  , create its man page as a symlink as well: 
#</p>

#********<pre>***********
ln -sv gawk.1 /usr/share/man/man1/awk.1
#********</pre>**********
#<p>
#
#  If desired, install the documentation: 
#</p>

#********<pre>***********
install -vDm644 doc/{awkforai.txt,*.{eps,pdf,jpg}} -t /usr/share/doc/gawk-5.3.2
#********</pre>**********

# ==== 8.61.2. Contents of Gawk ====

#  Installed programs: awk (link to gawk), gawk, and gawk-5.3.2
#  Installed libraries: filefuncs.so, fnmatch.so, fork.so, inplace.so, intdiv.so, ordchr.so, readdir.so, readfile.so, revoutput.so, revtwoway.so, rwarray.so, and time.so (all in /usr/lib/gawk)
#  Installed directories: /usr/lib/gawk, /usr/libexec/awk, /usr/share/awk, and /usr/share/doc/gawk-5.3.2
# ====== Short Descriptions ======

#--------------------------------------------
# | awk                                      | A link to                               gawk                                    
# | gawk                                     | A program for manipulating text files; it is the GNU implementation ofawk                                     
# | gawk-5.3.2                               | A hard link to                          gawk                                    
#--------------------------------------------
cd $topdir
rm -rf $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt
