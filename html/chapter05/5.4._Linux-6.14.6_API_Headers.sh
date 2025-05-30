#!/usr/bin/bash

# ===== 5.4. Linux-6.14.6 API Headers =====
topdir=$(pwd)
err=0
set -e
chapter=5004
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

if [ "$EUID" -eq "0" ]; then
  echo "ERROR: Please run as user lfs"
  exit 1
fi

srcdir=../../src/linux-6.14.6
tar xf ../../src/linux-6.14.6.tar.xz -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir

#<p>
#
#  The Linux API Headers (in linux-6.14.6.tar.xz) expose the kernel's API for use 
# by Glibc. 
#</p>

#  Approximate build time: less than 0.1 SBU
#  Required disk space: 1.6 GB
# ==== 5.4.1. Installation of Linux API Headers ====
#<p>
#
#  The Linux kernel needs to expose an Application Programming Interface (API) 
# for the system's C library (Glibc in LFS) to use. This is done by way of 
# sanitizing various C header files that are shipped in the Linux kernel source 
# tarball. 
#</p>
#<p>
#
#  Make sure there are no stale files embedded in the package: 
#</p>

#********<pre>***********
make mrproper
#********</pre>**********
#<p>
#
#  Now extract the user-visible kernel headers from the source. The recommended 
# make target “headers_install”
#  cannot be used, because it requires rsync
#  , which may not be available. The headers are first placed in ./usr 
#  , then copied to the needed location. 
#</p>

#********<pre>***********
make headers
find usr/include -type f ! -name '*.h' -delete
cp -rv usr/include $LFS/usr
#********</pre>**********

# ==== 5.4.2. Contents of Linux API Headers ====

#  Installed headers: /usr/include/asm/*.h, /usr/include/asm-generic/*.h, /usr/include/drm/*.h, /usr/include/linux/*.h, /usr/include/misc/*.h, /usr/include/mtd/*.h, /usr/include/rdma/*.h, /usr/include/scsi/*.h, /usr/include/sound/*.h, /usr/include/video/*.h, and /usr/include/xen/*.h
#  Installed directories: /usr/include/asm, /usr/include/asm-generic, /usr/include/drm, /usr/include/linux, /usr/include/misc, /usr/include/mtd, /usr/include/rdma, /usr/include/scsi, /usr/include/sound, /usr/include/video, and /usr/include/xen
# ====== Short Descriptions ======

#--------------------------------------------
# | /usr/include/asm/*.h                     | The Linux API ASM Headers               
# | /usr/include/asm-generic/*.h             | The Linux API ASM Generic Headers       
# | /usr/include/drm/*.h                     | The Linux API DRM Headers               
# | /usr/include/linux/*.h                   | The Linux API Linux Headers             
# | /usr/include/misc/*.h                    | The Linux API Miscellaneous Headers     
# | /usr/include/mtd/*.h                     | The Linux API MTD Headers               
# | /usr/include/rdma/*.h                    | The Linux API RDMA Headers              
# | /usr/include/scsi/*.h                    | The Linux API SCSI Headers              
# | /usr/include/sound/*.h                   | The Linux API Sound Headers             
# | /usr/include/video/*.h                   | The Linux API Video Headers             
# | /usr/include/xen/*.h                     | The Linux API Xen Headers               
#--------------------------------------------
cd $topdir
rm -rfv $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt
