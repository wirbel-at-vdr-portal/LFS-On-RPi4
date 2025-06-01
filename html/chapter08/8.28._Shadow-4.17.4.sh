#!/usr/bin/bash

# ===== 8.28. Shadow-4.17.4 =====
topdir=$(pwd)
err=0
set -e
chapter=8028
err_report() {
    echo "chapter $chapter: $(date +'%Y.%m.%d %H:%M:%S') Error $? on line $1" | tee >> $topdir/log.txt
}
trap 'err_report $LINENO' ERR
echo "---------" >> $topdir/log.txt
echo chapter $chapter: start = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt




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



srcdir=../../src/shadow-4.17.4
tar xf ../../src/shadow-4.17.4.tar.xz -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir

#<p>
#
#  The Shadow package contains programs for handling passwords in a secure way. 
#</p>

#  Approximate build time: 0.1 SBU
#  Required disk space: 114 MB
# ==== 8.28.1. Installation of Shadow ====

# ====== Important ======
#<p>
#
#  If you've installed Linux-PAM, you should follow [the BLFS instruction](https://www.linuxfromscratch.org/blfs/view/svn/postlfs/shadow.html)
#  instead of this page to build (or, rebuild or upgrade) shadow. 
#</p>

# ====== Note ======
#<p>
#
#  If you would like to enforce the use of strong passwords, [install and configure Linux-PAM](https://www.linuxfromscratch.org/blfs/view/svn/postlfs/linux-pam.html)
#  first. Then [install and configure shadow with the PAM support](https://www.linuxfromscratch.org/blfs/view/svn/postlfs/shadow.html)
#  . Finally [install libpwquality and configure PAM to use it](https://www.linuxfromscratch.org/blfs/view/svn/postlfs/libpwquality.html)
#  . 
#</p>
#<p>
#
#  Disable the installation of the groups
#  program and its man pages, as Coreutils provides a better version. Also, 
# prevent the installation of manual pages that were already installed in [Section 8.3, “Man-pages-6.14”](man-pages.html)
#  : 
#</p>

#********<pre>***********
sed -i 's/groups$(EXEEXT) //' src/Makefile.in
find man -name Makefile.in -exec sed -i 's/groups\.1 / /'   {} \;
find man -name Makefile.in -exec sed -i 's/getspnam\.3 / /' {} \;
find man -name Makefile.in -exec sed -i 's/passwd\.5 / /'   {} \;
#********</pre>**********
#<p>
#
#  Instead of using the default crypt
#  method, use the much more secure YESCRYPT
#  method of password encryption, which also allows passwords longer than 8 
# characters. It is also necessary to change the obsolete /var/spool/mail 
#  location for user mailboxes that Shadow uses by default to the /var/mail 
#  location used currently. And, remove /bin 
#  and /sbin 
#  from the PATH 
#  , since they are simply symlinks to their counterparts in /usr 
#  . 
#</p>

# ====== Warning ======
#<p>
#
#  Including /bin 
#  and/or /sbin 
#  in the PATH 
#  variable may cause some BLFS packages fail to build, so don't do that in the .bashrc 
#  file or anywhere else. 
#</p>

#********<pre>***********
sed -e 's:#ENCRYPT_METHOD DES:ENCRYPT_METHOD YESCRYPT:' \
    -e 's:/var/spool/mail:/var/mail:'                   \
    -e '/PATH=/{s@/sbin:@@;s@/bin:@@}'                  \
    -i etc/login.defs
#********</pre>**********
#<p>
#
#  Prepare Shadow for compilation: 
#</p>

#********<pre>***********
touch /usr/bin/passwd
./configure --sysconfdir=/etc   \
            --disable-static    \
            --with-{b,yes}crypt \
            --without-libbsd    \
            --with-group-name-max-length=32
#********</pre>**********
#<p>
#
#  The meaning of the new configuration options: 
#</p>

#touch /usr/bin/passwd
##<p>
#
#  The file /usr/bin/passwd 
#  needs to exist because its location is hardcoded in some programs; if it does 
# not already exist, the installation script will create it in the wrong place. 
#</p>

#--with-{b,yes}crypt 
##<p>
#
#  The shell expands this to two switches, --with-bcrypt 
#  and --with-yescrypt 
#  . They allow shadow to use the Bcrypt and Yescrypt algorithms implemented by Libxcrypt
#  for hashing passwords. These algorithms are more secure (in particular, much 
# more resistant to GPU-based attacks) than the traditional SHA algorithms. 
#</p>

#--with-group-name-max-length=32 
##<p>
#
#  The longest permissible user name is 32 characters. Make the maximum length of 
# a group name the same. 
#</p>

#--without-libbsd 
##<p>
#
#  Do not use the readpassphrase function from libbsd which is not in LFS. Use 
# the internal copy instead. 
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
#  This package does not come with a test suite. 
#</p>
#<p>
#
#  Install the package: 
#</p>

#********<pre>***********
make exec_prefix=/usr install
make -C man install-man
#********</pre>**********

# ==== 8.28.2. Configuring Shadow ====
#<p>
#
#  This package contains utilities to add, modify, and delete users and groups; 
# set and change their passwords; and perform other administrative tasks. For a 
# full explanation of what password shadowing
#  means, see the doc/HOWTO 
#  file within the unpacked source tree. If you use Shadow support, keep in mind 
# that programs which need to verify passwords (display managers, FTP programs, 
# pop3 daemons, etc.) must be Shadow-compliant. That is, they must be able to 
# work with shadowed passwords. 
#</p>
#<p>
#
#  To enable shadowed passwords, run the following command: 
#</p>

#********<pre>***********
pwconv
#********</pre>**********
#<p>
#
#  To enable shadowed group passwords, run: 
#</p>

#********<pre>***********
grpconv
#********</pre>**********
#<p>
#
#  Shadow's default configuration for the useradd
#  utility needs some explanation. First, the default action for the useradd
#  utility is to create the user and a group with the same name as the user. By 
# default the user ID (UID) and group ID (GID) numbers will begin at 1000. This 
# means if you don't pass extra parameters to useradd
#  , each user will be a member of a unique group on the system. If this behavior 
# is undesirable, you'll need to pass either the -g 
#  or -N 
#  parameter to useradd
#  , or else change the setting of USERGROUPS_ENAB 
#  in /etc/login.defs 
#  . See [useradd(8)](https://man.archlinux.org/man/useradd.8)
#  for more information. 
#</p>
#<p>
#
#  Second, to change the default parameters, the file /etc/default/useradd 
#  must be created and tailored to suit your particular needs. Create it with: 
#</p>

#********<pre>***********
mkdir -p /etc/default
useradd -D --gid 999
#********</pre>**********
#<p>
#/etc/default/useradd 
#  parameter explanations 
#</p>

#GROUP=999 
##<p>
#
#  This parameter sets the beginning of the group numbers used in the /etc/group 
#  file. The particular value 999 comes from the --gid 
#  parameter above. You may set it to any desired value. Note that useradd
#  will never reuse a UID or GID. If the number identified in this parameter is 
# used, it will use the next available number. Note also that if you don't have a 
# group with an ID equal to this number on your system, then the first time you 
# use useradd
#  without the -g 
#  parameter, an error message will be generated— useradd: unknown GID 999 
#  , even though the account has been created correctly. That is why we created 
# the group users 
#  with this group ID in [Section 7.6, “Creating Essential Files and Symlinks.”](../chapter07/createfiles.html)
#</p>

#CREATE_MAIL_SPOOL=yes 
##<p>
#
#  This parameter causes useradd
#  to create a mailbox file for each new user. useradd
#  will assign the group ownership of this file to the mail 
#  group with 0660 permissions. If you would rather not create these files, issue 
# the following command: 
#</p>

#********<pre>***********
sed -i '/MAIL/s/yes/no/' /etc/default/useradd
#********</pre>**********

# ==== 8.28.3. Setting the Root Password ====
#<p>
#
#  Choose a password for user root
#  and set it by running: 
#</p>

#********<pre>***********
passwd root
#********</pre>**********

# ==== 8.28.4. Contents of Shadow ====

#  Installed programs: chage, chfn, chgpasswd, chpasswd, chsh, expiry, faillog, getsubids, gpasswd, groupadd, groupdel, groupmems, groupmod, grpck, grpconv, grpunconv, login, logoutd, newgidmap, newgrp, newuidmap, newusers, nologin, passwd, pwck, pwconv, pwunconv, sg (link to newgrp), su, useradd, userdel, usermod, vigr (link to vipw), and vipw
#  Installed directories: /etc/default and /usr/include/shadow
#  Installed libraries: libsubid.so
# ====== Short Descriptions ======

#--------------------------------------------
# | chage                                    | Used to change the maximum number of days between obligatory password changes
# | chfn                                     | Used to change a user's full name and other information
# | chgpasswd                                | Used to update group passwords in batch mode
# | chpasswd                                 | Used to update user passwords in batch mode
# | chsh                                     | Used to change a user's default login shell
# | expiry                                   | Checks and enforces the current password expiration policy
# | faillog                                  | Is used to examine the log of login failures, to set a maximum number of failures before an account is blocked, and to reset the failure count
# | getsubids                                | Is used to list the subordinate id ranges for a user
# | gpasswd                                  | Is used to add and delete members and administrators to groups
# | groupadd                                 | Creates a group with the given name     
# | groupdel                                 | Deletes the group with the given name   
# | groupmems                                | Allows a user to administer his/her own group membership list without the requirement of super user privileges.
# | groupmod                                 | Is used to modify the given group's name or GID
# | grpck                                    | Verifies the integrity of the group files/etc/group                              and                                     /etc/gshadow                            
# | grpconv                                  | Creates or updates the shadow group file from the normal group file
# | grpunconv                                | Updates                                 /etc/group                              from                                    /etc/gshadow                            and then deletes the latter             
# | login                                    | Is used by the system to let users sign on
# | logoutd                                  | Is a daemon used to enforce restrictions on log-on time and ports
# | newgidmap                                | Is used to set the gid mapping of a user namespace
# | newgrp                                   | Is used to change the current GID during a login session
# | newuidmap                                | Is used to set the uid mapping of a user namespace
# | newusers                                 | Is used to create or update an entire series of user accounts
# | nologin                                  | Displays a message saying an account is not available; it is designed to be used as the default shell for disabled accounts
# | passwd                                   | Is used to change the password for a user or group account
# | pwck                                     | Verifies the integrity of the password files/etc/passwd                             and                                     /etc/shadow                             
# | pwconv                                   | Creates or updates the shadow password file from the normal password file
# | pwunconv                                 | Updates                                 /etc/passwd                             from                                    /etc/shadow                             and then deletes the latter             
# | sg                                       | Executes a given command while the user's GID is set to that of the given group
# | su                                       | Runs a shell with substitute user and group IDs
# | useradd                                  | Creates a new user with the given name, or updates the default new-user information
# | userdel                                  | Deletes the specified user account      
# | usermod                                  | Is used to modify the given user's login name, user identification (UID), shell, initial group, home directory, etc.
# | vigr                                     | Edits the                               /etc/group                              or                                      /etc/gshadow                            files                                   
# | vipw                                     | Edits the                               /etc/passwd                             or                                      /etc/shadow                             files                                   
# | libsubid                                 | library to handle subordinate id ranges for users and groups
#--------------------------------------------
cd $topdir
rm -rf $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt
