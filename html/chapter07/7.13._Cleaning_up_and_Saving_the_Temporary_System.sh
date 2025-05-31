#!/usr/bin/bash

# ===== 7.13. Cleaning up and Saving the Temporary System =====
topdir=$(pwd)
err=0
set -e
chapter=7013
err_report() {
    echo "chapter $chapter: $(date +'%Y.%m.%d %H:%M:%S') Error $? on line $1" | tee >> $topdir/log.txt
}
trap 'err_report $LINENO' ERR
echo "---------" >> $topdir/log.txt
echo chapter $chapter: start = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt



# ==== 7.13.1. Cleaning ====
#<p>
#
#  First, remove the currently installed documentation files to prevent them from 
# ending up in the final system, and to save about 35 MB: 
#</p>

#********<pre>***********
rm -rf /usr/share/{info,man,doc}/*
#********</pre>**********
#<p>
#
#  Second, on a modern Linux system, the libtool .la files are only useful for 
# libltdl. No libraries in LFS are loaded by libltdl, and it's known that some 
# .la files can cause BLFS package failures. Remove those files now: 
#</p>

#********<pre>***********
find /usr/{lib,libexec} -name \*.la -delete
#********</pre>**********
#<p>
#
#  The current system size is now about 3 GB, however the /tools directory is no 
# longer needed. It uses about 1 GB of disk space. Delete it now: 
#</p>

#********<pre>***********
rm -rf /tools
#********</pre>**********

# ==== 7.13.2. Backup ====
#<p>
#
#  At this point the essential programs and libraries have been created and your 
# current LFS system is in a good state. Your system can now be backed up for 
# later reuse. In case of fatal failures in the subsequent chapters, it often 
# turns out that removing everything and starting over (more carefully) is the 
# best way to recover. Unfortunately, all the temporary files will be removed, 
# too. To avoid spending extra time to redo something which has been done 
# successfully, creating a backup of the current LFS system may prove useful. 
#</p>

# ====== Note ======
#<p>
#
#  All the remaining steps in this section are optional. Nevertheless, as soon as 
# you begin installing packages in [Chapter 8](../chapter08/chapter08.html)
#  , the temporary files will be overwritten. So it may be a good idea to do a 
# backup of the current system as described below. 
#</p>
#<p>
#
#  The following steps are performed from outside the chroot environment. That 
# means you have to leave the chroot environment first before continuing. The 
# reason for that is to get access to file system locations outside of the chroot 
# environment to store/read the backup archive, which ought not be placed within 
# the $LFS 
#  hierarchy. 
#</p>
#<p>
#
#  If you have decided to make a backup, leave the chroot environment: 
#</p>

#********<pre>***********
#exit
#********</pre>**********

# ====== Important ======
#<p>
#
#  All of the following instructions are executed by root 
#  on your host system. Take extra care about the commands you're going to run as 
# mistakes made here can modify your host system. Be aware that the environment 
# variable LFS 
#  is set for user lfs 
#  by default but may not
#  be set for root 
#  . 
#</p>
#<p>
#
#  Whenever commands are to be executed by root 
#  , make sure you have set LFS 
#  . 
#</p>
#<p>
#
#  This has been discussed in [Section 2.6, “Setting the $LFS Variable and the Umask.”](../chapter02/aboutlfs.html)
#</p>
#<p>
#
#  Before making a backup, unmount the virtual file systems: 
#</p>

#********<pre>***********
#mountpoint -q $LFS/dev/shm && umount $LFS/dev/shm
#umount $LFS/dev/pts
#umount $LFS/{sys,proc,run,dev}
#********</pre>**********
#<p>
#
#  Make sure you have at least 1 GB free disk space (the source tarballs will be 
# included in the backup archive) on the file system containing the directory 
# where you create the backup archive. 
#</p>
#<p>
#
#  Note that the instructions below specify the home directory of the host 
# system's root 
#  user, which is typically found on the root file system. Replace $HOME 
#  by a directory of your choice if you do not want to have the backup stored in root 
#  's home directory. 
#</p>
#<p>
#
#  Create the backup archive by running the following command: 
#</p>

# ====== Note ======
#<p>
#
#  Because the backup archive is compressed, it takes a relatively long time 
# (over 10 minutes) even on a reasonably fast system. 
#</p>

#********<pre>***********
#cd $LFS
#tar -cJpf $HOME/lfs-temp-tools-r12.3-51.tar.xz .
#********</pre>**********

# ====== Note ======
#<p>
#
#  If continuing to chapter 8, don't forget to reenter the chroot environment as 
# explained in the “Important”
#  box below. 
#</p>

# ==== 7.13.3. Restore ====
#<p>
#
#  In case some mistakes have been made and you need to start over, you can use 
# this backup to restore the system and save some recovery time. Since the 
# sources are located under $LFS 
#  , they are included in the backup archive as well, so they do not need to be 
# downloaded again. After checking that $LFS 
#  is set properly, you can restore the backup by executing the following 
# commands: 
#</p>

# ====== Warning ======
#<p>
#
#  The following commands are extremely dangerous. If you run rm -rf ./*
#  as the root 
#  user and you do not change to the $LFS directory or the LFS 
#  environment variable is not set for the root 
#  user, it will destroy your entire host system. YOU ARE WARNED. 
#</p>

#********<pre>***********
#cd $LFS
#rm -rf ./*
#tar -xpf $HOME/lfs-temp-tools-r12.3-51.tar.xz
#********</pre>**********
#<p>
#
#  Again, double check that the environment has been set up properly and continue 
# building the rest of the system. 
#</p>

# ====== Important ======
#<p>
#
#  If you left the chroot environment to create a backup or restart building 
# using a restore, remember to check that the virtual file systems are still 
# mounted ( findmnt | grep $LFS
#  ). If they are not mounted, remount them now as described in [Section 7.3, “Preparing Virtual Kernel File Systems”](kernfs.html)
#  and re-enter the chroot environment (see [Section 7.4, “Entering the Chroot Environment”](chroot.html)
#  ) before continuing. 
#</p>
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt
