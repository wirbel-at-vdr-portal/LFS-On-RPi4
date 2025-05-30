#!/usr/bin/bash

# ===== 5.5. Glibc-2.41 =====
topdir=$(pwd)
err=0
set -e
chapter=5005
err_report() {
    echo "chapter $chapter: $(date +'%Y.%m.%d %H:%M:%S') Error $? on line $1" | tee >> $topdir/log.txt
}
trap 'err_report $LINENO' ERR
echo "---------" >> $topdir/log.txt
echo chapter $chapter: start = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt

if [[ -z "${LFS}" ]]; then
  echo "ERROR: 'LFS' is not set.";stop
  exit 1
fi

grep -q $LFS /proc/mounts || err=1
if [ "$err" -eq "1" ]; then
  echo "ERROR: The '$LFS' partition must be mounted.";stop
  exit 1
fi

if [ "$EUID" -eq "0" ]; then
  echo "ERROR: Please run as user lfs"
  exit 1
fi

srcdir=../../src/glibc-2.41
tar xf ../../src/glibc-2.41.tar.xz -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir

#<p>
#
#  The Glibc package contains the main C library. This library provides the basic 
# routines for allocating memory, searching directories, opening and closing 
# files, reading and writing files, string handling, pattern matching, 
# arithmetic, and so on. 
#</p>

#  Approximate build time: 1.4 SBU
#  Required disk space: 850 MB
# ==== 5.5.1. Installation of Glibc ====
#<p>
#
#  First, create a symbolic link for LSB compliance. Additionally, for x86_64, 
# create a compatibility symbolic link required for proper operation of the 
# dynamic library loader: 
#</p>

#********<pre>***********
case $(uname -m) in
    i?86)   ln -sfv ld-linux.so.2 $LFS/lib/ld-lsb.so.3
    ;;
    x86_64) ln -sfv ../lib/ld-linux-x86-64.so.2 $LFS/lib64
            ln -sfv ../lib/ld-linux-x86-64.so.2 $LFS/lib64/ld-lsb-x86-64.so.3
    ;;
    aarch64) ln -sfv ../lib/ld-linux-aarch64.so.1 $LFS/lib64
    ;;
esac
#********</pre>**********

# ====== Note ======
#<p>
#
#  The above command is correct. The ln
#  command has several syntactic versions, so be sure to check info coreutils ln
#  and [ln(1)](https://man.archlinux.org/man/ln.1)
#  before reporting what may appear to be an error. 
#</p>
#<p>
#
#  Some of the Glibc programs use the non-FHS-compliant /var/db 
#  directory to store their runtime data. Apply the following patch to make such 
# programs store their runtime data in the FHS-compliant locations: 
#</p>

#********<pre>***********
patch -Np1 -i ../glibc-2.41-fhs-1.patch
#********</pre>**********
#<p>
#
#  The Glibc documentation recommends building Glibc in a dedicated build 
# directory: 
#</p>

#********<pre>***********
mkdir -v build
cd       build
#********</pre>**********
#<p>
#
#  Ensure that the ldconfig
#  and sln
#  utilities are installed into /usr/sbin 
#  : 
#</p>

#********<pre>***********
echo "rootsbindir=/usr/sbin" > configparms
#********</pre>**********
#<p>
#
#  Next, prepare Glibc for compilation: 
#</p>

#********<pre>***********
../configure                             \
      --prefix=/usr                      \
      --host=$LFS_TGT                    \
      --build=$(../scripts/config.guess) \
      --disable-nscd                     \
      libc_cv_slibdir=/usr/lib           \
      --enable-kernel=5.4
#********</pre>**********
#<p>
#
#  The meaning of the configure options: 
#</p>

#--host=$LFS_TGT, --build=$(../scripts/config.guess) 
##<p>
#
#  The combined effect of these switches is that Glibc's build system configures 
# itself to be cross-compiled, using the cross-linker and cross-compiler in $LFS/tools 
#  . 
#</p>

#--enable-kernel=5.4 
##<p>
#
#  This tells Glibc to compile the library with support for 5.4 and later Linux 
# kernels. Workarounds for older kernels are not enabled. 
#</p>

#libc_cv_slibdir=/usr/lib 
##<p>
#
#  This ensures that the library is installed in /usr/lib instead of the default 
# /lib64 on 64-bit machines. 
#</p>

#--disable-nscd 
##<p>
#
#  Do not build the name service cache daemon which is no longer used. 
#</p>
#<p>
#
#  During this stage the following warning might appear: 
#</p>

#********<pre>***********
#configure: WARNING:
#*** These auxiliary programs are missing or
#*** incompatible versions: msgfmt
#*** some features will be disabled.
#*** Check the INSTALL file for required versions.
#********</pre>**********
#<p>
#
#  The missing or incompatible msgfmt
#  program is generally harmless. This msgfmt
#  program is part of the Gettext package, which the host distribution should 
# provide. 
#</p>

# ====== Note ======
#<p>
#
#  There have been reports that this package may fail when building as a “parallel make.”
#  If that occurs, rerun the make command with the -j1 
#  option. 
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
#  Install the package: 
#</p>

# ====== Warning ======
#<p>
#
#  If LFS 
#  is not properly set, and despite the recommendations, you are building as root 
#  , the next command will install the newly built Glibc to your host system, 
# which will almost certainly render it unusable. So double-check that the 
# environment is correctly set, and that you are not root 
#  , before running the following command. 
#</p>

#********<pre>***********
make DESTDIR=$LFS install
#********</pre>**********
#<p>
#
#  The meaning of the make install
#  option: 
#</p>

#DESTDIR=$LFS 
##<p>
#
#  The DESTDIR 
#  make variable is used by almost all packages to define the location where the 
# package should be installed. If it is not set, it defaults to the root ( / 
#  ) directory. Here we specify that the package is installed in $LFS 
#  , which will become the root directory in [Section 7.4, “Entering the Chroot Environment.”](../chapter07/chroot.html)
#</p>
#<p>
#
#  Fix a hard coded path to the executable loader in the ldd
#  script: 
#</p>

#********<pre>***********
sed '/RTLDLIST=/s@/usr@@g' -i $LFS/usr/bin/ldd
#********</pre>**********
#<p>
#
#  Now that our cross toolchain is in place, it is important to ensure that 
# compiling and linking will work as expected. We do this by performing some 
# sanity checks: 
#</p>

#********<pre>***********
echo 'int main(){}' | $LFS_TGT-gcc -x c - -v -Wl,--verbose &> dummy.log
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
#  Note that this path should not contain /mnt/lfs 
#  (or the value of the LFS 
#  variable if you used a different one). The path is resolved when the compiled 
# program is executed, and that should only happen after we enter the chroot 
# environment where the kernel would consider $LFS 
#  as the root directory ( / 
#  ). 
#</p>
#<p>
#
#  Now make sure that we're set up to use the correct start files: 
#</p>

#********<pre>***********
grep -E -o "$LFS/lib.*/S?crt[1in].*succeeded" dummy.log
#********</pre>**********
#<p>
#
#  The output of the last command should be: 
#</p>

#********<pre>***********
#/mnt/lfs/lib/../lib/Scrt1.o succeeded
#/mnt/lfs/lib/../lib/crti.o succeeded
#/mnt/lfs/lib/../lib/crtn.o succeeded
#********</pre>**********
#<p>
#
#  Verify that the compiler is searching for the correct header files: 
#</p>

#********<pre>***********
grep -B3 "^ $LFS/usr/include" dummy.log
#********</pre>**********
#<p>
#
#  This command should return the following output: 
#</p>

#********<pre>***********
##include <...> search starts here:
# /mnt/lfs/tools/lib/gcc/x86_64-lfs-linux-gnu/14.2.0/include
# /mnt/lfs/tools/lib/gcc/x86_64-lfs-linux-gnu/14.2.0/include-fixed
# /mnt/lfs/usr/include
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
#SEARCH_DIR("=/mnt/lfs/tools/x86_64-lfs-linux-gnu/lib64")
#SEARCH_DIR("=/usr/local/lib64")
#SEARCH_DIR("=/lib64")
#SEARCH_DIR("=/usr/lib64")
#SEARCH_DIR("=/mnt/lfs/tools/x86_64-lfs-linux-gnu/lib")
#SEARCH_DIR("=/usr/local/lib")
#SEARCH_DIR("=/lib")
#SEARCH_DIR("=/usr/lib");
#********</pre>**********
#<p>
#
#  A 32-bit system may use a few other directories, but anyway the important 
# facet here is all the paths should begin with an equal sign ( = 
#  ), which would be replaced with the sysroot directory that we've configured 
# for the linker. 
#</p>
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
#attempt to open /mnt/lfs/usr/lib/libc.so.6 succeeded
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
#found ld-linux-x86-64.so.2 at /mnt/lfs/usr/lib/ld-linux-x86-64.so.2
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

# ====== Note ======
#<p>
#
#  Building the packages in the next chapter will serve as an additional check 
# that the toolchain has been built properly. If some package, especially 
# Binutils-pass2 or GCC-pass2, fails to build, it is an indication that something 
# has gone wrong with the preceding Binutils, GCC, or Glibc installations. 
#</p>
#<p>
#
#  Details on this package are located in [Section 8.5.3, “Contents of Glibc.”](../chapter08/glibc.html#contents-glibc)
#</p>

cd $topdir
rm -rfv $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt
