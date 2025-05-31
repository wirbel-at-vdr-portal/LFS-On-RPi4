#!/usr/bin/bash

# ===== 7.6. Creating Essential Files and Symlinks =====
topdir=$(pwd)
err=0
set -e
chapter=7006
err_report() {
    echo "chapter $chapter: $(date +'%Y.%m.%d %H:%M:%S') Error $? on line $1" | tee >> $topdir/log.txt
}
trap 'err_report $LINENO' ERR
echo "---------" >> $topdir/log.txt
echo chapter $chapter: start = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt

#if [[ -z "${LFS}" ]]; then
#  echo "ERROR: 'LFS' is not set.";stop
#  exit 1
#fi

grep -q $LFS /proc/mounts || err=1
if [ "$err" -eq "1" ]; then
  echo "ERROR: The '$LFS' partition must be mounted.";stop
  exit 1
fi

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

#if [[ "$PS1" != "(lfs chroot) \u:\w\$ " ]]; then
#  echo "ERROR: enter chroot first.";stop
#  exit 1
#fi

#<p>
#
#  Historically, Linux maintained a list of the mounted file systems in the file /etc/mtab 
#  . Modern kernels maintain this list internally and expose it to the user via 
# the /proc 
#  filesystem. To satisfy utilities that expect to find /etc/mtab 
#  , create the following symbolic link: 
#</p>

#********<pre>***********
ln -sv /proc/self/mounts /etc/mtab
#********</pre>**********
#<p>
#
#  Create a basic /etc/hosts 
#  file to be referenced in some test suites, and in one of Perl's configuration 
# files as well: 
#</p>

#********<pre>***********
cat > /etc/hosts << EOF
127.0.0.1  localhost $(hostname)
::1        localhost
EOF
#********</pre>**********
#<p>
#
#  In order for user root 
#  to be able to login and for the name “root”
#  to be recognized, there must be relevant entries in the /etc/passwd 
#  and /etc/group 
#  files. 
#</p>
#<p>
#
#  Create the /etc/passwd 
#  file by running the following command: 
#</p>

#********<pre>***********
cat > /etc/passwd << "EOF"
root:x:0:0:root:/root:/bin/bash
bin:x:1:1:bin:/dev/null:/usr/bin/false
daemon:x:6:6:Daemon User:/dev/null:/usr/bin/false
messagebus:x:18:18:D-Bus Message Daemon User:/run/dbus:/usr/bin/false
uuidd:x:80:80:UUID Generation Daemon User:/dev/null:/usr/bin/false
nobody:x:65534:65534:Unprivileged User:/dev/null:/usr/bin/false
EOF
#********</pre>**********
#<p>
#
#  The actual password for root 
#  will be set later. 
#</p>
#<p>
#
#  Create the /etc/group 
#  file by running the following command: 
#</p>

#********<pre>***********
cat > /etc/group << "EOF"
root:x:0:
bin:x:1:daemon
sys:x:2:
kmem:x:3:
tape:x:4:
tty:x:5:
daemon:x:6:
floppy:x:7:
disk:x:8:
lp:x:9:
dialout:x:10:
audio:x:11:
video:x:12:
utmp:x:13:
cdrom:x:15:
adm:x:16:
messagebus:x:18:
input:x:24:
mail:x:34:
kvm:x:61:
uuidd:x:80:
wheel:x:97:
users:x:999:
nogroup:x:65534:
EOF
#********</pre>**********
#<p>
#
#  The created groups are not part of any standard—they are groups decided on 
# in part by the requirements of the Udev configuration in Chapter 9, and in part 
# by common conventions employed by a number of existing Linux distributions. In 
# addition, some test suites rely on specific users or groups. The Linux Standard 
# Base (LSB, available at [https://refspecs.linuxfoundation.org/lsb.shtml](https://refspecs.linuxfoundation.org/lsb.shtml)
#  ) only recommends that, besides the group root 
#  with a Group ID (GID) of 0, a group bin 
#  with a GID of 1 be present. The GID of 5 is widely used for the tty 
#  group, and the number 5 is also used in /etc/fstab 
#  for the devpts 
#  filesystem. All other group names and GIDs can be chosen freely by the system 
# administrator since well-written programs do not depend on GID numbers, but 
# rather use the group's name. 
#</p>
#<p>
#
#  The ID 65534 is used by the kernel for NFS and separate user namespaces for 
# unmapped users and groups (those exist on the NFS server or the parent user 
# namespace, but “do not exist”
#  on the local machine or in the separate namespace). We assign nobody 
#  and nogroup 
#  to avoid an unnamed ID. But other distros may treat this ID differently, so 
# any portable program should not depend on this assignment. 
#</p>
#<p>
#
#  Some tests in [Chapter 8](../chapter08/chapter08.html)
#  need a regular user. We add this user here and delete this account at the end 
# of that chapter. 
#</p>

#********<pre>***********
echo "tester:x:101:101::/home/tester:/bin/bash" >> /etc/passwd
echo "tester:x:101:" >> /etc/group
install -o tester -d /home/tester
#********</pre>**********
#<p>
#
#  To remove the “I have no name!”
#  prompt, start a new shell. Since the /etc/passwd 
#  and /etc/group 
#  files have been created, user name and group name resolution will now work: 
#</p>

#********<pre>***********
exec /usr/bin/bash --login
#********</pre>**********
#<p>
#
#  The login
#  , agetty
#  , and init
#  programs (and others) use a number of log files to record information such as 
# who was logged into the system and when. However, these programs will not write 
# to the log files if they do not already exist. Initialize the log files and 
# give them proper permissions: 
#</p>

#********<pre>***********
touch /var/log/{btmp,lastlog,faillog,wtmp}
chgrp -v utmp /var/log/lastlog
chmod -v 664  /var/log/lastlog
chmod -v 600  /var/log/btmp
#********</pre>**********
#<p>
#
#  The /var/log/wtmp 
#  file records all logins and logouts. The /var/log/lastlog 
#  file records when each user last logged in. The /var/log/faillog 
#  file records failed login attempts. The /var/log/btmp 
#  file records the bad login attempts. 
#</p>

# ====== Note ======
#<p>
#
#  The /run/utmp 
#  file records the users that are currently logged in. This file is created 
# dynamically in the boot scripts. 
#</p>

# ====== Note ======
#<p>
#
#  The utmp ,wtmp 
#  , btmp 
#  , and lastlog 
#  files use 32-bit integers for timestamps and they'll be fundamentally broken 
# after year 2038. Many packages have stopped using them and other packages are 
# going to stop using them. It is probably best to consider them deprecated. 
#</p>
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt
