#!/usr/bin/bash

# ===== 8.29. GCC-14.2.0 =====
topdir=$(pwd)
err=0
set -e
chapter=8029
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



srcdir=../../src/gcc-14.2.0
tar xf ../../src/gcc-14.2.0.tar.xz -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir

#<p>
#
#  The GCC package contains the GNU compiler collection, which includes the C and 
# C++ compilers. 
#</p>

#  Approximate build time: 46 SBU (with tests)
#  Required disk space: 6.3 GB
# ==== 8.29.1. Installation of GCC ====
#<p>
#
#  If building on x86_64, change the default directory name for 64-bit libraries 
# to “lib”
#  : 
#</p>

#********<pre>***********
case $(uname -m) in
  x86_64)
    sed -e '/m64=/s/lib64/lib/' \
        -i.orig gcc/config/i386/t-linux64
  ;;
  aarch64)
    sed -e '/m64=/s/lib64/lib/' \
        -i.orig gcc/config/aarch64/t-aarch64-linux
  ;;
esac
#********</pre>**********
#<p>
#
#  The GCC documentation recommends building GCC in a dedicated build directory: 
#</p>

#********<pre>***********
mkdir -v build
cd       build
#********</pre>**********
#<p>
#
#  Prepare GCC for compilation: 
#</p>

#********<pre>***********
../configure --prefix=/usr            \
             LD=ld                    \
             --enable-languages=c,c++ \
             --enable-default-pie     \
             --enable-default-ssp     \
             --enable-host-pie        \
             --disable-multilib       \
             --disable-bootstrap      \
             --disable-fixincludes    \
             --with-system-zlib
#********</pre>**********
#<p>
#
#  GCC supports seven different computer languages, but the prerequisites for 
# most of them have not yet been installed. See the [BLFS Book GCC page](https://www.linuxfromscratch.org/blfs/view/svn/general/gcc.html)
#  for instructions on how to build all of GCC's supported languages. 
#</p>
#<p>
#
#  The meaning of the new configure parameters: 
#</p>

#LD=ld 
##<p>
#
#  This parameter makes the configure script use the ld program installed by the 
# Binutils package built earlier in this chapter, rather than the cross-built 
# version which would otherwise be used. 
#</p>

#--disable-fixincludes 
##<p>
#
#  By default, during the installation of GCC some system headers would be “fixed”
#  to be used with GCC. This is not necessary for a modern Linux system, and 
# potentially harmful if a package is reinstalled after installing GCC. This 
# switch prevents GCC from “fixing”
#  the headers. 
#</p>

#--with-system-zlib 
##<p>
#
#  This switch tells GCC to link to the system installed copy of the Zlib 
# library, rather than its own internal copy. 
#</p>

# ====== Note ======
#<p>
#
#  PIE (position-independent executables) are binary programs that can be loaded 
# anywhere in memory. Without PIE, the security feature named ASLR (Address Space 
# Layout Randomization) can be applied for the shared libraries, but not for the 
# executables themselves. Enabling PIE allows ASLR for the executables in 
# addition to the shared libraries, and mitigates some attacks based on fixed 
# addresses of sensitive code or data in the executables. 
#</p>
#<p>
#
#  SSP (Stack Smashing Protection) is a technique to ensure that the parameter 
# stack is not corrupted. Stack corruption can, for example, alter the return 
# address of a subroutine, thus transferring control to some dangerous code 
# (existing in the program or shared libraries, or injected by the attacker 
# somehow). 
#</p>
#<p>
#
#  Compile the package: 
#</p>

#********<pre>***********
make
#********</pre>**********

# ====== Important ======
#<p>
#
#  In this section, the test suite for GCC is considered important, but it takes 
# a long time. First-time builders are encouraged to run the test suite. The time 
# to run the tests can be reduced significantly by adding -jx to the make -k check
#  command below, where x is the number of CPU cores on your system. 
#</p>
#<p>
#
#  GCC may need more stack space compiling some extremely complex code patterns. 
# As a precaution for the host distros with a tight stack limit, explicitly set 
# the stack size hard limit to infinite. On most host distros (and the final LFS 
# system) the hard limit is infinite by default, but there is no harm done by 
# setting it explicitly. It's not necessary to change the stack size soft limit 
# because GCC will automatically set it to an appropriate value, as long as the 
# value does not exceed the hard limit: 
#</p>

#********<pre>***********
ulimit -s -H unlimited
#********</pre>**********
#<p>
#
#  Now remove/fix several known test failures: 
#</p>

#********<pre>***********
sed -e '/cpython/d'               -i ../gcc/testsuite/gcc.dg/plugin/plugin.exp
sed -e 's/no-pic /&-no-pie /'     -i ../gcc/testsuite/gcc.target/i386/pr113689-1.c
sed -e 's/300000/(1|300000)/'     -i ../libgomp/testsuite/libgomp.c-c++-common/pr109062.c
sed -e 's/{ target nonpic } //' \
    -e '/GOTPCREL/d'              -i ../gcc/testsuite/gcc.target/i386/fentryname3.c
#********</pre>**********
#<p>
#
#  Test the results as a non-privileged user, but do not stop at errors: 
#</p>

#********<pre>***********
chown -R tester .
su tester -c "PATH=$PATH make -k check"
#********</pre>**********
#<p>
#
#  To extract a summary of the test suite results, run: 
#</p>

#********<pre>***********
../contrib/test_summary
#********</pre>**********
#<p>
#
#  To filter out only the summaries, pipe the output through grep -A7 Summ 
#  . 
#</p>
#<p>
#
#  Results can be compared with those located at [https://www.linuxfromscratch.org/lfs/build-logs/development/](https://www.linuxfromscratch.org/lfs/build-logs/development/)
#  and [https://gcc.gnu.org/ml/gcc-testresults/](https://gcc.gnu.org/ml/gcc-testresults/)
#  . 
#</p>
#<p>
#
#  The tsan tests are known to fail on some host distros. 
#</p>
#<p>
#
#  A few unexpected failures cannot always be avoided. In some cases test 
# failures depend on the specific hardware of the system. Unless the test results 
# are vastly different from those at the above URL, it is safe to continue. 
#</p>
#<p>
#
#  Install the package: 
#</p>

#********<pre>***********
make install
#********</pre>**********
#<p>
#
#  The GCC build directory is owned by tester 
#  now, and the ownership of the installed header directory (and its content) is 
# incorrect. Change the ownership to the root 
#  user and group: 
#</p>

#********<pre>***********
chown -v -R root:root \
    /usr/lib/gcc/$(gcc -dumpmachine)/14.2.0/include{,-fixed}
#********</pre>**********
#<p>
#
#  Create a symlink required by the [FHS](https://refspecs.linuxfoundation.org/FHS_3.0/fhs/ch03s09.html)
#  for "historical" reasons. 
#</p>

#********<pre>***********
ln -svr /usr/bin/cpp /usr/lib
#********</pre>**********
#<p>
#
#  Many packages use the name cc
#  to call the C compiler. We've already created cc
#  as a symlink in [gcc-pass2](../chapter06/gcc-pass2.html)
#  , create its man page as a symlink as well: 
#</p>

#********<pre>***********
ln -sv gcc.1 /usr/share/man/man1/cc.1
#********</pre>**********
#<p>
#
#  Add a compatibility symlink to enable building programs with Link Time 
# Optimization (LTO): 
#</p>

#********<pre>***********
ln -sfv ../../libexec/gcc/$(gcc -dumpmachine)/14.2.0/liblto_plugin.so \
        /usr/lib/bfd-plugins/
#********</pre>**********
#<p>
#
#  Now that our final toolchain is in place, it is important to again ensure that 
# compiling and linking will work as expected. We do this by performing some 
# sanity checks: 
#</p>

#********<pre>***********
echo 'int main(){}' | cc -x c - -v -Wl,--verbose &> dummy.log
readelf -l a.out | grep ': /lib'
#********</pre>**********
#<p>
#
#  There should be no errors, and the output of the last command will be 
# (allowing for platform-specific differences in the dynamic linker name): 
#</p>

#********<pre>***********
#[Requesting program interpreter: /lib64/ld-linux-x86-64.so.2]
#********</pre>**********
#<p>
#
#  Now make sure that we're set up to use the correct start files: 
#</p>

#********<pre>***********
grep -E -o '/usr/lib.*/S?crt[1in].*succeeded' dummy.log
#********</pre>**********
#<p>
#
#  The output of the last command should be: 
#</p>

#********<pre>***********
#/usr/lib/gcc/x86_64-pc-linux-gnu/14.2.0/../../../../lib/Scrt1.o succeeded
#/usr/lib/gcc/x86_64-pc-linux-gnu/14.2.0/../../../../lib/crti.o succeeded
#/usr/lib/gcc/x86_64-pc-linux-gnu/14.2.0/../../../../lib/crtn.o succeeded
#********</pre>**********
#<p>
#
#  Depending on your machine architecture, the above may differ slightly. The 
# difference will be the name of the directory after /usr/lib/gcc 
#  . The important thing to look for here is that gcc
#  has found all three crt*.o 
#  files under the /usr/lib 
#  directory. 
#</p>
#<p>
#
#  Verify that the compiler is searching for the correct header files: 
#</p>

#********<pre>***********
grep -B4 '^ /usr/include' dummy.log
#********</pre>**********
#<p>
#
#  This command should return the following output: 
#</p>

#********<pre>***********
##include <...> search starts here:
# /usr/lib/gcc/x86_64-pc-linux-gnu/14.2.0/include
# /usr/local/include
# /usr/lib/gcc/x86_64-pc-linux-gnu/14.2.0/include-fixed
# /usr/include
#********</pre>**********
#<p>
#
#  Again, the directory named after your target triplet may be different than the 
# above, depending on your system architecture. 
#</p>
#<p>
#
#  Next, verify that the new linker is being used with the correct search paths: 
#</p>

#********<pre>***********
grep 'SEARCH.*/usr/lib' dummy.log |sed 's|; |\n|g'
#********</pre>**********
#<p>
#
#  References to paths that have components with '-linux-gnu' should be ignored, 
# but otherwise the output of the last command should be: 
#</p>

#********<pre>***********
#SEARCH_DIR("/usr/x86_64-pc-linux-gnu/lib64")
#SEARCH_DIR("/usr/local/lib64")
#SEARCH_DIR("/lib64")
#SEARCH_DIR("/usr/lib64")
#SEARCH_DIR("/usr/x86_64-pc-linux-gnu/lib")
#SEARCH_DIR("/usr/local/lib")
#SEARCH_DIR("/lib")
#SEARCH_DIR("/usr/lib");
#********</pre>**********
#<p>
#
#  A 32-bit system may use a few other directories. For example, here is the 
# output from an i686 machine: 
#</p>

#********<pre>***********
#SEARCH_DIR("/usr/i686-pc-linux-gnu/lib32")
#SEARCH_DIR("/usr/local/lib32")
#SEARCH_DIR("/lib32")
#SEARCH_DIR("/usr/lib32")
#SEARCH_DIR("/usr/i686-pc-linux-gnu/lib")
#SEARCH_DIR("/usr/local/lib")
#SEARCH_DIR("/lib")
#SEARCH_DIR("/usr/lib");
#********</pre>**********
#<p>
#
#  Next make sure that we're using the correct libc: 
#</p>

#********<pre>***********
grep "/lib.*/libc.so.6 " dummy.log
#********</pre>**********
#<p>
#
#  The output of the last command should be: 
#</p>

#********<pre>***********
#attempt to open /usr/lib/libc.so.6 succeeded
#********</pre>**********
#<p>
#
#  Make sure GCC is using the correct dynamic linker: 
#</p>

#********<pre>***********
grep found dummy.log
#********</pre>**********
#<p>
#
#  The output of the last command should be (allowing for platform-specific 
# differences in dynamic linker name): 
#</p>

#********<pre>***********
#found ld-linux-x86-64.so.2 at /usr/lib/ld-linux-x86-64.so.2
#********</pre>**********
#<p>
#
#  If the output does not appear as shown above or is not received at all, then 
# something is seriously wrong. Investigate and retrace the steps to find out 
# where the problem is and correct it. Any issues should be resolved before 
# continuing with the process. 
#</p>
#<p>
#
#  Once everything is working correctly, clean up the test files: 
#</p>

#********<pre>***********
rm -v a.out dummy.log
#********</pre>**********
#<p>
#
#  Finally, move a misplaced file: 
#</p>

#********<pre>***********
mkdir -pv /usr/share/gdb/auto-load/usr/lib
mv -v /usr/lib/*gdb.py /usr/share/gdb/auto-load/usr/lib
#********</pre>**********

# ==== 8.29.2. Contents of GCC ====

#  Installed programs: c++, cc (link to gcc), cpp, g++, gcc, gcc-ar, gcc-nm, gcc-ranlib, gcov, gcov-dump, gcov-tool, and lto-dump
#  Installed libraries: libasan.{a,so}, libatomic.{a,so}, libcc1.so, libgcc.a, libgcc_eh.a, libgcc_s.so, libgcov.a, libgomp.{a,so}, libhwasan.{a,so}, libitm.{a,so}, liblsan.{a,so}, liblto_plugin.so, libquadmath.{a,so}, libssp.{a,so}, libssp_nonshared.a, libstdc++.{a,so}, libstdc++exp.a, libstdc++fs.a, libsupc++.a, libtsan.{a,so}, and libubsan.{a,so}
#  Installed directories: /usr/include/c++, /usr/lib/gcc, /usr/libexec/gcc, and /usr/share/gcc-14.2.0
# ====== Short Descriptions ======

#--------------------------------------------
# | c++                                      | The C++ compiler                        
# | cc                                       | The C compiler                          
# | cpp                                      | The C preprocessor; it is used by the compiler to expand the #include, #define, and similar directives in the source files
# | g++                                      | The C++ compiler                        
# | gcc                                      | The C compiler                          
# | gcc-ar                                   | A wrapper around                        ar                                      that adds a plugin to the command line. This program is only used to add "link time optimization" and is not useful with the default build options.
# | gcc-nm                                   | A wrapper around                        nm                                      that adds a plugin to the command line. This program is only used to add "link time optimization" and is not useful with the default build options.
# | gcc-ranlib                               | A wrapper around                        ranlib                                  that adds a plugin to the command line. This program is only used to add "link time optimization" and is not useful with the default build options.
# | gcov                                     | A coverage testing tool; it is used to analyze programs to determine where optimizations will have the greatest effect
# | gcov-dump                                | Offline gcda and gcno profile dump tool 
# | gcov-tool                                | Offline gcda profile processing tool    
# | lto-dump                                 | Tool for dumping object files produced by GCC with LTO enabled
# | libasan                                  | The Address Sanitizer runtime library   
# | libatomic                                | GCC atomic built-in runtime library     
# | libcc1                                   | A library that allows GDB to make use of GCC
# | libgcc                                   | Contains run-time support for           gcc                                     
# | libgcov                                  | This library is linked into a program when GCC is instructed to enable profiling
# | libgomp                                  | GNU implementation of the OpenMP API for multi-platform shared-memory parallel programming in C/C++ and Fortran
# | libhwasan                                | The Hardware-assisted Address Sanitizer runtime library
# | libitm                                   | The GNU transactional memory library    
# | liblsan                                  | The Leak Sanitizer runtime library      
# | liblto_plugin                            | GCC's LTO plugin allows Binutils to process object files produced by GCC with LTO enabled
# | libquadmath                              | GCC Quad Precision Math Library API     
# | libssp                                   | Contains routines supporting GCC's stack-smashing protection functionality. Normally it is not used, because Glibc also provides those routines.
# | libstdc++                                | The standard C++ library                
# | libstdc++exp                             | Experimental C++ Contracts library      
# | libstdc++fs                              | ISO/IEC TS 18822:2015 Filesystem library
# | libsupc++                                | Provides supporting routines for the C++ programming language
# | libtsan                                  | The Thread Sanitizer runtime library    
# | libubsan                                 | The Undefined Behavior Sanitizer runtime library
#--------------------------------------------
cd $topdir
rm -rf $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt
