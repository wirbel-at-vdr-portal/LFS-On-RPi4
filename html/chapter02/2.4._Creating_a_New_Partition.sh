#!/usr/bin/bash

# ===== 2.4. Creating a New Partition =====
topdir=$(pwd)
err=0
if [ "$EUID" -ne "0" ]; then
  echo "ERROR: Please run as root";stop
  exit 1
fi

#<p>
#
#  Like most other operating systems, LFS is usually installed on a dedicated 
# partition. The recommended approach to building an LFS system is to use an 
# available empty partition or, if you have enough unpartitioned space, to create 
# one. 
#</p>
#<p>
#
#  A minimal system requires a partition of around 10 gigabytes (GB). This is 
# enough to store all the source tarballs and compile the packages. However, if 
# the LFS system is intended to be the primary Linux system, additional software 
# will probably be installed which will require additional space. A 30 GB 
# partition is a reasonable size to provide for growth. The LFS system itself 
# will not take up this much room. A large portion of this requirement is to 
# provide sufficient free temporary storage as well as for adding additional 
# capabilities after LFS is complete. Additionally, compiling packages can 
# require a lot of disk space which will be reclaimed after the package is 
# installed. 
#</p>
#<p>
#
#  Because there is not always enough Random Access Memory (RAM) available for 
# compilation processes, it is a good idea to use a small disk partition as swap 
#  space. This is used by the kernel to store seldom-used data and leave more 
# memory available for active processes. The swap 
#  partition for an LFS system can be the same as the one used by the host 
# system, in which case it is not necessary to create another one. 
#</p>
#<p>
#
#  Start a disk partitioning program such as cfdisk
#  or fdisk
#  with a command line option naming the hard disk on which the new partition 
# will be created—for example /dev/sda 
#  for the primary disk drive. Create a Linux native partition and a swap 
#  partition, if needed. Please refer to [cfdisk(8)](https://man.archlinux.org/man/cfdisk.8)
#  or [fdisk(8)](https://man.archlinux.org/man/fdisk.8)
#  if you do not yet know how to use the programs. 
#</p>

# ====== Note ======
#<p>
#
#  For experienced users, other partitioning schemes are possible. The new LFS 
# system can be on a software [RAID](https://www.linuxfromscratch.org/blfs/view/svn/postlfs/raid.html)
#  array or an [LVM](https://www.linuxfromscratch.org/blfs/view/svn/postlfs/aboutlvm.html)
#  logical volume. However, some of these options require an [initramfs](https://www.linuxfromscratch.org/blfs/view/svn/postlfs/initramfs.html)
#  , which is an advanced topic. These partitioning methodologies are not 
# recommended for first time LFS users. 
#</p>
#<p>
#
#  Remember the designation of the new partition (e.g., sda5 
#  ). This book will refer to this as the LFS partition. Also remember the 
# designation of the swap 
#  partition. These names will be needed later for the /etc/fstab 
#  file. 
#</p>

# ==== 2.4.1. Other Partition Issues ====
#<p>
#
#  Requests for advice on system partitioning are often posted on the LFS mailing 
# lists. This is a highly subjective topic. The default for most distributions is 
# to use the entire drive with the exception of one small swap partition. This is 
# not optimal for LFS for several reasons. It reduces flexibility, makes sharing 
# of data across multiple distributions or LFS builds more difficult, makes 
# backups more time consuming, and can waste disk space through inefficient 
# allocation of file system structures. 
#</p>

# ====== 2.4.1.1. The Root Partition ======
#<p>
#
#  A root LFS partition (not to be confused with the /root 
#  directory) of twenty gigabytes is a good compromise for most systems. It 
# provides enough space to build LFS and most of BLFS, but is small enough so 
# that multiple partitions can be easily created for experimentation. 
#</p>

# ====== 2.4.1.2. The Swap Partition ======
#<p>
#
#  Most distributions automatically create a swap partition. Generally the 
# recommended size of the swap partition is about twice the amount of physical 
# RAM, however this is rarely needed. If disk space is limited, hold the swap 
# partition to two gigabytes and monitor the amount of disk swapping. 
#</p>
#<p>
#
#  If you want to use the hibernation feature (suspend-to-disk) of Linux, it 
# writes out the contents of RAM to the swap partition before turning off the 
# machine. In this case the size of the swap partition should be at least as 
# large as the system's installed RAM. 
#</p>
#<p>
#
#  Swapping is never good. For mechanical hard drives you can generally tell if a 
# system is swapping by just listening to disk activity and observing how the 
# system reacts to commands. With an SSD you will not be able to hear swapping, 
# but you can tell how much swap space is being used by running the top
#  or free
#  programs. Use of an SSD for a swap partition should be avoided if possible. 
# The first reaction to swapping should be to check for an unreasonable command 
# such as trying to edit a five gigabyte file. If swapping becomes a normal 
# occurrence, the best solution is to purchase more RAM for your system. 
#</p>

# ====== 2.4.1.3. The Grub Bios Partition ======
#<p>
#
#  If the boot disk
#  has been partitioned with a GUID Partition Table (GPT), then a small, 
# typically 1 MB, partition must be created if it does not already exist. This 
# partition is not formatted, but must be available for GRUB to use during 
# installation of the boot loader. This partition will normally be labeled 'BIOS 
# Boot' if using fdisk
#  or have a code of EF02
#  if using the gdisk
#  command. 
#</p>

# ====== Note ======
#<p>
#
#  The Grub Bios partition must be on the drive that the BIOS uses to boot the 
# system. This is not necessarily the drive that holds the LFS root partition. 
# The disks on a system may use different partition table types. The necessity of 
# the Grub Bios partition depends only on the partition table type of the boot 
# disk. 
#</p>

# ====== 2.4.1.4. Convenience Partitions ======
#<p>
#
#  There are several other partitions that are not required, but should be 
# considered when designing a disk layout. The following list is not 
# comprehensive, but is meant as a guide. 
#</p>

# ***** #<p>
#
#  /boot – Highly recommended. Use this partition to store kernels and other 
# booting information. To minimize potential boot problems with larger disks, 
# make this the first physical partition on your first disk drive. A partition 
# size of 200 megabytes is adequate. 
#</p>

# ***** #<p>
#
#  /boot/efi – The EFI System Partition, which is needed for booting the system 
# with UEFI. Read [the BLFS page](https://www.linuxfromscratch.org/blfs/view/svn/postlfs/grub-setup.html)
#  for details. 
#</p>

# ***** #<p>
#
#  /home – Highly recommended. Share your home directory and user customization 
# across multiple distributions or LFS builds. The size is generally fairly large 
# and depends on available disk space. 
#</p>

# ***** #<p>
#
#  /usr – In LFS, /bin 
#  , /lib 
#  , and /sbin 
#  are symlinks to their counterparts in /usr 
#  . So /usr 
#  contains all the binaries needed for the system to run. For LFS a separate 
# partition for /usr 
#  is normally not needed. If you create it anyway, you should make a partition 
# large enough to fit all the programs and libraries in the system. The root 
# partition can be very small (maybe just one gigabyte) in this configuration, so 
# it's suitable for a thin client or diskless workstation (where /usr 
#  is mounted from a remote server). However, you should be aware that an 
# initramfs (not covered by LFS) will be needed to boot a system with a separate /usr 
#  partition. 
#</p>

# ***** #<p>
#
#  /opt – This directory is most useful for BLFS, where multiple large packages 
# like KDE or Texlive can be installed without embedding the files in the /usr 
# hierarchy. If used, 5 to 10 gigabytes is generally adequate. 
#</p>

# ***** #<p>
#
#  /tmp – A separate /tmp partition is rare, but useful if configuring a thin 
# client. This partition, if used, will usually not need to exceed a couple of 
# gigabytes. If you have enough RAM, you can mount a tmpfs 
#  on /tmp to make access to temporary files faster. 
#</p>

# ***** #<p>
#
#  /usr/src – This partition is very useful for providing a location to store 
# BLFS source files and share them across LFS builds. It can also be used as a 
# location for building BLFS packages. A reasonably large partition of 30-50 
# gigabytes provides plenty of room. 
#</p>
#<p>
#
#  Any separate partition that you want automatically mounted when the system 
# starts must be specified in the /etc/fstab 
#  file. Details about how to specify partitions will be discussed in [Section 10.2, “Creating the /etc/fstab File”](../chapter10/fstab.html)
#  . 
#</p>
