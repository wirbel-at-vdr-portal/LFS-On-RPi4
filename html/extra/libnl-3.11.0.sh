topdir=$(pwd)
err=0
set -e
chapter=libnl-3.11.0
err_report() {
    echo "chapter $chapter: $(date +'%Y.%m.%d %H:%M:%S') Error $? on line $1" | tee >> $topdir/log.txt
}
trap 'err_report $LINENO' ERR
echo "---------" >> $topdir/log.txt
echo chapter $chapter: start = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt




srcdir=../../src/libnl-3.11.0
tar xf ../../src/libnl-3.11.0.tar.gz -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir









# Introduction to libnl
# 
# The libnl suite is a collection of libraries providing APIs to netlink protocol based Linux kernel interfaces.
# [Note] Note
# 
# Development versions of BLFS may not build or run some packages properly if LFS or dependencies have been updated since the most recent stable versions of the books.
# Package Information
# 
#     Download (HTTP): https://github.com/thom311/libnl/releases/download/libnl3_11_0/libnl-3.11.0.tar.gz
# 
#     Download MD5 sum: 0a5eb82b494c411931a47638cb0dba51
# 
#     Download size: 1.1 MB
# 
#     Estimated disk space required: 28 MB (with API documentation)
# 
#     Estimated build time: 0.3 SBU (with API documentation)
# 
# Optional Download
# 
#     Download (HTTP): https://github.com/thom311/libnl/releases/download/libnl3_11_0/libnl-doc-3.11.0.tar.gz
# 
#     Download MD5 sum: 5c74044c92f2eb08de69cce88714cd1b
# 
#     Download size: 3.8 MB
# 
# Installation of libnl
# 
# Install libnl by running the following commands:

./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --disable-static  &&
make

# [Note] Note
# 
# If the make command was executed with multiple parallel jobs enabled,
# it might disrupt the terminal mode and cause some “amusing” visual effects.
# In the worst case, this issue may cause keyboard inputs not displayed on
# the screen at all (but you can still run any command if you can type it
# correctly). Run the reset command to fix such an issue.
# 
# If you wish to run the tests, check that the following options are enabled in the kernel configuration and recompile the kernel if necessary. Some of them may not be strictly needed, but they should support a complete test coverage.
# 
# General setup --->
#   -*- Namespaces support --->                                       [NAMESPACES]
#     [*] User namespace                                                 [USER_NS]
#     [*] Network namespace                                               [NET_NS]
# 
# [*] Networking support --->                                                [NET]
#   Networking options --->
#     [*]   TCP/IP networking                                               [INET]
#     [*]     IP: advanced router                             [IP_ADVANCED_ROUTER]
#     [*]       IP: policy routing                            [IP_MULTIPLE_TABLES]
#     <*/M>   IP: tunneling                                             [NET_IPIP]
#     <*/M>   IP: GRE demultiplexer                              [NET_IPGRE_DEMUX]
#     <*/M>   IP: GRE tunnels over IP                                  [NET_IPGRE]
#     <*/M>   Virtual (secure) IP: tunneling                           [NET_IPVTI]
#     <*>     The IPv6 protocol --->                                        [IPV6]
#       <*/M>   IPv6: IPv6-in-IPv4 tunnel (SIT driver)                  [IPV6_SIT]
#       <*/M>   IPv6: IP-in-IPv6 tunnel (RFC2473)                    [IPV6_TUNNEL]
#       [*]     IPv6: Multiple Routing Tables               [IPV6_MULTIPLE_TABLES]
#     [*]   Network packet filtering framework (Netfilter) --->        [NETFILTER]
#       Core Netfilter Configuration --->
#         <*/M> Netfilter nf_tables support                            [NF_TABLES]
#         [*]     Netfilter nf_tables netdev tables support     [NF_TABLES_NETDEV]
#         {*/M}   Netfilter packet duplication support             [NF_DUP_NETDEV]
#         <*/M>   Netfilter nf_tables netdev packet forwarding support
#                                                            ...  [NFT_FWD_NETDEV]
#     <*/M> 802.1d Ethernet Bridging                                      [BRIDGE]
#     <*/M> 802.1Q/802.1ad VLAN Support                               [VLAN_8021Q]
#     -*-   L3 Master device support                           [NET_L3_MASTER_DEV]
# 
# Device Drivers --->
#   [*] Network device support --->                                   [NETDEVICES]
#     [*]   Network core driver support                                 [NET_CORE]
#     <*/M>   Bonding driver support                                     [BONDING]
#     <*/M>   Dummy net driver support                                     [DUMMY]
#     <*/M>   Intermediate Functional Block support                          [IFB]
#     <*/M>   MAC-VLAN support                                           [MACVLAN]
#     <*/M>     MAC-VLAN based tap driver                                [MACVTAP]
#     <*/M>   IP-VLAN support                                             [IPVLAN]
#     <*/M>   Virtual eXtensible Local Area Network (VXLAN)                [VXLAN]
#     <*/M>   IEEE 802.1AE MAC-level encryption (MACsec)                  [MACSEC]
#     <*/M>   Virtual ethernet pair device                                  [VETH]
#     <*/M>   Virtual Routing and Forwarding (Lite)                      [NET_VRF]
# 
# To test the results, issue: make check.
# 
# Now, as the root user:

make install

# If you wish to install the API documentation, as the root user:
# 
# mkdir -vp /usr/share/doc/libnl-3.11.0 &&
# tar -xf ../libnl-doc-3.11.0.tar.gz --strip-components=1 --no-same-owner \
#     -C  /usr/share/doc/libnl-3.11.0
# 
# Command Explanations
# 
# --disable-static: This switch prevents installation of static versions of the libraries.
# 
# --disable-cli: Use this parameter if you don't want to install cli tools provided by the package.
# Contents
# Installed Programs:
# genl-ctrl-list, idiag-socket-details, nl-class-add, nl-class-delete, nl-classid-lookup, nl-class-list, nl-cls-add, nl-cls-delete, nl-cls-list, nl-link-list, nl-pktloc-lookup, nl-qdisc-add, nl-qdisc-delete, nl-qdisc-list, and 48 other helper programs with nl- and nf- prefixes
# Installed Libraries:
# libnl-3.so, libnl-cli-3.so, libnl-genl-3.so, libnl-idiag-3.so, libnl-nf-3.so, libnl-route-3.so, libnl-xfrm-3.so, and cli modules under /usr/lib/libnl/cli tree
# Installed Directories:
# /etc/libnl, /usr/include/libnl3, /usr/lib/libnl, and /usr/share/doc/libnl-3.11.0
# Short Descriptions
# 
# genl-ctrl-list
# 	
# 
# queries the Generic Netlink controller in the kernel and prints a list of all registered Generic Netlink families including the version of the interface that has been registered
# 
# nl-class-add
# 	
# 
# adds, updates, or replaces Traffic Classes
# 
# nl-class-delete
# 	
# 
# deletes Traffic Classes
# 
# nl-classid-lookup
# 	
# 
# is used to resolve qdisc/class names to classid values and vice versa
# 
# nl-class-list
# 	
# 
# lists Traffic Classes
# 
# nl-cls-add
# 	
# 
# adds a classifier
# 
# nl-cls-delete
# 	
# 
# deletes a classifier
# 
# nl-cls-list
# 	
# 
# lists classifiers
# 
# nl-link-list
# 	
# 
# dumps link attributes
# 
# nl-pktloc-lookup
# 	
# 
# allows the lookup of packet location definitions
# 
# nl-qdisc-add
# 	
# 
# adds queueing disciplines (qdiscs) in the kernel
# 
# nl-qdisc-delete
# 	
# 
# deletes queueing disciplines (qdiscs) in the kernel
# 
# nl-qdisc-list
# 	
# 
# lists queueing disciplines (qdiscs) in the kernel
# 
# libnl*-3.so
# 	
# 
# These libraries contain API functions used to access Netlink interfaces in Linux kernel 
# 







cd $topdir
rm -rf $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt

