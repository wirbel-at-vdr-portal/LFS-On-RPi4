#!/usr/bin/bash

# ===== 9.4. Managing Devices =====
topdir=$(pwd)
err=0
set -e
chapter=9004
err_report() {
    echo "chapter $chapter: $(date +'%Y.%m.%d %H:%M:%S') Error $? on line $1" | tee >> $topdir/log.txt
}
trap 'err_report $LINENO' ERR
echo "---------" >> $topdir/log.txt
echo chapter $chapter: start = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt





# ==== 9.4.1. Network Devices ====
#<p>
#
#  Udev, by default, names network devices according to Firmware/BIOS data or 
# physical characteristics like the bus, slot, or MAC address. The purpose of 
# this naming convention is to ensure that network devices are named 
# consistently, not based on when the network card was discovered. In older 
# versions of Linux—on a computer with two network cards made by Intel and 
# Realtek, for instance—the network card manufactured by Intel might have 
# become eth0 while the Realtek card became eth1. After a reboot, the cards would 
# sometimes get renumbered the other way around. 
#</p>
#<p>
#
#  In the new naming scheme, typical network device names are something like 
# enp5s0 or wlp3s0. If this naming convention is not desired, the traditional 
# naming scheme, or a custom scheme, can be implemented. 
#</p>

# ====== 9.4.1.1. Disabling Persistent Naming on the Kernel Command Line ======
#<p>
#
#  The traditional naming scheme using eth0, eth1, etc. can be restored by adding net.ifnames=0 
#  on the kernel command line. This is most appropriate for systems that have 
# just one ethernet device of a particular type. Laptops often have two ethernet 
# connections named eth0 and wlan0; such laptops can also use this method. The 
# command line is in the GRUB configuration file. See [Section 10.4.4, “Creating the GRUB Configuration File.”](../chapter10/grub.html#grub-cfg)
#</p>

# ====== 9.4.1.2. Creating Custom Udev Rules ======
#<p>
#
#  The naming scheme can be customized by creating custom udev rules. A script 
# has been included that generates the initial rules. Generate these rules by 
# running: 
#</p>

#********<pre>***********
bash /usr/lib/udev/init-net-rules.sh
#********</pre>**********
#<p>
#
#  Now, inspect the /etc/udev/rules.d/70-persistent-net.rules 
#  file, to find out which name was assigned to which network device: 
#</p>

#********<pre>***********
cat /etc/udev/rules.d/70-persistent-net.rules
#********</pre>**********

# ====== Note ======
#<p>
#
#  In some cases, such as when MAC addresses have been assigned to a network card 
# manually, or in a virtual environment such as Qemu or Xen, the network rules 
# file may not be generated because addresses are not consistently assigned. In 
# these cases, this method cannot be used. 
#</p>
#<p>
#
#  The file begins with a comment block, followed by two lines for each NIC. The 
# first line for each NIC is a commented description showing its hardware IDs 
# (e.g. its PCI vendor and device IDs, if it's a PCI card), along with its driver 
# (in parentheses, if the driver can be found). Neither the hardware ID nor the 
# driver is used to determine which name to give an interface; this information 
# is only for reference. The second line is the udev rule that matches this NIC 
# and actually assigns it a name. 
#</p>
#<p>
#
#  All udev rules are made up of several keywords, separated by commas and 
# optional whitespace. Here are the keywords, and an explanation of each one: 
#</p>

# ***** #<p>
#SUBSYSTEM=="net" 
#  - This tells udev to ignore devices that are not network cards. 
#</p>

# ***** #<p>
#ACTION=="add" 
#  - This tells udev to ignore this rule for a uevent that isn't an add ("remove" 
# and "change" uevents also happen, but don't need to rename network interfaces). 
#</p>

# ***** #<p>
#DRIVERS=="?*" 
#  - This exists so that udev will ignore VLAN or bridge sub-interfaces (because 
# these sub-interfaces do not have drivers). These sub-interfaces are skipped 
# because the name that would be assigned would collide with the parent devices. 
#</p>

# ***** #<p>
#ATTR{address} 
#  - The value of this keyword is the NIC's MAC address. 
#</p>

# ***** #<p>
#ATTR{type}=="1" 
#  - This ensures the rule only matches the primary interface in the case of 
# certain wireless drivers which create multiple virtual interfaces. The 
# secondary interfaces are skipped for the same reason that VLAN and bridge 
# sub-interfaces are skipped: there would be a name collision otherwise. 
#</p>

# ***** #<p>
#NAME 
#  - The value of this keyword is the name that udev will assign to this 
# interface. 
#</p>
#<p>
#
#  The value of NAME 
#  is the important part. Make sure you know which name has been assigned to each 
# of your network cards before proceeding, and be sure to use that NAME 
#  value when creating your network configuration files. 
#</p>
#<p>
#
#  Even if the custom udev rule file is created, udev may still assign one or 
# more alternative names for a NIC based on physical characteristics. If a custom 
# udev rule would rename some NIC using a name already assigned as an alternative 
# name of another NIC, this udev rule will fail. If this issue happens, you may 
# create the /etc/udev/network/99-default.link 
#  configuration file with an empty alternative assignment policy, overriding the 
# default configuration file /usr/lib/udev/network/99-default.link 
#  : 
#</p>

#********<pre>***********
sed -e '/^AlternativeNamesPolicy/s/=.*$/=/'  \
       /usr/lib/udev/network/99-default.link \
     > /etc/udev/network/99-default.link
#********</pre>**********

# ==== 9.4.2. CD-ROM Symlinks ====
#<p>
#
#  Some software that you may want to install later (e.g., various media players) 
# expects the /dev/cdrom 
#  and /dev/dvd 
#  symlinks to exist, and to point to a CD-ROM or DVD-ROM device. Also, it may be 
# convenient to put references to those symlinks into /etc/fstab 
#  . Udev comes with a script that will generate rules files to create these 
# symlinks for you, depending on the capabilities of each device, but you need to 
# decide which of two modes of operation you wish to have the script use. 
#</p>
#<p>
#
#  First, the script can operate in “by-path”
#  mode (used by default for USB and FireWire devices), where the rules it 
# creates depend on the physical path to the CD or DVD device. Second, it can 
# operate in “by-id”
#  mode (default for IDE and SCSI devices), where the rules it creates depend on 
# identification strings stored on the CD or DVD device itself. The path is 
# determined by udev's path_id
#  script, and the identification strings are read from the hardware by its ata_id
#  or scsi_id
#  programs, depending on which type of device you have. 
#</p>
#<p>
#
#  There are advantages to each approach; the correct approach depends on what 
# kinds of device changes may happen. If you expect the physical path to the 
# device (that is, the ports and/or slots that it plugs into) to change, for 
# example because you plan on moving the drive to a different IDE port or a 
# different USB connector, then you should use the “by-id”
#  mode. On the other hand, if you expect the device's identification to change, 
# for example because it may die, and you intend to replace it with a different 
# device that plugs into the same connectors, then you should use the “by-path”
#  mode. 
#</p>
#<p>
#
#  If either type of change is possible with your drive, then choose a mode based 
# on the type of change you expect to happen more often. 
#</p>

# ====== Important ======
#<p>
#
#  External devices (for example, a USB-connected CD drive) should not use 
# by-path persistence, because each time the device is plugged into a new 
# external port, its physical path will change. All externally-connected devices 
# will have this problem if you write udev rules to recognize them by their 
# physical path; the problem is not limited to CD and DVD drives. 
#</p>
#<p>
#
#  If you wish to see the values that the udev scripts will use, then for the 
# appropriate CD-ROM device, find the corresponding directory under /sys 
#  (e.g., this can be /sys/block/hdd 
#  ) and run a command similar to the following: 
#</p>

#********<pre>***********
udevadm test /sys/block/hdd
#********</pre>**********
#<p>
#
#  Look at the lines containing the output of various *_id programs. The “by-id”
#  mode will use the ID_SERIAL value if it exists and is not empty, otherwise it 
# will use a combination of ID_MODEL and ID_REVISION. The “by-path”
#  mode will use the ID_PATH value. 
#</p>
#<p>
#
#  If the default mode is not suitable for your situation, then the following 
# modification can be made to the /etc/udev/rules.d/83-cdrom-symlinks.rules 
#  file, as follows (where mode 
#  is one of “by-id”
#  or “by-path”
#  ): 
#</p>

#********<pre>***********
sed -e 's/"write_cd_rules"/"write_cd_rules mode"/' \
    -i /etc/udev/rules.d/83-cdrom-symlinks.rules
#********</pre>**********
#<p>
#
#  Note that it is not necessary to create the rules files or symlinks at this 
# time because you have bind-mounted the host's /dev 
#  directory into the LFS system and we assume the symlinks exist on the host. 
# The rules and symlinks will be created the first time you boot your LFS system. 
#</p>
#<p>
#
#  However, if you have multiple CD-ROM devices, then the symlinks generated at 
# that time may point to different devices than they point to on your host 
# because devices are not discovered in a predictable order. The assignments 
# created when you first boot the LFS system will be stable, so this is only an 
# issue if you need the symlinks on both systems to point to the same device. If 
# you need that, then inspect (and possibly edit) the generated /etc/udev/rules.d/70-persistent-cd.rules 
#  file after booting, to make sure the assigned symlinks match your needs. 
#</p>

# ==== 9.4.3. Dealing with Duplicate Devices ====
#<p>
#
#  As explained in [Section 9.3, “Overview of Device and Module Handling,”](udev.html)
#  the order in which devices with the same function appear in /dev 
#  is essentially random. E.g., if you have a USB web camera and a TV tuner, 
# sometimes /dev/video0 
#  refers to the camera and /dev/video1 
#  refers to the tuner, and sometimes after a reboot the order changes. For all 
# classes of hardware except sound cards and network cards, this is fixable by 
# creating udev rules to create persistent symlinks. The case of network cards is 
# covered separately in [Section 9.5, “General Network Configuration,”](network.html)
#  and sound card configuration can be found in [BLFS](https://www.linuxfromscratch.org/blfs/view/svn/postlfs/devices.html)
#  . 
#</p>
#<p>
#
#  For each of your devices that is likely to have this problem (even if the 
# problem doesn't exist in your current Linux distribution), find the 
# corresponding directory under /sys/class 
#  or /sys/block 
#  . For video devices, this may be /sys/class/video4linux/video 
#  . Figure out the attributes that identify the device uniquely (usually, vendor 
# and product IDs and/or serial numbers work): 
#</p>

#********<pre>***********
udevadm info -a -p /sys/class/video4linux/video0
#********</pre>**********
#<p>
#
#  Then write rules that create the symlinks, e.g.: 
#</p>

#********<pre>***********
cat > /etc/udev/rules.d/83-duplicate_devs.rules << "EOF"

# Persistent symlinks for webcam and tuner
KERNEL=="video*", ATTRS{idProduct}=="1910", ATTRS{idVendor}=="0d81", SYMLINK+="webcam"
KERNEL=="video*", ATTRS{device}=="0x036f",  ATTRS{vendor}=="0x109e", SYMLINK+="tvtuner"

EOF
#********</pre>**********
#<p>
#
#  The result is that /dev/video0 
#  and /dev/video1 
#  devices still refer randomly to the tuner and the web camera (and thus should 
# never be used directly), but there are symlinks /dev/tvtuner 
#  and /dev/webcam 
#  that always point to the correct device. 
#</p>
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt
