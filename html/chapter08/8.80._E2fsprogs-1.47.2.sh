#!/usr/bin/bash

# ===== 8.80. E2fsprogs-1.47.2 =====
topdir=$(pwd)
err=0
set -e
chapter=8080
err_report() {
    echo "chapter $chapter: $(date +'%Y.%m.%d %H:%M:%S') Error $? on line $1" | tee >> $topdir/log.txt
}
trap 'err_report $LINENO' ERR
echo "---------" >> $topdir/log.txt
echo chapter $chapter: start = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt






srcdir=../../src/e2fsprogs-1.47.2
tar xf ../../src/e2fsprogs-1.47.2.tar.gz -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir

#<p>
#
#  The E2fsprogs package contains the utilities for handling the ext2 
#  file system. It also supports the ext3 
#  and ext4 
#  journaling file systems. 
#</p>

#  Approximate build time: 2.4 SBU on a spinning disk, 0.5 SBU on an SSD
#  Required disk space: 99 MB
# ==== 8.80.1. Installation of E2fsprogs ====
#<p>
#
#  The E2fsprogs documentation recommends that the package be built in a 
# subdirectory of the source tree: 
#</p>

#********<pre>***********
mkdir -v build
cd       build
#********</pre>**********
#<p>
#
#  Prepare E2fsprogs for compilation: 
#</p>

#********<pre>***********
../configure --prefix=/usr       \
             --sysconfdir=/etc   \
             --enable-elf-shlibs \
             --disable-libblkid  \
             --disable-libuuid   \
             --disable-uuidd     \
             --disable-fsck
#********</pre>**********
#<p>
#
#  The meaning of the configure options: 
#</p>

#--enable-elf-shlibs 
##<p>
#
#  This creates the shared libraries which some programs in this package use. 
#</p>

#--disable-* 
##<p>
#
#  These prevent building and installing the libuuid 
#  and libblkid 
#  libraries, the uuidd 
#  daemon, and the fsck
#  wrapper; util-linux installs more recent versions. 
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
#  To run the tests, issue: 
#</p>

#********<pre>***********
#make check
#********</pre>**********
#<p>
#
#  One test named m_assume_storage_prezeroed 
#  is known to fail. Another test named m_rootdir_acl 
#  is known to fail if the file system used for the LFS system is not ext4 
#  . 
#</p>
#<p>
#
#  Install the package: 
#</p>

#********<pre>***********
make install
#********</pre>**********
#<p>
#
#  Remove useless static libraries: 
#</p>

#********<pre>***********
rm -fv /usr/lib/{libcom_err,libe2p,libext2fs,libss}.a
#********</pre>**********
#<p>
#
#  This package installs a gzipped .info 
#  file but doesn't update the system-wide dir 
#  file. Unzip this file and then update the system dir 
#  file using the following commands: 
#</p>

#********<pre>***********
gunzip -v /usr/share/info/libext2fs.info.gz
install-info --dir-file=/usr/share/info/dir /usr/share/info/libext2fs.info
#********</pre>**********
#<p>
#
#  If desired, create and install some additional documentation by issuing the 
# following commands: 
#</p>

#********<pre>***********
makeinfo -o      doc/com_err.info ../lib/et/com_err.texinfo
install -v -m644 doc/com_err.info /usr/share/info
install-info --dir-file=/usr/share/info/dir /usr/share/info/com_err.info
#********</pre>**********

# ==== 8.80.2. Configuring E2fsprogs ====
#<p>
#/etc/mke2fs.conf 
#  contains the default value of various command line options of mke2fs
#  . You may edit the file to make the default values suitable for your needs. 
# For example, some utilities (not in LFS or BLFS) cannot recognize a ext4 
#  file system with metadata_csum_seed 
#  feature enabled. If
#  you need such an utility, you may remove the feature from the default ext4 
#  feature list with the command: 
#</p>

#********<pre>***********
sed 's/metadata_csum_seed,//' -i /etc/mke2fs.conf
#********</pre>**********
#<p>
#
#  Read the man page [mke2fs.conf(5)](https://man.archlinux.org/man/mke2fs.conf.5)
#  for details. 
#</p>

# ==== 8.80.3. Contents of E2fsprogs ====

#  Installed programs: badblocks, chattr, compile_et, debugfs, dumpe2fs, e2freefrag, e2fsck, e2image, e2label, e2mmpstatus, e2scrub, e2scrub_all, e2undo, e4crypt, e4defrag, filefrag, fsck.ext2, fsck.ext3, fsck.ext4, logsave, lsattr, mk_cmds, mke2fs, mkfs.ext2, mkfs.ext3, mkfs.ext4, mklost+found, resize2fs, and tune2fs
#  Installed libraries: libcom_err.so, libe2p.so, libext2fs.so, and libss.so
#  Installed directories: /usr/include/e2p, /usr/include/et, /usr/include/ext2fs, /usr/include/ss, /usr/lib/e2fsprogs, /usr/share/et, and /usr/share/ss
# ====== Short Descriptions ======

#--------------------------------------------
# | badblocks                                | Searches a device (usually a disk partition) for bad blocks
# | chattr                                   | Changes the attributes of files on      ext{234}                                file systems                            
# | compile_et                               | An error table compiler; it converts a table of error-code names and messages into a C source file suitable for use with thecom_err                                 library                                 
# | debugfs                                  | A file system debugger; it can be used to examine and change the state ofext{234}                                file systems                            
# | dumpe2fs                                 | Prints the super block and blocks group information for the file system present on a given device
# | e2freefrag                               | Reports free space fragmentation information
# | e2fsck                                   | Is used to check and optionally repair  ext{234}                                file systems                            
# | e2image                                  | Is used to save critical                ext{234}                                file system data to a file              
# | e2label                                  | Displays or changes the file system label on theext{234}                                file system on a given device           
# | e2mmpstatus                              | Checks MMP (Multiple Mount Protection) status of anext4                                    file system                             
# | e2scrub                                  | Checks the contents of a mounted        ext{234}                                file system                             
# | e2scrub_all                              | Checks all mounted                      ext{234}                                file systems for errors                 
# | e2undo                                   | Replays the undo log for an             ext{234}                                file system found on a device. [This can be used to undo a failed operation by an E2fsprogs program.]
# | e4crypt                                  | Ext4                                    file system encryption utility          
# | e4defrag                                 | Online defragmenter for                 ext4                                    file systems                            
# | filefrag                                 | Reports on how badly fragmented a particular file might be
# | fsck.ext2                                | By default checks                       ext2                                    file systems and is a hard link to      e2fsck                                  
# | fsck.ext3                                | By default checks                       ext3                                    file systems and is a hard link to      e2fsck                                  
# | fsck.ext4                                | By default checks                       ext4                                    file systems and is a hard link to      e2fsck                                  
# | logsave                                  | Saves the output of a command in a log file
# | lsattr                                   | Lists the attributes of files on a second extended file system
# | mk_cmds                                  | Converts a table of command names and help messages into a C source file suitable for use with thelibss                                   subsystem library                       
# | mke2fs                                   | Creates an                              ext{234}                                file system on the given device         
# | mkfs.ext2                                | By default creates                      ext2                                    file systems and is a hard link to      mke2fs                                  
# | mkfs.ext3                                | By default creates                      ext3                                    file systems and is a hard link to      mke2fs                                  
# | mkfs.ext4                                | By default creates                      ext4                                    file systems and is a hard link to      mke2fs                                  
# | mklost+found                             | Creates a                               lost+found                              directory on an                         ext{234}                                file system; it pre-allocates disk blocks to this directory to lighten the task ofe2fsck                                  
# | resize2fs                                | Can be used to enlarge or shrink        ext{234}                                file systems                            
# | tune2fs                                  | Adjusts tunable file system parameters onext{234}                                file systems                            
# | libcom_err                               | The common error display routine        
# | libe2p                                   | Used by                                 dumpe2fs                                ,                                       chattr                                  , and                                   lsattr                                  
# | libext2fs                                | Contains routines to enable user-level programs to manipulateext{234}                                file systems                            
# | libss                                    | Used by                                 debugfs                                 
#--------------------------------------------
cd $topdir
rm -rf $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt
