#!/usr/bin/bash

# ===== 8.32. Psmisc-23.7 =====
topdir=$(pwd)
err=0
set -e
chapter=8032
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



srcdir=../../src/psmisc-23.7
tar xf ../../src/psmisc-23.7.tar.xz -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir

#<p>
#
#  The Psmisc package contains programs for displaying information about running 
# processes. 
#</p>

#  Approximate build time: less than 0.1 SBU
#  Required disk space: 6.7 MB
# ==== 8.32.1. Installation of Psmisc ====
#<p>
#
#  Prepare Psmisc for compilation: 
#</p>

#********<pre>***********
./configure --prefix=/usr
#********</pre>**********
#<p>
#
#  Compile the package: 
#</p>

#********<pre>***********
make
#********</pre>**********
#<p>
#
#  To run the test suite, run: 
#</p>

#********<pre>***********
#make check
#********</pre>**********
#<p>
#
#  Install the package: 
#</p>

#********<pre>***********
make install
#********</pre>**********

# ==== 8.32.2. Contents of Psmisc ====

#  Installed programs: fuser, killall, peekfd, prtstat, pslog, pstree, and pstree.x11 (link to pstree)
# ====== Short Descriptions ======

#--------------------------------------------
# | fuser                                    | Reports the Process IDs (PIDs) of processes that use the given files or file systems
# | killall                                  | Kills processes by name; it sends a signal to all processes running any of the given commands
# | peekfd                                   | Peek at file descriptors of a running process, given its PID
# | prtstat                                  | Prints information about a process      
# | pslog                                    | Reports current logs path of a process  
# | pstree                                   | Displays running processes as a tree    
# | pstree.x11                               | Same as                                 pstree                                  , except that it waits for confirmation before exiting
#--------------------------------------------
cd $topdir
rm -rf $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt
