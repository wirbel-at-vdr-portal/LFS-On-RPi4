#!/usr/bin/bash

# ===== 7.5. Creating Directories =====
topdir=$(pwd)
err=0
set -e
chapter=7005
err_report() {
    echo "chapter $chapter: $(date +'%Y.%m.%d %H:%M:%S') Error $? on line $1" | tee >> $topdir/log.txt
}
trap 'err_report $LINENO' ERR
echo "---------" >> $topdir/log.txt
echo chapter $chapter: start = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt

#if [[ -z "${LFS}" ]]; then
#  echo "ERROR: 'LFS' is not set.";stop
#  exit 1
#fi
#
#grep -q $LFS /proc/mounts || err=1
#if [ "$err" -eq "1" ]; then
#  echo "ERROR: The '$LFS' partition must be mounted.";stop
#  exit 1
#fi

if [ "$EUID" -ne "0" ]; then
  echo "ERROR: Please run as root, not as user id = $EUID";stop
  exit 1
fi

grep -q $LFS/dev/pts /proc/mounts || err=1
if [ "$err" -eq "1" ]; then
  echo "ERROR: The '$LFS/dev/pts' partition must be mounted.";stop
  exit 1
fi

grep -q $LFS/dev /proc/mounts || err=1
if [ "$err" -eq "1" ]; then
  echo "ERROR: The '$LFS/dev' partition must be mounted.";stop
  exit 1
fi

grep -q $LFS/proc /proc/mounts || err=1
if [ "$err" -eq "1" ]; then
  echo "ERROR: The '$LFS/proc' partition must be mounted.";stop
  exit 1
fi

grep -q $LFS/sys /proc/mounts || err=1
if [ "$err" -eq "1" ]; then
  echo "ERROR: The '$LFS/sys' partition must be mounted.";stop
  exit 1
fi

grep -q $LFS/run /proc/mounts || err=1
if [ "$err" -eq "1" ]; then
  echo "ERROR: The '$LFS/run' partition must be mounted.";stop
  exit 1
fi

#if [[ "$PS1" != "(lfs chroot) \u:\w\$ " ]]; then
#  # PS1 isn't defined here. :(
#  echo "ERROR: enter chroot first.";stop
#  exit 1
#fi

#<p>
#
#  It is time to create the full directory structure in the LFS file system. 
#</p>

# ====== Note ======
#<p>
#
#  Some of the directories mentioned in this section may have already been 
# created earlier with explicit instructions, or when installing some packages. 
# They are repeated below for completeness. 
#</p>
#<p>
#
#  Create some root-level directories that are not in the limited set required in 
# the previous chapters by issuing the following command: 
#</p>

#********<pre>***********
mkdir -pv /{boot,home,mnt,opt,srv}
#********</pre>**********
#<p>
#
#  Create the required set of subdirectories below the root-level by issuing the 
# following commands: 
#</p>

#********<pre>***********
mkdir -pv /etc/{opt,sysconfig}
mkdir -pv /lib/firmware
mkdir -pv /media/{floppy,cdrom}
mkdir -pv /usr/{,local/}{include,src}
mkdir -pv /usr/lib/locale
mkdir -pv /usr/local/{bin,lib,sbin}
mkdir -pv /usr/{,local/}share/{color,dict,doc,info,locale,man}
mkdir -pv /usr/{,local/}share/{misc,terminfo,zoneinfo}
mkdir -pv /usr/{,local/}share/man/man{1..8}
mkdir -pv /var/{cache,local,log,mail,opt,spool}
mkdir -pv /var/lib/{color,misc,locate}

ln -sfv /run /var/run
ln -sfv /run/lock /var/lock

install -dv -m 0750 /root
install -dv -m 1777 /tmp /var/tmp
#********</pre>**********
#<p>
#
#  Directories are, by default, created with permission mode 755, but this is not 
# desirable everywhere. In the commands above, two changes are made—one to the 
# home directory of user root 
#  , and another to the directories for temporary files. 
#</p>
#<p>
#
#  The first mode change ensures that not just anybody can enter the /root 
#  directory—just like a normal user would do with his or her own home 
# directory. The second mode change makes sure that any user can write to the /tmp 
#  and /var/tmp 
#  directories, but cannot remove another user's files from them. The latter is 
# prohibited by the so-called “sticky bit,”
#  the highest bit (1) in the 1777 bit mask. 
#</p>

# ==== 7.5.1. FHS Compliance Note ====
#<p>
#
#  This directory tree is based on the Filesystem Hierarchy Standard (FHS) 
# (available at [https://refspecs.linuxfoundation.org/fhs.shtml](https://refspecs.linuxfoundation.org/fhs.shtml)
#  ). The FHS also specifies the optional existence of additional directories 
# such as /usr/local/games 
#  and /usr/share/games 
#  . In LFS, we create only the directories that are really necessary. However, 
# feel free to create more directories, if you wish. 
#</p>

# ====== Warning ======
#<p>
#
#  The FHS does not mandate the existence of the directory /usr/lib64 
#  , and the LFS editors have decided not to use it. For the instructions in LFS 
# and BLFS to work correctly, it is imperative that this directory be 
# non-existent. From time to time you should verify that it does not exist, 
# because it is easy to create it inadvertently, and this will probably break 
# your system. 
#</p>
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt
