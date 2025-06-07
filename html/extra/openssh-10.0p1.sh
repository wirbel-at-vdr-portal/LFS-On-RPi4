topdir=$(pwd)
err=0
set -e
chapter=openssh-10.0p1
err_report() {
    echo "chapter $chapter: $(date +'%Y.%m.%d %H:%M:%S') Error $? on line $1" | tee >> $topdir/log.txt
}
trap 'err_report $LINENO' ERR
echo "---------" >> $topdir/log.txt
echo chapter $chapter: start = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt




srcdir=../../src/openssh-10.0p1
tar xf ../../src/openssh-10.0p1.tar.gz -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir





# Introduction to OpenSSH
# 
# The OpenSSH package contains ssh clients and the sshd daemon. This is useful for encrypting authentication and subsequent traffic over a network. The ssh and scp commands are secure implementations of telnet and rcp respectively.
# [Note] Note
# 
# This package reports version OpenSSH_10.0p2 even though the source package is openssh-10.0p1.
# [Note] Note
# 
# Development versions of BLFS may not build or run some packages properly if LFS or dependencies have been updated since the most recent stable versions of the books.
# Package Information
# 
#     Download (HTTP): https://ftp.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-10.0p1.tar.gz
# 
#     Download MD5 sum: 689148621a2eaa734497b12bed1c5202
# 
#     Download size: 1.9 MB
# 
#     Estimated disk space required: 50 MB (add 22 MB for tests)
# 
#     Estimated build time: 0.4 SBU (Using parallelism=4; running the tests takes about 15 minutes, irrespective of processor speed)
# 
# OpenSSH Dependencies
# Optional
# 
# GDB-16.3 (for tests), Linux-PAM-1.7.0 (PAM configuration files from Shadow-4.17.4 are used to create openssh ones),
# Xorg Applications (or Xorg build environment, see Command Explanations),
# MIT Kerberos V5-1.21.3, Which-2.23 (for tests), libedit, LibreSSL Portable, OpenSC, and libsectok
# Optional Runtime (Used only to gather entropy)
# 
# Net-tools-2.10, and Sysstat-12.7.7
# Installation of OpenSSH
# 
# OpenSSH runs as two processes when connecting to other computers.
# The first process is a privileged process and controls the issuance of privileges as necessary.
# The second process communicates with the network. Additional installation steps are necessary
# to set up the proper environment, which are performed by issuing the following commands as the root user:

install -v -g sys -m700 -d /var/lib/sshd &&

groupadd -g 50 sshd        &&
useradd  -c 'sshd PrivSep' \
         -d /var/lib/sshd  \
         -g sshd           \
         -s /bin/false     \
         -u 50 sshd

# Install OpenSSH by running the following commands:

./configure --prefix=/usr                            \
            --sysconfdir=/etc/ssh                    \
            --with-privsep-path=/var/lib/sshd        \
            --with-default-path=/usr/bin             \
            --with-superuser-path=/usr/sbin:/usr/bin \
            --with-pid-dir=/run                      &&
make -j8

# To test the results, issue: make -j1 tests.
# 
# Now, as the root user:

make install &&
install -v -m755    contrib/ssh-copy-id /usr/bin     &&

install -v -m644    contrib/ssh-copy-id.1 \
                    /usr/share/man/man1              &&
install -v -m755 -d /usr/share/doc/openssh-10.0p1     &&
install -v -m644    INSTALL LICENCE OVERVIEW README* \
                    /usr/share/doc/openssh-10.0p1

# Command Explanations
# 
# --sysconfdir=/etc/ssh: This prevents the configuration files from being installed in /usr/etc.
# 
# --with-default-path=/usr/bin and --with-superuser-path=/usr/sbin:/usr/bin: These set PATH consistent with LFS and BLFS Shadow package.
# 
# --with-pid-dir=/run: This prevents OpenSSH from referring to deprecated /var/run.
# 
# --with-pam: This parameter enables Linux-PAM support in the build.
# 
# --with-xauth=$XORG_PREFIX/bin/xauth: Set the default location for the xauth binary for X authentication. The environment variable XORG_PREFIX should be set following Xorg build environment. This can also be controlled from sshd_config with the XAuthLocation keyword. You can omit this switch if Xorg is already installed.
# 
# --with-kerberos5=/usr: This option is used to include Kerberos 5 support in the build.
# 
# --with-libedit: This option enables line editing and history features for sftp.
# Configuring OpenSSH
# Config Files
# 
# ~/.ssh/*, /etc/ssh/ssh_config, and /etc/ssh/sshd_config
# 
# There are no required changes to any of these files. However, you may wish to view the /etc/ssh/ files and make any changes appropriate for the security of your system. One recommended change is that you disable root login via ssh. Execute the following command as the root user to disable root login via ssh:
# 
# echo "PermitRootLogin no" >> /etc/ssh/sshd_config
# 
# If you want to be able to log in without typing in your password, first create ~/.ssh/id_rsa and ~/.ssh/id_rsa.pub with ssh-keygen and then copy ~/.ssh/id_rsa.pub to ~/.ssh/authorized_keys on the remote computer that you want to log into. You'll need to change REMOTE_USERNAME and REMOTE_HOSTNAME for the username and hostname of the remote computer and you'll also need to enter your password for the ssh-copy-id command to succeed:
# 
# ssh-keygen &&
# ssh-copy-id -i ~/.ssh/id_ed25519.pub REMOTE_USERNAME@REMOTE_HOSTNAME
# 
# Once you've got passwordless logins working it's actually more secure than logging in with a password (as the private key is much longer than most people's passwords). If you would like to now disable password logins, as the root user:
# 
# echo "PasswordAuthentication no" >> /etc/ssh/sshd_config &&
# echo "KbdInteractiveAuthentication no" >> /etc/ssh/sshd_config

# If you added Linux-PAM support and you want ssh to use it then you will need to add a configuration file for sshd and enable use of LinuxPAM. Note, ssh only uses PAM to check passwords, if you've disabled password logins these commands are not needed. If you want to use PAM, issue the following commands as the root user:
# 
# sed 's@d/login@d/sshd@g' /etc/pam.d/login > /etc/pam.d/sshd &&
# chmod 644 /etc/pam.d/sshd &&
# echo "UsePAM yes" >> /etc/ssh/sshd_config

#Additional configuration information can be found in the man pages for sshd, ssh and ssh-agent.
#Boot Script
#
# To start the SSH server at system boot, install the /etc/rc.d/init.d/sshd init script included in the blfs-bootscripts-20250225 package.
# [Note] Note
# 
# Changing the setting of ListenAddress in /etc/sshd/sshd_config is unsupported with the BLFS sshd bootscript.

# make install-sshd

# Contents
# Installed Programs:
# scp, sftp, ssh, ssh-add, ssh-agent, ssh-copy-id, ssh-keygen, ssh-keyscan, and sshd
# Installed Libraries:
# None
# Installed Directories:
# /etc/ssh, /usr/share/doc/openssh-10.0p1, and /var/lib/sshd
# Short Descriptions
# 
# scp
# 	
# 
# is a file copy program that acts like rcp except it uses an encrypted protocol
# 
# sftp
# 	
# 
# is an FTP-like program that works over the SSH1 and SSH2 protocols
# 
# ssh
# 	
# 
# is an rlogin/rsh-like client program except it uses an encrypted protocol
# 
# sshd
# 	
# 
# is a daemon that listens for ssh login requests
# 
# ssh-add
# 	
# 
# is a tool which adds keys to the ssh-agent
# 
# ssh-agent
# 	
# 
# is an authentication agent that can store private keys
# 
# ssh-copy-id
# 	
# 
# is a script that enables logins on remote machines using local keys
# 
# ssh-keygen
# 	
# 
# is a key generation tool
# 
# ssh-keyscan
# 	
# 
# is a utility for gathering public host keys from a number of hosts 




cd $topdir
rm -rf $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt

