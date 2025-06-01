#!/usr/bin/bash

# ===== 8.64. GRUB-2.12 =====
topdir=$(pwd)
err=0
set -e
chapter=8064
err_report() {
    echo "chapter $chapter: $(date +'%Y.%m.%d %H:%M:%S') Error $? on line $1" | tee >> $topdir/log.txt
}
trap 'err_report $LINENO' ERR
echo "---------" >> $topdir/log.txt
echo chapter $chapter: start = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt






srcdir=../../src/grub-2.12
tar xf ../../src/grub-2.12.tar.xz -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir

#<p>
#
#  The GRUB package contains the GRand Unified Bootloader. 
#</p>

#  Approximate build time: 0.3 SBU
#  Required disk space: 166 MB
# ==== 8.64.1. Installation of GRUB ====

# ====== Note ======
#<p>
#
#  If your system has UEFI support and you wish to boot LFS with UEFI, you need 
# to install GRUB with UEFI support (and its dependencies) by following the 
# instructions on [the BLFS page](https://www.linuxfromscratch.org/blfs/view/svn/postlfs/grub-efi.html)
#  . You may skip this package, or install this package and the BLFS GRUB for 
# UEFI package without conflict (the BLFS page provides instructions for both 
# cases). 
#</p>

# ====== Warning ======
#<p>
#
#  Unset any environment variables which may affect the build: 
#</p>

#********<pre>***********
unset {C,CPP,CXX,LD}FLAGS
#********</pre>**********
#<p>
#
#  Don't try “tuning”
#  this package with custom compilation flags. This package is a bootloader. The 
# low-level operations in the source code may be broken by aggressive 
# optimization. 
#</p>
#<p>
#
#  Add a file missing from the release tarball: 
#</p>

#********<pre>***********
echo depends bli part_gpt > grub-core/extra_deps.lst
#********</pre>**********
#<p>
#
#  Prepare GRUB for compilation: 
#</p>

#********<pre>***********
./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --disable-efiemu  \
            --disable-werror
#********</pre>**********
#<p>
#
#  The meaning of the new configure options: 
#</p>

#--disable-werror 
##<p>
#
#  This allows the build to complete with warnings introduced by more recent 
# versions of Flex. 
#</p>

#--disable-efiemu 
##<p>
#
#  This option minimizes what is built by disabling a feature and eliminating 
# some test programs not needed for LFS. 
#</p>
#<p>
#
#  Compile the package: 
#</p>

#********<pre>***********
make
#********</pre>**********
#<p>
#
#  The test suite for this packages is not recommended. Most of the tests depend 
# on packages that are not available in the limited LFS environment. To run the 
# tests anyway, run #make check
#  . 
#</p>
#<p>
#
#  Install the package, and move the Bash completion support file to the location 
# recommended by the Bash completion maintainers: 
#</p>

#********<pre>***********
make install
mv -v /etc/bash_completion.d/grub /usr/share/bash-completion/completions
#********</pre>**********
#<p>
#
#  Making your LFS system bootable with GRUB will be discussed in [Section 10.4, “Using GRUB to Set Up the Boot Process.”](../chapter10/grub.html)
#</p>

# ==== 8.64.2. Contents of GRUB ====

#  Installed programs: grub-bios-setup, grub-editenv, grub-file, grub-fstest, grub-glue-efi, grub-install, grub-kbdcomp, grub-macbless, grub-menulst2cfg, grub-mkconfig, grub-mkimage, grub-mklayout, grub-mknetdir, grub-mkpasswd-pbkdf2, grub-mkrelpath, grub-mkrescue, grub-mkstandalone, grub-ofpathname, grub-probe, grub-reboot, grub-render-label, grub-script-check, grub-set-default, grub-sparc64-setup, and grub-syslinux2cfg
#  Installed directories: /usr/lib/grub, /etc/grub.d, /usr/share/grub, and /boot/grub (when grub-install is first run)
# ====== Short Descriptions ======

#--------------------------------------------
# | grub-bios-setup                          | Is a helper program for                 grub-install                            
# | grub-editenv                             | Is a tool to edit the environment block 
# | grub-file                                | Checks to see if the given file is of the specified type
# | grub-fstest                              | Is a tool to debug the file system driver
# | grub-glue-efi                            | Glues 32-bit and 64-bit binaries into a single file (for Apple machines)
# | grub-install                             | Installs GRUB on your drive             
# | grub-kbdcomp                             | Is a script that converts an xkb layout into one recognized by GRUB
# | grub-macbless                            | Is the Mac-style bless for HFS or HFS+ file systems (bless                                   is peculiar to Apple machines; it makes a device bootable)
# | grub-menulst2cfg                         | Converts a GRUB Legacy                  menu.lst                                into a                                  grub.cfg                                for use with GRUB 2                     
# | grub-mkconfig                            | Generates a                             grub.cfg                                file                                    
# | grub-mkimage                             | Makes a bootable image of GRUB          
# | grub-mklayout                            | Generates a GRUB keyboard layout file   
# | grub-mknetdir                            | Prepares a GRUB netboot directory       
# | grub-mkpasswd-pbkdf2                     | Generates an encrypted PBKDF2 password for use in the boot menu
# | grub-mkrelpath                           | Makes a system pathname relative to its root
# | grub-mkrescue                            | Makes a bootable image of GRUB suitable for a floppy disk, CDROM/DVD, or a USB drive
# | grub-mkstandalone                        | Generates a standalone image            
# | grub-ofpathname                          | Is a helper program that prints the path to a GRUB device
# | grub-probe                               | Probes device information for a given path or device
# | grub-reboot                              | Sets the default boot entry for GRUB for the next boot only
# | grub-render-label                        | Renders Apple .disk_label for Apple Macs
# | grub-script-check                        | Checks the GRUB configuration script for syntax errors
# | grub-set-default                         | Sets the default boot entry for GRUB    
# | grub-sparc64-setup                       | Is a helper program for grub-setup      
# | grub-syslinux2cfg                        | Transforms a syslinux config file into grub.cfg format
#--------------------------------------------
cd $topdir
rm -rf $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt
