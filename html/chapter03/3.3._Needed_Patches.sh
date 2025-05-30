#!/usr/bin/bash

# ===== 3.3. Needed Patches =====
topdir=$(pwd)
err=0
set -e
chapter=3003
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
#  In addition to the packages, several patches are also required. These patches 
# correct any mistakes in the packages that should be fixed by the maintainer. 
# The patches also make small modifications to make the packages easier to work 
# with. The following patches will be needed to build an LFS system: 
#</p>

#Bzip2 Documentation Patch -1.6 KB:
##<p>
#
#  Download: [https://www.linuxfromscratch.org/patches/lfs/development/bzip2-1.0.8-install_docs-1.patch](https://www.linuxfromscratch.org/patches/lfs/development/bzip2-1.0.8-install_docs-1.patch)
#</p>
#<p>
#
#  MD5 sum: 6a5ac7e89b791aae556de0f745916f7f 
#</p>

#Coreutils Internationalization Fixes Patch -159 KB:
##<p>
#
#  Download: [https://www.linuxfromscratch.org/patches/lfs/development/coreutils-9.7-i18n-1.patch](https://www.linuxfromscratch.org/patches/lfs/development/coreutils-9.7-i18n-1.patch)
#</p>
#<p>
#
#  MD5 sum: 33ebfad32b2dfb8417c3335c08671206 
#</p>

#Expect GCC14 Patch -7.8 KB:
##<p>
#
#  Download: [https://www.linuxfromscratch.org/patches/lfs/development/expect-5.45.4-gcc14-1.patch](https://www.linuxfromscratch.org/patches/lfs/development/expect-5.45.4-gcc14-1.patch)
#</p>
#<p>
#
#  MD5 sum: 0b8b5ac411d011263ad40b0664c669f0 
#</p>

#Glibc FHS Patch -2.8 KB:
##<p>
#
#  Download: [https://www.linuxfromscratch.org/patches/lfs/development/glibc-2.41-fhs-1.patch](https://www.linuxfromscratch.org/patches/lfs/development/glibc-2.41-fhs-1.patch)
#</p>
#<p>
#
#  MD5 sum: 9a5997c3452909b1769918c759eff8a2 
#</p>

#Kbd Backspace/Delete Fix Patch -12 KB:
##<p>
#
#  Download: [https://www.linuxfromscratch.org/patches/lfs/development/kbd-2.7.1-backspace-1.patch](https://www.linuxfromscratch.org/patches/lfs/development/kbd-2.7.1-backspace-1.patch)
#</p>
#<p>
#
#  MD5 sum: f75cca16a38da6caa7d52151f7136895 
#</p>

#SysVinit Consolidated Patch -2.5 KB:
##<p>
#
#  Download: [https://www.linuxfromscratch.org/patches/lfs/development/sysvinit-3.14-consolidated-1.patch](https://www.linuxfromscratch.org/patches/lfs/development/sysvinit-3.14-consolidated-1.patch)
#</p>
#<p>
#
#  MD5 sum: 3af8fd8e13cad481eeeaa48be4247445 
#</p>

# make our sources available for user lfs:

chmod -R 777 src

#<p>
#
#  Total size of these patches: about 185.7 KB 
#</p>
#<p>
#
#  In addition to the above required patches, there exist a number of optional 
# patches created by the LFS community. These optional patches solve minor 
# problems or enable functionality that is not enabled by default. Feel free to 
# peruse the patches database located at [https://www.linuxfromscratch.org/patches/downloads/](https://www.linuxfromscratch.org/patches/downloads/)
#  and acquire any additional patches to suit your system needs. 
#</p>
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt
