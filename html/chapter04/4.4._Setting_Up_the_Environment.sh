#!/usr/bin/bash

# ===== 4.4. Setting Up the Environment =====
topdir=$(pwd)
err=0
set -e
chapter=4004
err_report() {
    echo "chapter $chapter: $(date +'%Y.%m.%d %H:%M:%S') Error $? on line $1" | tee >> $topdir/log.txt
}
trap 'err_report $LINENO' ERR
echo "---------" >> $topdir/log.txt
echo chapter $chapter: start = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt

if [ "$EUID" -ne "0" ]; then
  echo "ERROR: Please run as root";stop
  exit 1
fi

if [[ -z "${LFS}" ]]; then
  echo "ERROR: 'LFS' is not set.";stop
  exit 1
fi

grep -q ${LFS} /proc/mounts || err=1
if [ "$err" -eq "1" ]; then
  echo "ERROR: The '$LFS' partition must be mounted.";stop
  exit 1
fi

#<p>
#
#  Set up a good working environment by creating two new startup files for the bash
#  shell. While logged in as user lfs 
#  , issue the following command to create a new .bash_profile 
#  : 
#</p>

#********<pre>***********
cat > ~/.bash_profile << "EOF"
exec env -i HOME=$HOME TERM=$TERM PS1='\u:\w\$ ' /bin/bash
EOF
#********</pre>**********
#<p>
#
#  When logged on as user lfs 
#  , or when switched to the lfs 
#  user using an su
#  command with the “- ”
#  option, the initial shell is a login
#  shell which reads the /etc/profile 
#  of the host (probably containing some settings and environment variables) and 
# then .bash_profile 
#  . The exec env -i.../bin/bash
#  command in the .bash_profile 
#  file replaces the running shell with a new one with a completely empty 
# environment, except for the HOME 
#  , TERM 
#  , and PS1 
#  variables. This ensures that no unwanted and potentially hazardous environment 
# variables from the host system leak into the build environment. 
#</p>
#<p>
#
#  The new instance of the shell is a non-login
#  shell, which does not read, and execute, the contents of the /etc/profile 
#  or .bash_profile 
#  files, but rather reads, and executes, the .bashrc 
#  file instead. Create the .bashrc 
#  file now: 
#</p>

#********<pre>***********
cat > ~/.bashrc << "EOF"
set +h
umask 022
LFS=/mnt/lfs
LC_ALL=POSIX
LFS_TGT=$(uname -m)-lfs-linux-gnu
PATH=/usr/bin
if [ ! -L /bin ]; then PATH=/bin:$PATH; fi
PATH=$LFS/tools/bin:$PATH
CONFIG_SITE=$LFS/usr/share/config.site
export LFS LC_ALL LFS_TGT PATH CONFIG_SITE
EOF
#********</pre>**********
#<p>
#
#  The meaning of the settings in .bashrc 
#</p>

#set +h 
##<p>
#
#  The set +h
#  command turns off bash
#  's hash function. Hashing is ordinarily a useful feature— bash
#  uses a hash table to remember the full path to executable files to avoid 
# searching the PATH 
#  time and again to find the same executable. However, the new tools should be 
# used as soon as they are installed. Switching off the hash function forces the 
# shell to search the PATH 
#  whenever a program is to be run. As such, the shell will find the newly 
# compiled tools in $LFS/tools/bin 
#  as soon as they are available without remembering a previous version of the 
# same program provided by the host distro, in /usr/bin 
#  or /bin 
#  . 
#</p>

#umask 022 
##<p>
#
#  Setting the umask as we've already explained in [Section 2.6, “Setting the $LFS Variable and the Umask.”](../chapter02/aboutlfs.html)
#</p>

#LFS=/mnt/lfs 
##<p>
#
#  The LFS 
#  variable should be set to the chosen mount point. 
#</p>

#LC_ALL=POSIX 
##<p>
#
#  The LC_ALL 
#  variable controls the localization of certain programs, making their messages 
# follow the conventions of a specified country. Setting LC_ALL 
#  to “POSIX”
#  or “C”
#  (the two are equivalent) ensures that everything will work as expected in the 
# cross-compilation environment. 
#</p>

#LFS_TGT=$(uname -m)-lfs-linux-gnu 
##<p>
#
#  The LFS_TGT 
#  variable sets a non-default, but compatible machine description for use when 
# building our cross-compiler and linker and when cross-compiling our temporary 
# toolchain. More information is provided by [Toolchain Technical Notes](../partintro/toolchaintechnotes.html)
#  . 
#</p>

#PATH=/usr/bin 
##<p>
#
#  Many modern Linux distributions have merged /bin 
#  and /usr/bin 
#  . When this is the case, the standard PATH 
#  variable should be set to /usr/bin/ 
#  for the [Chapter 6](../chapter06/chapter06.html)
#  environment. When this is not the case, the following line adds /bin 
#  to the path. 
#</p>

#if [ ! -L /bin ]; then PATH=/bin:$PATH; fi 
##<p>
#
#  If /bin 
#  is not a symbolic link, it must be added to the PATH 
#  variable. 
#</p>

#PATH=$LFS/tools/bin:$PATH 
##<p>
#
#  By putting $LFS/tools/bin 
#  ahead of the standard PATH 
#  , the cross-compiler installed at the beginning of [Chapter 5](../chapter05/chapter05.html)
#  is picked up by the shell immediately after its installation. This, combined 
# with turning off hashing, limits the risk that the compiler from the host is 
# used instead of the cross-compiler. 
#</p>

#CONFIG_SITE=$LFS/usr/share/config.site 
##<p>
#
#  In [Chapter 5](../chapter05/chapter05.html)
#  and [Chapter 6](../chapter06/chapter06.html)
#  , if this variable is not set, configure
#  scripts may attempt to load configuration items specific to some distributions 
# from /usr/share/config.site 
#  on the host system. Override it to prevent potential contamination from the 
# host. 
#</p>

#export ... 
##<p>
#
#  While the preceding commands have set some variables, in order to make them 
# visible within any sub-shells, we export them. 
#</p>

# ====== Important ======
#<p>
#
#  Several commercial distributions add an undocumented instantiation of /etc/bash.bashrc 
#  to the initialization of bash
#  . This file has the potential to modify the lfs 
#  user's environment in ways that can affect the building of critical LFS 
# packages. To make sure the lfs 
#  user's environment is clean, check for the presence of /etc/bash.bashrc 
#  and, if present, move it out of the way. As the root 
#  user, run: 
#</p>

#********<pre>***********
[ ! -e /etc/bash.bashrc ] || mv -v /etc/bash.bashrc /etc/bash.bashrc.NOUSE
#********</pre>**********
#<p>
#
#  When the lfs 
#  user is no longer needed (at the beginning of [Chapter 7](../chapter07/chapter07.html)
#  ), you may safely restore /etc/bash.bashrc 
#  (if desired). 
#</p>
#<p>
#
#  Note that the LFS Bash package we will build in [Section 8.36, “Bash-5.2.37”](../chapter08/bash.html)
#  is not configured to load or execute /etc/bash.bashrc 
#  , so this file is useless on a completed LFS system. 
#</p>
#<p>
#
#  For many modern systems with multiple processors (or cores) the compilation 
# time for a package can be reduced by performing a "parallel make" by telling 
# the make program how many processors are available via a command line option or 
# an environment variable. For instance, an Intel Core i9-13900K processor has 8 
# P (performance) cores and 16 E (efficiency) cores, and a P core can 
# simultaneously run two threads so each P core are modeled as two logical cores 
# by the Linux kernel. As the result there are 32 logical cores in total. One 
# obvious way to use all these logical cores is allowing make
#  to spawn up to 32 build jobs. This can be done by passing the -j32 
#  option to make
#  : 
#</p>

#********<pre>***********
make -j32
#********</pre>**********
#<p>
#
#  Or set the MAKEFLAGS 
#  environment variable and its content will be automatically used by make
#  as command line options: 
#</p>

#********<pre>***********
export MAKEFLAGS=-j32
#********</pre>**********

# ====== Important ======
#<p>
#
#  Never pass a -j 
#  option without a number to make
#  or set such an option in MAKEFLAGS 
#  . Doing so will allow make
#  to spawn infinite build jobs and cause system stability problems. 
#</p>
#<p>
#
#  To use all logical cores available for building packages in [Chapter 5](../chapter05/chapter05.html)
#  and [Chapter 6](../chapter06/chapter06.html)
#  , set MAKEFLAGS 
#  now in .bashrc 
#  : 
#</p>

#********<pre>***********
cat >> ~/.bashrc << "EOF"
export MAKEFLAGS=-j$(nproc)
EOF
#********</pre>**********
#<p>
#
#  Replace $(nproc) 
#  with the number of logical cores you want to use if you don't want to use all 
# the logical cores. 
#</p>
#<p>
#
#  Finally, to ensure the environment is fully prepared for building the 
# temporary tools, force the bash
#  shell to read the new user profile: 
#</p>

#********<pre>***********
source ~/.bash_profile
#********</pre>**********
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt
