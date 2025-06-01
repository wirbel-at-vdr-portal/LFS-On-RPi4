#!/usr/bin/bash

# ===== 8.52. Flit-Core-3.12.0 =====
topdir=$(pwd)
err=0
set -e
chapter=8052
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


srcdir=../../src/flit_core-3.12.0
tar xf ../../src/flit_core-3.12.0.tar.gz -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir

#<p>
#
#  Flit-core is the distribution-building parts of Flit (a packaging tool for 
# simple Python modules). 
#</p>

#  Approximate build time: less than 0.1 SBU
#  Required disk space: 1.0 MB
# ==== 8.52.1. Installation of Flit-Core ====
#<p>
#
#  Build the package: 
#</p>

#********<pre>***********
pip3 wheel -w dist --no-cache-dir --no-build-isolation --no-deps $PWD
#********</pre>**********
#<p>
#
#  Install the package: 
#</p>

#********<pre>***********
pip3 install --no-index --find-links dist flit_core
#********</pre>**********
#<p>
#
#  The meaning of the pip3 configuration options and commands: 
#</p>

#wheel
##<p>
#
#  This command builds the wheel archive for this package. 
#</p>

#-w dist 
##<p>
#
#  Instructs pip to put the created wheel into the dist 
#  directory. 
#</p>

#--no-cache-dir 
##<p>
#
#  Prevents pip from copying the created wheel into the /root/.cache/pip 
#  directory. 
#</p>

#install
##<p>
#
#  This command installs the package. 
#</p>

#--no-build-isolation ,--no-deps , and--no-index 
##<p>
#
#  These options prevent fetching files from the online package repository 
# (PyPI). If packages are installed in the correct order, pip won't need to fetch 
# any files in the first place; these options add some safety in case of user 
# error. 
#</p>

#--find-links dist 
##<p>
#
#  Instructs pip to search for wheel archives in the dist 
#  directory. 
#</p>

# ==== 8.52.2. Contents of Flit-Core ====

#  Installed directory: /usr/lib/python3.13/site-packages/flit_core and /usr/lib/python3.13/site-packages/flit_core-3.12.0.dist-infoecho chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
cd $topdir
rm -rf $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt

echo "---------" >> $topdir/log.txt
