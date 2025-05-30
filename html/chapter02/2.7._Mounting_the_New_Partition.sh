#!/usr/bin/bash

# ===== 2.7. Mounting the New Partition =====
topdir=$(pwd)
err=0
if [ "$EUID" -ne "0" ]; then
  echo "ERROR: Please run as root";stop
  exit 1
fi

if [[ -z "${LFS}" ]]; then
  echo "ERROR: 'LFS' is not set.";stop
  exit 1
fi

#<p>
#
#  Now that a file system has been created, the partition must be mounted so the 
# host system can access it. This book assumes that the file system is mounted at 
# the directory specified by the LFS 
#  environment variable described in the previous section. 
#</p>
#<p>
#
#  Strictly speaking, one cannot “mount a partition.”
#  One mounts the file system
#  embedded in that partition. But since a single partition can't contain more 
# than one file system, people often speak of the partition and the associated 
# file system as if they were one and the same. 
#</p>
#<p>
#
#  Create the mount point and mount the LFS file system with these commands: 
#</p>

#********<pre>***********
mkdir -pv $LFS
mount -v -t ext4 /dev/<xxx> $LFS
#********</pre>**********
#<p>
#
#  Replace <xxx> 
#  with the name of the LFS partition. 
#</p>
#<p>
#
#  If you are using multiple partitions for LFS (e.g., one for / 
#  and another for /home 
#  ), mount them like this: 
#</p>

#********<pre>***********
mkdir -pv $LFS
mount -v -t ext4 /dev/<xxx> $LFS
mkdir -v $LFS/home
mount -v -t ext4 /dev/<yyy> $LFS/home
#********</pre>**********
#<p>
#
#  Replace <xxx> 
#  and <yyy> 
#  with the appropriate partition names. 
#</p>
#<p>
#
#  Set the owner and permission mode of the $LFS 
#  directory (i.e. the root directory in the newly created file system for the 
# LFS system) to root 
#  and 755 
#  in case the host distro has been configured to use a different default for mkfs
#  : 
#</p>

#********<pre>***********
chown root:root $LFS
chmod 755 $LFS
#********</pre>**********
#<p>
#
#  Ensure that this new partition is not mounted with permissions that are too 
# restrictive (such as the nosuid 
#  or nodev 
#  options). Run the mount
#  command without any parameters to see what options are set for the mounted LFS 
# partition. If nosuid 
#  and/or nodev 
#  are set, the partition must be remounted. 
#</p>

# ====== Warning ======
#<p>
#
#  The above instructions assume that you will not restart your computer 
# throughout the LFS process. If you shut down your system, you will either need 
# to remount the LFS partition each time you restart the build process, or modify 
# the host system's /etc/fstab 
#  file to automatically remount it when you reboot. For example, you might add 
# this line to your /etc/fstab 
#  file: 
#</p>

#********<pre>***********
#/dev/#<xxx>#  /mnt/lfs ext4   defaults      1     1
#********</pre>**********
#<p>
#
#  If you use additional optional partitions, be sure to add them also. 
#</p>
#<p>
#
#  If you are using a swap 
#  partition, ensure that it is enabled using the swapon
#  command: 
#</p>

#********<pre>***********
/sbin/swapon -v /dev/<zzz>
#********</pre>**********
#<p>
#
#  Replace <zzz> 
#  with the name of the swap 
#  partition. 
#</p>
#<p>
#
#  Now that the new LFS partition is open for business, it's time to download the 
# packages. 
#</p>
