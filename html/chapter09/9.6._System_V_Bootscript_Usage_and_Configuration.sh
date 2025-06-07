#!/usr/bin/bash

# ===== 9.6. System V Bootscript Usage and Configuration =====
topdir=$(pwd)
err=0
set -e
chapter=9006
err_report() {
    echo "chapter $chapter: $(date +'%Y.%m.%d %H:%M:%S') Error $? on line $1" | tee >> $topdir/log.txt
}
trap 'err_report $LINENO' ERR
echo "---------" >> $topdir/log.txt
echo chapter $chapter: start = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt




srcdir=../../src/systemd-257.3
tar xf ../../src/systemd-257.3.tar.gz -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir


# ==== 9.6.1. How Do the System V Bootscripts Work? ====
#<p>
#
#  This version of LFS uses a special booting facility named SysVinit, based on a 
# series of run levels
#  . The boot procedure can be quite different from one system to another; the 
# fact that things worked one way in a particular Linux distribution does not 
# guarantee they will work the same way in LFS. LFS has its own way of doing 
# things, but it does respect generally accepted standards. 
#</p>
#<p>
#
#  There is an alternative boot procedure called systemd
#  . We will not discuss that boot process any further here. For a detailed 
# description visit [https://www.linux.com/training-tutorials/understanding-and-using-systemd/](https://www.linux.com/training-tutorials/understanding-and-using-systemd/)
#  . 
#</p>
#<p>
#
#  SysVinit (which will be referred to as “init”
#  from now on) uses a run levels scheme. There are seven run levels, numbered 0 
# to 6. (Actually, there are more run levels, but the others are for special 
# cases and are generally not used. See [init(8)](https://man.archlinux.org/man/init.8)
#  for more details.) Each one of the seven corresponds to actions the computer 
# is supposed to perform when it starts up or shuts down. The default run level 
# is 3. Here are the descriptions of the different run levels as they are 
# implemented in LFS: 
#</p>
#<p>
#
#  0: halt the computer 

#  1: single-user mode 

#  2: reserved for customization, otherwise the same as 3 

#  3: multi-user mode with networking 

#  4: reserved for customization, otherwise the same as 3 

#  5: same as 4, it is usually used for GUI login (like GNOME's  gdm
#   or LXDE's  lxdm
#  ) 

#  6: reboot the computer 
#</p>

# ====== Note ======
#<p>
#
#  Classically, run level 2 above was defined as “multi-user mode without networking,”
#  but this was only the case many years ago when multiple users could connect to 
# a system via serial ports. In today's environment it makes no sense, and we now 
# say it is “reserved.”
#</p>

# ==== 9.6.2. Configuring SysVinit ====
#<p>
#
#  During kernel initialization, the first program that is run (if not overridden 
# on the command line) is init
#  . This program reads the initialization file /etc/inittab 
#  . Create this file with: 
#</p>

#********<pre>***********
cat > /etc/inittab << "EOF"
# Begin /etc/inittab

id:3:initdefault:

si::sysinit:/etc/rc.d/init.d/rc S

l0:0:wait:/etc/rc.d/init.d/rc 0
l1:S1:wait:/etc/rc.d/init.d/rc 1
l2:2:wait:/etc/rc.d/init.d/rc 2
l3:3:wait:/etc/rc.d/init.d/rc 3
l4:4:wait:/etc/rc.d/init.d/rc 4
l5:5:wait:/etc/rc.d/init.d/rc 5
l6:6:wait:/etc/rc.d/init.d/rc 6

ca:12345:ctrlaltdel:/sbin/shutdown -t1 -a -r now

su:S06:once:/sbin/sulogin
s1:1:respawn:/sbin/sulogin

1:2345:respawn:/sbin/agetty --noclear tty1 9600
2:2345:respawn:/sbin/agetty tty2 9600
3:2345:respawn:/sbin/agetty tty3 9600
4:2345:respawn:/sbin/agetty tty4 9600
5:2345:respawn:/sbin/agetty tty5 9600
6:2345:respawn:/sbin/agetty tty6 9600

# End /etc/inittab
EOF
#********</pre>**********
#<p>
#
#  An explanation of this initialization file is in the man page for inittab
#  . In LFS, the key command is rc
#  . The initialization file above instructs rc
#  to run all the scripts starting with an S in the /etc/rc.d/rcS.d 
#  directory followed by all the scripts starting with an S in the /etc/rc.d/rc?.d 
#  directory where the question mark is specified by the initdefault value. 
#</p>
#<p>
#
#  As a convenience, the rc
#  script reads a library of functions in /lib/lsb/init-functions 
#  . This library also reads an optional configuration file, /etc/sysconfig/rc.site 
#  . Any of the system configuration parameters described in subsequent sections 
# can be placed in this file, allowing consolidation of all system parameters in 
# this one file. 
#</p>
#<p>
#
#  As a debugging convenience, the functions script also logs all output to /run/var/bootlog 
#  . Since the /run 
#  directory is a tmpfs, this file is not persistent across boots; however, it is 
# appended to the more permanent file /var/log/boot.log 
#  at the end of the boot process. 
#</p>

# ====== 9.6.2.1. Changing Run Levels ======
#<p>
#
#  Changing run levels is done with init<runlevel> 
#  , where <runlevel> 
#  is the target run level. For example, to reboot the computer, a user could 
# issue the init 6
#  command, which is an alias for the reboot
#  command. Likewise, init 0
#  is an alias for the halt
#  command. 
#</p>
#<p>
#
#  There are a number of directories under /etc/rc.d 
#  that look like rc?.d 
#  (where ? is the number of the run level) and rcS.d 
#  , all containing a number of symbolic links. Some links begin with a K
#  ; the others begin with an S
#  , and all of them have two numbers following the initial letter. The K means 
# to stop (kill) a service and the S means to start a service. The numbers 
# determine the order in which the scripts are run, from 00 to 99—the smaller 
# the number, the sooner the script runs. When init
#  switches to another run level, the appropriate services are either started or 
# stopped, depending on the run level chosen. 
#</p>
#<p>
#
#  The real scripts are in /etc/rc.d/init.d 
#  . They do the actual work, and the symlinks all point to them. K links and S 
# links point to the same script in /etc/rc.d/init.d 
#  . This is because the scripts can be called with different parameters like start 
#  , stop 
#  , restart 
#  , reload 
#  , and status 
#  . When a K link is encountered, the appropriate script is run with the stop 
#  argument. When an S link is encountered, the appropriate script is run with 
# the start 
#  argument. 
#</p>
#<p>
#
#  These are descriptions of what the arguments make the scripts do: 
#</p>

#start 
##<p>
#
#  The service is started. 
#</p>

#stop 
##<p>
#
#  The service is stopped. 
#</p>

#restart 
##<p>
#
#  The service is stopped and then started again. 
#</p>

#reload 
##<p>
#
#  The configuration of the service is updated. This is used after the 
# configuration file of a service was modified, when the service does not need to 
# be restarted. 
#</p>

#status 
##<p>
#
#  Tells if the service is running and with which PIDs. 
#</p>
#<p>
#
#  Feel free to modify the way the boot process works (after all, it is your own 
# LFS system). The files given here are an example of how it can be done. 
#</p>

# ==== 9.6.3. Udev Bootscripts ====
#<p>
#
#  The /etc/rc.d/init.d/udev 
#  initscript starts udevd
#  , triggers any "coldplug" devices that have already been created by the 
# kernel, and waits for any rules to complete. The script also unsets the uevent 
# handler from the default of /sbin/hotplug 
#  . This is done because the kernel no longer needs to call an external binary. 
# Instead, udevd
#  will listen on a netlink socket for uevents that the kernel raises. 
#</p>
#<p>
#
#  The /etc/rc.d/init.d/udev_retry
#  script takes care of re-triggering events for subsystems whose rules may rely 
# on file systems that are not mounted until the mountfs
#  script is run (in particular, /usr 
#  and /var 
#  may cause this). This script runs after the mountfs
#  script, so those rules (if re-triggered) should succeed the second time 
# around. It is configured by the /etc/sysconfig/udev_retry 
#  file; any words in this file other than comments are considered subsystem 
# names to trigger at retry time. To find the subsystem of a device, use udevadm info --attribute-walk <device>
#  where <device> is an absolute path in /dev or /sys, such as /dev/sr0, or 
# /sys/class/rtc. 
#</p>
#<p>
#
#  For information on kernel module loading and udev, see [Section 9.3.2.3, “Module Loading.”](udev.html#module-loading)
#</p>

# ==== 9.6.4. Configuring the System Clock ====
#<p>
#
#  The setclock
#  script reads the time from the hardware clock, also known as the BIOS or 
# Complementary Metal Oxide Semiconductor (CMOS) clock. If the hardware clock is 
# set to UTC, this script will convert the hardware clock's time to the local 
# time using the /etc/localtime 
#  file (which tells the hwclock
#  program which time zone to use). There is no way to detect whether or not the 
# hardware clock is set to UTC, so this must be configured manually. 
#</p>
#<p>
#
#  The setclock
#  program is run via udev
#  when the kernel detects the hardware capability upon boot. It can also be run 
# manually with the stop parameter to store the system time to the CMOS clock. 
#</p>
#<p>
#
#  If you cannot remember whether or not the hardware clock is set to UTC, find 
# out by running the hwclock --localtime --show 
#  command. This will display what the current time is according to the hardware 
# clock. If this time matches whatever your watch says, then the hardware clock 
# is set to local time. If the output from hwclock
#  is not local time, chances are it is set to UTC time. Verify this by adding or 
# subtracting the proper number of hours for your time zone to the time shown by hwclock
#  . For example, if you are currently in the MST time zone, which is also known 
# as GMT -0700, add seven hours to the local time. 
#</p>
#<p>
#
#  Change the value of the UTC 
#  variable below to a value of 0 
#  (zero) if the hardware clock is NOT
#  set to UTC time. 
#</p>
#<p>
#
#  Create a new file /etc/sysconfig/clock 
#  by running the following: 
#</p>

#********<pre>***********
cat > /etc/sysconfig/clock << "EOF"
# Begin /etc/sysconfig/clock

UTC=1

# Set this to any options you might need to give to hwclock,
# such as machine hardware clock type for Alphas.
CLOCKPARAMS=

# End /etc/sysconfig/clock
EOF
#********</pre>**********
#<p>
#
#  A good hint explaining how to deal with time on LFS is available at [https://www.linuxfromscratch.org/hints/downloads/files/time.txt](https://www.linuxfromscratch.org/hints/downloads/files/time.txt)
#  . It explains issues such as time zones, UTC, and the TZ 
#  environment variable. 
#</p>

# ====== Note ======
#<p>
#
#  The CLOCKPARAMS and UTC parameters may also be set in the /etc/sysconfig/rc.site 
#  file. 
#</p>

# ==== 9.6.5. Configuring the Linux Console ====
#<p>
#
#  This section discusses how to configure the console
#  bootscript that sets up the keyboard map, console font, and console kernel log 
# level. If non-ASCII characters (e.g., the copyright sign, the British pound 
# sign, and the Euro symbol) will not be used and the keyboard is a U.S. one, 
# much of this section can be skipped. Without the configuration file, (or 
# equivalent settings in rc.site 
#  ), the console
#  bootscript will do nothing. 
#</p>
#<p>
#
#  The console
#  script reads the /etc/sysconfig/console 
#  file for configuration information. Decide which keymap and screen font will 
# be used. Various language-specific HOWTOs can also help with this; see [https://tldp.org/HOWTO/HOWTO-INDEX/other-lang.html](https://tldp.org/HOWTO/HOWTO-INDEX/other-lang.html)
#  . If still in doubt, look in the /usr/share/keymaps 
#  and /usr/share/consolefonts 
#  directories for valid keymaps and screen fonts. Read the [loadkeys(1)](https://man.archlinux.org/man/loadkeys.1)
#  and [setfont(8)](https://man.archlinux.org/man/setfont.8)
#  manual pages to determine the correct arguments for these programs. 
#</p>
#<p>
#
#  The /etc/sysconfig/console 
#  file should contain lines of the form: VARIABLE=value 
#  . The following variables are recognized: 
#</p>

#LOGLEVEL
##<p>
#
#  This variable specifies the log level for kernel messages sent to the console 
# as set by dmesg -n
#  . Valid levels are from 1 
#  (no messages) to 8 
#  . The default level is 7 
#  , which is quite verbose. 
#</p>

#KEYMAP
##<p>
#
#  This variable specifies the arguments for the loadkeys
#  program, typically, the name of the keymap to load, e.g., it 
#  . If this variable is not set, the bootscript will not run the loadkeys
#  program, and the default kernel keymap will be used. Note that a few keymaps 
# have multiple versions with the same name (cz and its variants in qwerty/ and 
# qwertz/, es in olpc/ and qwerty/, and trf in fgGIod/ and qwerty/). In these 
# cases the parent directory should also be specified (e.g. qwerty/es) to ensure 
# the proper keymap is loaded. 
#</p>

#KEYMAP_CORRECTIONS
##<p>
#
#  This (rarely used) variable specifies the arguments for the second call to the loadkeys
#  program. This is useful if the stock keymap is not completely satisfactory and 
# a small adjustment has to be made. E.g., to include the Euro sign into a keymap 
# that normally doesn't have it, set this variable to euro2 
#  . 
#</p>

#FONT
##<p>
#
#  This variable specifies the arguments for the setfont
#  program. Typically, this includes the font name, -m 
#  , and the name of the application character map to load. E.g., in order to 
# load the “lat1-16”
#  font together with the “8859-1”
#  application character map (appropriate in the USA), set this variable to lat1-16 -m 8859-1 
#  . In UTF-8 mode, the kernel uses the application character map to convert 
# 8-bit key codes to UTF-8. Therefore the argument of the "-m" parameter should 
# be set to the encoding of the composed key codes in the keymap. 
#</p>

#UNICODE
##<p>
#
#  Set this variable to 1 
#  , yes 
#  , or true 
#  in order to put the console into UTF-8 mode. This is useful in UTF-8 based 
# locales and harmful otherwise. 
#</p>

#LEGACY_CHARSET
##<p>
#
#  For many keyboard layouts, there is no stock Unicode keymap in the Kbd 
# package. The console
#  bootscript will convert an available keymap to UTF-8 on the fly if this 
# variable is set to the encoding of the available non-UTF-8 keymap. 
#</p>
#<p>
#
#  Some examples: 
#</p>

# ***** #<p>
#
#  We'll use C.UTF-8 
#  as the locale for interactive sessions in the Linux console in [Section 9.7, “Configuring the System Locale,”](locale.html)
#  so we should set UNICODE 
#  to 1 
#  . And the console fonts shipped by the Kbd
#  package containing the glyphs for all characters from the program messages in 
# the C.UTF-8 
#  locale are LatArCyrHeb*.psfu.gz 
#  , LatGrkCyr*.psfu.gz 
#  , Lat2-Terminus16.psfu.gz 
#  , and pancyrillic.f16.psfu.gz 
#  in /usr/share/consolefonts 
#  (the other shipped console fonts lack glyphs of some characters like the 
# Unicode left/right quotation marks and the Unicode English dash). So set one of 
# them, for example Lat2-Terminus16.psfu.gz 
#  as the default console font: 
#</p>

#********<pre>***********
cat > /etc/sysconfig/console << "EOF"
# Begin /etc/sysconfig/console

UNICODE="1"
FONT="Lat2-Terminus16"

# End /etc/sysconfig/console
EOF
#********</pre>**********

# ***** #<p>
#
#  For a non-Unicode setup, only the KEYMAP and FONT variables are generally 
# needed. E.g., for a Polish setup, one would use: 
#</p>

#********<pre>***********
cat > /etc/sysconfig/console << "EOF"
# Begin /etc/sysconfig/console

KEYMAP="pl2"
FONT="lat2a-16 -m 8859-2"

# End /etc/sysconfig/console
EOF
#********</pre>**********

# ***** #<p>
#
#  As mentioned above, it is sometimes necessary to adjust a stock keymap 
# slightly. The following example adds the Euro symbol to the German keymap: 
#</p>

#********<pre>***********
cat > /etc/sysconfig/console << "EOF"
# Begin /etc/sysconfig/console

KEYMAP="de-latin1"
KEYMAP_CORRECTIONS="euro2"
FONT="lat0-16 -m 8859-15"
UNICODE="1"

# End /etc/sysconfig/console
EOF
#********</pre>**********

# ***** #<p>
#
#  The following is a Unicode-enabled example for Bulgarian, where a stock UTF-8 
# keymap exists: 
#</p>

#********<pre>***********
cat > /etc/sysconfig/console << "EOF"
# Begin /etc/sysconfig/console

UNICODE="1"
KEYMAP="bg_bds-utf8"
FONT="LatArCyrHeb-16"

# End /etc/sysconfig/console
EOF
#********</pre>**********

# ***** #<p>
#
#  Due to the use of a 512-glyph LatArCyrHeb-16 font in the previous example, 
# bright colors are no longer available on the Linux console unless a framebuffer 
# is used. If one wants to have bright colors without a framebuffer and can live 
# without characters not belonging to his language, it is still possible to use a 
# language-specific 256-glyph font, as illustrated below: 
#</p>

#********<pre>***********
cat > /etc/sysconfig/console << "EOF"
# Begin /etc/sysconfig/console

UNICODE="1"
KEYMAP="bg_bds-utf8"
FONT="cyr-sun16"

# End /etc/sysconfig/console
EOF
#********</pre>**********

# ***** #<p>
#
#  The following example illustrates keymap autoconversion from ISO-8859-15 to 
# UTF-8 and enabling dead keys in Unicode mode: 
#</p>

#********<pre>***********
cat > /etc/sysconfig/console << "EOF"
# Begin /etc/sysconfig/console

UNICODE="1"
KEYMAP="de-latin1"
KEYMAP_CORRECTIONS="euro2"
LEGACY_CHARSET="iso-8859-15"
FONT="LatArCyrHeb-16 -m 8859-15"

# End /etc/sysconfig/console
EOF
#********</pre>**********

# ***** #<p>
#
#  Some keymaps have dead keys (i.e., keys that don't produce a character by 
# themselves, but put an accent on the character produced by the next key) or 
# define composition rules (such as: “press Ctrl+. A E to get Æ”
#  in the default keymap). Linux-6.14.6 interprets dead keys and composition 
# rules in the keymap correctly only when the source characters to be composed 
# together are not multibyte. This deficiency doesn't affect keymaps for European 
# languages, because there accents are added to unaccented ASCII characters, or 
# two ASCII characters are composed together. However, in UTF-8 mode it is a 
# problem; e.g., for the Greek language, where one sometimes needs to put an 
# accent on the letter α. The solution is either to avoid the use of UTF-8, or 
# to install the X window system, which doesn't have this limitation, in its 
# input handling. 
#</p>

# ***** #<p>
#
#  For Chinese, Japanese, Korean, and some other languages, the Linux console 
# cannot be configured to display the needed characters. Users who need such 
# languages should install the X Window System, fonts that cover the necessary 
# character ranges, and the proper input method (e.g., SCIM supports a wide 
# variety of languages). 
#</p>

# ====== Note ======
#<p>
#
#  The /etc/sysconfig/console 
#  file only controls the Linux text console localization. It has nothing to do 
# with setting the proper keyboard layout and terminal fonts in the X Window 
# System, with ssh sessions, or with a serial console. In such situations, 
# limitations mentioned in the last two list items above do not apply. 
#</p>

# ==== 9.6.6. Creating Files at Boot ====
#<p>
#
#  At times, it is desirable to create files at boot time. For instance, the /tmp/.ICE-unix 
#  directory is often needed. This can be done by creating an entry in the /etc/sysconfig/createfiles 
#  configuration script. The format of this file is embedded in the comments of 
# the default configuration file. 
#</p>

# ==== 9.6.7. Configuring the Sysklogd Script ====
#<p>
#
#  The sysklogd 
#  script invokes the syslogd
#  program as a part of System V initialization. The -m 0 
#  option turns off the periodic timestamp mark that syslogd
#  writes to the log files every 20 minutes by default. If you want to turn on 
# this periodic timestamp mark, edit /etc/sysconfig/rc.site 
#  and define the variable SYSKLOGD_PARMS to the desired value. For instance, to 
# remove all parameters, set the variable to a null value: 
#</p>

#********<pre>***********
#SYSKLOGD_PARMS=
#********</pre>**********
#<p>
#
#  See man syslogd 
#  for more options. 
#</p>

# ==== 9.6.8. The rc.site File ====
#<p>
#
#  The optional /etc/sysconfig/rc.site 
#  file contains settings that are automatically set for each SystemV boot 
# script. It can alternatively set the values specified in the hostname 
#  , console 
#  , and clock 
#  files in the /etc/sysconfig/ 
#  directory. If the associated variables are present in both these separate 
# files and rc.site 
#  , the values in the script-specific files take effect. 
#</p>
#<p>
#rc.site 
#  also contains parameters that can customize other aspects of the boot process. 
# Setting the IPROMPT variable will enable selective running of bootscripts. 
# Other options are described in the file comments. The default version of the 
# file is as follows: 
#</p>

#********<pre>***********
# rc.site
# Optional parameters for boot scripts.

# Distro Information
# These values, if specified here, override the defaults
#DISTRO="Linux From Scratch" # The distro name
#DISTRO_CONTACT="lfs-dev@lists.linuxfromscratch.org" # Bug report address
#DISTRO_MINI="LFS" # Short name used in filenames for distro config

# Define custom colors used in messages printed to the screen

# Please consult `man console_codes` for more information
# under the "ECMA-48 Set Graphics Rendition" section
#
# Warning: when switching from a 8bit to a 9bit font,
# the linux console will reinterpret the bold (1;) to
# the top 256 glyphs of the 9bit font.  This does
# not affect framebuffer consoles

# These values, if specified here, override the defaults
#BRACKET="\\033[1;34m" # Blue
#FAILURE="\\033[1;31m" # Red
#INFO="\\033[1;36m"    # Cyan
#NORMAL="\\033[0;39m"  # Grey
#SUCCESS="\\033[1;32m" # Green
#WARNING="\\033[1;33m" # Yellow

# Use a colored prefix
# These values, if specified here, override the defaults
#BMPREFIX="      "
#SUCCESS_PREFIX="${SUCCESS}  *  ${NORMAL} "
#FAILURE_PREFIX="${FAILURE}*****${NORMAL} "
#WARNING_PREFIX="${WARNING} *** ${NORMAL} "

# Manually set the right edge of message output (characters)
# Useful when resetting console font during boot to override
# automatic screen width detection
#COLUMNS=120

# Interactive startup
#IPROMPT="yes" # Whether to display the interactive boot prompt
#itime="3"    # The amount of time (in seconds) to display the prompt

# The total length of the distro welcome string, without escape codes
#wlen=$(echo "Welcome to ${DISTRO}" | wc -c )
#welcome_message="Welcome to ${INFO}${DISTRO}${NORMAL}"

# The total length of the interactive string, without escape codes
#ilen=$(echo "Press 'I' to enter interactive startup" | wc -c )
#i_message="Press '${FAILURE}I${NORMAL}' to enter interactive startup"

# Set scripts to skip the file system check on reboot
#FASTBOOT=yes

# Skip reading from the console
#HEADLESS=yes

# Write out fsck progress if yes
#VERBOSE_FSCK=no

# Speed up boot without waiting for settle in udev
#OMIT_UDEV_SETTLE=y

# Speed up boot without waiting for settle in udev_retry
#OMIT_UDEV_RETRY_SETTLE=yes

# Skip cleaning /tmp if yes
#SKIPTMPCLEAN=no

# For setclock
#UTC=1
#CLOCKPARAMS=

# For consolelog (Note that the default, 7=debug, is noisy)
#LOGLEVEL=7

# For network
#HOSTNAME=mylfs

# Delay between TERM and KILL signals at shutdown
#KILLDELAY=3

# Optional sysklogd parameters
#SYSKLOGD_PARMS="-m 0"

# Console parameters
#UNICODE=1
#KEYMAP="de-latin1"
#KEYMAP_CORRECTIONS="euro2"
#FONT="lat0-16 -m 8859-15"
#LEGACY_CHARSET=


#********</pre>**********

# ====== 9.6.8.1. Customizing the Boot and Shutdown Scripts ======
#<p>
#
#  The LFS boot scripts boot and shut down a system in a fairly efficient manner, 
# but there are a few tweaks you can make in the rc.site file to improve speed 
# even more, and to adjust messages according to your preferences. To do this, 
# adjust the settings in the /etc/sysconfig/rc.site 
#  file above. 
#</p>

# ***** #<p>
#
#  During the boot script udev 
#  , there is a call to udev settle
#  that requires some time to complete. This time may or may not be required 
# depending on the devices in the system. If you only have simple partitions and 
# a single ethernet card, the boot process will probably not need to wait for 
# this command. To skip it, set the variable OMIT_UDEV_SETTLE=y. 
#</p>

# ***** #<p>
#
#  The boot script udev_retry 
#  also runs udev settle
#  by default. This command is only needed if the /var 
#  directory is separately mounted, because the clock needs the /var/lib/hwclock/adjtime 
#  file. Other customizations may also need to wait for udev to complete, but in 
# many installations it is not necessary. Skip the command by setting the 
# variable OMIT_UDEV_RETRY_SETTLE=y. 
#</p>

# ***** #<p>
#
#  By default, the file system checks are silent. This can appear to be a delay 
# during the bootup process. To turn on the fsck
#  output, set the variable VERBOSE_FSCK=y. 
#</p>

# ***** #<p>
#
#  When rebooting, you may want to skip the filesystem check, fsck
#  , completely. To do this, either create the file /fastboot 
#  or reboot the system with the command /sbin/shutdown -f -r now
#  . On the other hand, you can force all file systems to be checked by creating /forcefsck 
#  or running shutdown
#  with the -F 
#  parameter instead of -f 
#  . 
#</p>
#<p>
#
#  Setting the variable FASTBOOT=y will disable fsck
#  during the boot process until it is removed. This is not recommended on a 
# permanent basis. 
#</p>

# ***** #<p>
#
#  Normally, all files in the /tmp 
#  directory are deleted at boot time. Depending on the number of files or 
# directories present, this can cause a noticeable delay in the boot process. To 
# skip removing these files set the variable SKIPTMPCLEAN=y. 
#</p>

# ***** #<p>
#
#  During shutdown, the init
#  program sends a TERM signal to each program it has started (e.g. agetty), 
# waits for a set time (default 3 seconds), then sends each process a KILL signal 
# and waits again. This process is repeated in the sendsignals
#  script for any processes that are not shut down by their own scripts. The 
# delay for init
#  can be set by passing a parameter. For example to remove the delay in init
#  , pass the -t0 parameter when shutting down or rebooting (e.g. /sbin/shutdown -t0 -r now
#  ). The delay for the sendsignals
#  script can be skipped by setting the parameter KILLDELAY=0. 
#</p>

cd $topdir
rm -rfv $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt
