#!/usr/bin/bash

# ===== 6.1. Introduction =====
topdir=$(pwd)
err=0
set -e
chapter=6001
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
#  This chapter shows how to cross-compile basic utilities using the just built 
# cross-toolchain. Those utilities are installed into their final location, but 
# cannot be used yet. Basic tasks still rely on the host's tools. Nevertheless, 
# the installed libraries are used when linking. 
#</p>
#<p>
#
#  Using the utilities will be possible in the next chapter after entering the “chroot”
#  environment. But all the packages built in the present chapter need to be 
# built before we do that. Therefore we cannot be independent of the host system 
# yet. 
#</p>
#<p>
#
#  Once again, let us recall that improper setting of LFS 
#  together with building as root 
#  , may render your computer unusable. This whole chapter must be done as user lfs 
#  , with the environment as described in [Section 4.4, “Setting Up the Environment.”](../chapter04/settingenvironment.html)
#</p>
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt
