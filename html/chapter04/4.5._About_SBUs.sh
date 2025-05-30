#!/usr/bin/bash

# ===== 4.5. About SBUs =====
topdir=$(pwd)
err=0
set -e
chapter=4005
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

if [[ -z "${LFS_TGT}" ]]; then
  echo "ERROR: 'LFS_TGT' is not set.";stop
  exit 1
fi

if [[ -z "${CONFIG_SITE}" ]]; then
  echo "ERROR: 'CONFIG_SITE' is not set.";stop
  exit 1
fi

#<p>
#
#  Many people would like to know beforehand approximately how long it takes to 
# compile and install each package. Because Linux From Scratch can be built on 
# many different systems, it is impossible to provide absolute time estimates. 
# The biggest package (gcc) will take approximately 5 minutes on the fastest 
# systems, but could take days on slower systems! Instead of providing actual 
# times, the Standard Build Unit (SBU) measure will be used instead. 
#</p>
#<p>
#
#  The SBU measure works as follows. The first package to be compiled is binutils 
# in [Chapter 5](../chapter05/chapter05.html)
#  . The time it takes to compile using one core is what we will refer to as the 
# Standard Build Unit or SBU. All other compile times will be expressed in terms 
# of this unit of time. 
#</p>
#<p>
#
#  For example, consider a package whose compilation time is 4.5 SBUs. This means 
# that if your system took 4 minutes to compile and install the first pass of 
# binutils, it will take approximately
#  18 minutes to build the example package. Fortunately, most build times are 
# shorter than one SBU. 
#</p>
#<p>
#
#  SBUs are not entirely accurate because they depend on many factors, including 
# the host system's version of GCC. They are provided here to give an estimate of 
# how long it might take to install a package, but the numbers can vary by as 
# much as dozens of minutes in some cases. 
#</p>
#<p>
#
#  On some newer systems, the motherboard is capable of controlling the system 
# clock speed. This can be controlled with a command such as powerprofilesctl
#  . This is not available in LFS, but may be available on the host distro. After 
# LFS is complete, it can be added to a system with the procedures at the [BLFS power-profiles-daemon](https://www.linuxfromscratch.org/blfs/view/svn/sysutils/power-profiles-daemon.html)
#  page. Before measuring the build time of any package it is advisable to use a 
# system power profile set for maximum performance (and maximum power 
# consumption). Otherwise the measured SBU value may be inaccurate because the 
# system may react differently when building [binutils-pass1](../chapter05/binutils-pass1.html)
#  or other packages. Be aware that a significant inaccuracy can still show up 
# even if the same profile is used for both packages because the system may 
# respond slower if the system is idle when starting the build procedure. Setting 
# the power profile to “performance”
#  will minimize this problem. And obviously doing so will also make the system 
# build LFS faster. 
#</p>
#<p>
#
#  If powerprofilesctl
#  is available, issue the powerprofilesctl set performance
#  command to select the performance 
#  profile. Some distros provides the tuned-adm
#  command for managing the profiles instead of powerprofilesctl
#  , on these distros issue the tuned-adm profile throughput-performance
#  command to select the throughput-performance 
#  profile. 
#</p>

# ====== Note ======
#<p>
#
#  When multiple processors are used in this way, the SBU units in the book will 
# vary even more than they normally would. In some cases, the make step will 
# simply fail. Analyzing the output of the build process will also be more 
# difficult because the lines from different processes will be interleaved. If 
# you run into a problem with a build step, revert to a single processor build to 
# properly analyze the error messages. 
#</p>
#<p>
#
#  The times presented here for all packages (except [binutils-pass1](../chapter05/binutils-pass1.html)
#  which is based on one core) are based upon using four cores (-j4). The times 
# in Chapter 8 also include the time to run the regression tests for the package 
# unless specified otherwise. 
#</p>
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt
