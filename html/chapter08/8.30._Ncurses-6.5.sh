#!/usr/bin/bash

# ===== 8.30. Ncurses-6.5 =====
topdir=$(pwd)
err=0
set -e
chapter=8030
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



srcdir=../../src/ncurses-6.5
tar xf ../../src/ncurses-6.5.tar.gz -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir

#<p>
#
#  The Ncurses package contains libraries for terminal-independent handling of 
# character screens. 
#</p>

#  Approximate build time: 0.2 SBU
#  Required disk space: 46 MB
# ==== 8.30.1. Installation of Ncurses ====
#<p>
#
#  Prepare Ncurses for compilation: 
#</p>

#********<pre>***********
./configure --prefix=/usr           \
            --mandir=/usr/share/man \
            --with-shared           \
            --without-debug         \
            --without-normal        \
            --with-cxx-shared       \
            --enable-pc-files       \
            --with-pkg-config-libdir=/usr/lib/pkgconfig
#********</pre>**********
#<p>
#
#  The meaning of the new configure options: 
#</p>

#--with-shared 
##<p>
#
#  This makes Ncurses build and install shared C libraries. 
#</p>

#--without-normal 
##<p>
#
#  This prevents Ncurses building and installing static C libraries. 
#</p>

#--without-debug 
##<p>
#
#  This prevents Ncurses building and installing debug libraries. 
#</p>

#--with-cxx-shared 
##<p>
#
#  This makes Ncurses build and install shared C++ bindings. It also prevents it 
# building and installing static C++ bindings. 
#</p>

#--enable-pc-files 
##<p>
#
#  This switch generates and installs .pc files for pkg-config. 
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
#  This package has a test suite, but it can only be run after the package has 
# been installed. The tests reside in the test/ 
#  directory. See the README 
#  file in that directory for further details. 
#</p>
#<p>
#
#  The installation of this package will overwrite libncursesw.so.6.5 
#  in-place. It may crash the shell process which is using code and data from the 
# library file. Install the package with DESTDIR 
#  , and replace the library file correctly using install
#  command (the header curses.h 
#  is also edited to ensure the wide-character ABI to be used as what we've done 
# in [Section 6.3, “Ncurses-6.5”](../chapter06/ncurses.html)
#  ): 
#</p>

#********<pre>***********
make DESTDIR=$PWD/dest install
install -vm755 dest/usr/lib/libncursesw.so.6.5 /usr/lib
rm -v  dest/usr/lib/libncursesw.so.6.5
sed -e 's/^#if.*XOPEN.*$/#if 1/' \
    -i dest/usr/include/curses.h
cp -av dest/* /
#********</pre>**********
#<p>
#
#  Many applications still expect the linker to be able to find 
# non-wide-character Ncurses libraries. Trick such applications into linking with 
# wide-character libraries by means of symlinks (note that the .so 
#  links are only safe with curses.h 
#  edited to always use the wide-character ABI): 
#</p>

#********<pre>***********
for lib in ncurses form panel menu ; do
    ln -sfv lib${lib}w.so /usr/lib/lib${lib}.so
    ln -sfv ${lib}w.pc    /usr/lib/pkgconfig/${lib}.pc
done
#********</pre>**********
#<p>
#
#  Finally, make sure that old applications that look for -lcurses 
#  at build time are still buildable: 
#</p>

#********<pre>***********
ln -sfv libncursesw.so /usr/lib/libcurses.so
#********</pre>**********
#<p>
#
#  If desired, install the Ncurses documentation: 
#</p>

#********<pre>***********
cp -v -R doc -T /usr/share/doc/ncurses-6.5
#********</pre>**********

# ====== Note ======
#<p>
#
#  The instructions above don't create non-wide-character Ncurses libraries since 
# no package installed by compiling from sources would link against them at 
# runtime. However, the only known binary-only applications that link against 
# non-wide-character Ncurses libraries require version 5. If you must have such 
# libraries because of some binary-only application or to be compliant with LSB, 
# build the package again with the following commands: 
#</p>

#********<pre>***********
make distclean
./configure --prefix=/usr    \
            --with-shared    \
            --without-normal \
            --without-debug  \
            --without-cxx-binding \
            --with-abi-version=5
make sources libs
cp -av lib/lib*.so.5* /usr/lib
#********</pre>**********

# ==== 8.30.2. Contents of Ncurses ====

#  Installed programs: captoinfo (link to tic), clear, infocmp, infotocap (link to tic), ncursesw6-config, reset (link to tset), tabs, tic, toe, tput, and tset
#  Installed libraries: libcurses.so (symlink), libform.so (symlink), libformw.so, libmenu.so (symlink), libmenuw.so, libncurses.so (symlink), libncursesw.so, libncurses++w.so, libpanel.so (symlink), and libpanelw.so,
#  Installed directories: /usr/share/tabset, /usr/share/terminfo, and /usr/share/doc/ncurses-6.5
# ====== Short Descriptions ======

#--------------------------------------------
# | captoinfo                                | Converts a termcap description into a terminfo description
# | clear                                    | Clears the screen, if possible          
# | infocmp                                  | Compares or prints out terminfo descriptions
# | infotocap                                | Converts a terminfo description into a termcap description
# | ncursesw6-config                         | Provides configuration information for ncurses
# | reset                                    | Reinitializes a terminal to its default values
# | tabs                                     | Clears and sets tab stops on a terminal 
# | tic                                      | The terminfo entry-description compiler that translates a terminfo file from source format into the binary format needed for the ncurses library routines [A terminfo file contains information on the capabilities of a certain terminal.]
# | toe                                      | Lists all available terminal types, giving the primary name and description for each
# | tput                                     | Makes the values of terminal-dependent capabilities available to the shell; it can also be used to reset or initialize a terminal or report its long name
# | tset                                     | Can be used to initialize terminals     
# | libncursesw                              | Contains functions to display text in many complex ways on a terminal screen; a good example of the use of these functions is the menu displayed during the kernel'smake menuconfig                         
# | libncurses++w                            | Contains C++ binding for other libraries in this package
# | libformw                                 | Contains functions to implement forms   
# | libmenuw                                 | Contains functions to implement menus   
# | libpanelw                                | Contains functions to implement panels  
#--------------------------------------------
cd $topdir
rm -rf $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt
