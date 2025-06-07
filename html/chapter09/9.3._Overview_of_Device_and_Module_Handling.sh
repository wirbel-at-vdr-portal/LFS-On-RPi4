#!/usr/bin/bash

# ===== 9.3. Overview of Device and Module Handling =====
topdir=$(pwd)
err=0
set -e
chapter=9003
err_report() {
    echo "chapter $chapter: $(date +'%Y.%m.%d %H:%M:%S') Error $? on line $1" | tee >> $topdir/log.txt
}
trap 'err_report $LINENO' ERR
echo "---------" >> $topdir/log.txt
echo chapter $chapter: start = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt




#<p>
#
#  In [Chapter 8](../chapter08/chapter08.html)
#  , we installed the udev daemon when udev
#  was built. Before we go into the details regarding how udev works, a brief 
# history of previous methods of handling devices is in order. 
#</p>
#<p>
#
#  Linux systems in general traditionally used a static device creation method, 
# whereby a great many device nodes were created under /dev 
#  (sometimes literally thousands of nodes), regardless of whether the 
# corresponding hardware devices actually existed. This was typically done via a MAKEDEV
#  script, which contained a number of calls to the mknod
#  program with the relevant major and minor device numbers for every possible 
# device that might exist in the world. 
#</p>
#<p>
#
#  Using the udev method, device nodes are only created for those devices which 
# are detected by the kernel. These device nodes are created each time the system 
# boots; they are stored in a devtmpfs 
#  file system (a virtual file system that resides entirely in system memory). 
# Device nodes do not require much space, so the memory that is used is 
# negligible. 
#</p>

# ==== 9.3.1. History ====
#<p>
#
#  In February 2000, a new filesystem called devfs 
#  was merged into the 2.3.46 kernel and was made available during the 2.4 series 
# of stable kernels. Although it was present in the kernel source itself, this 
# method of creating devices dynamically never received overwhelming support from 
# the core kernel developers. 
#</p>
#<p>
#
#  The main problem with the approach adopted by devfs 
#  was the way it handled device detection, creation, and naming. The latter 
# issue, that of device node naming, was perhaps the most critical. It is 
# generally accepted that if device names are configurable, the device naming 
# policy should be chosen by system administrators, and not imposed on them by 
# the developer(s). The devfs 
#  file system also suffered from race conditions that were inherent in its 
# design; these could not be fixed without a substantial revision of the kernel. devfs 
#  was marked as deprecated for a long time, and was finally removed from the 
# kernel in June, 2006. 
#</p>
#<p>
#
#  With the development of the unstable 2.5 kernel tree, later released as the 
# 2.6 series of stable kernels, a new virtual filesystem called sysfs 
#  came to be. The job of sysfs 
#  is to provide information about the system's hardware configuration to 
# userspace processes. With this userspace-visible representation, it became 
# possible to develop a userspace replacement for devfs 
#  . 
#</p>

# ==== 9.3.2. Udev Implementation ====

# ====== 9.3.2.1. Sysfs ======
#<p>
#
#  The sysfs 
#  filesystem was mentioned briefly above. One may wonder how sysfs 
#  knows about the devices present on a system and what device numbers should be 
# used for them. Drivers that have been compiled into the kernel register their 
# objects in sysfs 
#  (devtmpfs internally) as they are detected by the kernel. For drivers compiled 
# as modules, registration happens when the module is loaded. Once the sysfs 
#  filesystem is mounted (on /sys 
#  ), data which the drivers have registered with sysfs 
#  are available to userspace processes and to udevd for processing (including 
# modifications to device nodes). 
#</p>

# ====== 9.3.2.2. Device Node Creation ======
#<p>
#
#  Device files are created by the kernel in the devtmpfs 
#  file system. Any driver that wishes to register a device node will use the devtmpfs 
#  (via the driver core) to do it. When a devtmpfs 
#  instance is mounted on /dev 
#  , the device node will initially be exposed to userspace with a fixed name, 
# permissions, and owner. 
#</p>
#<p>
#
#  A short time later, the kernel will send a uevent to udevd
#  . Based on the rules specified in the files within the /etc/udev/rules.d 
#  , /usr/lib/udev/rules.d 
#  , and /run/udev/rules.d 
#  directories, udevd
#  will create additional symlinks to the device node, or change its permissions, 
# owner, or group, or modify the internal udevd
#  database entry (name) for that object. 
#</p>
#<p>
#
#  The rules in these three directories are numbered and all three directories 
# are merged together. If udevd
#  can't find a rule for the device it is creating, it will leave the permissions 
# and ownership at whatever devtmpfs 
#  used initially. 
#</p>

# ====== 9.3.2.3. Module Loading ======
#<p>
#
#  Device drivers compiled as modules may have aliases built into them. Aliases 
# are visible in the output of the modinfo
#  program and are usually related to the bus-specific identifiers of devices 
# supported by a module. For example, the snd-fm801
#  driver supports PCI devices with vendor ID 0x1319 and device ID 0x0801, and 
# has an alias of pci:v00001319d00000801sv*sd*bc04sc01i* 
#  . For most devices, the bus driver exports the alias of the driver that would 
# handle the device via sysfs 
#  . E.g., the /sys/bus/pci/devices/0000:00:0d.0/modalias 
#  file might contain the string pci:v00001319d00000801sv00001319sd00001319bc04sc01i00 
#  . The default rules provided with udev will cause udevd
#  to call out to /sbin/modprobe
#  with the contents of the MODALIAS 
#  uevent environment variable (which should be the same as the contents of the modalias 
#  file in sysfs), thus loading all modules whose aliases match this string after 
# wildcard expansion. 
#</p>
#<p>
#
#  In this example, this means that, in addition to snd-fm801
#  , the obsolete (and unwanted) forte
#  driver will be loaded if it is available. See below for ways in which the 
# loading of unwanted drivers can be prevented. 
#</p>
#<p>
#
#  The kernel itself is also able to load modules for network protocols, 
# filesystems, and NLS support on demand. 
#</p>

# ====== 9.3.2.4. Handling Hotpluggable/Dynamic Devices ======
#<p>
#
#  When you plug in a device, such as a Universal Serial Bus (USB) MP3 player, 
# the kernel recognizes that the device is now connected and generates a uevent. 
# This uevent is then handled by udevd
#  as described above. 
#</p>

# ==== 9.3.3. Problems with Loading Modules and Creating Devices ====
#<p>
#
#  There are a few possible problems when it comes to automatically creating 
# device nodes. 
#</p>

# ====== 9.3.3.1. A Kernel Module Is Not Loaded Automatically ======
#<p>
#
#  Udev will only load a module if it has a bus-specific alias and the bus driver 
# properly exports the necessary aliases to sysfs 
#  . In other cases, one should arrange module loading by other means. With 
# Linux-6.14.6, udev is known to load properly-written drivers for INPUT, IDE, 
# PCI, USB, SCSI, SERIO, and FireWire devices. 
#</p>
#<p>
#
#  To determine if the device driver you require has the necessary support for 
# udev, run modinfo
#  with the module name as the argument. Now try locating the device directory 
# under /sys/bus 
#  and check whether there is a modalias 
#  file there. 
#</p>
#<p>
#
#  If the modalias 
#  file exists in sysfs 
#  , the driver supports the device and can talk to it directly, but doesn't have 
# the alias, it is a bug in the driver. Load the driver without the help from 
# udev and expect the issue to be fixed later. 
#</p>
#<p>
#
#  If there is no modalias 
#  file in the relevant directory under /sys/bus 
#  , this means that the kernel developers have not yet added modalias support to 
# this bus type. With Linux-6.14.6, this is the case with ISA busses. Expect this 
# issue to be fixed in later kernel versions. 
#</p>
#<p>
#
#  Udev is not intended to load “wrapper”
#  drivers such as snd-pcm-oss
#  and non-hardware drivers such as loop
#  at all. 
#</p>

# ====== 9.3.3.2. A Kernel Module Is Not Loaded Automatically, and Udev Is Not Intended to Load It ======
#<p>
#
#  If the “wrapper”
#  module only enhances the functionality provided by some other module (e.g., snd-pcm-oss
#  enhances the functionality of snd-pcm
#  by making the sound cards available to OSS applications), configure modprobe
#  to load the wrapper after udev loads the wrapped module. To do this, add a “softdep”
#  line to the corresponding /etc/modprobe.d/ .conf 
#  file. For example: 
#</p>

#********<pre>***********
#softdep snd-pcm post: snd-pcm-oss
#********</pre>**********
#<p>
#
#  Note that the “softdep”
#  command also allows pre: 
#  dependencies, or a mixture of both pre: 
#  and post: 
#  dependencies. See the [modprobe.d(5)](https://man.archlinux.org/man/modprobe.d.5)
#  manual page for more information on “softdep”
#  syntax and capabilities. 
#</p>
#<p>
#
#  If the module in question is not a wrapper and is useful by itself, configure 
# the modules
#  bootscript to load this module on system boot. To do this, add the module name 
# to the /etc/sysconfig/modules 
#  file on a separate line. This works for wrapper modules too, but is suboptimal 
# in that case. 
#</p>

# ====== 9.3.3.3. Udev Loads Some Unwanted Module ======
#<p>
#
#  Either don't build the module, or blacklist it in a /etc/modprobe.d/blacklist.conf 
#  file as done with the forte
#  module in the example below: 
#</p>

#********<pre>***********
#blacklist forte
#********</pre>**********
#<p>
#
#  Blacklisted modules can still be loaded manually with the explicit modprobe
#  command. 
#</p>

# ====== 9.3.3.4. Udev Creates a Device Incorrectly, or Makes the Wrong Symlink ======
#<p>
#
#  This usually happens if a rule unexpectedly matches a device. For example, a 
# poorly-written rule can match both a SCSI disk (as desired) and the 
# corresponding SCSI generic device (incorrectly) by vendor. Find the offending 
# rule and make it more specific, with the help of the udevadm info
#  command. 
#</p>

# ====== 9.3.3.5. Udev Rule Works Unreliably ======
#<p>
#
#  This may be another manifestation of the previous problem. If not, and your 
# rule uses sysfs 
#  attributes, it may be a kernel timing issue, to be fixed in later kernels. For 
# now, you can work around it by creating a rule that waits for the used sysfs 
#  attribute and appending it to the /etc/udev/rules.d/10-wait_for_sysfs.rules 
#  file (create this file if it does not exist). Please notify the LFS 
# Development list if you do so and it helps. 
#</p>

# ====== 9.3.3.6. Udev Does Not Create a Device ======
#<p>
#
#  First, be certain that the driver is built into the kernel or already loaded 
# as a module, and that udev isn't creating a misnamed device. 
#</p>
#<p>
#
#  If a kernel driver does not export its data to sysfs 
#  , udev lacks the information needed to create a device node. This is most 
# likely to happen with third party drivers from outside the kernel tree. Create 
# a static device node in /usr/lib/udev/devices 
#  with the appropriate major/minor numbers (see the file devices.txt 
#  inside the kernel documentation or the documentation provided by the third 
# party driver vendor). The static device node will be copied to /dev 
#  by udev
#  . 
#</p>

# ====== 9.3.3.7. Device Naming Order Changes Randomly After Rebooting ======
#<p>
#
#  This is due to the fact that udev, by design, handles uevents and loads 
# modules in parallel, and thus in an unpredictable order. This will never be “fixed.”
#  You should not rely upon the kernel device names being stable. Instead, create 
# your own rules that make symlinks with stable names based on some stable 
# attributes of the device, such as a serial number or the output of various *_id 
# utilities installed by udev. See [Section 9.4, “Managing Devices”](symlinks.html)
#  and [Section 9.5, “General Network Configuration”](network.html)
#  for examples. 
#</p>

# ==== 9.3.4. Useful Reading ====
#<p>
#
#  Additional helpful documentation is available at the following sites: 
#</p>

# ***** #<p>
#
#  A Userspace Implementation of devfs [http://www.kroah.com/linux/talks/ols_2003_udev_paper/Reprint-Kroah-Hartman-OLS2003.pdf](http://www.kroah.com/linux/talks/ols_2003_udev_paper/Reprint-Kroah-Hartman-OLS2003.pdf)
#</p>

# ***** #<p>
#
#  The sysfs 
#  Filesystem [https://www.kernel.org/pub/linux/kernel/people/mochel/doc/papers/ols-2005/mochel.pdf](https://www.kernel.org/pub/linux/kernel/people/mochel/doc/papers/ols-2005/mochel.pdf)
#</p>
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt
