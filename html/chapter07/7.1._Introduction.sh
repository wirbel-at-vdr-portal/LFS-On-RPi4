#!/usr/bin/bash

# ===== 7.1. Introduction =====
topdir=$(pwd)
err=0
set -e
chapter=7001
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

#<p>
#
#  This chapter shows how to build the last missing bits of the temporary system: 
# the tools needed to build the various packages. Now that all circular 
# dependencies have been resolved, a “chroot”
#  environment, completely isolated from the host operating system (except for 
# the running kernel), can be used for the build. 
#</p>
#<p>
#
#  For proper operation of the isolated environment, some communication with the 
# running kernel must be established. This is done via the so-called Virtual Kernel File Systems
#  , which will be mounted before entering the chroot environment. You may want 
# to verify that they are mounted by issuing the findmnt
#  command. 
#</p>
#<p>
#
#  Until [Section 7.4, “Entering the Chroot Environment”](chroot.html)
#  , the commands must be run as root 
#  , with the LFS 
#  variable set. After entering chroot, all commands are run as root 
#  , fortunately without access to the OS of the computer you built LFS on. Be 
# careful anyway, as it is easy to destroy the whole LFS system with bad 
# commands. 
#</p>
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt
