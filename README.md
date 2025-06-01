# LFS-On-RPi4

Just a backup, how to install Linux From Scratch on a Raspberry Pi 4. Host system for build is Raspberry Pi OS (64bit, aarch64).

Th scripts here are generated from html files. Any bash script needs to be revised and checked.
Sometimes, really stupid errors are done by my parser. However, those scripts add a layer of safety into a LFS build.

The chroot env cannot be done in a script; so this has to be done manually.

Changes to LFS dev so far:
- add ``--build=aarch64-unknown-linux-gnu`` flag to configure for some .configure calls
- change the lib64 fix for gcc-14.2.0
