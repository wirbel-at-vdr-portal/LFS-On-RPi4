#!/usr/bin/bash

# ===== 9.5. General Network Configuration =====
topdir=$(pwd)
err=0
set -e
chapter=9005
err_report() {
    echo "chapter $chapter: $(date +'%Y.%m.%d %H:%M:%S') Error $? on line $1" | tee >> $topdir/log.txt
}
trap 'err_report $LINENO' ERR
echo "---------" >> $topdir/log.txt
echo chapter $chapter: start = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt





# ==== 9.5.1. Creating Network Interface Configuration Files ====
#<p>
#
#  The files in /etc/sysconfig/ 
#  usually determine which interfaces are brought up and down by the network 
# script. This directory should contain a file for each interface to be 
# configured, such as ifconfig.xyz 
#  , where “xyz”
#  describes the network card. The interface name (e.g. eth0) is usually 
# appropriate. Each file contains the attributes of one interface, such as its IP 
# address(es), subnet masks, and so forth. The stem of the filename must be ifconfig
#  . 
#</p>

# ====== Note ======
#<p>
#
#  If the procedure in the previous section was not used, udev will assign 
# network card interface names based on system physical characteristics such as 
# enp2s1. If you are not sure what your interface name is, you can always run ip link
#  or ls /sys/class/net
#  after you have booted your system. 
#</p>
#<p>
#
#  The interface names depend on the implementation and configuration of the udev 
# daemon running on the system. The udev daemon for LFS (installed in [Section 8.76, “Udev from Systemd-257.3”](../chapter08/udev.html)
#  ) will not run until the LFS system is booted. So the interface names in the 
# LFS system cannot always be determined by running those commands on the host 
# distro, even in the chroot environment
#  . 
#</p>
#<p>
#
#  The following command creates a sample file for the eth0
#  device with a static IP address: 
#</p>

#********<pre>***********
cd /etc/sysconfig/
cat > ifconfig.eth0 << "EOF"
ONBOOT=yes
IFACE=eth0
SERVICE=ipv4-static
IP=192.168.1.2
GATEWAY=192.168.1.1
PREFIX=24
BROADCAST=192.168.1.255
EOF
#********</pre>**********
#<p>
#
#  The values in italics must be changed in each file, to set the interfaces up 
# correctly. 
#</p>
#<p>
#
#  If the ONBOOT 
#  variable is set to yes 
#  the System V network script will bring up the Network Interface Card (NIC) 
# during the system boot process. If set to anything besides yes 
#  , the NIC will be ignored by the network script and will not be started 
# automatically. Interfaces can be manually started or stopped with the ifup
#  and ifdown
#  commands. 
#</p>
#<p>
#
#  The IFACE 
#  variable defines the interface name, for example, eth0. It is required for all 
# network device configuration files. The filename extension must match this 
# value. 
#</p>
#<p>
#
#  The SERVICE 
#  variable defines the method used for obtaining the IP address. The 
# LFS-Bootscripts package has a modular IP assignment format, and creating 
# additional files in the /lib/services/ 
#  directory allows other IP assignment methods. This is commonly used for 
# Dynamic Host Configuration Protocol (DHCP), which is addressed in the BLFS 
# book. 
#</p>
#<p>
#
#  The GATEWAY 
#  variable should contain the default gateway IP address, if one is present. If 
# not, then comment out the variable entirely. 
#</p>
#<p>
#
#  The PREFIX 
#  variable specifies the number of bits used in the subnet. Each segment of an 
# IP address is 8 bits. If the subnet's netmask is 255.255.255.0, then it is 
# using the first three segments (24 bits) to specify the network number. If the 
# netmask is 255.255.255.240, the subnet is using the first 28 bits. Prefixes 
# longer than 24 bits are commonly used by DSL and cable-based Internet Service 
# Providers (ISPs). In this example (PREFIX=24), the netmask is 255.255.255.0. 
# Adjust the PREFIX 
#  variable according to your specific subnet. If omitted, the PREFIX defaults to 
# 24. 
#</p>
#<p>
#
#  For more information see the ifup
#  man page. 
#</p>

# ==== 9.5.2. Creating the /etc/resolv.conf File ====
#<p>
#
#  The system will need some means of obtaining Domain Name Service (DNS) name 
# resolution to resolve Internet domain names to IP addresses, and vice versa. 
# This is best achieved by placing the IP address of the DNS server, available 
# from the ISP or network administrator, into /etc/resolv.conf 
#  . Create the file by running the following: 
#</p>

#********<pre>***********
cat > /etc/resolv.conf << "EOF"
# Begin /etc/resolv.conf

domain <Your Domain Name>
nameserver <IP address of your primary nameserver>
nameserver <IP address of your secondary nameserver>

# End /etc/resolv.conf
EOF
#********</pre>**********
#<p>
#
#  The domain 
#  statement can be omitted or replaced with a search 
#  statement. See the man page for resolv.conf for more details. 
#</p>
#<p>
#
#  Replace <IP address of the nameserver> 
#  with the IP address of the DNS most appropriate for the setup. There will 
# often be more than one entry (requirements demand secondary servers for 
# fallback capability). If you only need or want one DNS server, remove the 
# second nameserver
#  line from the file. The IP address may also be a router on the local network. 
#</p>

# ====== Note ======
#<p>
#
#  The Google Public IPv4 DNS addresses are 8.8.8.8 and 8.8.4.4. 
#</p>

# ==== 9.5.3. Configuring the System Hostname ====
#<p>
#
#  During the boot process, the file /etc/hostname 
#  is used for establishing the system's hostname. 
#</p>
#<p>
#
#  Create the /etc/hostname 
#  file and enter a hostname by running: 
#</p>

#********<pre>***********
echo "<lfs>" > /etc/hostname
#********</pre>**********
#<p>
#<lfs> 
#  needs to be replaced with the name given to the computer. Do not enter the 
# Fully Qualified Domain Name (FQDN) here. That information goes in the /etc/hosts 
#  file. 
#</p>

# ==== 9.5.4. Customizing the /etc/hosts File ====
#<p>
#
#  Decide on a fully-qualified domain name (FQDN), and possible aliases for use 
# in the /etc/hosts 
#  file. If using static IP addresses, you'll also need to decide on an IP 
# address. The syntax for a hosts file entry is: 
#</p>

#********<pre>***********
#IP_address myhost.example.org aliases
#********</pre>**********
#<p>
#
#  Unless the computer is to be visible to the Internet (i.e., there is a 
# registered domain and a valid block of assigned IP addresses—most users do 
# not have this), make sure that the IP address is in the private network IP 
# address range. Valid ranges are: 
#</p>

#********<pre>***********
#Private Network Address Range      Normal Prefix
#10.0.0.1 - 10.255.255.254           8
#172.x.0.1 - 172.x.255.254           16
#192.168.y.1 - 192.168.y.254         24
#********</pre>**********
#<p>
#
#  x can be any number in the range 16-31. y can be any number in the range 
# 0-255. 
#</p>
#<p>
#
#  A valid private IP address could be 192.168.1.2. 
#</p>
#<p>
#
#  If the computer is to be visible to the Internet, a valid FQDN can be the 
# domain name itself, or a string resulted by concatenating a prefix (often the 
# hostname) and the domain name with a “.”
#  character. And, you need to contact the domain provider to resolve the FQDN to 
# your public IP address. 
#</p>
#<p>
#
#  Even if the computer is not visible to the Internet, a FQDN is still needed 
# for certain programs, such as MTAs, to operate properly. A special FQDN, localhost.localdomain 
#  , can be used for this purpose. 
#</p>
#<p>
#
#  Create the /etc/hosts 
#  file by running: 
#</p>

#********<pre>***********
cat > /etc/hosts << "EOF"
# Begin /etc/hosts

127.0.0.1 localhost.localdomain localhost
127.0.1.1 <FQDN><HOSTNAME><192.168.1.2><FQDN><HOSTNAME>[alias1] [alias2 ...]
::1       localhost ip6-localhost ip6-loopback
ff02::1   ip6-allnodes
ff02::2   ip6-allrouters

# End /etc/hosts
EOF
#********</pre>**********
#<p>
#
#  The <192.168.1.2> 
#  , <FQDN> 
#  , and <HOSTNAME> 
#  values need to be changed for specific uses or requirements (if assigned an IP 
# address by a network/system administrator and the machine will be connected to 
# an existing network). The optional alias name(s) can be omitted. 
#</p>
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt
