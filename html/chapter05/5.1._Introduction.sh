#!/usr/bin/bash

# ===== 5.1. Introduction =====
topdir=$(pwd)
err=0
set -e
chapter=5001
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

#<p>
#
#  This chapter shows how to build a cross-compiler and its associated tools. 
# Although here cross-compilation is faked, the principles are the same as for a 
# real cross-toolchain. 
#</p>
#<p>
#
#  The programs compiled in this chapter will be installed under the $LFS/tools 
#  directory to keep them separate from the files installed in the following 
# chapters. The libraries, on the other hand, are installed into their final 
# place, since they pertain to the system we want to build. 
#</p>
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt
