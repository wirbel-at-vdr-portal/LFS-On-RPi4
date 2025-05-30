#!/usr/bin/bash

# ===== 7.4. Entering the Chroot Environment =====
topdir=$(pwd)
err=0
set -e
chapter=7004
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

#<p>
#
#  Now that all the packages which are required to build the rest of the needed 
# tools are on the system, it is time to enter the chroot environment and finish 
# installing the temporary tools. This environment will also be used to install 
# the final system. As user root 
#  , run the following command to enter the environment that is, at the moment, 
# populated with nothing but temporary tools: 
#</p>

#********<pre>***********
chroot "$LFS" /usr/bin/env -i   \
    HOME=/root                  \
    TERM="$TERM"                \
    PS1='(lfs chroot) \u:\w\$ ' \
    PATH=/usr/bin:/usr/sbin     \
    MAKEFLAGS="-j$(nproc)"      \
    TESTSUITEFLAGS="-j$(nproc)" \
    /bin/bash --login
#********</pre>**********
#<p>
#
#  If you don't want to use all available logical cores, replace $(nproc) 
#  with the number of logical cores you want to use for building packages in this 
# chapter and the following chapters. The test suites of some packages (notably 
# Autoconf, Libtool, and Tar) in [Chapter 8](../chapter08/chapter08.html)
#  are not affected by MAKEFLAGS 
#  , they use a TESTSUITEFLAGS 
#  environment variable instead. We set that here as well for running these test 
# suites with multiple cores. 
#</p>
#<p>
#
#  The -i 
#  option given to the env
#  command will clear all the variables in the chroot environment. After that, 
# only the HOME 
#  , TERM 
#  , PS1 
#  , and PATH 
#  variables are set again. The TERM=$TERM 
#  construct sets the TERM 
#  variable inside chroot to the same value as outside chroot. This variable is 
# needed so programs like vim
#  and less
#  can operate properly. If other variables are desired, such as CFLAGS 
#  or CXXFLAGS 
#  , this is a good place to set them. 
#</p>
#<p>
#
#  From this point on, there is no need to use the LFS 
#  variable any more because all work will be restricted to the LFS file system; 
# the chroot
#  command runs the Bash shell with the root ( / 
#  ) directory set to $LFS 
#  . 
#</p>
#<p>
#
#  Notice that /tools/bin 
#  is not in the PATH 
#  . This means that the cross toolchain will no longer be used. 
#</p>
#<p>
#
#  Also note that the bash
#  prompt will say I have no name! 
#  This is normal because the /etc/passwd 
#  file has not been created yet. 
#</p>

# ====== Note ======
#<p>
#
#  It is important that all the commands throughout the remainder of this chapter 
# and the following chapters are run from within the chroot environment. If you 
# leave this environment for any reason (rebooting for example), ensure that the 
# virtual kernel filesystems are mounted as explained in [Section 7.3.1, “Mounting and Populating /dev”](kernfs.html#ch-tools-bindmount)
#  and [Section 7.3.2, “Mounting Virtual Kernel File Systems”](kernfs.html#ch-tools-kernfsmount)
#  and enter chroot again before continuing with the installation. 
#</p>
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt
