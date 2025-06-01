#!/usr/bin/bash

# ===== 8.82. SysVinit-3.14 =====
topdir=$(pwd)
err=0
set -e
chapter=8082
err_report() {
    echo "chapter $chapter: $(date +'%Y.%m.%d %H:%M:%S') Error $? on line $1" | tee >> $topdir/log.txt
}
trap 'err_report $LINENO' ERR
echo "---------" >> $topdir/log.txt
echo chapter $chapter: start = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt






srcdir=../../src/sysvinit-3.14
tar xf ../../src/sysvinit-3.14.tar.xz -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir

#<p>
#
#  The SysVinit package contains programs for controlling the startup, running, 
# and shutdown of the system. 
#</p>

#  Approximate build time: less than 0.1 SBU
#  Required disk space: 2.9 MB
# ==== 8.82.1. Installation of SysVinit ====
#<p>
#
#  First, apply a patch that removes several programs installed by other 
# packages, clarifies a message, and fixes a compiler warning: 
#</p>

#********<pre>***********
patch -Np1 -i ../sysvinit-3.14-consolidated-1.patch
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
#  This package does not come with a test suite. 
#</p>
#<p>
#
#  Install the package: 
#</p>

#********<pre>***********
make install
#********</pre>**********

# ==== 8.82.2. Contents of SysVinit ====

#  Installed programs: bootlogd, fstab-decode, halt, init, killall5, poweroff (link to halt), reboot (link to halt), runlevel, shutdown, and telinit (link to init)
# ====== Short Descriptions ======

#--------------------------------------------
# | bootlogd                                 | Logs boot messages to a log file        
# | fstab-decode                             | Runs a command with fstab-encoded arguments
# | halt                                     | Normally invokes                        shutdown                                with the                                -h                                      option, but when already in run-level 0, it tells the kernel to halt the system; it notes in the file/var/log/wtmp                           that the system is going down           
# | init                                     | The first process to be started when the kernel has initialized the hardware; it takes over the boot process and starts all the processes specified in its configuration file
# | killall5                                 | Sends a signal to all processes, except the processes in its own session; it will not kill its parent shell
# | poweroff                                 | Tells the kernel to halt the system and switch off the computer (seehalt                                    )                                       
# | reboot                                   | Tells the kernel to reboot the system (seehalt                                    )                                       
# | runlevel                                 | Reports the previous and the current run-level, as noted in the last run-level record in/run/utmp                               
# | shutdown                                 | Brings the system down in a secure way, signaling all processes and notifying all logged-in users
# | telinit                                  | Tells                                   init                                    which run-level to change to            
#--------------------------------------------
cd $topdir
rm -rf $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt
