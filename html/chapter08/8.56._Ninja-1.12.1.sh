#!/usr/bin/bash

# ===== 8.56. Ninja-1.12.1 =====
topdir=$(pwd)
err=0
set -e
chapter=8056
err_report() {
    echo "chapter $chapter: $(date +'%Y.%m.%d %H:%M:%S') Error $? on line $1" | tee >> $topdir/log.txt
}
trap 'err_report $LINENO' ERR
echo "---------" >> $topdir/log.txt
echo chapter $chapter: start = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt




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



srcdir=../../src/ninja-1.12.1
tar xf ../../src/ninja-1.12.1.tar.gz -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir

#<p>
#
#  Ninja is a small build system with a focus on speed. 
#</p>

#  Approximate build time: 0.2 SBU
#  Required disk space: 37 MB
# ==== 8.56.1. Installation of Ninja ====
#<p>
#
#  When run, ninja
#  normally utilizes the greatest possible number of processes in parallel. By 
# default this is the number of cores on the system, plus two. This may overheat 
# the CPU, or make the system run out of memory. When ninja
#  is invoked from the command line, passing the -jN parameter will limit the 
# number of parallel processes. Some packages embed the execution of ninja
#  , and do not pass the -j parameter on to it. 
#</p>
#<p>
#
#  Using the optional
#  procedure below allows a user to limit the number of parallel processes via an 
# environment variable, NINJAJOBS. For example
#  , setting: 
#</p>

#********<pre>***********
#export NINJAJOBS=4
#********</pre>**********
#<p>
#
#  will limit ninja
#  to four parallel processes. 
#</p>
#<p>
#
#  If desired, make ninja
#  recognize the environment variable NINJAJOBS by running the stream editor: 
#</p>

#********<pre>***********
sed -i '/int Guess/a \
  int   j = 0;\
  char* jobs = getenv( "NINJAJOBS" );\
  if ( jobs != NULL ) j = atoi( jobs );\
  if ( j > 0 ) return j;\
' src/ninja.cc
#********</pre>**********
#<p>
#
#  Build Ninja with: 
#</p>

#********<pre>***********
python3 configure.py --bootstrap --verbose
#********</pre>**********
#<p>
#
#  The meaning of the build option: 
#</p>

#--bootstrap 
##<p>
#
#  This parameter forces Ninja to rebuild itself for the current system. 
#</p>

#--verbose 
##<p>
#
#  This parameter makes configure.py
#  show the progress building Ninja. 
#</p>
#<p>
#
#  The package tests cannot run in the chroot environment. They require [cmake](https://www.linuxfromscratch.org/blfs/view/svn/general/cmake.html)
#  . But the basic function of this package is already tested by rebuilding 
# itself (with the --bootstrap 
#  option) anyway. 
#</p>
#<p>
#
#  Install the package: 
#</p>

#********<pre>***********
install -vm755 ninja /usr/bin/
install -vDm644 misc/bash-completion /usr/share/bash-completion/completions/ninja
install -vDm644 misc/zsh-completion  /usr/share/zsh/site-functions/_ninja
#********</pre>**********

# ==== 8.56.2. Contents of Ninja ====

#  Installed programs: ninja
# ====== Short Descriptions ======

#--------------------------------------------
# | ninja                                    | is the Ninja build system               
#--------------------------------------------
cd $topdir
rm -rf $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt
