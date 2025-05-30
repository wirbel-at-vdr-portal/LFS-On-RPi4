#!/usr/bin/bash

# ===== 4.2. Creating a Limited Directory Layout in the LFS Filesystem =====
topdir=$(pwd)
err=0
set -e
chapter=4002
err_report() {
    echo "chapter $chapter: $(date +'%Y.%m.%d %H:%M:%S') Error $? on line $1" | tee >> $topdir/log.txt
}
trap 'err_report $LINENO' ERR
echo "---------" >> $topdir/log.txt
echo chapter $chapter: start = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt

if [ "$EUID" -ne "0" ]; then
  echo "ERROR: Please run as root";stop
  exit 1
fi

if [[ -z "${LFS}" ]]; then
  echo "ERROR: 'LFS' is not set.";stop
  exit 1
fi

grep -q ${LFS} /proc/mounts || err=1
if [ "$err" -eq "1" ]; then
  echo "ERROR: The '$LFS' partition must be mounted.";stop
  exit 1
fi

#<p>
#
#  In this section, we begin populating the LFS filesystem with the pieces that 
# will constitute the final Linux system. The first step is to create a limited 
# directory hierarchy, so that the programs compiled in [Chapter 6](../chapter06/chapter06.html)
#  (as well as glibc and libstdc++ in [Chapter 5](../chapter05/chapter05.html)
#  ) can be installed in their final location. We do this so those temporary 
# programs will be overwritten when the final versions are built in [Chapter 8](../chapter08/chapter08.html)
#  . 
#</p>
#<p>
#
#  Create the required directory layout by issuing the following commands as root 
#  : 
#</p>

#********<pre>***********
mkdir -pv $LFS/{etc,var} $LFS/usr/{bin,lib,sbin}

for i in bin lib sbin; do
  ln -sv usr/$i $LFS/$i
done

case $(uname -m) in
  x86_64) mkdir -pv $LFS/lib64 ;;
esac
#********</pre>**********
#<p>
#
#  Programs in [Chapter 6](../chapter06/chapter06.html)
#  will be compiled with a cross-compiler (more details can be found in section [Toolchain Technical Notes](../partintro/toolchaintechnotes.html)
#  ). This cross-compiler will be installed in a special directory, to separate 
# it from the other programs. Still acting as root 
#  , create that directory with this command: 
#</p>

#********<pre>***********
mkdir -pv $LFS/tools
#********</pre>**********

# ====== Note ======
#<p>
#
#  The LFS editors have deliberately decided not to use a /usr/lib64 
#  directory. Several steps are taken to be sure the toolchain will not use it. 
# If for any reason this directory appears (either because you made an error in 
# following the instructions, or because you installed a binary package that 
# created it after finishing LFS), it may break your system. You should always be 
# sure this directory does not exist. 
#</p>
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt
