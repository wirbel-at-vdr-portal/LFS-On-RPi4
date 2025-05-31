#!/usr/bin/bash

# ===== 8.4. Iana-Etc-20250407 =====
topdir=$(pwd)
err=0
set -e
chapter=8004
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



srcdir=../../src/iana-etc-20250407
tar xf ../../src/iana-etc-20250407.tar.gz -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir

#<p>
#
#  The Iana-Etc package provides data for network services and protocols. 
#</p>

#  Approximate build time: less than 0.1 SBU
#  Required disk space: 4.8 MB
# ==== 8.4.1. Installation of Iana-Etc ====
#<p>
#
#  For this package, we only need to copy the files into place: 
#</p>

#********<pre>***********
cp services protocols /etc
#********</pre>**********

# ==== 8.4.2. Contents of Iana-Etc ====

#  Installed files: /etc/protocols and /etc/services
# ====== Short Descriptions ======

#--------------------------------------------
# | /etc/protocols                           | Describes the various DARPA Internet protocols that are available from the TCP/IP subsystem
# | /etc/services                            | Provides a mapping between friendly textual names for internet services, and their underlying assigned port numbers and protocol types
#--------------------------------------------
cd $topdir
rm -rfv $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt
