#!/usr/bin/bash

# ===== 8.41. Inetutils-2.6 =====
topdir=$(pwd)
err=0
set -e
chapter=8041
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



srcdir=../../src/inetutils-2.6
tar xf ../../src/inetutils-2.6.tar.xz -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir

#<p>
#
#  The Inetutils package contains programs for basic networking. 
#</p>

#  Approximate build time: 0.2 SBU
#  Required disk space: 35 MB
# ==== 8.41.1. Installation of Inetutils ====
#<p>
#
#  First, make the package build with gcc-14.1 or later: 
#</p>

#********<pre>***********
sed -i 's/def HAVE_TERMCAP_TGETENT/ 1/' telnet/telnet.c
#********</pre>**********
#<p>
#
#  Prepare Inetutils for compilation: 
#</p>

#********<pre>***********
./configure --prefix=/usr        \
            --bindir=/usr/bin    \
            --localstatedir=/var \
            --disable-logger     \
            --disable-whois      \
            --disable-rcp        \
            --disable-rexec      \
            --disable-rlogin     \
            --disable-rsh        \
            --disable-servers
#********</pre>**********
#<p>
#
#  The meaning of the configure options: 
#</p>

#--disable-logger 
##<p>
#
#  This option prevents Inetutils from installing the logger
#  program, which is used by scripts to pass messages to the System Log Daemon. 
# Do not install it because Util-linux installs a more recent version. 
#</p>

#--disable-whois 
##<p>
#
#  This option disables the building of the Inetutils whois
#  client, which is out of date. Instructions for a better whois
#  client are in the BLFS book. 
#</p>

#--disable-r* 
##<p>
#
#  These parameters disable building obsolete programs that should not be used 
# due to security issues. The functions provided by these programs can be 
# provided by the openssh
#  package in the BLFS book. 
#</p>

#--disable-servers 
##<p>
#
#  This disables the installation of the various network servers included as part 
# of the Inetutils package. These servers are deemed not appropriate in a basic 
# LFS system. Some are insecure by nature and are only considered safe on trusted 
# networks. Note that better replacements are available for many of these 
# servers. 
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
#  To test the results, issue: 
#</p>

#********<pre>***********
#make check
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
#  Move a program to the proper location: 
#</p>

#********<pre>***********
mv -v /usr/{,s}bin/ifconfig
#********</pre>**********

# ==== 8.41.2. Contents of Inetutils ====

#  Installed programs: dnsdomainname, ftp, ifconfig, hostname, ping, ping6, talk, telnet, tftp, and traceroute
# ====== Short Descriptions ======

#--------------------------------------------
# | dnsdomainname                            | Show the system's DNS domain name       
# | ftp                                      | Is the file transfer protocol program   
# | hostname                                 | Reports or sets the name of the host    
# | ifconfig                                 | Manages network interfaces              
# | ping                                     | Sends echo-request packets and reports how long the replies take
# | ping6                                    | A version of                            ping                                    for IPv6 networks                       
# | talk                                     | Is used to chat with another user       
# | telnet                                   | An interface to the TELNET protocol     
# | tftp                                     | A trivial file transfer program         
# | traceroute                               | Traces the route your packets take from the host you are working on to another host on a network, showing all the intermediate hops (gateways) along the way
#--------------------------------------------
cd $topdir
rm -rf $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt
