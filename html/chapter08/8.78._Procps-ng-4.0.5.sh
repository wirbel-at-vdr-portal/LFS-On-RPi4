#!/usr/bin/bash

# ===== 8.78. Procps-ng-4.0.5 =====
topdir=$(pwd)
err=0
set -e
chapter=8078
err_report() {
    echo "chapter $chapter: $(date +'%Y.%m.%d %H:%M:%S') Error $? on line $1" | tee >> $topdir/log.txt
}
trap 'err_report $LINENO' ERR
echo "---------" >> $topdir/log.txt
echo chapter $chapter: start = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt






srcdir=../../src/procps-ng-4.0.5
tar xf ../../src/procps-ng-4.0.5.tar.xz -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir

#<p>
#
#  The Procps-ng package contains programs for monitoring processes. 
#</p>

#  Approximate build time: 0.1 SBU
#  Required disk space: 28 MB
# ==== 8.78.1. Installation of Procps-ng ====
#<p>
#
#  Prepare Procps-ng for compilation: 
#</p>

#********<pre>***********
./configure --prefix=/usr                           \
            --docdir=/usr/share/doc/procps-ng-4.0.5 \
            --disable-static                        \
            --disable-kill                          \
            --enable-watch8bit
#********</pre>**********
#<p>
#
#  The meaning of the configure option: 
#</p>

#--disable-kill 
##<p>
#
#  This switch disables building the kill
#  command; it will be installed from the Util-linux package. 
#</p>

#--enable-watch8bit 
##<p>
#
#  This switch enables the ncursesw support for the watch
#  command, so it can handle 8-bit characters. 
#</p>
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
chown -R tester .
su tester -c "PATH=$PATH #make check"
#********</pre>**********
#<p>
#
#  One test named ps with output flag bsdtime,cputime,etime,etimes 
#  is known to fail if the host kernel is not built with CONFIG_BSD_PROCESS_ACCT 
#  enabled. In addition, one pgrep test may fail in the chroot environment. 
#</p>
#<p>
#
#  Install the package: 
#</p>

#********<pre>***********
make install
#********</pre>**********

# ==== 8.78.2. Contents of Procps-ng ====

#  Installed programs: free, pgrep, pidof, pkill, pmap, ps, pwdx, slabtop, sysctl, tload, top, uptime, vmstat, w, and watch
#  Installed library: libproc-2.so
#  Installed directories: /usr/include/procps and /usr/share/doc/procps-ng-4.0.5
# ====== Short Descriptions ======

#--------------------------------------------
# | free                                     | Reports the amount of free and used memory (both physical and swap memory) in the system
# | pgrep                                    | Looks up processes based on their name and other attributes
# | pidof                                    | Reports the PIDs of the given programs  
# | pkill                                    | Signals processes based on their name and other attributes
# | pmap                                     | Reports the memory map of the given process
# | ps                                       | Lists the current running processes     
# | pwdx                                     | Reports the current working directory of a process
# | slabtop                                  | Displays detailed kernel slab cache information in real time
# | sysctl                                   | Modifies kernel parameters at run time  
# | tload                                    | Prints a graph of the current system load average
# | top                                      | Displays a list of the most CPU intensive processes; it provides an ongoing look at processor activity in real time
# | uptime                                   | Reports how long the system has been running, how many users are logged on, and the system load averages
# | vmstat                                   | Reports virtual memory statistics, giving information about processes, memory, paging, block Input/Output (IO), traps, and CPU activity
# | w                                        | Shows which users are currently logged on, where, and since when
# | watch                                    | Runs a given command repeatedly, displaying the first screen-full of its output; this allows a user to watch the output change over time
# | libproc-2                                | Contains the functions used by most programs in this package
#--------------------------------------------
cd $topdir
rm -rf $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt
