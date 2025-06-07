#!/usr/bin/bash

# ===== 9.1. Introduction =====
topdir=$(pwd)
err=0
set -e
chapter=9001
err_report() {
    echo "chapter $chapter: $(date +'%Y.%m.%d %H:%M:%S') Error $? on line $1" | tee >> $topdir/log.txt
}
trap 'err_report $LINENO' ERR
echo "---------" >> $topdir/log.txt
echo chapter $chapter: start = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt




#<p>
#
#  Booting a Linux system involves several tasks. The process must mount both 
# virtual and real file systems, initialize devices, check file systems for 
# integrity, mount and activate any swap partitions or files, set the system 
# clock, bring up networking, start any daemons required by the system, and 
# accomplish any other custom tasks specified by the user. This process must be 
# organized to ensure the tasks are performed in the correct order and executed 
# as quickly as possible. 
#</p>

# ==== 9.1.1. System V ====
#<p>
#
#  System V is the classic boot process that has been used in Unix and Unix-like 
# systems such as Linux since about 1983. It consists of a small program, init
#  , that sets up basic processes such as login
#  (via getty) and runs a script. This script, usually named rc
#  , controls the execution of a set of additional scripts that perform the tasks 
# required to initialize the system. 
#</p>
#<p>
#
#  The init
#  program is controlled by the /etc/inittab 
#  file and is organized into run levels that can be chosen by the user. In LFS, 
# they are used as follows: 
#</p>
#<p>
#
#  0 — halt 

#  1 — Single user mode 

#  2 — User definable 

#  3 — Full multiuser mode 

#  4 — User definable 

#  5 — Full multiuser mode with display manager 

#  6 — reboot 
#</p>
#<p>
#
#  The usual default run level is 3 or 5. 
#</p>

# ====== Advantages ======

# ***** #<p>
#
#  Established, well understood system. 
#</p>

# ***** #<p>
#
#  Easy to customize. 
#</p>

# ====== Disadvantages ======

# ***** #<p>
#
#  May be slower to boot. A medium speed base LFS system takes 8-12 seconds where 
# the boot time is measured from the first kernel message to the login prompt. 
# Network connectivity is typically established about 2 seconds after the login 
# prompt. 
#</p>

# ***** #<p>
#
#  Serial processing of boot tasks. This is related to the previous point. A 
# delay in any process, such as a file system check, will delay the entire boot 
# process. 
#</p>

# ***** #<p>
#
#  Does not directly support advanced features like control groups (cgroups) and 
# per-user fair share scheduling. 
#</p>

# ***** #<p>
#
#  Adding scripts requires manual, static sequencing decisions. 
#</p>
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt
