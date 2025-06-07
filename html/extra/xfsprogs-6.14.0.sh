topdir=$(pwd)
err=0
set -e
chapter=xfsprogs-6.14.0
err_report() {
    echo "chapter $chapter: $(date +'%Y.%m.%d %H:%M:%S') Error $? on line $1" | tee >> $topdir/log.txt
}
trap 'err_report $LINENO' ERR
echo "---------" >> $topdir/log.txt
echo chapter $chapter: start = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt




srcdir=../../src/xfsprogs-6.14.0
tar xf ../../src/xfsprogs-6.14.0.tar.xz -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir





# Introduction to xfsprogs
# 
# The xfsprogs package contains administration and debugging tools for the XFS file system.
# [Note] Note
# 
# Development versions of BLFS may not build or run some packages properly if LFS or dependencies have been updated since the most recent stable versions of the books.
# Package Information
# 
#     Download (HTTP): https://www.kernel.org/pub/linux/utils/fs/xfs/xfsprogs/xfsprogs-6.14.0.tar.xz
# 
#     Download MD5 sum: 339b90d4716d5f1e3e9d31f3c68f830d
# 
#     Download size: 1.4 MB
# 
#     Estimated disk space required: 99 MB
# 
#     Estimated build time: 0.2 SBU (Using parallelism=4)
# 
# xfsprogs Dependencies
# Required
# 
# inih-59 and liburcu-0.15.3
# Optional
# 
# ICU-77.1 (for unicode name scanning in xfs_scrub)
# Kernel Configuration
# 
# Enable the following options in the kernel configuration and recompile the kernel:
# 
# File systems --->
#   <*/M> XFS filesystem support                                          [XFS_FS]
# 
# Installation of xfsprogs
# 
# Install xfsprogs by running the following commands:

make DEBUG=-DNDEBUG     \
     INSTALL_USER=root  \
     INSTALL_GROUP=root \
     LOCAL_CONFIGURE_OPTIONS="--localstatedir=/var"

# This package does not come with a test suite.
# 
# Now, as the root user:

make PKG_DOC_DIR=/usr/share/doc/xfsprogs-6.14.0 install     &&
make PKG_DOC_DIR=/usr/share/doc/xfsprogs-6.14.0 install-dev &&

rm -rfv /usr/lib/libhandle.{a,la}

# Command Explanations
# 
# sed ... static long filesize...: That sed fixes an issue which appears when building on 32 bit systems, only. There is a mismatch in prototype and function header which results in error on that architecture.
# 
# DEBUG=-DNDEBUG: Turns off debugging symbols.
# 
# INSTALL_USER=root INSTALL_GROUP=root: This sets the owner and group of the installed files.
# 
# LOCAL_CONFIGURE_OPTIONS="--localstatedir=/var": This sets the state directory to /var, preventing /usr/var from being created.
# 
# OPTIMIZER="...": Adding this parameter to the end of the make command overrides the default optimization settings.
# Contents
# Installed Programs:
# fsck.xfs, mkfs.xfs, xfs_admin, xfs_bmap, xfs_copy, xfs_db, xfs_estimate, xfs_freeze, xfs_fsr, xfs_growfs, xfs_info, xfs_io, xfs_logprint, xfs_mdrestore, xfs_metadump, xfs_mkfile, xfs_ncheck, xfs_property, xfs_protofile, xfs_quota, xfs_repair, xfs_rtcp, xfs_scrub, xfs_scrub_all, and xfs_spaceman
# Installed Libraries:
# libhandle.so
# Installed Directories:
# /usr/include/xfs, /usr/lib/xfsprogs, /usr/share/xfsprogs, and /usr/share/doc/xfsprogs-6.14.0
# Short Descriptions
# 
# fsck.xfs
# 	
# 
# simply exits with a zero status, since XFS partitions are checked at mount time
# 
# mkfs.xfs
# 	
# 
# constructs an XFS file system
# 
# xfs_admin
# 	
# 
# changes the parameters of an XFS file system
# 
# xfs_bmap
# 	
# 
# prints block mapping for an XFS file
# 
# xfs_copy
# 	
# 
# copies the contents of an XFS file system to one or more targets in parallel
# 
# xfs_estimate
# 	
# 
# for each directory argument, estimates the space that directory would take if it were copied to an XFS filesystem (does not cross mount points)
# 
# xfs_db
# 	
# 
# is used to debug an XFS file system
# 
# xfs_freeze
# 	
# 
# suspends access to an XFS file system
# 
# xfs_fsr
# 	
# 
# applicable only to XFS filesystems, improves the organization of mounted filesystems, the reorganization algorithm operates on one file at a time, compacting or otherwise improving the layout of the file extents (contiguous blocks of file data)
# 
# xfs_growfs
# 	
# 
# expands an XFS file system
# 
# xfs_info
# 	
# 
# is equivalent to invoking xfs_growfs, but specifying that no change to the file system is to be made
# 
# xfs_io
# 	
# 
# is a debugging tool like xfs_db, but is aimed at examining the regular file I/O path rather than the raw XFS volume itself
# 
# xfs_logprint
# 	
# 
# prints the log of an XFS file system
# 
# xfs_mdrestore
# 	
# 
# restores an XFS metadump image to a filesystem image
# 
# xfs_metadump
# 	
# 
# copies XFS filesystem metadata to a file
# 
# xfs_mkfile
# 	
# 
# creates an XFS file, padded with zeroes by default
# 
# xfs_ncheck
# 	
# 
# generates pathnames from inode numbers for an XFS file system
# 
# xfs_property
# 	
# 
# examines and edits properties about a XFS filesystem
# 
# xfs_protofile
# 	
# 
# creates a protofile for use with mkfs.xfs
# 
# xfs_quota
# 	
# 
# is a utility for reporting and editing various aspects of filesystem quotas
# 
# xfs_repair
# 	
# 
# repairs corrupt or damaged XFS file systems
# 
# xfs_rtcp
# 	
# 
# copies a file to the real-time partition on an XFS file system
# 
# xfs_scrub
# 	
# 
# checks and repairs the contents of a mounted XFS file system
# 
# xfs_scrub_all
# 	
# 
# scrubs all mounted XFS file systems
# 
# xfs_spaceman
# 	
# 
# reports and controls free space usage in an XFS file system
# 
# libhandle.so
# 	
# 
# contains XFS-specific functions that provide a way to perform certain filesystem operations without using a file descriptor to access filesystem objects 





cd $topdir
rm -rfv $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt

