topdir=$(pwd)
err=0
set -e
chapter=ntp-4.2.8p18
err_report() {
    echo "chapter $chapter: $(date +'%Y.%m.%d %H:%M:%S') Error $? on line $1" | tee >> $topdir/log.txt
}
trap 'err_report $LINENO' ERR
echo "---------" >> $topdir/log.txt
echo chapter $chapter: start = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt




srcdir=../../src/ntp-4.2.8p18
tar xf ../../src/ntp-4.2.8p18.tar.gz -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir








# ntp-4.2.8p18
# Introduction to ntp
# 
# The ntp package contains a client and server to keep the time synchronized between various computers over a network. This package is the official reference implementation of the NTP protocol.
# [Note] Note
# 
# Development versions of BLFS may not build or run some packages properly if LFS or dependencies have been updated since the most recent stable versions of the books.
# Package Information
# 
#     Download (HTTP): https://www.eecis.udel.edu/~ntp/ntp_spool/ntp4/ntp-4.2/ntp-4.2.8p18.tar.gz
# 
#     Download MD5 sum: 516bdabd94ab7c824e9771390761a46c
# 
#     Download size: 6.8 MB
# 
#     Estimated disk space required: 99 MB (with tests)
# 
#     Estimated build time: 0.8 SBU (With tests; both using parallelism=4)
# 
# ntp Dependencies
# Required
# 
# IO-Socket-SSL-2.090
# Optional
# 
# libcap-2.76 with PAM, libevent-2.1.12, libedit, and libopts from AutoGen
# 
# Editor Notes: https://wiki.linuxfromscratch.org/blfs/wiki/ntp
# Installation of ntp
# 
# There should be a dedicated user and group to take control of the ntpd daemon after it is started. Issue the following commands as the root user:

groupadd -g 87 ntp &&
useradd -c "Network Time Protocol" -d /var/lib/ntp -u 87 \
        -g ntp -s /bin/false ntp

# Fix an type issue by executing

sed -e "s;pthread_detach(NULL);pthread_detach(0);" \
    -i configure \
       sntp/configure

# Install ntp by running the following commands:

./configure --prefix=/usr      \
            --bindir=/usr/sbin \
            --sysconfdir=/etc  \
            --enable-linuxcaps \
            --with-lineeditlibs=readline \
            --docdir=/usr/share/doc/ntp-4.2.8p18
sleep 10

make -j8
sleep 10

# To test the results, issue: make check.

# Now, as the root user:

make install &&
install -v -o ntp -g ntp -d /var/lib/ntp
sleep 10

# Command Explanations
# 
# --bindir=/usr/sbin: This parameter places the administrative programs in /usr/sbin.
# 
# --enable-linuxcaps: ntpd is run as user ntp, so use Linux capabilities for non-root clock control.
# 
# --with-lineeditlibs=readline: This switch enables Readline support for ntpdc and ntpq programs. If omitted, libedit will be used if installed, otherwise no readline capabilities will be compiled.
# Configuring ntp
# Config Files
# 
# /etc/ntp.conf
# Configuration Information
# 
# The following configuration file first defines various ntp servers with open access from different continents. Second, it creates a drift file where ntpd stores the frequency offset and a pid file to store the ntpd process ID. Since the documentation included with the package is sparse, visit the ntp website at https://www.ntp.org/ and https://www.ntppool.org/ for more information.

cat > /etc/ntp.conf << "EOF"
# # Asia
# server 0.asia.pool.ntp.org
# 
# # Australia
# server 0.oceania.pool.ntp.org
# 
# Europe
server 0.europe.pool.ntp.org

# North America
# server 0.north-america.pool.ntp.org
# 
# # South America
# server 2.south-america.pool.ntp.org

driftfile /var/lib/ntp/ntp.drift
pidfile   /run/ntpd.pid
EOF

# You may wish to add a “Security session.” For explanations, see https://www.eecis.udel.edu/~mills/ntp/html/accopt.html#restrict.

cat >> /etc/ntp.conf << "EOF"
# Security session
restrict    default limited kod nomodify notrap nopeer noquery
restrict -6 default limited kod nomodify notrap nopeer noquery

restrict 127.0.0.1
restrict ::1
EOF

# Synchronizing the Time
# 
# There are two options. Option one is to run ntpd continuously and allow it to synchronize the time in a gradual manner. The other option is to run ntpd periodically (using cron) and update the time each time ntpd is scheduled.
# 
# If you choose Option one, then install the /etc/rc.d/init.d/ntp init script included in the blfs-bootscripts-20250225 package.

srcdir=$(pwd)
cd ../../blfs-bootscripts-20250225
make install-ntpd
cd $srcdir
sleep 10

#If you prefer to run ntpd periodically, add the following command to root's crontab:
#
#ntpd -q
#
#Execute the following command if you would like to set the hardware clock to the current system time at shutdown and reboot:

ln -v -sf ../init.d/setclock /etc/rc.d/rc0.d/K46setclock &&
ln -v -sf ../init.d/setclock /etc/rc.d/rc6.d/K46setclock

# The other way around is already set up by LFS.
# Contents
# Installed Programs:
# calc_tickadj, ntp-keygen, ntp-wait, ntpd, ntpdate, ntpdc, ntpq, ntptime, ntptrace, sntp, tickadj, and update-leap
# Installed Libraries:
# None
# Installed Directories:
# /usr/share/ntp, /usr/share/doc/ntp-4.2.8 and /var/lib/ntp
# Short Descriptions
# 
# calc_tickadj
# 	
# 
# calculates optimal value for tick given ntp drift file
# 
# ntp-keygen
# 	
# 
# generates cryptographic data files used by the NTPv4 authentication and identification schemes
# 
# ntp-wait
# 	
# 
# is useful at boot time, to delay the boot sequence until ntpd has set the time
# 
# ntpd
# 	
# 
# is a ntp daemon that runs in the background and keeps the date and time synchronized based on response from configured ntp servers. It also functions as a ntp server
# 
# ntpdate
# 	
# 
# is a client program that sets the date and time based on the response from an ntp server. This command is deprecated
# 
# ntpdc
# 	
# 
# is used to query the ntp daemon about its current state and to request changes in that state
# 
# ntpq
# 	
# 
# is a utility program used to monitor ntpd operations and determine performance
# 
# ntptime
# 	
# 
# reads and displays time-related kernel variables
# 
# ntptrace
# 	
# 
# traces a chain of ntp servers back to the primary source
# 
# sntp
# 	
# 
# is a Simple Network Time Protocol (SNTP) client
# 
# tickadj
# 	
# 
# reads, and optionally modifies, several timekeeping-related variables in older kernels that do not have support for precision timekeeping
# 
# update-leap
# 	
# 
# is a script to verify and, if necessary, update the leap-second definition file.
# [Note] Note
# 
# In November 2022, at the 27th General Conference on Weights and Measures, it was decided to abandon the leap second. In addition this script hardcodes a URL for an update file that no longer exists. The last time a leap second was declared was January 2017. This script will probably be removed in a future release.





cd $topdir
rm -rf $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt

