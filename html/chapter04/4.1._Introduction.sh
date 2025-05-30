#!/usr/bin/bash

# ===== 4.1. Introduction =====
topdir=$(pwd)
err=0
set -e
chapter=4001
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
#  In this chapter, we will perform a few additional tasks to prepare for 
# building the temporary system. We will create a set of directories in $LFS 
#  (in which we will install the temporary tools), add an unprivileged user, and 
# create an appropriate build environment for that user. We will also explain the 
# units of time ( “SBUs”
#  ) we use to measure how long it takes to build LFS packages, and provide some 
# information about package test suites. 
#</p>
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt
