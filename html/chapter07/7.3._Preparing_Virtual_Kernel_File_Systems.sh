#!/usr/bin/bash

# ===== 7.3. Preparing Virtual Kernel File Systems =====
topdir=$(pwd)
err=0
set -e
chapter=7003
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

if [ "$EUID" -ne "0" ]; then
  echo "ERROR: Please run as root, not as user id = $EUID";stop
  exit 1
fi

#<p>
#
#  Applications running in userspace utilize various file systems created by the 
# kernel to communicate with the kernel itself. These file systems are virtual: 
# no disk space is used for them. The content of these file systems resides in 
# memory. These file systems must be mounted in the $LFS directory tree so the 
# applications can find them in the chroot environment. 
#</p>
#<p>
#
#  Begin by creating the directories on which these virtual file systems will be 
# mounted: 
#</p>

#********<pre>***********
mkdir -pv $LFS/{dev,proc,sys,run}
#********</pre>**********

# ==== 7.3.1. Mounting and Populating /dev ====
#<p>
#
#  During a normal boot of an LFS system, the kernel automatically mounts the devtmpfs 
#  file system on the /dev 
#  directory; the kernel creates device nodes on that virtual file system during 
# the boot process, or when a device is first detected or accessed. The udev 
# daemon may change the ownership or permissions of the device nodes created by 
# the kernel, and create new device nodes or symlinks, to ease the work of distro 
# maintainers and system administrators. (See [Section 9.3.2.2, “Device Node Creation”](../chapter09/udev.html#ch-config-udev-device-node-creation)
#  for details.) If the host kernel supports devtmpfs 
#  , we can simply mount a devtmpfs 
#  at $LFS/dev 
#  and rely on the kernel to populate it. 
#</p>
#<p>
#
#  But some host kernels lack devtmpfs 
#  support; these host distros use different methods to create the content of /dev 
#  . So the only host-agnostic way to populate the $LFS/dev 
#  directory is by bind mounting the host system's /dev 
#  directory. A bind mount is a special type of mount that makes a directory 
# subtree or a file visible at some other location. Use the following command to 
# do this. 
#</p>

#********<pre>***********
mount -v --bind /dev $LFS/dev
#********</pre>**********

# ==== 7.3.2. Mounting Virtual Kernel File Systems ====
#<p>
#
#  Now mount the remaining virtual kernel file systems: 
#</p>

#********<pre>***********
mount -vt devpts devpts -o gid=5,mode=0620 $LFS/dev/pts
mount -vt proc proc $LFS/proc
mount -vt sysfs sysfs $LFS/sys
mount -vt tmpfs tmpfs $LFS/run
#********</pre>**********
#<p>
#
#  The meaning of the mount options for devpts: 
#</p>

#gid=5 
##<p>
#
#  This ensures that all devpts-created device nodes are owned by group ID 5. 
# This is the ID we will use later on for the tty 
#  group. We use the group ID instead of a name, since the host system might use 
# a different ID for its tty 
#  group. 
#</p>

#mode=0620 
##<p>
#
#  This ensures that all devpts-created device nodes have mode 0620 (user 
# readable and writable, group writable). Together with the option above, this 
# ensures that devpts will create device nodes that meet the requirements of 
# grantpt(), meaning the Glibc pt_chown
#  helper binary (which is not installed by default) is not necessary. 
#</p>
#<p>
#
#  In some host systems, /dev/shm 
#  is a symbolic link to a directory, typically /run/shm 
#  . The /run tmpfs was mounted above so in this case only a directory needs to 
# be created with the correct permissions. 
#</p>
#<p>
#
#  In other host systems /dev/shm 
#  is a mount point for a tmpfs. In that case the mount of /dev above will only 
# create /dev/shm as a directory in the chroot environment. In this situation we 
# must explicitly mount a tmpfs: 
#</p>

#********<pre>***********
if [ -h $LFS/dev/shm ]; then
  install -v -d -m 1777 $LFS$(realpath /dev/shm)
else
  mount -vt tmpfs -o nosuid,nodev tmpfs $LFS/dev/shm
fi
#********</pre>**********
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt
