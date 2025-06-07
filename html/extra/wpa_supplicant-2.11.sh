topdir=$(pwd)
err=0
set -e
chapter=wpa_supplicant-2.11
err_report() {
    echo "chapter $chapter: $(date +'%Y.%m.%d %H:%M:%S') Error $? on line $1" | tee >> $topdir/log.txt
}
trap 'err_report $LINENO' ERR
echo "---------" >> $topdir/log.txt
echo chapter $chapter: start = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt




srcdir=../../src/wpa_supplicant-2.11
tar xf ../../src/wpa_supplicant-2.11.tar.gz -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir









# Introduction to WPA Supplicant
# 
# WPA Supplicant is a Wi-Fi Protected Access (WPA) client and IEEE 802.1X supplicant. It implements WPA key negotiation with a WPA Authenticator and Extensible Authentication Protocol (EAP) authentication with an Authentication Server. In addition, it controls the roaming and IEEE 802.11 authentication/association of the wireless LAN driver. This is useful for connecting to a password protected wireless access point.
# [Note] Note
# 
# Development versions of BLFS may not build or run some packages properly if LFS or dependencies have been updated since the most recent stable versions of the books.
# Package Information
# 
#     Download (HTTP): https://w1.fi/releases/wpa_supplicant-2.11.tar.gz
# 
#     Download MD5 sum: 72a4a00eddb7a499a58113c3361ab094
# 
#     Download size: 3.7 MB
# 
#     Estimated disk space required: 35 MB
# 
#     Estimated build time: 0.3 SBU
# 
# WPA Supplicant Dependencies
# Required (Runtime)
# 
# Configuring the Linux Kernel for Wireless
# Recommended
# 
# libnl-3.11.0
# Optional
# 
# dbus-1.16.2 and libxml2-2.14.3
# Kernel Configuration
# 
# To use wpa_supplicant, the kernel must have the appropriate drivers and other support available. Read Configuring the Linux Kernel for Wireless for details.
# Installation of WPA Supplicant
# 
# First you will need to create an initial configuration file for the build process. You can read wpa_supplicant/README and wpa_supplicant/defconfig for the explanation of the following options as well as other options that can be used. Create a build configuration file that should work for standard WiFi setups by running the following command:

cat > wpa_supplicant/.config << "EOF"
CONFIG_BACKEND=file
CONFIG_CTRL_IFACE=y
CONFIG_DEBUG_FILE=y
CONFIG_DEBUG_SYSLOG=y
CONFIG_DEBUG_SYSLOG_FACILITY=LOG_DAEMON
CONFIG_DRIVER_NL80211=y
CONFIG_DRIVER_WEXT=y
CONFIG_DRIVER_WIRED=y
CONFIG_EAP_GTC=y
CONFIG_EAP_LEAP=y
CONFIG_EAP_MD5=y
CONFIG_EAP_MSCHAPV2=y
CONFIG_EAP_OTP=y
CONFIG_EAP_PEAP=y
CONFIG_EAP_TLS=y
CONFIG_EAP_TTLS=y
CONFIG_IEEE8021X_EAPOL=y
CONFIG_IPV6=y
CONFIG_LIBNL32=y
CONFIG_PEERKEY=y
CONFIG_PKCS12=y
CONFIG_READLINE=y
CONFIG_SMARTCARD=y
CONFIG_WPS=y
CFLAGS += -I/usr/include/libnl3
EOF

# If you wish to use WPA Supplicant with NetworkManager-1.52.0, make sure that you have installed dbus-1.16.2, then add the following options to the WPA Supplicant build configuration file by running the following command:
# 
# cat >> wpa_supplicant/.config << "EOF"
# CONFIG_CTRL_IFACE_DBUS=y
# CONFIG_CTRL_IFACE_DBUS_NEW=y
# CONFIG_CTRL_IFACE_DBUS_INTRO=y
# EOF

# Install WPA Supplicant by running the following commands:

cd wpa_supplicant &&
make BINDIR=/usr/sbin LIBDIR=/usr/lib

# This package does not come with a test suite.
# 
# Now, as the root user:

install -v -m755 wpa_{cli,passphrase,supplicant} /usr/sbin/ &&
install -v -m644 doc/docbook/wpa_supplicant.conf.5 /usr/share/man/man5/ &&
install -v -m644 doc/docbook/wpa_{cli,passphrase,supplicant}.8 /usr/share/man/man8/

# If you have built WPA Supplicant with D-Bus support, you will need to install D-Bus configuration files.
# Install them by running the following commands as the root user:
# 
# install -v -m644 dbus/fi.w1.wpa_supplicant1.service \
#                  /usr/share/dbus-1/system-services/ &&
# install -v -d -m755 /etc/dbus-1/system.d &&
# install -v -m644 dbus/dbus-wpa_supplicant.conf \
#                  /etc/dbus-1/system.d/wpa_supplicant.conf
# 
# [Note] Note
# 
# You will need to restart the system D-Bus daemon before you can use the WPA Supplicant D-Bus interface.
# Configuring wpa_supplicant
# [Important] Important
# 
# If you are using WPA Supplicant with NetworkManager-1.52.0 (or anything communicating with WPA Supplicant via D-Bus), this section should be skipped.
# Running a D-Bus connected WPA Supplicant instance and another WPA supplicant instance configured following this section
# simultaneously can cause subtle issues.
# Config File
# 
# /etc/sysconfig/wpa_supplicant-*.conf
# Configuration Information
# 
# To connect to an access point that uses a password, you need to put the pre-shared key in /etc/sysconfig/wpa_supplicant-wifi0.conf. SSID is the string that the access point/router transmits to identify itself. Run the following command as the root user:
# 
#
#wpa_passphrase $SSID $SECRET_PASSWORD > /etc/sysconfig/wpa_supplicant-wifi0.conf
#
# 
# /etc/sysconfig/wpa_supplicant-wifi0.conf can hold the details of several access points. When wpa_supplicant is started, it will scan for the SSIDs it can see and choose the appropriate password to connect.
# 
# If you want to connect to an access point that isn't password protected, put an entry like this
# in /etc/sysconfig/wpa_supplicant-wifi0.conf. Replace "Some-SSID" with the SSID of the access point/router.
# 
# network={
#   ssid="Some-SSID"
#   key_mgmt=NONE
# }
# 
# Connecting to a new access point that is not in the configuration file can be accomplished manually via the command line, but it must be done via a privileged user. To do that, add the following to the configuration file:
#
# ctrl_interface=DIR=/run/wpa_supplicant GROUP=<privileged group>
# update_config=1
#
# Replace the <privileged group> above with a system group where members have the ability to connect to a wireless access point.
#
# There are many options that you could use to tweak how you connect to each access point. They are described in some detail in the wpa_supplicant/wpa_supplicant.conf file in the source tree.
# Connecting to an Access Point
#
# If you want to configure network interfaces at boot using wpa_supplicant, you need to install the /lib/services/wpa script included in blfs-bootscripts-20250225 package:

srcdir=$(pwd)
cd /usr/src/blfs-bootscripts-20250225
make install-service-wpa
cd $srcdir

# If your router/access point uses DHCP to allocate IP addresses, you can install dhcpcd-10.2.4 and use it to automatically obtain network addresses. Create the /etc/sysconfig/ifconfig-wifi0 by running the following command as the root user:
# 
# cat > /etc/sysconfig/ifconfig.wifi0 << "EOF"
# ONBOOT="yes"
# IFACE="wlan0"
# SERVICE="wpa"
# 
# # Additional arguments to wpa_supplicant
# WPA_ARGS=""
# 
# WPA_SERVICE="dhcpcd"
# DHCP_START="-b -q <insert appropriate start options here>"
# DHCP_STOP="-k <insert additional stop options here>"
# EOF
# 
# Alternatively, if you use static addresses on your local network, then create the /etc/sysconfig/ifconfig-wifi0 by running the following command as the root user:

cat > /etc/sysconfig/ifconfig.wifi0 << "EOF"
ONBOOT="yes"
IFACE="wlan0"
SERVICE="wpa"

# Additional arguments to wpa_supplicant
WPA_ARGS=""

WPA_SERVICE="ipv4-static"
IP="192.168.1.1"
GATEWAY="192.168.1.2"
PREFIX="24"
BROADCAST="192.168.1.255"
EOF

# You can connect to the wireless access point by running the following command as the root user:
# 
# ifup wifi0
# 
# Replace wlan0 with the correct wireless interface and wifi0 with desired name for the configuration file. Please note that wpa_supplicant-*.conf and ifconfig.* configuration files need to have identical names, ie both contain wifi0 in their name.
# Contents
# Installed Programs:
# wpa_supplicant, wpa_passphrase and wpa_cli
# Installed Libraries:
# None
# Installed Directories:
# None
# Short Descriptions
# 
# wpa_supplicant
# 	
# 
# is a daemon that can connect to a password protected wireless access point
# 
# wpa_passphrase
# 	
# 
# takes an SSID and a password and generates a simple configuration that wpa_supplicant can understand
# 
# wpa_cli
# 	
# 
# is a command line interface used to control a running wpa_supplicant daemon  








cd $topdir
rm -rf $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt

