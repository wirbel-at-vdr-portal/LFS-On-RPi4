#!/usr/bin/bash

# ===== 8.66. IPRoute2-6.14.0 =====
topdir=$(pwd)
err=0
set -e
chapter=8066
err_report() {
    echo "chapter $chapter: $(date +'%Y.%m.%d %H:%M:%S') Error $? on line $1" | tee >> $topdir/log.txt
}
trap 'err_report $LINENO' ERR
echo "---------" >> $topdir/log.txt
echo chapter $chapter: start = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt






srcdir=../../src/iproute2-6.14.0
tar xf ../../src/iproute2-6.14.0.tar.xz -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir

#<p>
#
#  The IPRoute2 package contains programs for basic and advanced IPV4-based 
# networking. 
#</p>

#  Approximate build time: 0.1 SBU
#  Required disk space: 17 MB
# ==== 8.66.1. Installation of IPRoute2 ====
#<p>
#
#  The arpd
#  program included in this package will not be built since it depends on 
# Berkeley DB, which is not installed in LFS. However, a directory and a man page 
# for arpd
#  will still be installed. Prevent this by running the commands shown below. 
#</p>

#********<pre>***********
sed -i /ARPD/d Makefile
rm -fv man/man8/arpd.8
#********</pre>**********
#<p>
#
#  Compile the package: 
#</p>

#********<pre>***********
make NETNS_RUN_DIR=/run/netns
#********</pre>**********
#<p>
#
#  This package does not have a working test suite. 
#</p>
#<p>
#
#  Install the package: 
#</p>

#********<pre>***********
make SBINDIR=/usr/sbin install
#********</pre>**********
#<p>
#
#  If desired, install the documentation: 
#</p>

#********<pre>***********
install -vDm644 COPYING README* -t /usr/share/doc/iproute2-6.14.0
#********</pre>**********

# ==== 8.66.2. Contents of IPRoute2 ====

#  Installed programs: bridge, ctstat (link to lnstat), genl, ifstat, ip, lnstat, nstat, routel, rtacct, rtmon, rtpr, rtstat (link to lnstat), ss, and tc
#  Installed directories: /etc/iproute2, /usr/lib/tc, and /usr/share/doc/iproute2-6.14.0
# ====== Short Descriptions ======

#--------------------------------------------
# | bridge                                   | Configures network bridges              
# | ctstat                                   | Connection status utility               
# | genl                                     | Generic netlink utility front end       
# | ifstat                                   | Shows interface statistics, including the number of packets transmitted and received, by interface
# | ip                                       | The main executable. It has several different functions, including these:ip link                                 <device>                                allows users to look at the state of devices and to make changesip addr                                 allows users to look at addresses and their properties, add new addresses, and delete old onesip neighbor                             allows users to look at neighbor bindings and their properties, add new neighbor entries, and delete old onesip rule                                 allows users to look at the routing policies and change themip route                                allows users to look at the routing table and change routing table rulesip tunnel                               allows users to look at the IP tunnels and their properties, and change themip maddr                                allows users to look at the multicast addresses and their properties, and change themip mroute                               allows users to set, change, or delete the multicast routingip monitor                              allows users to continuously monitor the state of devices, addresses and routes
# | lnstat                                   | Provides Linux network statistics; it is a generalized and more feature-complete replacement for the oldrtstat                                  program                                 
# | nstat                                    | Displays network statistics             
# | routel                                   | A component of                          ip route                                , for listing the routing tables        
# | rtacct                                   | Displays the contents of                /proc/net/rt_acct                       
# | rtmon                                    | Route monitoring utility                
# | rtpr                                     | Converts the output of                  ip -o                                   into a readable form                    
# | rtstat                                   | Route status utility                    
# | ss                                       | Similar to the                          netstat                                 command; shows active connections       
# | tc                                       | Traffic control for Quality of Service (QoS) and Class of Service (CoS) implementationstc qdisc                                allows users to set up the queueing disciplinetc class                                allows users to set up classes based on the queueing discipline schedulingtc filter                               allows users to set up the QoS/CoS packet filteringtc monitor                              can be used to view changes made to Traffic Control in the kernel.
#--------------------------------------------
cd $topdir
rm -rf $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt
