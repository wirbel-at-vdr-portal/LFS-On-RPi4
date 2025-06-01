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
