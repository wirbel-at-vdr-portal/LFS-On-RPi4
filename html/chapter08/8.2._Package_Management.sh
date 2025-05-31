#!/usr/bin/bash

# ===== 8.2. Package Management =====
topdir=$(pwd)
err=0
set -e
chapter=8002
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



srcdir=../../src/packaging-25.0
tar xf ../../src/packaging-25.0.tar.gz -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir

#<p>
#
#  Package Management is an often requested addition to the LFS Book. A Package 
# Manager tracks the installation of files, making it easier to remove and 
# upgrade packages. A good package manager will also handle the configuration 
# files specially to keep the user configuration when the package is reinstalled 
# or upgraded. Before you begin to wonder, NO—this section will not talk about 
# nor recommend any particular package manager. What it does provide is a roundup 
# of the more popular techniques and how they work. The perfect package manager 
# for you may be among these techniques, or it may be a combination of two or 
# more of these techniques. This section briefly mentions issues that may arise 
# when upgrading packages. 
#</p>
#<p>
#
#  Some reasons why no package manager is mentioned in LFS or BLFS include: 
#</p>

# ***** #<p>
#
#  Dealing with package management takes the focus away from the goals of these 
# books—teaching how a Linux system is built. 
#</p>

# ***** #<p>
#
#  There are multiple solutions for package management, each having its strengths 
# and drawbacks. Finding one solution that satisfies all audiences is difficult. 
#</p>
#<p>
#
#  There are some hints written on the topic of package management. Visit the [Hints Project](https://www.linuxfromscratch.org/hints/downloads/files/)
#  and see if one of them fits your needs. 
#</p>

# ==== 8.2.1. Upgrade Issues ====
#<p>
#
#  A Package Manager makes it easy to upgrade to newer versions when they are 
# released. Generally the instructions in the LFS and BLFS books can be used to 
# upgrade to the newer versions. Here are some points that you should be aware of 
# when upgrading packages, especially on a running system. 
#</p>

# ***** #<p>
#
#  If the Linux kernel needs to be upgraded (for example, from 5.10.17 to 5.10.18 
# or 5.11.1), nothing else needs to be rebuilt. The system will keep working fine 
# thanks to the well-defined interface between the kernel and userspace. 
# Specifically, Linux API headers need not be upgraded along with the kernel. You 
# will merely need to reboot your system to use the upgraded kernel. 
#</p>

# ***** #<p>
#
#  If Glibc needs to be upgraded to a newer version, (e.g., from Glibc-2.36 to 
# Glibc-2.41), some extra steps are needed to avoid breaking the system. Read [Section 8.5, “Glibc-2.41”](glibc.html)
#  for details. 
#</p>

# ***** #<p>
#
#  If a package containing a shared library is updated, and if the name of the 
# library (#ftn.idm140377821129024)
#  changes, then any packages dynamically linked to the library must be 
# recompiled, to link against the newer library. For example, consider a package 
# foo-1.2.3 that installs a shared library with the name libfoo.so.1 
#  . Suppose you upgrade the package to a newer version foo-1.2.4 that installs a 
# shared library with the name libfoo.so.2 
#  . In this case, any packages that are dynamically linked to libfoo.so.1 
#  need to be recompiled to link against libfoo.so.2 
#  in order to use the new library version. You should not remove the old 
# libraries until all the dependent packages have been recompiled. 
#</p>

# ***** #<p>
#
#  If a package is (directly or indirectly) linked to both the old and new names 
# of a shared library (for example, the package links to both libfoo.so.2 
#  and libbar.so.1 
#  , while the latter links to libfoo.so.3 
#  ), the package may malfunction because the different revisions of the shared 
# library present incompatible definitions for some symbol names. This can be 
# caused by recompiling some, but not all, of the packages linked to the old 
# shared library after the package providing the shared library is upgraded. To 
# avoid the issue, users will need to rebuild every package linked to a shared 
# library with an updated revision (e.g. libfoo.so.2 to libfoo.so.3) as soon as 
# possible. 
#</p>

# ***** #<p>
#
#  If a package containing a shared library is updated, and the name of the 
# library doesn't change, but the version number of the library file
#  decreases (for example, the library is still named libfoo.so.1 
#  , but the name of the library file is changed from libfoo.so.1.25 
#  to libfoo.so.1.24 
#  ), you should remove the library file from the previously installed version ( libfoo.so.1.25 
#  in this case). Otherwise, a ldconfig
#  command (invoked by yourself from the command line, or by the installation of 
# some package) will reset the symlink libfoo.so.1 
#  to point to the old library file because it seems to be a “newer”
#  version; its version number is larger. This situation may arise if you have to 
# downgrade a package, or if the authors change the versioning scheme for library 
# files. 
#</p>

# ***** #<p>
#
#  If a package containing a shared library is updated, and the name of the 
# library doesn't change, but a severe issue (especially, a security 
# vulnerability) is fixed, all running programs linked to the shared library 
# should be restarted. The following command, run as root 
#  after the update is complete, will list which processes are using the old 
# versions of those libraries (replace libfoo 
#  with the name of the library): 
#</p>

#********<pre>***********
grep -l 'libfoo.*deleted' /proc/*/maps | tr -cd 0-9\\n | xargs -r ps u
#********</pre>**********
#<p>
#
#  If OpenSSH
#  is being used to access the system and it is linked to the updated library, 
# you must restart the sshd
#  service, then logout, login again, and run the preceding command again to 
# confirm that nothing is still using the deleted libraries. 
#</p>

# ***** #<p>
#
#  If an executable program or a shared library is overwritten, the processes 
# using the code or data in that program or library may crash. The correct way to 
# update a program or a shared library without causing the process to crash is to 
# remove it first, then install the new version. The install
#  command provided by coreutils
#  has already implemented this, and most packages use that command to install 
# binary files and libraries. This means that you won't be troubled by this issue 
# most of the time. However, the install process of some packages (notably 
# SpiderMonkey in BLFS) just overwrites the file if it exists; this causes a 
# crash. So it's safer to save your work and close unneeded running processes 
# before updating a package. 
#</p>

# ==== 8.2.2. Package Management Techniques ====
#<p>
#
#  The following are some common package management techniques. Before making a 
# decision on a package manager, do some research on the various techniques, 
# particularly the drawbacks of each particular scheme. 
#</p>

# ====== 8.2.2.1. It is All in My Head! ======
#<p>
#
#  Yes, this is a package management technique. Some folks do not need a package 
# manager because they know the packages intimately and know which files are 
# installed by each package. Some users also do not need any package management 
# because they plan on rebuilding the entire system whenever a package is 
# changed. 
#</p>

# ====== 8.2.2.2. Install in Separate Directories ======
#<p>
#
#  This is a simplistic package management technique that does not need a special 
# program to manage the packages. Each package is installed in a separate 
# directory. For example, package foo-1.1 is installed in /opt/foo-1.1 
#  and a symlink is made from /opt/foo 
#  to /opt/foo-1.1 
#  . When a new version foo-1.2 comes along, it is installed in /opt/foo-1.2 
#  and the previous symlink is replaced by a symlink to the new version. 
#</p>
#<p>
#
#  Environment variables such as PATH 
#  , MANPATH 
#  , INFOPATH 
#  , PKG_CONFIG_PATH 
#  , CPPFLAGS 
#  , LDFLAGS 
#  , and the configuration file /etc/ld.so.conf 
#  may need to be expanded to include the corresponding subdirectories in /opt/foo-x.y 
#  . 
#</p>
#<p>
#
#  This scheme is used by the BLFS book to install some very large packages to 
# make it easier to upgrade them. If you install more than a few packages, this 
# scheme becomes unmanageable. And some packages (for example Linux API headers 
# and Glibc) may not work well with this scheme. Never use this scheme system-wide.
#</p>

# ====== 8.2.2.3. Symlink Style Package Management ======
#<p>
#
#  This is a variation of the previous package management technique. Each package 
# is installed as in the previous scheme. But instead of making the symlink via a 
# generic package name, each file is symlinked into the /usr 
#  hierarchy. This removes the need to expand the environment variables. Though 
# the symlinks can be created by the user, many package managers use this 
# approach, and automate the creation of the symlinks. A few of the popular ones 
# include Stow, Epkg, Graft, and Depot. 
#</p>
#<p>
#
#  The installation script needs to be fooled, so the package thinks it is 
# installed in /usr 
#  though in reality it is installed in the /usr/pkg 
#  hierarchy. Installing in this manner is not usually a trivial task. For 
# example, suppose you are installing a package libfoo-1.1. The following 
# instructions may not install the package properly: 
#</p>

#********<pre>***********
./configure --prefix=/usr/pkg/libfoo/1.1
make
make install
#********</pre>**********
#<p>
#
#  The installation will work, but the dependent packages may not link to libfoo 
# as you would expect. If you compile a package that links against libfoo, you 
# may notice that it is linked to /usr/pkg/libfoo/1.1/lib/libfoo.so.1 
#  instead of /usr/lib/libfoo.so.1 
#  as you would expect. The correct approach is to use the DESTDIR 
#  variable to direct the installation. This approach works as follows: 
#</p>

#********<pre>***********
./configure --prefix=/usr
make
make DESTDIR=/usr/pkg/libfoo/1.1 install
#********</pre>**********
#<p>
#
#  Most packages support this approach, but there are some which do not. For the 
# non-compliant packages, you may either need to install the package manually, or 
# you may find that it is easier to install some problematic packages into /opt 
#  . 
#</p>

# ====== 8.2.2.4. Timestamp Based ======
#<p>
#
#  In this technique, a file is timestamped before the installation of the 
# package. After the installation, a simple use of the find
#  command with the appropriate options can generate a log of all the files 
# installed after the timestamp file was created. A package manager that uses 
# this approach is install-log. 
#</p>
#<p>
#
#  Though this scheme has the advantage of being simple, it has two drawbacks. 
# If, during installation, the files are installed with any timestamp other than 
# the current time, those files will not be tracked by the package manager. Also, 
# this scheme can only be used when packages are installed one at a time. The 
# logs are not reliable if two packages are installed simultaneously from two 
# different consoles. 
#</p>

# ====== 8.2.2.5. Tracing Installation Scripts ======
#<p>
#
#  In this approach, the commands that the installation scripts perform are 
# recorded. There are two techniques that one can use: 
#</p>
#<p>
#
#  The LD_PRELOAD 
#  environment variable can be set to point to a library to be preloaded before 
# installation. During installation, this library tracks the packages that are 
# being installed by attaching itself to various executables such as cp
#  , install
#  , mv
#  and tracking the system calls that modify the filesystem. For this approach to 
# work, all the executables need to be dynamically linked without the suid or 
# sgid bit. Preloading the library may cause some unwanted side-effects during 
# installation. Therefore, it's a good idea to perform some tests to ensure that 
# the package manager does not break anything, and that it logs all the 
# appropriate files. 
#</p>
#<p>
#
#  Another technique is to use strace
#  , which logs all the system calls made during the execution of the 
# installation scripts. 
#</p>

# ====== 8.2.2.6. Creating Package Archives ======
#<p>
#
#  In this scheme, the package installation is faked into a separate tree as 
# previously described in the symlink style package management section. After the 
# installation, a package archive is created using the installed files. This 
# archive is then used to install the package on the local machine or even on 
# other machines. 
#</p>
#<p>
#
#  This approach is used by most of the package managers found in the commercial 
# distributions. Examples of package managers that follow this approach are RPM 
# (which, incidentally, is required by the [Linux Standard Base Specification](https://refspecs.linuxfoundation.org/lsb.shtml)
#  ), pkg-utils, Debian's apt, and Gentoo's Portage system. A hint describing how 
# to adopt this style of package management for LFS systems is located at [https://www.linuxfromscratch.org/hints/downloads/files/fakeroot.txt](https://www.linuxfromscratch.org/hints/downloads/files/fakeroot.txt)
#  . 
#</p>
#<p>
#
#  The creation of package files that include dependency information is complex, 
# and beyond the scope of LFS. 
#</p>
#<p>
#
#  Slackware uses a tar
#  -based system for package archives. This system purposely does not handle 
# package dependencies as more complex package managers do. For details of 
# Slackware package management, see [https://www.slackbook.org/html/package-management.html](https://www.slackbook.org/html/package-management.html)
#  . 
#</p>

# ====== 8.2.2.7. User Based Management ======
#<p>
#
#  This scheme, unique to LFS, was devised by Matthias Benkmann, and is available 
# from the [Hints Project](https://www.linuxfromscratch.org/hints/downloads/files/)
#  . In this scheme, each package is installed as a separate user into the 
# standard locations. Files belonging to a package are easily identified by 
# checking the user ID. The features and shortcomings of this approach are too 
# complex to describe in this section. For the details please see the hint at [https://www.linuxfromscratch.org/hints/downloads/files/more_control_and_pkg_man.txt](https://www.linuxfromscratch.org/hints/downloads/files/more_control_and_pkg_man.txt)
#  . 
#</p>

# ==== 8.2.3. Deploying LFS on Multiple Systems ====
#<p>
#
#  One of the advantages of an LFS system is that there are no files that depend 
# on the position of files on a disk system. Cloning an LFS build to another 
# computer with the same architecture as the base system is as simple as using tar
#  on the LFS partition that contains the root directory (about 900MB 
# uncompressed for a basic LFS build), copying that file via network transfer or 
# CD-ROM / USB stick to the new system, and expanding it. After that, a few 
# configuration files will have to be changed. Configuration files that may need 
# to be updated include: /etc/hosts 
#  , /etc/fstab 
#  , /etc/passwd 
#  , /etc/group 
#  , /etc/shadow ,/etc/ld.so.conf ,/etc/sysconfig/rc.site ,/etc/sysconfig/network , and/etc/sysconfig/ifconfig.eth0 .
#</p>
#<p>
#
#  A custom kernel may be needed for the new system, depending on differences in 
# system hardware and the original kernel configuration. 
#</p>

# ====== Important ======
#<p>
#
#  If you want to deploy the LFS system onto a system with a different CPU, when 
# you build [Section 8.21, “GMP-6.3.0”](gmp.html)
#  and [Section 8.50, “Libffi-3.4.8”](libffi.html)
#  you must follow the notes about overriding the architecture-specific 
# optimization to produce libraries suitable for both the host system and the 
# system(s) where you'll deploy the LFS system. Otherwise you'll get Illegal Instruction 
#  errors running LFS. 
#</p>
#<p>
#
#  Finally, the new system has to be made bootable via [Section 10.4, “Using GRUB to Set Up the Boot Process”](../chapter10/grub.html)
#  . 
#</p>

#<p>
#(#idm140377821129024)
#  The name of a shared library is the string coded in the DT_SONAME 
#  entry of its ELF dynamic section. You can get it with the readelf -d<library file> | grep SONAME
#  command. In most cases it's suffixed with .so. 
#  , but there are some cases where it contains multiple numbers for versioning 
# (like libbz2.so.1.0 
#  ), contains the version number before the .so 
#  suffix (like libbfd-2.44 
#  ), or does not contain any version number at all (for example libmemusage.so 
#  ). Generally there is no correlation between the package version and the 
# version number(s) in the library name. 
#</p>

cd $topdir
rm -rfv $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt
