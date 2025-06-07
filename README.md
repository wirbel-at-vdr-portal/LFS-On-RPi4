# LFS-On-RPi4

Just a backup, how to install Linux From Scratch on a Raspberry Pi 4. Host system for build is Raspberry Pi OS (64bit, aarch64).

Th scripts here are generated from html files. Any bash script needs to be revised and checked.
Sometimes, really stupid errors are done by my parser. However, those scripts add a layer of safety into a LFS build.

The chroot env cannot be done in a script; so this has to be done manually.

Changes to LFS dev so far:
- add ``--build=aarch64-unknown-linux-gnu`` flag to configure for some .configure calls
- Glibc-2.41, change time zone to Europe/Berlin
- change the lib64 fix for gcc-14.2.0
- compared the results to aarch64 instead of x86_64 for gcc and glibc tests, ie /lib64/ld-linux-x86-64.so.2 => /lib64/ld-linux-aarch64.so.1
- set paper size to A4 for groff
- 8.84 stripping is not done.
- chapter09 is done by hand
- 10.2 /etc/fstab is taken from raspbian

## Getting the system bootable again
```cd /mnt/sdcard/
tar -xpf lfs-2025-r12.3-62-aarch64.tar.xz
mkdir _backup



I want to keep the original /boot and /dev folder, and not the lfs ones:
mv boot _backup
mv dev _backup
mv _boot boot
mv _dev dev

mv _bin _backup
mv _etc _backup
mv _home _backup
mv _var _backup
mv _usr _backup
mv _tmp _backup
mv _sys _backup
mv _srv _backup
mv _sbin _backup
mv _run _backup
mv _root _backup
mv _proc _backup
mv _opt _backup
mv _mnt _backup
mv _media _backup
mv _lost+found/ _backup/
mv _lib _backup
mv lfs-2025-r12.3-62-aarch64.tar.xz usr/src
mv _backup usr/src

cd /
umount /mnt/sdcard
```
  
