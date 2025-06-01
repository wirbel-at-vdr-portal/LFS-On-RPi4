#!/usr/bin/bash

# ===== 8.57. Meson-1.8.0 =====
topdir=$(pwd)
err=0
set -e
chapter=8057
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



srcdir=../../src/meson-1.8.0
tar xf ../../src/meson-1.8.0.tar.gz -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir

#<p>
#
#  Meson is an open source build system designed to be both extremely fast and as 
# user friendly as possible. 
#</p>

#  Approximate build time: less than 0.1 SBU
#  Required disk space: 44 MB
# ==== 8.57.1. Installation of Meson ====
#<p>
#
#  Compile Meson with the following command: 
#</p>

#********<pre>***********
pip3 wheel -w dist --no-cache-dir --no-build-isolation --no-deps $PWD
#********</pre>**********
#<p>
#
#  The test suite requires some packages outside the scope of LFS. 
#</p>
#<p>
#
#  Install the package: 
#</p>

#********<pre>***********
pip3 install --no-index --find-links dist meson
install -vDm644 data/shell-completions/bash/meson /usr/share/bash-completion/completions/meson
install -vDm644 data/shell-completions/zsh/_meson /usr/share/zsh/site-functions/_meson
#********</pre>**********
#<p>
#
#  The meaning of the install parameters: 
#</p>

#-w dist 
##<p>
#
#  Puts the created wheels into the dist 
#  directory. 
#</p>

#--find-links dist 
##<p>
#
#  Installs wheels from the dist 
#  directory. 
#</p>

# ==== 8.57.2. Contents of Meson ====

#  Installed programs: meson
#  Installed directory: /usr/lib/python3.13/site-packages/meson-1.8.0.dist-info and /usr/lib/python3.13/site-packages/mesonbuild
# ====== Short Descriptions ======

#--------------------------------------------
# | meson                                    | A high productivity build system        
#--------------------------------------------
cd $topdir
rm -rf $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt
