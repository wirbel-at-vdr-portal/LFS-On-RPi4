#!/usr/bin/bash

# ===== 9.2. LFS-Bootscripts-20240825 =====
topdir=$(pwd)
err=0
set -e
chapter=9002
err_report() {
    echo "chapter $chapter: $(date +'%Y.%m.%d %H:%M:%S') Error $? on line $1" | tee >> $topdir/log.txt
}
trap 'err_report $LINENO' ERR
echo "---------" >> $topdir/log.txt
echo chapter $chapter: start = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt




srcdir=../../src/lfs-bootscripts-20240825
tar xf ../../src/lfs-bootscripts-20240825.tar.xz -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir

#<p>
#
#  The LFS-Bootscripts package contains a set of scripts to start/stop the LFS 
# system at bootup/shutdown. The configuration files and procedures needed to 
# customize the boot process are described in the following sections. 
#</p>

#  Approximate build time: less than 0.1 SBU
#  Required disk space: 248 KB
# ==== 9.2.1. Installation of LFS-Bootscripts ====
#<p>
#
#  Install the package: 
#</p>

#********<pre>***********
make install
#********</pre>**********

# ==== 9.2.2. Contents of LFS-Bootscripts ====

#  Installed scripts: checkfs, cleanfs, console, functions, halt, ifdown, ifup, localnet, modules, mountfs, mountvirtfs, network, rc, reboot, sendsignals, setclock, ipv4-static, swap, sysctl, sysklogd, template, udev, and udev_retry
#  Installed directories: /etc/rc.d, /etc/init.d (symbolic link), /etc/sysconfig, /lib/services, /lib/lsb (symbolic link)
# ====== Short Descriptions ======

#--------------------------------------------
# | checkfs                                  | Checks the integrity of the file systems before they are mounted (with the exception of journaling and network-based file systems)
# | cleanfs                                  | Removes files that should not be preserved between reboots, such as those in/run/                                   and                                     /var/lock/                              ; it re-creates                         /run/utmp                               and removes the possibly present        /etc/nologin                            ,                                       /fastboot                               , and                                   /forcefsck                              files                                   
# | console                                  | Loads the correct keymap table for the desired keyboard layout; it also sets the screen font
# | functions                                | Contains common functions, such as error and status checking, that are used by several bootscripts
# | halt                                     | Halts the system                        
# | ifdown                                   | Stops a network device                  
# | ifup                                     | Initializes a network device            
# | localnet                                 | Sets up the system's hostname and local loopback device
# | modules                                  | Loads kernel modules listed in          /etc/sysconfig/modules                  , using arguments that are also given there
# | mountfs                                  | Mounts all file systems, except those that are markednoauto                                  , or are network based                  
# | mountvirtfs                              | Mounts virtual kernel file systems, such asproc                                    
# | network                                  | Sets up network interfaces, such as network cards, and sets up the default gateway (where applicable)
# | rc                                       | The master run-level control script; it is responsible for running all the other bootscripts one-by-one, in a sequence determined by the names of the symbolic links to those other bootscripts
# | reboot                                   | Reboots the system                      
# | sendsignals                              | Makes sure every process is terminated before the system reboots or halts
# | setclock                                 | Resets the system clock to local time if the hardware clock is not set to UTC
# | ipv4-static                              | Provides the functionality needed to assign a static Internet Protocol (IP) address to a network interface
# | swap                                     | Enables and disables swap files and partitions
# | sysctl                                   | Loads system configuration values from  /etc/sysctl.conf                        , if that file exists, into the running kernel
# | sysklogd                                 | Starts and stops the system and kernel log daemons
# | template                                 | A template to create custom bootscripts for other daemons
# | udev                                     | Prepares the                            /dev                                    directory and starts the udev daemon    
# | udev_retry                               | Retries failed udev uevents, and copies generated rules files from/run/udev                               to                                      /etc/udev/rules.d                       if required                             
#--------------------------------------------
cd $topdir
rm -rfv $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt
