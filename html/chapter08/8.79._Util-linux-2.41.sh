#!/usr/bin/bash

# ===== 8.79. Util-linux-2.41 =====
topdir=$(pwd)
err=0
set -e
chapter=8079
err_report() {
    echo "chapter $chapter: $(date +'%Y.%m.%d %H:%M:%S') Error $? on line $1" | tee >> $topdir/log.txt
}
trap 'err_report $LINENO' ERR
echo "---------" >> $topdir/log.txt
echo chapter $chapter: start = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt






srcdir=../../src/util-linux-2.41
tar xf ../../src/util-linux-2.41.tar.xz -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir

#<p>
#
#  The Util-linux package contains miscellaneous utility programs. Among them are 
# utilities for handling file systems, consoles, partitions, and messages. 
#</p>

#  Approximate build time: 0.5 SBU
#  Required disk space: 316 MB
# ==== 8.79.1. Installation of Util-linux ====
#<p>
#
#  Prepare Util-linux for compilation: 
#</p>

#********<pre>***********
./configure --bindir=/usr/bin     \
            --libdir=/usr/lib     \
            --runstatedir=/run    \
            --sbindir=/usr/sbin   \
            --disable-chfn-chsh   \
            --disable-login       \
            --disable-nologin     \
            --disable-su          \
            --disable-setpriv     \
            --disable-runuser     \
            --disable-pylibmount  \
            --disable-liblastlog2 \
            --disable-static      \
            --without-python      \
            --without-systemd     \
            --without-systemdsystemunitdir        \
            ADJTIME_PATH=/var/lib/hwclock/adjtime \
            --docdir=/usr/share/doc/util-linux-2.41
#********</pre>**********
#<p>
#
#  The --disable and --without options prevent warnings about building components 
# that either require packages not in LFS, or are inconsistent with programs 
# installed by other packages. 
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
#  If desired, create a dummy /etc/fstab 
#  file to satisfy two tests and run the test suite as a non- root 
#  user: 
#</p>

# ====== Warning ======
#<p>
#
#  Running the test suite as the root 
#  user can be harmful to your system. To run it, the CONFIG_SCSI_DEBUG option 
# for the kernel must be available in the currently running system and must be 
# built as a module. Building it into the kernel will prevent booting. For 
# complete coverage, other BLFS packages must be installed. If desired, this test 
# can be run by booting into the completed LFS system and running: 
#</p>

#********<pre>***********
#bash tests/run.sh --srcdir=$PWD --builddir=$PWD
#********</pre>**********

#********<pre>***********
#touch /etc/fstab
#chown -R tester .
#su tester -c "make -k check"
#********</pre>**********
#<p>
#
#  The hardlink
#  tests will fail if the host's kernel does not have the option CONFIG_CRYPTO_USER_API_HASH 
#  enabled or does not have any options providing a SHA256 implementation (for 
# example, CONFIG_CRYPTO_SHA256 
#  , or CONFIG_CRYPTO_SHA256_SSSE3 
#  if the CPU supports Supplemental SSE3) enabled. In addition, the lsfd: inotify 
# test will fail if the kernel option CONFIG_NETLINK_DIAG 
#  is not enabled. 
#</p>
#<p>
#
#  Two other tests, lsfd: SOURCE column and utmp: last, are known to fail in the 
# chroot environment. 
#</p>
#<p>
#
#  Install the package: 
#</p>

#********<pre>***********
make install
#********</pre>**********

# ==== 8.79.2. Contents of Util-linux ====

#  Installed programs: addpart, agetty, blkdiscard, blkid, blkzone, blockdev, cal, cfdisk, chcpu, chmem, choom, chrt, col, colcrt, colrm, column, ctrlaltdel, delpart, dmesg, eject, fallocate, fdisk, fincore, findfs, findmnt, flock, fsck, fsck.cramfs, fsck.minix, fsfreeze, fstrim, getopt, hardlink, hexdump, hwclock, i386 (link to setarch), ionice, ipcmk, ipcrm, ipcs, irqtop, isosize, kill, last, lastb (link to last), ldattach, linux32 (link to setarch), linux64 (link to setarch), logger, look, losetup, lsblk, lscpu, lsipc, lsirq, lsfd, lslocks, lslogins, lsmem, lsns, mcookie, mesg, mkfs, mkfs.bfs, mkfs.cramfs, mkfs.minix, mkswap, more, mount, mountpoint, namei, nsenter, partx, pivot_root, prlimit, readprofile, rename, renice, resizepart, rev, rfkill, rtcwake, script, scriptlive, scriptreplay, setarch, setsid, setterm, sfdisk, sulogin, swaplabel, swapoff, swapon, switch_root, taskset, uclampset, ul, umount, uname26 (link to setarch), unshare, utmpdump, uuidd, uuidgen, uuidparse, wall, wdctl, whereis, wipefs, x86_64 (link to setarch), and zramctl
#  Installed libraries: libblkid.so, libfdisk.so, libmount.so, libsmartcols.so, and libuuid.so
#  Installed directories: /usr/include/blkid, /usr/include/libfdisk, /usr/include/libmount, /usr/include/libsmartcols, /usr/include/uuid, /usr/share/doc/util-linux-2.41, and /var/lib/hwclock
# ====== Short Descriptions ======

#--------------------------------------------
# | addpart                                  | Informs the Linux kernel of new partitions
# | agetty                                   | Opens a tty port, prompts for a login name, and then invokes thelogin                                   program                                 
# | blkdiscard                               | Discards sectors on a device            
# | blkid                                    | A command line utility to locate and print block device attributes
# | blkzone                                  | Is used to manage zoned storage block devices
# | blockdev                                 | Allows users to call block device ioctls from the command line
# | cal                                      | Displays a simple calendar              
# | cfdisk                                   | Manipulates the partition table of the given device
# | chcpu                                    | Modifies the state of CPUs              
# | chmem                                    | Configures memory                       
# | choom                                    | Displays and adjusts OOM-killer scores, used to determine which process to kill first when Linux is Out Of Memory
# | chrt                                     | Manipulates real-time attributes of a process
# | col                                      | Filters out reverse line feeds          
# | colcrt                                   | Filters                                 nroff                                   output for terminals that lack some capabilities, such as overstriking and half-lines
# | colrm                                    | Filters out the given columns           
# | column                                   | Formats a given file into multiple columns
# | ctrlaltdel                               | Sets the function of the Ctrl+Alt+Del key combination to a hard or a soft reset
# | delpart                                  | Asks the Linux kernel to remove a partition
# | dmesg                                    | Dumps the kernel boot messages          
# | eject                                    | Ejects removable media                  
# | fallocate                                | Preallocates space to a file            
# | fdisk                                    | Manipulates the partition table of the given device
# | fincore                                  | Counts pages of file contents in core   
# | findfs                                   | Finds a file system, either by label or Universally Unique Identifier (UUID)
# | findmnt                                  | Is a command line interface to the libmount library for working with mountinfo, fstab and mtab files
# | flock                                    | Acquires a file lock and then executes a command with the lock held
# | fsck                                     | Is used to check, and optionally repair, file systems
# | fsck.cramfs                              | Performs a consistency check on the Cramfs file system on the given device
# | fsck.minix                               | Performs a consistency check on the Minix file system on the given device
# | fsfreeze                                 | Is a very simple wrapper around FIFREEZE/FITHAW ioctl kernel driver operations
# | fstrim                                   | Discards unused blocks on a mounted filesystem
# | getopt                                   | Parses options in the given command line
# | hardlink                                 | Consolidates duplicate files by creating hard links
# | hexdump                                  | Dumps the given file in hexadecimal, decimal, octal, or ascii
# | hwclock                                  | Reads or sets the system's hardware clock, also called the Real-Time Clock (RTC) or Basic Input-Output System (BIOS) clock
# | i386                                     | A symbolic link to setarch              
# | ionice                                   | Gets or sets the io scheduling class and priority for a program
# | ipcmk                                    | Creates various IPC resources           
# | ipcrm                                    | Removes the given Inter-Process Communication (IPC) resource
# | ipcs                                     | Provides IPC status information         
# | irqtop                                   | Displays kernel interrupt counter information in[top(1)](https://man.archlinux.org/man/top.1)style view                              
# | isosize                                  | Reports the size of an iso9660 file system
# | kill                                     | Sends signals to processes              
# | last                                     | Shows which users last logged in (and out), searching back through the/var/log/wtmp                           file; it also shows system boots, shutdowns, and run-level changes
# | lastb                                    | Shows the failed login attempts, as logged in/var/log/btmp                           
# | ldattach                                 | Attaches a line discipline to a serial line
# | linux32                                  | A symbolic link to setarch              
# | linux64                                  | A symbolic link to setarch              
# | logger                                   | Enters the given message into the system log
# | look                                     | Displays lines that begin with the given string
# | losetup                                  | Sets up and controls loop devices       
# | lsblk                                    | Lists information about all or selected block devices in a tree-like format
# | lscpu                                    | Prints CPU architecture information     
# | lsfd                                     | Displays information about open files; replaceslsof                                    
# | lsipc                                    | Prints information on IPC facilities currently employed in the system
# | lsirq                                    | Displays kernel interrupt counter information
# | lslocks                                  | Lists local system locks                
# | lslogins                                 | Lists information about users, groups and system accounts
# | lsmem                                    | Lists the ranges of available memory with their online status
# | lsns                                     | Lists namespaces                        
# | mcookie                                  | Generates magic cookies (128-bit random hexadecimal numbers) forxauth                                   
# | mesg                                     | Controls whether other users can send messages to the current user's terminal
# | mkfs                                     | Builds a file system on a device (usually a hard disk partition)
# | mkfs.bfs                                 | Creates a Santa Cruz Operations (SCO) bfs file system
# | mkfs.cramfs                              | Creates a cramfs file system            
# | mkfs.minix                               | Creates a Minix file system             
# | mkswap                                   | Initializes the given device or file to be used as a swap area
# | more                                     | A filter for paging through text one screen at a time
# | mount                                    | Attaches the file system on the given device to a specified directory in the file-system tree
# | mountpoint                               | Checks if the directory is a mountpoint 
# | namei                                    | Shows the symbolic links in the given paths
# | nsenter                                  | Runs a program with namespaces of other processes
# | partx                                    | Tells the kernel about the presence and numbering of on-disk partitions
# | pivot_root                               | Makes the given file system the new root file system of the current process
# | prlimit                                  | Gets and sets a process's resource limits
# | readprofile                              | Reads kernel profiling information      
# | rename                                   | Renames the given files, replacing a given string with another
# | renice                                   | Alters the priority of running processes
# | resizepart                               | Asks the Linux kernel to resize a partition
# | rev                                      | Reverses the lines of a given file      
# | rfkill                                   | Tool for enabling and disabling wireless devices
# | rtcwake                                  | Used to enter a system sleep state until the specified wakeup time
# | script                                   | Makes a typescript of a terminal session
# | scriptlive                               | Re-runs session typescripts using timing information
# | scriptreplay                             | Plays back typescripts using timing information
# | setarch                                  | Changes reported architecture in a new program environment, and sets personality flags
# | setsid                                   | Runs the given program in a new session 
# | setterm                                  | Sets terminal attributes                
# | sfdisk                                   | A disk partition table manipulator      
# | sulogin                                  | Allows                                  root                                    to log in; it is normally invoked by    init                                    when the system goes into single user mode
# | swaplabel                                | Makes changes to the swap area's UUID and label
# | swapoff                                  | Disables devices and files for paging and swapping
# | swapon                                   | Enables devices and files for paging and swapping, and lists the devices and files currently in use
# | switch_root                              | Switches to another filesystem as the root of the mount tree
# | taskset                                  | Retrieves or sets a process's CPU affinity
# | uclampset                                | Manipulates the utilization clamping attributes of the system or a process
# | ul                                       | A filter for translating underscores into escape sequences indicating underlining for the terminal in use
# | umount                                   | Disconnects a file system from the system's file tree
# | uname26                                  | A symbolic link to setarch              
# | unshare                                  | Runs a program with some namespaces unshared from parent
# | utmpdump                                 | Displays the content of the given login file in a user-friendly format
# | uuidd                                    | A daemon used by the UUID library to generate time-based UUIDs in a secure and guaranteed-unique fashion
# | uuidgen                                  | Creates new UUIDs. Each new UUID is a random number likely to be unique among all UUIDs created, on the local system and on other systems, in the past and in the future, with extremely high probability (2^128                                     UUIDs are possible)                     
# | uuidparse                                | A utility to parse unique identifiers   
# | wall                                     | Displays the contents of a file or, by default, its standard input, on the terminals of all currently logged in users
# | wdctl                                    | Shows hardware watchdog status          
# | whereis                                  | Reports the location of the binary, source, and man page files for the given command
# | wipefs                                   | Wipes a filesystem signature from a device
# | x86_64                                   | A symbolic link to setarch              
# | zramctl                                  | A program to set up and control zram (compressed ram disk) devices
# | libblkid                                 | Contains routines for device identification and token extraction
# | libfdisk                                 | Contains routines for manipulating partition tables
# | libmount                                 | Contains routines for block device mounting and unmounting
# | libsmartcols                             | Contains routines for aiding screen output in tabular form
# | libuuid                                  | Contains routines for generating unique identifiers for objects that may be accessible beyond the local system
#--------------------------------------------
cd $topdir
rm -rf $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt
