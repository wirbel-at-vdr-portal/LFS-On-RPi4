#!/usr/bin/bash

# ===== 8.20. Binutils-2.44 =====
topdir=$(pwd)
err=0
set -e
chapter=8020
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



srcdir=../../src/binutils-2.44
tar xf ../../src/binutils-2.44.tar.xz -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir

#<p>
#
#  The Binutils package contains a linker, an assembler, and other tools for 
# handling object files. 
#</p>

#  Approximate build time: 1.6 SBU
#  Required disk space: 819 MB
# ==== 8.20.1. Installation of Binutils ====
#<p>
#
#  The Binutils documentation recommends building Binutils in a dedicated build 
# directory: 
#</p>

#********<pre>***********
mkdir -v build
cd       build
#********</pre>**********
#<p>
#
#  Prepare Binutils for compilation: 
#</p>

#********<pre>***********
../configure --prefix=/usr       \
             --sysconfdir=/etc   \
             --enable-ld=default \
             --enable-plugins    \
             --enable-shared     \
             --disable-werror    \
             --enable-64-bit-bfd \
             --enable-new-dtags  \
             --with-system-zlib  \
             --enable-default-hash-style=gnu
#********</pre>**********
#<p>
#
#  The meaning of the new configure parameters: 
#</p>

#--enable-ld=default 
##<p>
#
#  Build the original bfd linker and install it as both ld (the default linker) 
# and ld.bfd. 
#</p>

#--enable-plugins 
##<p>
#
#  Enables plugin support for the linker. 
#</p>

#--with-system-zlib 
##<p>
#
#  Use the installed zlib library instead of building the included version. 
#</p>
#<p>
#
#  Compile the package: 
#</p>

#********<pre>***********
make tooldir=/usr
#********</pre>**********
#<p>
#
#  The meaning of the make parameter: 
#</p>

#tooldir=/usr 
##<p>
#
#  Normally, the tooldir (the directory where the executables will ultimately be 
# located) is set to $(exec_prefix)/$(target_alias) 
#  . For example, x86_64 machines would expand that to /usr/x86_64-pc-linux-gnu 
#  . Because this is a custom system, this target-specific directory in /usr 
#  is not required. $(exec_prefix)/$(target_alias) 
#  would be used if the system were used to cross-compile (for example, compiling 
# a package on an Intel machine that generates code that can be executed on 
# PowerPC machines). 
#</p>

# ====== Important ======
#<p>
#
#  The test suite for Binutils in this section is considered critical. Do not 
# skip it under any circumstances. 
#</p>
#<p>
#
#  Test the results: 
#</p>

#********<pre>***********
make -k check
#********</pre>**********
#<p>
#
#  For a list of failed tests, run: 
#</p>

#********<pre>***********
grep '^FAIL:' $(find -name '*.log')
#********</pre>**********
#<p>
#
#  Install the package: 
#</p>

#********<pre>***********
make tooldir=/usr install
#********</pre>**********
#<p>
#
#  Remove useless static libraries and other files: 
#</p>

#********<pre>***********
rm -rfv /usr/lib/lib{bfd,ctf,ctf-nobfd,gprofng,opcodes,sframe}.a \
        /usr/share/doc/gprofng/
#********</pre>**********

# ==== 8.20.2. Contents of Binutils ====

#  Installed programs: addr2line, ar, as, c++filt, dwp, elfedit, gprof, gprofng, ld, ld.bfd, nm, objcopy, objdump, ranlib, readelf, size, strings, and strip
#  Installed libraries: libbfd.so, libctf.so, libctf-nobfd.so, libgprofng.so, libopcodes.so, and libsframe.so
#  Installed directory: /usr/lib/ldscripts
# ====== Short Descriptions ======

#--------------------------------------------
# | addr2line                                | Translates program addresses to file names and line numbers; given an address and the name of an executable, it uses the debugging information in the executable to determine which source file and line number are associated with the address
# | ar                                       | Creates, modifies, and extracts from archives
# | as                                       | An assembler that assembles the output ofgcc                                     into object files                       
# | c++filt                                  | Used by the linker to de-mangle C++ and Java symbols and to keep overloaded functions from clashing
# | dwp                                      | The DWARF packaging utility             
# | elfedit                                  | Updates the ELF headers of ELF files    
# | gprof                                    | Displays call graph profile data        
# | gprofng                                  | Gathers and analyzes performance data   
# | ld                                       | A linker that combines a number of object and archive files into a single file, relocating their data and tying up symbol references
# | ld.bfd                                   | A hard link to                          ld                                      
# | nm                                       | Lists the symbols occurring in a given object file
# | objcopy                                  | Translates one type of object file into another
# | objdump                                  | Displays information about the given object file, with options controlling the particular information to display; the information shown is useful to programmers who are working on the compilation tools
# | ranlib                                   | Generates an index of the contents of an archive and stores it in the archive; the index lists all of the symbols defined by archive members that are relocatable object files
# | readelf                                  | Displays information about ELF type binaries
# | size                                     | Lists the section sizes and the total size for the given object files
# | strings                                  | Outputs, for each given file, the sequences of printable characters that are of at least the specified length (defaulting to four); for object files, it prints, by default, only the strings from the initializing and loading sections while for other types of files, it scans the entire file
# | strip                                    | Discards symbols from object files      
# | libbfd                                   | The Binary File Descriptor library      
# | libctf                                   | The Compat ANSI-C Type Format debugging support library
# | libctf-nobfd                             | A libctf variant which does not use libbfd functionality
# | libgprofng                               | A library containing most routines used bygprofng                                 
# | libopcodes                               | A library for dealing with opcodes—the  “                                       readable text                           ”                                       versions of instructions for the processor; it is used for building utilities likeobjdump                                 
# | libsframe                                | A library to support online backtracing using a simple unwinder
#--------------------------------------------
cd $topdir
rm -rf $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt
