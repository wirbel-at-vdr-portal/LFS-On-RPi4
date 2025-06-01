#!/usr/bin/bash

# ===== 8.16. Tcl-8.6.16 =====
topdir=$(pwd)
err=0
set -e
chapter=8016
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

srcdir=../../src/tcl8.6.16
tar xf ../../src/tcl8.6.16-src.tar.gz -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir

#<p>
#
#  The Tcl
#  package contains the Tool Command Language, a robust general-purpose scripting 
# language. The Expect
#  package is written in Tcl
#  (pronounced "tickle"). 
#</p>

#  Approximate build time: 3.1 SBU
#  Required disk space: 91 MB
# ==== 8.16.1. Installation of Tcl ====
#<p>
#
#  This package and the next two (Expect and DejaGNU) are installed to support 
# running the test suites for Binutils, GCC and other packages. Installing three 
# packages for testing purposes may seem excessive, but it is very reassuring, if 
# not essential, to know that the most important tools are working properly. 
#</p>
#<p>
#
#  Prepare Tcl for compilation: 
#</p>

#********<pre>***********
SRCDIR=$(pwd)
cd unix
./configure --prefix=/usr           \
            --mandir=/usr/share/man \
            --disable-rpath
#********</pre>**********
#<p>
#
#  The meaning of the new configure parameters: 
#</p>

#--disable-rpath 
##<p>
#
#  This parameter prevents hard coding library search paths (rpath) into the 
# binary executable files and shared libraries. This package does not need rpath 
# for an installation into the standard location, and rpath may sometimes cause 
# unwanted effects or even security issues. 
#</p>
#<p>
#
#  Build the package: 
#</p>

#********<pre>***********
make

sed -e "s|$SRCDIR/unix|/usr/lib|" \
    -e "s|$SRCDIR|/usr/include|"  \
    -i tclConfig.sh

sed -e "s|$SRCDIR/unix/pkgs/tdbc1.1.10|/usr/lib/tdbc1.1.10|" \
    -e "s|$SRCDIR/pkgs/tdbc1.1.10/generic|/usr/include|"     \
    -e "s|$SRCDIR/pkgs/tdbc1.1.10/library|/usr/lib/tcl8.6|"  \
    -e "s|$SRCDIR/pkgs/tdbc1.1.10|/usr/include|"             \
    -i pkgs/tdbc1.1.10/tdbcConfig.sh

sed -e "s|$SRCDIR/unix/pkgs/itcl4.3.2|/usr/lib/itcl4.3.2|" \
    -e "s|$SRCDIR/pkgs/itcl4.3.2/generic|/usr/include|"    \
    -e "s|$SRCDIR/pkgs/itcl4.3.2|/usr/include|"            \
    -i pkgs/itcl4.3.2/itclConfig.sh

unset SRCDIR
#********</pre>**********
#<p>
#
#  The various “sed”
#  instructions after the “make”
#  command remove references to the build directory from the configuration files 
# and replace them with the install directory. This is not mandatory for the 
# remainder of LFS, but may be needed if a package built later uses Tcl. 
#</p>
#<p>
#
#  To test the results, issue: 
#</p>

#********<pre>***********
make test
#********</pre>**********
#<p>
#
#  Install the package: 
#</p>

#********<pre>***********
make install
#********</pre>**********
#<p>
#
#  Make the installed library writable so debugging symbols can be removed later: 
#</p>

#********<pre>***********
chmod -v u+w /usr/lib/libtcl8.6.so
#********</pre>**********
#<p>
#
#  Install Tcl's headers. The next package, Expect, requires them. 
#</p>

#********<pre>***********
make install-private-headers
#********</pre>**********
#<p>
#
#  Now make a necessary symbolic link: 
#</p>

#********<pre>***********
ln -sfv tclsh8.6 /usr/bin/tclsh
#********</pre>**********
#<p>
#
#  Rename a man page that conflicts with a Perl man page: 
#</p>

#********<pre>***********
mv /usr/share/man/man3/{Thread,Tcl_Thread}.3
#********</pre>**********
#<p>
#
#  Optionally, install the documentation by issuing the following commands: 
#</p>

#********<pre>***********
cd ..
tar -xf ../tcl8.6.16-html.tar.gz --strip-components=1
mkdir -v -p /usr/share/doc/tcl-8.6.16
cp -v -r  ./html/* /usr/share/doc/tcl-8.6.16
#********</pre>**********

# ==== 8.16.2. Contents of Tcl ====

#  Installed programs: tclsh (link to tclsh8.6) and tclsh8.6
#  Installed library: libtcl8.6.so and libtclstub8.6.a
# ====== Short Descriptions ======

#--------------------------------------------
# | tclsh8.6                                 | The Tcl command shell                   
# | tclsh                                    | A link to tclsh8.6                      
# | libtcl8.6.so                             | The Tcl library                         
# | libtclstub8.6.a                          | The Tcl Stub library                    
#--------------------------------------------echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
cd $topdir
rm -rf $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt
