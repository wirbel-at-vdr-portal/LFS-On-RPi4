topdir=$(pwd)
err=0
set -e
chapter=ntfs-3g_ntfsprogs-2022.10.3
err_report() {
    echo "chapter $chapter: $(date +'%Y.%m.%d %H:%M:%S') Error $? on line $1" | tee >> $topdir/log.txt
}
trap 'err_report $LINENO' ERR
echo "---------" >> $topdir/log.txt
echo chapter $chapter: start = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt




srcdir=../../src/ntfs-3g_ntfsprogs-2022.10.3
tar xf ../../src/ntfs-3g_ntfsprogs-2022.10.3.tgz -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir








# Introduction to Ntfs-3g
# [Note] Note
# 
# A new read-write driver for NTFS, called NTFS3, has been added into the Linux kernel since the 5.15 release. The performance of NTFS3 is much better than ntfs-3g. To enable NTFS3, enable the following options in the kernel configuration and recompile the kernel if necessary:
# 
# File systems --->
#   DOS/FAT/EXFAT/NT Filesystems --->
#     <*/M> NTFS Read-Write file system support                         [NTFS3_FS]
# 
# To ensure the mount command uses NTFS3 for ntfs partitions, create a wrapper script:

cat > /usr/sbin/mount.ntfs << "EOF" &&
#!/bin/sh
exec mount -t ntfs3 "$@"
EOF
chmod -v 755 /usr/sbin/mount.ntfs

# With the kernel support available, ntfs-3g is only needed if you need the utilities from it (for example, to create NTFS filesystems).
# 
# The Ntfs-3g package contains a stable, read-write open source driver for NTFS partitions. NTFS partitions are used by most Microsoft operating systems. Ntfs-3g allows you to mount NTFS partitions in read-write mode from your Linux system. It uses the FUSE kernel module to be able to implement NTFS support in userspace. The package also contains various utilities useful for manipulating NTFS partitions.
# [Note] Note
# 
# Development versions of BLFS may not build or run some packages properly if LFS or dependencies have been updated since the most recent stable versions of the books.
# Package Information
# 
#     Download (HTTP): https://tuxera.com/opensource/ntfs-3g_ntfsprogs-2022.10.3.tgz
# 
#     Download MD5 sum: a038af61be7584b79f8922ff11244090
# 
#     Download size: 1.3 MB
# 
#     Estimated disk space required: 22 MB
# 
#     Estimated build time: 0.2 SBU
# 
# Ntfs-3g Dependencies
# Optional
# 
# fuse 2.x (this disables user mounts)
# Kernel Configuration
# 
# Enable the following options in the kernel configuration and recompile the kernel if necessary:
# 
# File systems --->
#   <*/M> FUSE (Filesystem in Userspace) support                         [FUSE_FS]
# 
# Note that it is only needed for mounting NTFS partitions with ntfs-3g. If you will use the in-kernel NTFS3 driver for mounting NTFS partitions (as the BLFS editors recommend) instead, you can skip this configuration item.
# Installation of Ntfs-3g
# 
# Install Ntfs-3g by running the following commands:

./configure --prefix=/usr        \
            --disable-static     \
            --with-fuse=internal \
            --docdir=/usr/share/doc/ntfs-3g-2022.10.3 &&
make -j4

# This package does not come with a test suite.
# 
# Now, as the root user:

make install

# # It's recommended to use the in-kernel NTFS3 driver for mounting NTFS filesystems,
# #  instead of ntfs-3g (see the note at the start of this page). However, if you want
# # to use ntfs-3g to mount the NTFS filesystems anyway, create a symlink for the mount command:
# 
# ln -sv ../bin/ntfs-3g /usr/sbin/mount.ntfs &&
# ln -sv ntfs-3g.8 /usr/share/man/man8/mount.ntfs.8
# 
# Command Explanations
# 
# --disable-static: This switch prevents installation of static versions of the libraries.
# 
# --with-fuse=internal: This switch dynamically forces ntfs-3g to use an internal copy of the fuse-2.x library. This is required if you wish to allow users to mount NTFS partitions.
# 
# --disable-ntfsprogs: Disables installation of various utilities used to manipulate NTFS partitions.
# 
# chmod -v 4755 /usr/bin/ntfs-3g: Making mount.ntfs setuid root allows non root users to mount NTFS partitions.
# Using Ntfs-3g
# 
# To mount a Windows partition at boot time, put a line like this in /etc/fstab:
# 
# /dev/sda1 /mnt/windows auto defaults 0 0
# 
# To allow users to mount a usb stick with an NTFS filesystem on it, put a line similar to this (change sdc1 to whatever a usb stick would be on your system) in /etc/fstab:
# 
# /dev/sdc1 /mnt/usb auto user,noauto,umask=0,utf8 0 0
# 
# In order for a user to be able to mount the usb stick, they will need to be able to write to /mnt/usb, so as the root user:
# 
# chmod -v 777 /mnt/usb
# 
# Contents
# Installed Programs:
# lowntfs-3g, mkfs.ntfs, mkntfs, mount.lowntfs-3g, mount.ntfs, mount.ntfs-3g, ntfs-3g, ntfs-3g.probe, ntfscat, ntfsclone, ntfscluster, ntfscmp, ntfscp, ntfsfix, ntfsinfo, ntfslabel, ntfsls, ntfsresize and ntfsundelete
# Installed Library:
# libntfs-3g.so
# Installed Directories:
# /usr/include/ntfs-3g and /usr/share/doc/ntfs-3g
# Short Descriptions
# 
# lowntfs-3g
# 	
# 
# is similar to ntfs-3g but uses the Fuse low-level interface
# 
# mkfs.ntfs
# 	
# 
# is a symlink to mkntfs
# 
# mkntfs
# 	
# 
# creates an NTFS file system
# 
# mount.lowntfs-3g
# 	
# 
# is a symlink to lowntfs-3g
# 
# mount.ntfs
# 	
# 
# mounts an NTFS filesystem
# 
# mount.ntfs-3g
# 	
# 
# is a symbolic link to ntfs-3g
# 
# ntfs-3g
# 	
# 
# is an NTFS driver, which can create, remove, rename, move files, directories, hard links, and streams. It can also read and write files, including streams, sparse files and transparently compressed files. It can also handle special files like symbolic links, devices, and FIFOs; moreover it provides standard management of file ownership and permissions, including POSIX ACLs
# 
# ntfs-3g.probe
# 	
# 
# tests if an NTFS volume is mountable read only or read-write, and exits with a status value accordingly. The volume can be a block device or image file
# 
# ntfscluster
# 	
# 
# identifies files in a specified region of an NTFS volume
# 
# ntfscp
# 	
# 
# copies a file to an NTFS volume
# 
# ntfsfix
# 	
# 
# fixes common errors and forces Windows to check an NTFS partition
# 
# ntfsls
# 	
# 
# lists directory contents on an NTFS filesystem
# 
# ntfscat
# 	
# 
# prints NTFS files and streams on the standard output
# 
# ntfsclone
# 	
# 
# clones an NTFS filesystem
# 
# ntfscmp
# 	
# 
# compares two NTFS filesystems and shows the differences
# 
# ntfsinfo
# 	
# 
# dumps a file's attributes
# 
# ntfslabel
# 	
# 
# displays or changes the label on an ntfs file system
# 
# ntfsresize
# 	
# 
# resizes an NTFS filesystem without data loss
# 
# ntfsundelete
# 	
# 
# recovers a deleted file from an NTFS volume
# 
# libntfs-3g.so
# 	
# 
# contains the Ntfs-3g API functions 




cd $topdir
rm -rfv $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt

