#!/usr/bin/bash

# ===== 8.15. Flex-2.6.4 =====
topdir=$(pwd)
err=0
set -e
chapter=8015
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



srcdir=../../src/flex-2.6.4
tar xf ../../src/flex-2.6.4.tar.gz -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir

#<p>
#
#  The Flex package contains a utility for generating programs that recognize 
# patterns in text. 
#</p>

#  Approximate build time: 0.1 SBU
#  Required disk space: 33 MB
# ==== 8.15.1. Installation of Flex ====
#<p>
#
#  Prepare Flex for compilation: 
#</p>

#********<pre>***********
./configure --prefix=/usr \
            --docdir=/usr/share/doc/flex-2.6.4 \
            --disable-static
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
#<p>
#
#  A few programs do not know about flex
#  yet and try to run its predecessor, lex
#  . To support those programs, create a symbolic link named lex 
#  that runs flex 
#  in lex
#  emulation mode, and also create the man page of lex
#  as a symlink: 
#</p>

#********<pre>***********
ln -sv flex   /usr/bin/lex
ln -sv flex.1 /usr/share/man/man1/lex.1
#********</pre>**********

# ==== 8.15.2. Contents of Flex ====

#  Installed programs: flex, flex++ (link to flex), and lex (link to flex)
#  Installed libraries: libfl.so
#  Installed directory: /usr/share/doc/flex-2.6.4
# ====== Short Descriptions ======

#--------------------------------------------
# | flex                                     | A tool for generating programs that recognize patterns in text; it allows for the versatility to specify the rules for pattern-finding, eradicating the need to develop a specialized program
# | flex++                                   | An extension of flex, is used for generating C++ code and classes. It is a symbolic link toflex                                    
# | lex                                      | A symbolic link that runs               flex                                    in                                      lex                                     emulation mode                          
# | libfl                                    | The                                     flex                                    library                                 
#--------------------------------------------
cd $topdir
rm -rf $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt
