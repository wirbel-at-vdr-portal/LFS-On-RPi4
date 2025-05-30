#!/usr/bin/bash

# ===== 2.5. Creating a File System on the Partition =====
topdir=$(pwd)
err=0
if [ "$EUID" -ne "0" ]; then
  echo "ERROR: Please run as root";stop
  exit 1
fi

#<p>
#
#  A partition is just a range of sectors on a disk drive, delimited by 
# boundaries set in a partition table. Before the operating system can use a 
# partition to store any files, the partition must be formatted to contain a file 
# system, typically consisting of a label, directory blocks, data blocks, and an 
# indexing scheme to locate a particular file on demand. The file system also 
# helps the OS keep track of free space on the partition, reserve the needed 
# sectors when a new file is created or an existing file is extended, and recycle 
# the free data segments created when files are deleted. It may also provide 
# support for data redundancy, and for error recovery. 
#</p>
#<p>
#
#  LFS can use any file system recognized by the Linux kernel, but the most 
# common types are ext3 and ext4. The choice of the right file system can be 
# complex; it depends on the characteristics of the files and the size of the 
# partition. For example: 
#</p>

#ext2
##<p>
#
#  is suitable for small partitions that are updated infrequently such as /boot. 
#</p>

#ext3
##<p>
#
#  is an upgrade to ext2 that includes a journal to help recover the partition's 
# status in the case of an unclean shutdown. It is commonly used as a general 
# purpose file system. 
#</p>

#ext4
##<p>
#
#  is the latest version of the ext family of file systems. It provides several 
# new capabilities including nano-second timestamps, creation and use of very 
# large files (up to 16 TB), and speed improvements. 
#</p>
#<p>
#
#  Other file systems, including FAT32, NTFS, JFS, and XFS are useful for 
# specialized purposes. More information about these file systems, and many 
# others, can be found at [https://en.wikipedia.org/wiki/Comparison_of_file_systems](https://en.wikipedia.org/wiki/Comparison_of_file_systems)
#  . 
#</p>
#<p>
#
#  LFS assumes that the root file system (/) is of type ext4. To create an ext4 
#  file system on the LFS partition, issue the following command: 
#</p>

#********<pre>***********
mkfs -v -t ext4 /dev/<xxx>
#********</pre>**********
#<p>
#
#  Replace <xxx> 
#  with the name of the LFS partition. 
#</p>
#<p>
#
#  If you are using an existing swap 
#  partition, there is no need to format it. If a new swap 
#  partition was created, it will need to be initialized with this command: 
#</p>

#********<pre>***********
mkswap /dev/<yyy>
#********</pre>**********
#<p>
#
#  Replace <yyy> 
#  with the name of the swap 
#  partition. 
#</p>
