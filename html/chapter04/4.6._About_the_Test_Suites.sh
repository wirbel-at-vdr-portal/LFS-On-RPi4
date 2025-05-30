#!/usr/bin/bash

# ===== 4.6. About the Test Suites =====
topdir=$(pwd)
err=0
set -e
chapter=4006
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
#  Most packages provide a test suite. Running the test suite for a newly built 
# package is a good idea because it can provide a “sanity check”
#  indicating that everything compiled correctly. A test suite that passes its 
# set of checks usually proves that the package is functioning as the developer 
# intended. It does not, however, guarantee that the package is totally bug free. 
#</p>
#<p>
#
#  Some test suites are more important than others. For example, the test suites 
# for the core toolchain packages—GCC, binutils, and glibc—are of the utmost 
# importance due to their central role in a properly functioning system. The test 
# suites for GCC and glibc can take a very long time to complete, especially on 
# slower hardware, but are strongly recommended. 
#</p>

# ====== Note ======
#<p>
#
#  Running the test suites in [Chapter 5](../chapter05/chapter05.html)
#  and [Chapter 6](../chapter06/chapter06.html)
#  is pointless; since the test programs are compiled with a cross-compiler, they 
# probably can't run on the build host. 
#</p>
#<p>
#
#  A common issue with running the test suites for binutils and GCC is running 
# out of pseudo terminals (PTYs). This can result in a large number of failing 
# tests. This may happen for several reasons, but the most likely cause is that 
# the host system does not have the devpts 
#  file system set up correctly. This issue is discussed in greater detail at [https://www.linuxfromscratch.org/lfs/faq.html#no-ptys](https://www.linuxfromscratch.org/lfs/faq.html#no-ptys)
#  . 
#</p>
#<p>
#
#  Sometimes package test suites will fail for reasons which the developers are 
# aware of and have deemed non-critical. Consult the logs located at [https://www.linuxfromscratch.org/lfs/build-logs/development/](https://www.linuxfromscratch.org/lfs/build-logs/development/)
#  to verify whether or not these failures are expected. This site is valid for 
# all test suites throughout this book. 
#</p>
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt
