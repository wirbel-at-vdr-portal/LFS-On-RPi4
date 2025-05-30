#!/usr/bin/bash

# ===== 5.3. GCC-14.2.0 - Pass 1 =====
topdir=$(pwd)
err=0
set -e
chapter=5003
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

#  Approximate build time: 3.2 SBU
#  Required disk space: 4.8 GB
# ==== 5.3.1. Installation of Cross GCC ====
#<p>
#
#  GCC requires the GMP, MPFR and MPC packages. As these packages may not be 
# included in your host distribution, they will be built with GCC. Unpack each 
# package into the GCC source directory and rename the resulting directories so 
# the GCC build procedures will automatically use them: 
#</p>

# ====== Note ======
#<p>
#
#  There are frequent misunderstandings about this chapter. The procedures are 
# the same as every other chapter, as explained earlier ( [Package build instructions](../partintro/generalinstructions.html#buildinstr)
#  ). First, extract the gcc-14.2.0 tarball from the sources directory, and then 
# change to the directory created. Only then should you proceed with the 
# instructions below. 
#</p>

#********<pre>***********
tar -xf ../mpfr-4.2.2.tar.xz
mv -v mpfr-4.2.2 mpfr
tar -xf ../gmp-6.3.0.tar.xz
mv -v gmp-6.3.0 gmp
tar -xf ../mpc-1.3.1.tar.gz
mv -v mpc-1.3.1 mpc
#********</pre>**********
#<p>
#
#  On x86_64 hosts, set the default directory name for 64-bit libraries to “lib”
#  : 
#</p>

#********<pre>***********
case $(uname -m) in
  x86_64)
    sed -e '/m64=/s/lib64/lib/' \
        -i.orig gcc/config/i386/t-linux64
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
../configure                  \
    --target=$LFS_TGT         \
    --prefix=$LFS/tools       \
    --with-glibc-version=2.41 \
    --with-sysroot=$LFS       \
    --with-newlib             \
    --without-headers         \
    --enable-default-pie      \
    --enable-default-ssp      \
    --disable-nls             \
    --disable-shared          \
    --disable-multilib        \
    --disable-threads         \
    --disable-libatomic       \
    --disable-libgomp         \
    --disable-libquadmath     \
    --disable-libssp          \
    --disable-libvtv          \
    --disable-libstdcxx       \
    --enable-languages=c,c++
#********</pre>**********
#<p>
#
#  The meaning of the configure options: 
#</p>

#--with-glibc-version=2.41 
##<p>
#
#  This option specifies the version of Glibc which will be used on the target. 
# It is not relevant to the libc of the host distro because everything compiled 
# by pass1 GCC will run in the chroot environment, which is isolated from libc of 
# the host distro. 
#</p>

#--with-newlib 
##<p>
#
#  Since a working C library is not yet available, this ensures that the 
# inhibit_libc constant is defined when building libgcc. This prevents the 
# compiling of any code that requires libc support. 
#</p>

#--without-headers 
##<p>
#
#  When creating a complete cross-compiler, GCC requires standard headers 
# compatible with the target system. For our purposes these headers will not be 
# needed. This switch prevents GCC from looking for them. 
#</p>

#--enable-default-pie and --enable-default-ssp 
##<p>
#
#  Those switches allow GCC to compile programs with some hardening security 
# features (more information on those in the [note on PIE and SSP](../chapter08/gcc.html#pie-ssp-info)
#  in chapter 8) by default. They are not strictly needed at this stage, since 
# the compiler will only produce temporary executables. But it is cleaner to have 
# the temporary packages be as close as possible to the final ones. 
#</p>

#--disable-shared 
##<p>
#
#  This switch forces GCC to link its internal libraries statically. We need this 
# because the shared libraries require Glibc, which is not yet installed on the 
# target system. 
#</p>

#--disable-multilib 
##<p>
#
#  On x86_64, LFS does not support a multilib configuration. This switch is 
# harmless for x86. 
#</p>

#--disable-threads, --disable-libatomic, --disable-libgomp, --disable-libquadmath, --disable-libssp, --disable-libvtv, --disable-libstdcxx 
##<p>
#
#  These switches disable support for threading, libatomic, libgomp, libquadmath, 
# libssp, libvtv, and the C++ standard library respectively. These features may 
# fail to compile when building a cross-compiler and are not necessary for the 
# task of cross-compiling the temporary libc. 
#</p>

#--enable-languages=c,c++ 
##<p>
#
#  This option ensures that only the C and C++ compilers are built. These are the 
# only languages needed now. 
#</p>
#<p>
#
#  Compile GCC by running: 
#</p>

#********<pre>***********
make
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
#  This build of GCC has installed a couple of internal system headers. Normally 
# one of them, limits.h 
#  , would in turn include the corresponding system limits.h 
#  header, in this case, $LFS/usr/include/limits.h 
#  . However, at the time of this build of GCC $LFS/usr/include/limits.h 
#  does not exist, so the internal header that has just been installed is a 
# partial, self-contained file and does not include the extended features of the 
# system header. This is adequate for building Glibc, but the full internal 
# header will be needed later. Create a full version of the internal header using 
# a command that is identical to what the GCC build system does in normal 
# circumstances: 
#</p>

# ====== Note ======
#<p>
#
#  The command below shows an example of nested command substitution using two 
# methods: backquotes and a $() 
#  construct. It could be rewritten using the same method for both substitutions, 
# but is shown this way to demonstrate how they can be mixed. Generally the $() 
#  method is preferred. 
#</p>

#********<pre>***********
cd ..
cat gcc/limitx.h gcc/glimits.h gcc/limity.h > \
  `dirname $($LFS_TGT-gcc -print-libgcc-file-name)`/include/limits.h
#********</pre>**********
#<p>
#
#  Details on this package are located in [Section 8.29.2, “Contents of GCC.”](../chapter08/gcc.html#contents-gcc)
#</p>

cd $topdir
rm -rfv $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt
