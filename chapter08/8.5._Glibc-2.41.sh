#!/usr/bin/bash

# ===== 8.5. Glibc-2.41 =====
topdir=$(pwd)
err=0
set -e
chapter=8005
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



srcdir=../../src/glibc-2.41
tar xf ../../src/glibc-2.41.tar.xz -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir

#<p>
#
#  The Glibc package contains the main C library. This library provides the basic 
# routines for allocating memory, searching directories, opening and closing 
# files, reading and writing files, string handling, pattern matching, 
# arithmetic, and so on. 
#</p>

#  Approximate build time: 12 SBU
#  Required disk space: 3.2 GB
# ==== 8.5.1. Installation of Glibc ====
#<p>
#
#  Some of the Glibc programs use the non-FHS compliant /var/db 
#  directory to store their runtime data. Apply the following patch to make such 
# programs store their runtime data in the FHS-compliant locations: 
#</p>

#********<pre>***********
patch -Np1 -i ../glibc-2.41-fhs-1.patch
#********</pre>**********
#<p>
#
#  The Glibc documentation recommends building Glibc in a dedicated build 
# directory: 
#</p>

#********<pre>***********
mkdir -v build
cd       build
#********</pre>**********
#<p>
#
#  Ensure that the ldconfig
#  and sln
#  utilities will be installed into /usr/sbin 
#  : 
#</p>

#********<pre>***********
echo "rootsbindir=/usr/sbin" > configparms
#********</pre>**********
#<p>
#
#  Prepare Glibc for compilation: 
#</p>

#********<pre>***********
../configure --prefix=/usr                   \
             --disable-werror                \
             --disable-nscd                  \
             libc_cv_slibdir=/usr/lib        \
             --enable-stack-protector=strong \
             --enable-kernel=5.4
#********</pre>**********
#<p>
#
#  The meaning of the configure options: 
#</p>

#--disable-werror 
##<p>
#
#  This option disables the -Werror option passed to GCC. This is necessary for 
# running the test suite. 
#</p>

#--enable-kernel=5.4 
##<p>
#
#  This option tells the build system that this Glibc may be used with kernels as 
# old as 5.4. This means generating workarounds in case a system call introduced 
# in a later version cannot be used. 
#</p>

#--enable-stack-protector=strong 
##<p>
#
#  This option increases system security by adding extra code to check for buffer 
# overflows, such as stack smashing attacks. Note that Glibc always explicitly 
# overrides the default of GCC, so this option is still needed even though we've 
# already specified --enable-default-ssp 
#  for GCC. 
#</p>

#--disable-nscd 
##<p>
#
#  Do not build the name service cache daemon which is no longer used. 
#</p>

#libc_cv_slibdir=/usr/lib 
##<p>
#
#  This variable sets the correct library for all systems. We do not want lib64 
# to be used. 
#</p>
#<p>
#
#  Compile the package: 
#</p>

#********<pre>***********
make
#********</pre>**********

# ====== Important ======
#<p>
#
#  In this section, the test suite for Glibc is considered critical. Do not skip 
# it under any circumstance. 
#</p>
#<p>
#
#  Generally a few tests do not pass. The test failures listed below are usually 
# safe to ignore. 
#</p>

#********<pre>***********
#make check
#********</pre>**********
#<p>
#
#  You may see some test failures. The Glibc test suite is somewhat dependent on 
# the host system. A few failures out of over 6000 tests can generally be 
# ignored. This is a list of the most common issues seen for recent versions of 
# LFS: 
#</p>

# ***** #<p>
#io/tst-lchmod
#  is known to fail in the LFS chroot environment. 
#</p>

# ***** #<p>
#
#  Some tests, for example nss/tst-nss-files-hosts-multi
#  and nptl/tst-thread-affinity*
#  are known to fail due to a timeout (especially when the system is relatively 
# slow and/or running the test suite with multiple parallel make jobs). These 
# tests can be identified with: 
#</p>

#********<pre>***********
#grep "Timed out" $(find -name \*.out)
#********</pre>**********
#<p>
#
#  It's possible to re-run a single test with enlarged timeout with TIMEOUTFACTOR=<factor> make test t=<test name> 
#  . For example, TIMEOUTFACTOR=10 make test t=nss/tst-nss-files-hosts-multi
#  will re-run nss/tst-nss-files-hosts-multi
#  with ten times the original timeout. 
#</p>

# ***** #<p>
#
#  Additionally, some tests may fail with a relatively old CPU model (for example elf/tst-cpu-features-cpuinfo
#  ) or host kernel version (for example stdlib/tst-arc4random-thread
#  ). 
#</p>
#<p>
#
#  Though it is a harmless message, the install stage of Glibc will complain 
# about the absence of /etc/ld.so.conf 
#  . Prevent this warning with: 
#</p>

#********<pre>***********
touch /etc/ld.so.conf
#********</pre>**********
#<p>
#
#  Fix the Makefile to skip an outdated sanity check that fails with a modern 
# Glibc configuration: 
#</p>

#********<pre>***********
#sed '/test-installation/s@$(PERL)@echo not running@' -i ../Makefile
#********</pre>**********

# ====== Important ======
#<p>
#
#  If upgrading Glibc to a new minor version (for example, from Glibc-2.36 to 
# Glibc-2.41) on a running LFS system, you need to take some extra precautions to 
# avoid breaking the system: 
#</p>

# ***** #<p>
#
#  Upgrading Glibc on a LFS system prior to 11.0 (exclusive) is not supported. 
# Rebuild LFS if you are running such an old LFS system but you need a newer 
# Glibc. 
#</p>

# ***** #<p>
#
#  If upgrading on a LFS system prior to 12.0 (exclusive), install Libxcrypt
#  following [Section 8.27, “Libxcrypt-4.4.38.”](libxcrypt.html)
#  In addition to a normal Libxcrypt
#  installation, you MUST follow the note in Libxcrypt section to installlibcrypt.so.1* (replacinglibcrypt.so.1 from the prior Glibc installation)
#  . 
#</p>

# ***** #<p>
#
#  If upgrading on a LFS system prior to 12.1 (exclusive), remove the nscd
#  program: 
#</p>

#********<pre>***********
rm -f /usr/sbin/nscd
#********</pre>**********

# ***** #<p>
#
#  Upgrade the kernel and reboot if it's older than 5.4 (check the current 
# version with uname -r
#  ) or if you want to upgrade it anyway, following [Section 10.3, “Linux-6.14.6.”](../chapter10/kernel.html)
#</p>

# ***** #<p>
#
#  Upgrade the kernel API headers if it's older than 5.4 (check the current 
# version with cat /usr/include/linux/version.h
#  ) or if you want to upgrade it anyway, following [Section 5.4, “Linux-6.14.6 API Headers”](../chapter05/linux-headers.html)
#  (but removing $LFS 
#  from the cp
#  command). 
#</p>

# ***** #<p>
#
#  Perform a DESTDIR 
#  installation and upgrade the Glibc shared libraries on the system using one 
# single install
#  command: 
#</p>

#********<pre>***********
make DESTDIR=$PWD/dest install
install -vm755 dest/usr/lib/*.so.* /usr/lib
#********</pre>**********
#<p>
#
#  It's imperative to strictly follow these steps above unless you completely 
# understand what you are doing. Any unexpected deviation may render the system completely unusable. YOU ARE WARNED.
#</p>
#<p>
#
#  Then continue to run the make install
#  command, the sed
#  command against /usr/bin/ldd 
#  , and the commands to install the locales. Once they are finished, reboot the 
# system immediately. 
#</p>
#<p>
#
#  When the system has successfully rebooted, if you are running a LFS system 
# prior to 12.0 (exclusive) where GCC was not built with the --disable-fixincludes 
#  option, move two GCC headers into a better location and remove the stale “fixed”
#  copies of the Glibc headers: 
#</p>

#********<pre>***********
DIR=$(dirname $(gcc -print-libgcc-file-name))
[ -e $DIR/include/limits.h ]    || mv $DIR/include{-fixed,}/limits.h
[ -e $DIR/include/syslimits.h ] || mv $DIR/include{-fixed,}/syslimits.h
rm -rfv $DIR/include-fixed/*
unset DIR
#********</pre>**********
#<p>
#
#  Install the package: 
#</p>

#********<pre>***********
make install
#********</pre>**********
#<p>
#
#  Fix a hardcoded path to the executable loader in the ldd
#  script: 
#</p>

#********<pre>***********
sed '/RTLDLIST=/s@/usr@@g' -i /usr/bin/ldd
#********</pre>**********
#<p>
#
#  Next, install the locales that can make the system respond in a different 
# language. None of these locales are required, but if some of them are missing, 
# the test suites of some packages will skip important test cases. 
#</p>
#<p>
#
#  Individual locales can be installed using the localedef
#  program. E.g., the second localedef
#  command below combines the /usr/share/i18n/locales/cs_CZ 
#  charset-independent locale definition with the /usr/share/i18n/charmaps/UTF-8.gz 
#  charmap definition and appends the result to the /usr/lib/locale/locale-archive 
#  file. The following instructions will install the minimum set of locales 
# necessary for the optimal coverage of tests: 
#</p>

#********<pre>***********
localedef -i C -f UTF-8 C.UTF-8
localedef -i cs_CZ -f UTF-8 cs_CZ.UTF-8
localedef -i de_DE -f ISO-8859-1 de_DE
localedef -i de_DE@euro -f ISO-8859-15 de_DE@euro
localedef -i de_DE -f UTF-8 de_DE.UTF-8
localedef -i el_GR -f ISO-8859-7 el_GR
localedef -i en_GB -f ISO-8859-1 en_GB
localedef -i en_GB -f UTF-8 en_GB.UTF-8
localedef -i en_HK -f ISO-8859-1 en_HK
localedef -i en_PH -f ISO-8859-1 en_PH
localedef -i en_US -f ISO-8859-1 en_US
localedef -i en_US -f UTF-8 en_US.UTF-8
localedef -i es_ES -f ISO-8859-15 es_ES@euro
localedef -i es_MX -f ISO-8859-1 es_MX
localedef -i fa_IR -f UTF-8 fa_IR
localedef -i fr_FR -f ISO-8859-1 fr_FR
localedef -i fr_FR@euro -f ISO-8859-15 fr_FR@euro
localedef -i fr_FR -f UTF-8 fr_FR.UTF-8
localedef -i is_IS -f ISO-8859-1 is_IS
localedef -i is_IS -f UTF-8 is_IS.UTF-8
localedef -i it_IT -f ISO-8859-1 it_IT
localedef -i it_IT -f ISO-8859-15 it_IT@euro
localedef -i it_IT -f UTF-8 it_IT.UTF-8
localedef -i ja_JP -f EUC-JP ja_JP
localedef -i ja_JP -f UTF-8 ja_JP.UTF-8
localedef -i nl_NL@euro -f ISO-8859-15 nl_NL@euro
localedef -i ru_RU -f KOI8-R ru_RU.KOI8-R
localedef -i ru_RU -f UTF-8 ru_RU.UTF-8
localedef -i se_NO -f UTF-8 se_NO.UTF-8
localedef -i ta_IN -f UTF-8 ta_IN.UTF-8
localedef -i tr_TR -f UTF-8 tr_TR.UTF-8
localedef -i zh_CN -f GB18030 zh_CN.GB18030
localedef -i zh_HK -f BIG5-HKSCS zh_HK.BIG5-HKSCS
localedef -i zh_TW -f UTF-8 zh_TW.UTF-8
#********</pre>**********
#<p>
#
#  In addition, install the locale for your own country, language and character 
# set. 
#</p>
#<p>
#
#  Alternatively, install all the locales listed in the glibc-2.41/localedata/SUPPORTED 
#  file (it includes every locale listed above and many more) at once with the 
# following time-consuming command: 
#</p>

#********<pre>***********
make localedata/install-locales
#********</pre>**********

# ====== Note ======
#<p>
#
#  Glibc now uses libidn2 when resolving internationalized domain names. This is 
# a run time dependency. If this capability is needed, the instructions for 
# installing libidn2 are in the [BLFS libidn2 page](https://www.linuxfromscratch.org/blfs/view/svn/general/libidn2.html)
#  . 
#</p>

# ==== 8.5.2. Configuring Glibc ====

# ====== 8.5.2.1. Adding nsswitch.conf ======
#<p>
#
#  The /etc/nsswitch.conf 
#  file needs to be created because the Glibc defaults do not work well in a 
# networked environment. 
#</p>
#<p>
#
#  Create a new file /etc/nsswitch.conf 
#  by running the following: 
#</p>

#********<pre>***********
cat > /etc/nsswitch.conf << "EOF"
# Begin /etc/nsswitch.conf

passwd: files
group: files
shadow: files

hosts: files dns
networks: files

protocols: files
services: files
ethers: files
rpc: files

# End /etc/nsswitch.conf
EOF
#********</pre>**********

# ====== 8.5.2.2. Adding Time Zone Data ======
#<p>
#
#  Install and set up the time zone data with the following: 
#</p>

#********<pre>***********
tar -xf ../../tzdata2025b.tar.gz

ZONEINFO=/usr/share/zoneinfo
mkdir -pv $ZONEINFO/{posix,right}

for tz in etcetera southamerica northamerica europe africa antarctica  \
          asia australasia backward; do
    zic -L /dev/null   -d $ZONEINFO       ${tz}
    zic -L /dev/null   -d $ZONEINFO/posix ${tz}
    zic -L leapseconds -d $ZONEINFO/right ${tz}
done

cp -v zone.tab zone1970.tab iso3166.tab $ZONEINFO
zic -d $ZONEINFO -p Europe/Berlin
unset ZONEINFO tz
#********</pre>**********
#<p>
#
#  The meaning of the zic commands: 
#</p>

#zic -L /dev/null ... 
##<p>
#
#  This creates posix time zones without any leap seconds. It is conventional to 
# put these in both zoneinfo 
#  and zoneinfo/posix 
#  . It is necessary to put the POSIX time zones in zoneinfo 
#  , otherwise various test suites will report errors. On an embedded system, 
# where space is tight and you do not intend to ever update the time zones, you 
# could save 1.9 MB by not using the posix 
#  directory, but some applications or test suites might produce some failures. 
#</p>

#zic -L leapseconds ... 
##<p>
#
#  This creates right time zones, including leap seconds. On an embedded system, 
# where space is tight and you do not intend to ever update the time zones, or 
# care about the correct time, you could save 1.9MB by omitting the right 
#  directory. 
#</p>

#zic ... -p ... 
##<p>
#
#  This creates the posixrules 
#  file. We use New York because POSIX requires the daylight saving time rules to 
# be in accordance with US rules. 
#</p>
#<p>
#
#  One way to determine the local time zone is to run the following script: 
#</p>

#********<pre>***********
#tzselect
#********</pre>**********
#<p>
#
#  After answering a few questions about the location, the script will output the 
# name of the time zone (e.g., America/Edmonton
#  ). There are also some other possible time zones listed in /usr/share/zoneinfo 
#  such as Canada/Eastern
#  or EST5EDT
#  that are not identified by the script but can be used. 
#</p>
#<p>
#
#  Then create the /etc/localtime 
#  file by running: 
#</p>

#********<pre>***********
ln -sfv /usr/share/zoneinfo/Europe/Berlin /etc/localtime
#********</pre>**********
#<p>
#
#  Replace <xxx> 
#  with the name of the time zone selected (e.g., Canada/Eastern). 
#</p>

# ====== 8.5.2.3. Configuring the Dynamic Loader ======
#<p>
#
#  By default, the dynamic loader ( /lib/ld-linux.so.2 
#  ) searches through /usr/lib 
#  for dynamic libraries that are needed by programs as they are run. However, if 
# there are libraries in directories other than /usr/lib 
#  , these need to be added to the /etc/ld.so.conf 
#  file in order for the dynamic loader to find them. Two directories that are 
# commonly known to contain additional libraries are /usr/local/lib 
#  and /opt/lib 
#  , so add those directories to the dynamic loader's search path. 
#</p>
#<p>
#
#  Create a new file /etc/ld.so.conf 
#  by running the following: 
#</p>

#********<pre>***********
cat > /etc/ld.so.conf << "EOF"
# Begin /etc/ld.so.conf
/usr/local/lib
/opt/lib

EOF
#********</pre>**********
#<p>
#
#  If desired, the dynamic loader can also search a directory and include the 
# contents of files found there. Generally the files in this include directory 
# are one line specifying the desired library path. To add this capability run 
# the following commands: 
#</p>

#********<pre>***********
cat >> /etc/ld.so.conf << "EOF"
# Add an include directory
include /etc/ld.so.conf.d/*.conf

EOF
mkdir -pv /etc/ld.so.conf.d
#********</pre>**********

# ==== 8.5.3. Contents of Glibc ====

#  Installed programs: gencat, getconf, getent, iconv, iconvconfig, ldconfig, ldd, lddlibc4, ld.so (symlink to ld-linux-x86-64.so.2 or ld-linux.so.2), locale, localedef, makedb, mtrace, pcprofiledump, pldd, sln, sotruss, sprof, tzselect, xtrace, zdump, and zic
#  Installed libraries: ld-linux-x86-64.so.2, ld-linux.so.2, libBrokenLocale.{a,so}, libanl.{a,so}, libc.{a,so}, libc_nonshared.a, libc_malloc_debug.so, libdl.{a,so.2}, libg.a, libm.{a,so}, libmcheck.a, libmemusage.so, libmvec.{a,so}, libnsl.so.1, libnss_compat.so, libnss_dns.so, libnss_files.so, libnss_hesiod.so, libpcprofile.so, libpthread.{a,so.0}, libresolv.{a,so}, librt.{a,so.1}, libthread_db.so, and libutil.{a,so.1}
#  Installed directories: /usr/include/arpa, /usr/include/bits, /usr/include/gnu, /usr/include/net, /usr/include/netash, /usr/include/netatalk, /usr/include/netax25, /usr/include/neteconet, /usr/include/netinet, /usr/include/netipx, /usr/include/netiucv, /usr/include/netpacket, /usr/include/netrom, /usr/include/netrose, /usr/include/nfs, /usr/include/protocols, /usr/include/rpc, /usr/include/sys, /usr/lib/audit, /usr/lib/gconv, /usr/lib/locale, /usr/libexec/getconf, /usr/share/i18n, /usr/share/zoneinfo, and /var/lib/nss_db
# ====== Short Descriptions ======

#--------------------------------------------
# | gencat                                   | Generates message catalogues            
# | getconf                                  | Displays the system configuration values for file system specific variables
# | getent                                   | Gets entries from an administrative database
# | iconv                                    | Performs character set conversion       
# | iconvconfig                              | Creates fastloading                     iconv                                   module configuration files              
# | ldconfig                                 | Configures the dynamic linker runtime bindings
# | ldd                                      | Reports which shared libraries are required by each given program or shared library
# | lddlibc4                                 | Assists                                 ldd                                     with object files. It does not exist on newer architectures like x86_64
# | locale                                   | Prints various information about the current locale
# | localedef                                | Compiles locale specifications          
# | makedb                                   | Creates a simple database from textual input
# | mtrace                                   | Reads and interprets a memory trace file and displays a summary in human-readable format
# | pcprofiledump                            | Dump information generated by PC profiling
# | pldd                                     | Lists dynamic shared objects used by running processes
# | sln                                      | A statically linked                     ln                                      program                                 
# | sotruss                                  | Traces shared library procedure calls of a specified command
# | sprof                                    | Reads and displays shared object profiling data
# | tzselect                                 | Asks the user about the location of the system and reports the corresponding time zone description
# | xtrace                                   | Traces the execution of a program by printing the currently executed function
# | zdump                                    | The time zone dumper                    
# | zic                                      | The time zone compiler                  
# | ld-*.so                                  | The helper program for shared library executables
# | libBrokenLocale                          | Used internally by Glibc as a gross hack to get broken programs (e.g., some Motif applications) running. See comments inglibc-2.41/locale/broken_cur_max.c      for more information                    
# | libanl                                   | Dummy library containing no functions. Previously was the asynchronous name lookup library, whose functions are now inlibc                                    
# | libc                                     | The main C library                      
# | libc_malloc_debug                        | Turns on memory allocation checking when preloaded
# | libdl                                    | Dummy library containing no functions. Previously was the dynamic linking interface library, whose functions are now inlibc                                    
# | libg                                     | Dummy library containing no functions. Previously was a runtime library forg++                                     
# | libm                                     | The mathematical library                
# | libmvec                                  | The vector math library, linked in as needed whenlibm                                    is used                                 
# | libmcheck                                | Turns on memory allocation checking when linked to
# | libmemusage                              | Used by                                 memusage                                to help collect information about the memory usage of a program
# | libnsl                                   | The network services library, now deprecated
# | libnss_*                                 | The Name Service Switch modules, containing functions for resolving host names, user names, group names, aliases, services, protocols, etc. Loaded bylibc                                    according to the configuration in       /etc/nsswitch.conf                      
# | libpcprofile                             | Can be preloaded to PC profile an executable
# | libpthread                               | Dummy library containing no functions. Previously contained functions providing most of the interfaces specified by the POSIX.1c Threads Extensions and the semaphore interfaces specified by the POSIX.1b Real-time Extensions, now the functions are inlibc                                    
# | libresolv                                | Contains functions for creating, sending, and interpreting packets to the Internet domain name servers
# | librt                                    | Contains functions providing most of the interfaces specified by the POSIX.1b Real-time Extensions
# | libthread_db                             | Contains functions useful for building debuggers for multi-threaded programs
# | libutil                                  | Dummy library containing no functions. Previously contained code for“                                       standard                                ”                                       functions used in many different Unix utilities. These functions are now inlibc                                    
#--------------------------------------------
cd $topdir
rm -rfv $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt
