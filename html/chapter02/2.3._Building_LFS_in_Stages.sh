#!/usr/bin/bash

# ===== 2.3. Building LFS in Stages =====
topdir=$(pwd)
err=0
if [ "$EUID" -ne "0" ]; then
  echo "ERROR: Please run as root";stop
  exit 1
fi

#<p>
#
#  LFS is designed to be built in one session. That is, the instructions assume 
# that the system will not be shut down during the process. This does not mean 
# that the system has to be built in one sitting. The issue is that certain 
# procedures must be repeated after a reboot when resuming LFS at different 
# points. 
#</p>

# ==== 2.3.1. Chapters 1–4 ====
#<p>
#
#  These chapters run commands on the host system. When restarting, be certain of 
# one thing: 
#</p>

# ***** #<p>
#
#  Procedures performed as the root 
#  user after Section 2.4 must have the LFS environment variable set FOR THE ROOT USER
#  . 
#</p>

# ==== 2.3.2. Chapters 5–6 ====

# ***** #<p>
#
#  The /mnt/lfs partition must be mounted. 
#</p>

# ***** #<p>
#
#  These two chapters must
#  be done as user lfs 
#  . A su - lfs
#  command must be issued before performing any task in these chapters. If you 
# don't do that, you are at risk of installing packages to the host, and 
# potentially rendering it unusable. 
#</p>

# ***** #<p>
#
#  The procedures in [General Compilation Instructions](../partintro/generalinstructions.html)
#  are critical. If there is any doubt a package has been installed correctly, 
# ensure the previously expanded tarball has been removed, then re-extract the 
# package, and complete all the instructions in that section. 
#</p>

# ==== 2.3.3. Chapters 7–10 ====

# ***** #<p>
#
#  The /mnt/lfs partition must be mounted. 
#</p>

# ***** #<p>
#
#  A few operations, from “Preparing Virtual Kernel File Systems”
#  to “Entering the Chroot Environment,”
#  must be done as the root 
#  user, with the LFS environment variable set for the root 
#  user. 
#</p>

# ***** #<p>
#
#  When entering chroot, the LFS environment variable must be set for root 
#  . The LFS variable is not used after the chroot environment has been entered. 
#</p>

# ***** #<p>
#
#  The virtual file systems must be mounted. This can be done before or after 
# entering chroot by changing to a host virtual terminal and, as root 
#  , running the commands in [Section 7.3.1, “Mounting and Populating /dev”](../chapter07/kernfs.html#ch-tools-bindmount)
#  and [Section 7.3.2, “Mounting Virtual Kernel File Systems.”](../chapter07/kernfs.html#ch-tools-kernfsmount)
#</p>
