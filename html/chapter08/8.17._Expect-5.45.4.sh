#!/usr/bin/bash

# ===== 8.17. Expect-5.45.4 =====
topdir=$(pwd)
err=0
set -e
chapter=8017
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

srcdir=../../src/expect5.45.4
tar xf ../../src/expect5.45.4.tar.gz -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir


#<p>
#
#  The Expect
#  package contains tools for automating, via scripted dialogues, interactive 
# applications such as telnet
#  , ftp
#  , passwd
#  , fsck
#  , rlogin
#  , and tip
#  . Expect
#  is also useful for testing these same applications as well as easing all sorts 
# of tasks that are prohibitively difficult with anything else. The DejaGnu
#  framework is written in Expect
#  . 
#</p>

#  Approximate build time: 0.2 SBU
#  Required disk space: 3.9 MB
# ==== 8.17.1. Installation of Expect ====
#<p>
#
#  Expect needs PTYs to work. Verify that the PTYs are working properly inside 
# the chroot environment by performing a simple test: 
#</p>

#********<pre>***********
python3 -c 'from pty import spawn; spawn(["echo", "ok"])'
#********</pre>**********
#<p>
#
#  This command should output ok 
#  . If, instead, the output includes OSError: out of pty devices 
#  , then the environment is not set up for proper PTY operation. You need to 
# exit from the chroot environment, read [Section 7.3, “Preparing Virtual Kernel File Systems”](../chapter07/kernfs.html)
#  again, and ensure the devpts 
#  file system (and other virtual kernel file systems) mounted correctly. Then 
# reenter the chroot environment following [Section 7.4, “Entering the Chroot Environment”](../chapter07/chroot.html)
#  . This issue needs to be resolved before continuing, or the test suites 
# requiring Expect (for example the test suites of Bash, Binutils, GCC, GDBM, and 
# of course Expect itself) will fail catastrophically, and other subtle breakages 
# may also happen. 
#</p>
#<p>
#
#  Now, make some changes to allow the package with gcc-14.1 or later: 
#</p>

#********<pre>***********
patch -Np1 -i ../expect-5.45.4-gcc14-1.patch
#********</pre>**********
#<p>
#
#  Prepare Expect for compilation: 
#</p>

#********<pre>***********
./configure --prefix=/usr           \
            --with-tcl=/usr/lib     \
            --enable-shared         \
            --disable-rpath         \
            --mandir=/usr/share/man \
            --with-tclinclude=/usr/include \
            --build=aarch64-unknown-linux-gnu
#********</pre>**********
#<p>
#
#  The meaning of the configure options: 
#</p>

#--with-tcl=/usr/lib 
##<p>
#
#  This parameter is needed to tell configure
#  where the tclConfig.sh
#  script is located. 
#</p>

#--with-tclinclude=/usr/include 
##<p>
#
#  This explicitly tells Expect where to find Tcl's internal headers. 
#</p>
#<p>
#
#  Build the package: 
#</p>

#********<pre>***********
make
#********</pre>**********
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
ln -svf expect5.45.4/libexpect5.45.4.so /usr/lib
#********</pre>**********

# ==== 8.17.2. Contents of Expect ====

#  Installed program: expect
#  Installed library: libexpect5.45.4.so
# ====== Short Descriptions ======

#--------------------------------------------
# | expect                                   | Communicates with other interactive programs according to a script
# | libexpect-5.45.4.so                      | Contains functions that allow Expect to be used as a Tcl extension or to be used directly from C or C++ (without Tcl)
#--------------------------------------------echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt
