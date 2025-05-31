#!/usr/bin/bash

# ===== 8.1. Introduction =====
topdir=$(pwd)
err=0
set -e
chapter=8001
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



#<p>
#
#  In this chapter, we start constructing the LFS system in earnest. 
#</p>
#<p>
#
#  The installation of this software is straightforward. Although in many cases 
# the installation instructions could be made shorter and more generic, we have 
# opted to provide the full instructions for every package to minimize the 
# possibilities for mistakes. The key to learning what makes a Linux system work 
# is to know what each package is used for and why you (or the system) may need 
# it. 
#</p>
#<p>
#
#  We do not recommend using customized optimizations. They can make a program 
# run slightly faster, but they may also cause compilation difficulties, and 
# problems when running the program. If a package refuses to compile with a 
# customized optimization, try to compile it without optimization and see if that 
# fixes the problem. Even if the package does compile when using a customized 
# optimization, there is the risk it may have been compiled incorrectly because 
# of the complex interactions between the code and the build tools. Also note 
# that the -march 
#  and -mtune 
#  options using values not specified in the book have not been tested. This may 
# cause problems with the toolchain packages (Binutils, GCC and Glibc). The small 
# potential gains achieved by customizing compiler optimizations are often 
# outweighed by the risks. First-time builders of LFS are encouraged to build 
# without custom optimizations. 
#</p>
#<p>
#
#  On the other hand, we keep the optimizations enabled by the default 
# configuration of the packages. In addition, we sometimes explicitly enable an 
# optimized configuration provided by a package but not enabled by default. The 
# package maintainers have already tested these configurations and consider them 
# safe, so it's not likely they would break the build. Generally the default 
# configuration already enables -O2 
#  or -O3 
#  , so the resulting system will still run very fast without any customized 
# optimization, and be stable at the same time. 
#</p>
#<p>
#
#  Before the installation instructions, each installation page provides 
# information about the package, including a concise description of what it 
# contains, approximately how long it will take to build, and how much disk space 
# is required during this building process. Following the installation 
# instructions, there is a list of programs and libraries (along with brief 
# descriptions) that the package installs. 
#</p>

# ====== Note ======
#<p>
#
#  The SBU values and required disk space include test suite data for all 
# applicable packages in [Chapter 8](chapter08.html)
#  . SBU values have been calculated using four CPU cores (-j4) for all 
# operations unless specified otherwise. 
#</p>

# ==== 8.1.1. About Libraries ====
#<p>
#
#  In general, the LFS editors discourage building and installing static 
# libraries. Most static libraries have been made obsolete in a modern Linux 
# system. In addition, linking a static library into a program can be 
# detrimental. If an update to the library is needed to remove a security 
# problem, every program that uses the static library will need to be relinked 
# with the new library. Since the use of static libraries is not always obvious, 
# the relevant programs (and the procedures needed to do the linking) may not 
# even be known. 
#</p>
#<p>
#
#  The procedures in this chapter remove or disable installation of most static 
# libraries. Usually this is done by passing a --disable-static 
#  option to configure
#  . In other cases, alternate means are needed. In a few cases, especially Glibc 
# and GCC, the use of static libraries remains an essential feature of the 
# package building process. 
#</p>
#<p>
#
#  For a more complete discussion of libraries, see [Libraries: Static or shared?](https://www.linuxfromscratch.org/blfs/view/svn/introduction/libraries.html)
#  in the BLFS book. 
#</p>
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt
