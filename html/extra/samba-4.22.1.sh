topdir=$(pwd)
err=0
set -e
chapter=samba-4.22.1
err_report() {
    echo "chapter $chapter: $(date +'%Y.%m.%d %H:%M:%S') Error $? on line $1" | tee >> $topdir/log.txt
}
trap 'err_report $LINENO' ERR
echo "---------" >> $topdir/log.txt
echo chapter $chapter: start = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt




srcdir=../../src/samba-4.22.1
tar xf ../../src/samba-4.22.1.tar.gz -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir






# Introduction to Samba
# 
# The Samba package provides file and print services to SMB/CIFS clients and Windows networking to Linux clients. Samba can also be configured as a Windows Domain Controller replacement, a file/print server acting as a member of a Windows Active Directory domain and a NetBIOS (RFC1001/1002) nameserver (which among other things provides LAN browsing support).
# [Note] Note
# 
# Development versions of BLFS may not build or run some packages properly if LFS or dependencies have been updated since the most recent stable versions of the books.
# Package Information
# 
#     Download (HTTP): https://download.samba.org/pub/samba/stable/samba-4.22.1.tar.gz
# 
#     Download MD5 sum: c3f3d5eb760b27d5d340f81844405673
# 
#     Download size: 41 MB
# 
#     Estimated disk space required: 691 MB (add 64 MB for quicktest)
# 
#     Estimated build time: 2.1 SBU (using parallelism=4; add 0.4 SBU for quicktest)
# 
# Samba Dependencies
# Required
# 
# GnuTLS-3.8.9, libtirpc-1.3.6, Parse-Yapp-1.21, and rpcsvc-proto-1.4.4
# Recommended
# 
# dbus-1.16.2 (for vfs_snapper, which is useful on systems that support Volume Shadow Copies on Windows), Fuse-3.17.2, GPGME-1.24.3, ICU-77.1, jansson-2.14, libtasn1-4.20.0, libxslt-1.1.43 (for documentation), Linux-PAM-1.7.0, lmdb-0.9.31, MIT Kerberos V5-1.21.3, and OpenLDAP-2.6.10
# Optional
# 
# Avahi-0.8, BIND-9.20.9, Cups-2.4.12, Cyrus SASL-2.1.28, GDB-16.3, git-2.49.0, GnuPG-2.4.8 (required for ADS and the test suite), libaio-0.3.113, libarchive-3.8.0 (for tar in smbclient), libcap-2.76 with PAM, libgcrypt-1.11.1, libnsl-2.0.1, libunwind-1.8.2, Markdown-3.8, nss-3.112, popt-1.19, Talloc-2.4.3 (used by the test suite), Vala-0.56.18, Valgrind-3.25.1 (optionally used by the test suite), xfsprogs-6.14.0, cmocka, cryptography, ctdb (included), cwrap, dnspython, FAM, Gamin, GlusterFS, Heimdal (included), iso8601, ldb (included), OpenAFS, poetry-core (required for ADS), pyasn1, tevent (included), tdb (included), and tracker-2
# Optional (for the Developer Test Suite)
# 
# Install in listed order: six-1.17.0, pytest-8.3.5, argparse, testtools, testscenarios, and python-subunit
# 
# Editor Notes: https://wiki.linuxfromscratch.org/blfs/wiki/samba4
# Installation of Samba
# 
# To support the test suite, set up a Python virtual environment for some Python modules out of the scope of BLFS:
# 
python3 -m venv --system-site-packages pyvenv         &&
./pyvenv/bin/pip3 install cryptography pyasn1 iso8601

# Install Samba by running the following commands:
# 
PYTHON=$PWD/pyvenv/bin/python3             \
PATH=$PWD/pyvenv/bin:$PATH                 \
./configure                                \
    --prefix=/usr                          \
    --sysconfdir=/etc                      \
    --localstatedir=/var                   \
    --with-piddir=/run/samba               \
    --with-pammodulesdir=/usr/lib/security \
    --enable-fhs                           \
    --without-ad-dc                        \
    --without-systemd                      \
    --with-system-mitkrb5                  \
    --without-libarchive                   \
    --disable-rpath-install \
--without-pam --with-shared-modules='!vfs_snapper'

#    --enable-selftest                      \
make  -j4
# 
# To test the results, issue: PATH=$PWD/pyvenv/bin:$PATH make quicktest. The test suite will produce lines that look like failures, but these are innocuous. The last few lines of output should report "ALL OK" for a good test run. A summary of any failures can be found in ./st/summary.
# [Note] Note
# 
# Additionally, developer test suites are available. If you've installed the optional python modules above in the Python virtual environment for building this package, you can run these tests with make test. It is not recommended for the average builder at around 290 SBU and over a gigabyte of disk space, and you should expect ~73 errors and ~30 failures from the 3000+ tests.
# 
# Fix hard coded paths to Python 3 interpreter:
# 
sed '1s@^.*$@#!/usr/bin/python3@' \
    -i ./bin/default/source4/scripting/bin/*.inst
# 
# If upgrading from an old version of samba, as the root user, remove the old Python support files to prevent some issues:
# 
# rm -rf /usr/lib/python3.13/site-packages/samba
# 
# Still as the root user, install the package:
# 
make install
# 
install -v -m644 examples/smb.conf.default /etc/samba &&

sed -e "s;log file =.*;log file = /var/log/samba/%m.log;"   \
    -e "s;path = /usr/spool/samba;path = /var/spool/samba;" \
    -i /etc/samba/smb.conf.default &&

mkdir -pv /etc/openldap/schema &&

install -v -m644    examples/LDAP/README \
                    /etc/openldap/schema/README.samba &&

install -v -m644    examples/LDAP/samba* \
                    /etc/openldap/schema &&

install -v -m755    examples/LDAP/{get*,ol*} \
                    /etc/openldap/schema
# 
# Command Explanations
# 
# --system-site-packages: Allow the Python3 venv module to access the system-installed /usr/lib/python3.13/site-packages directory.
# 
# --enable-fhs: Assigns all other file paths in a manner compliant with the Filesystem Hierarchy Standard (FHS).
# 
# --without-systemd: Disable systemd integration, since it is not built in the System V version of LFS/BLFS.
# 
# --with-shared-modules='!vfs_snapper': Disable the vfs_snapper module if you want to build samba without dbus support, for setups without graphical user interfaces.
# 
# --without-ad-dc: Disables Active Directory Domain Controller functionality. See Set up a Samba Active Directory Domain Controller for detailed information. Remove this switch if you've installed the Python modules needed for ADS support. Note that BLFS does not provide a samba bootscript or systemd unit for an Active Directory domain controller.
# 
# --with-system-mitkrb5: Enables building with the system version of Kerberos. This mitigates security vulnerabilities and reduces build time. Remove this if you do not have MIT Kerberos V5-1.21.3 installed.
# 
# --disable-rpath-install: Removes the library installation path from embedded shared library search paths in the installed binary executable files and shared libraries. When this package is installed into the standard location the library installation path is /usr/lib. It's always searched by the dynamic linker, so there is no need to embed it into installed files.
# 
# --with-selftest-prefix=SELFTEST_PREFIX: This option specifies the test suite work directory (default=./st).
# 
# install -v -m644 examples/LDAP/* /etc/openldap/schema: These commands are used to copy sample Samba schemas to the OpenLDAP schema directory.
# 
# install -v -m644 ../examples/smb.conf.default /etc/samba: This copies a default smb.conf file into /etc/samba. This sample configuration will not work until you copy it to /etc/samba/smb.conf and make the appropriate changes for your installation. See the configuration section for minimum values which must be set.
# Configuring Samba
# Config Files
# 
# /etc/samba/smb.conf
# Printing to SMB Clients
# 
# If you use CUPS for print services, and you wish to print to a printer attached to an SMB client, you need to create an SMB backend device. To create the device, issue the following command as the root user:
# 
# install -dvm 755 /usr/lib/cups/backend &&
# ln -v -sf /usr/bin/smbspool /usr/lib/cups/backend/smb
# 
# Configuration Information
# 
# Due to the complexity and the many various uses for Samba, complete configuration for all the package's capabilities is well beyond the scope of the BLFS book. This section provides instructions to configure the /etc/samba/smb.conf file for two common scenarios. The complete contents of /etc/samba/smb.conf will depend on the purpose of Samba installation.
# [Note] Note
# 
# You may find it easier to copy the configuration parameters shown below into an empty /etc/samba/smb.conf file instead of copying and editing the default file as mentioned in the “Command Explanations” section. How you create/edit the /etc/samba/smb.conf file will be left up to you. Do ensure the file is only writable by the root user (mode 644).
# Scenario 1: Minimal Standalone Client-Only Installation
# 
# Choose this variant if you only want to transfer files using smbclient, mount Windows shares and print to Windows printers, and don't want to share your files and printers to Windows machines.
# 
# A /etc/samba/smb.conf file with the following three parameters is sufficient:
# 
# [global]
#     workgroup = WORKGROUP
#     dos charset = cp850
#     unix charset = ISO-8859-1
# 
# The values in this example specify that the computer belongs to a Windows workgroup named WORKGROUP, uses the cp850 character set on the wire when talking to MS-DOS and MS Windows 9x, and that the filenames are stored in the ISO-8859-1 encoding on the disk. Adjust these values appropriately for your installation. The unix charset value must be the same as the output of locale charmap when executed with the LANG variable set to your preferred locale, otherwise the ls command may not display correct filenames of downloaded files.
# 
# There is no need to run any Samba servers in this scenario, thus you don't need to install the provided bootscripts.
# Scenario 2: Standalone File/Print Server
# 
# Choose this variant if you want to share your files and printers to Windows machines in your workgroup in addition to the capabilities described in Scenario 1.
# 
# In this case, the /etc/samba/smb.conf.default file may be a good template to start from. Also, you should add the “dos charset” and “unix charset” parameters to the “[global]” section as described in Scenario 1 in order to prevent filename corruption. For security reasons, you may wish to define path = /home/alice/shared-files, assuming your user name is alice and you only want to share the files in that directory, instead of your entire home. Then, replace homes by shared-files and change also the “comment” if used the configuration file below or the /etc/samba/smb.conf.default to create yours.
# 
# The following configuration file creates a separate share for each user's home directory and also makes all printers available to Windows machines:
# 
# [global]
#     workgroup = WORKGROUP
#     dos charset = cp850
#     unix charset = ISO-8859-1
# 
# [homes]
#     comment = Home Directories
#     browseable = no
#     writable = yes
# 
# [printers]
#     comment = All Printers
#     path = /var/spool/samba
#     browseable = no
#     guest ok = no
#     printable = yes
# 
# Other parameters you may wish to customize in the “[global]” section include:
# 
#     server string =
#     security =
#     hosts allow =
#     load printers =
#     log file =
#     max log size =
#     socket options =
#     local master =
# 
# Reference the comments in the /etc/samba/smb.conf.default file for information regarding these parameters.
# 
# Since the smbd and nmbd daemons are needed in this case, install the samba bootscript. Be sure to run smbpasswd (with the -a option to add users) to enable and set passwords for all accounts that need Samba access. Using the default Samba passdb backend, any user you attempt to add will also be required to exist in the /etc/passwd file.
# Advanced Requirements
# 
# More complex scenarios involving domain control or membership are possible. Such setups are advanced topics and cannot be adequately covered in BLFS. Many complete books have been written on these topics alone. Note that in some domain membership scenarios, the winbindd daemon and the corresponding bootscript are needed.
# Guest account
# 
# The default Samba installation uses the nobody user for guest access to the server. This can be overridden by setting the guest account = parameter in the /etc/samba/smb.conf file. If you utilize the guest account = parameter, ensure this user exists in the /etc/passwd file.
# Boot Script
# 
# For your convenience, boot scripts have been provided for Samba. There are two included in the blfs-bootscripts-20250225 package. The first, samba, will start the smbd and nmbd daemons needed to provide SMB/CIFS services. The second script, winbind, starts the winbindd daemon, used for providing Windows domain services to Linux clients.
# 
# make install-samba
# 
# make install-winbindd
# 
# Contents
# Installed Programs:
# cifsdd, dbwrap_tool, dumpmscat, eventlogadm, gentest, ldbadd, ldbdel, ldbedit, ldbmodify, ldbrename, ldbsearch, locktest, masktest, mdsearch, mvxattr, ndrdump, net, nmbd, nmblookup, ntlm_auth, oLschema2ldif, pdbedit, profiles, regdiff, regpatch, regshell, regtree, rpcclient, samba-log-parser, samba-gpupdate, samba-regedit, samba-tool, sharesec, smbcacls, smbclient, smbcontrol, smbcquotas, smbd, smbget, smbpasswd, smbspool, smbstatus, smbtar, smbtorture, smbtree, tdbbackup, tdbdump, tdbrestore, tdbtool, testparm, wbinfo, and winbindd
# Installed Libraries:
# libdcerpc-binding.so, libdcerpc-samr.so, libdcerpc-server-core.so, libdcerpc.so, libndr-krb5pac.so, libndr-nbt.so, libndr.so, libndr-standard.so, libnetapi.so, libnss_winbind.so, libnss_wins.so, libsamba-credentials.so, libsamba-errors.so, libsamba-hostconfig.so, libsamba-passdb.so, libsamba-policy.cpython-311-x86_64-linux-gnu.so, libsamba-util.so, libsamdb.so, libsmbclient.so, libsmbconf.so, libsmbldap.so, libtevent-util.so, libwbclient.so, and filesystem and support modules under /usr/lib/{python3.13,samba}
# Installed Directories:
# /etc/samba, /run/samba, /usr/include/samba-4.0, /usr/lib/python3.13/site-packages/samba, /usr/{lib,libexec,share}/samba, and /var/{cache,lib,lock,log,run}/samba
# Short Descriptions
# 
# cifsdd
# 	
# 
# is the dd command for SMB
# 
# dbwrap_tool
# 	
# 
# is used to read and manipulate TDB/CTDB databases using the dbwrap interface
# 
# dumpmscat
# 	
# 
# dumps the content of MS catalog files
# 
# eventlogadm
# 	
# 
# is used to write records to eventlogs from STDIN, add the specified source and DLL eventlog registry entries and display the active eventlog names (from smb.conf)
# 
# gentest
# 	
# 
# is used to run random generic SMB operations against two SMB servers and show the differences in behavior
# 
# ldbadd
# 	
# 
# is a command-line utility for adding records to an LDB database
# 
# ldbdel
# 	
# 
# is a command-line utility for deleting LDB database records
# 
# ldbedit
# 	
# 
# allows you to edit LDB databases using your preferred editor
# 
# ldbmodify
# 	
# 
# allows you to modify records in an LDB database
# 
# ldbrename
# 	
# 
# allows you to rename LDB databases
# 
# ldbsearch
# 	
# 
# searches an LDB database for records matching a specified expression
# 
# locktest
# 	
# 
# is used to find differences in locking between two SMB servers
# 
# masktest
# 	
# 
# is used to find differences in wildcard matching between Samba's implementation and that of a remote server
# 
# mdsearch
# 	
# 
# runs Spotlight searches against a SMB server
# 
# mvxattr
# 	
# 
# is used to recursively rename extended attributes
# 
# ndrdump
# 	
# 
# is a DCE/RPC Packet Parser and Dumper
# 
# net
# 	
# 
# is a tool for administration of Samba and remote CIFS servers, similar to the net utility for DOS/Windows
# 
# nmbd
# 	
# 
# is the Samba NetBIOS name server
# 
# nmblookup
# 	
# 
# is used to query NetBIOS names and map them to IP addresses
# 
# ntlm_auth
# 	
# 
# is a tool to allow external access to Winbind's NTLM authentication function
# 
# oLschema2ldif
# 	
# 
# converts LDAP schema's to LDB-compatible LDIF
# 
# pdbedit
# 	
# 
# is a tool used to manage the SAM database
# 
# profiles
# 	
# 
# is a utility that reports and changes SIDs in Windows registry files
# 
# regdiff
# 	
# 
# is a Diff program for Windows registry files
# 
# regpatch
# 	
# 
# applies registry patches to registry files
# 
# regshell
# 	
# 
# is a Windows registry file browser using readline
# 
# regtree
# 	
# 
# is a text-mode registry viewer
# 
# rpcclient
# 	
# 
# is used to execute MS-RPC client side functions
# 
# samba-log-parser
# 	
# 
# parses winbind logs generated by Samba
# 
# samba-gpupdate
# 	
# 
# allows you to edit Microsoft Group Policy Objects (GPOs)
# 
# samba-regedit
# 	
# 
# is a ncurses based tool to manage the Samba registry
# 
# samba-tool
# 	
# 
# is the main Samba administration tool
# 
# sharesec
# 	
# 
# manipulates share ACL permissions on SMB file shares
# 
# smbcacls
# 	
# 
# is used to manipulate Windows NT access control lists
# 
# smbclient
# 	
# 
# is a SMB/CIFS access utility, similar to FTP
# 
# smbcontrol
# 	
# 
# is used to control running smbd, nmbd and winbindd daemons
# 
# smbcquotas
# 	
# 
# is used to manipulate Windows NT quotas on SMB file shares
# 
# smbd
# 	
# 
# is the main Samba daemon which provides SMB/CIFS services to clients
# 
# smbget
# 	
# 
# is a simple utility with wget-like semantics, that can download files from SMB servers. You can specify the files you would like to download on the command-line
# 
# smbpasswd
# 	
# 
# changes a user's Samba password
# 
# smbspool
# 	
# 
# sends a print job to a SMB printer
# 
# smbstatus
# 	
# 
# reports current Samba connections
# 
# smbtar
# 	
# 
# is a shell script used for backing up SMB/CIFS shares directly to Linux tape drives or to a file
# 
# smbtorture
# 	
# 
# is a test suite that runs several tests against a SMB server
# 
# smbtree
# 	
# 
# is a text-based SMB network browser
# 
# tdbbackup
# 	
# 
# is a tool for backing up or validating the integrity of Samba .tdb files
# 
# tdbdump
# 	
# 
# is a tool used to print the contents of a Samba .tdb file
# 
# tdbrestore
# 	
# 
# is a tool for creating a Samba .tdb file out of a ntdbdump
# 
# tdbtool
# 	
# 
# is a tool which allows simple database manipulation from the command line
# 
# testparm
# 	
# 
# checks a smb.conf file for proper syntax
# 
# wbinfo
# 	
# 
# queries a running winbindd daemon
# 
# winbindd
# 	
# 
# resolves names from Windows NT servers
# 
# libnss_winbind.so
# 	
# 
# provides Name Service Switch API functions for resolving names from NT servers
# 
# libnss_wins.so
# 	
# 
# provides API functions for Samba's implementation of the Windows Internet Naming Service
# 
# libnetapi.so
# 	
# 
# provides API functions for the administration tools used for Samba and remote CIFS servers
# 
# libsmbclient.so
# 	
# 
# provides API functions for the Samba SMB client tools
# 
# libwbclient.so
# 	provides API functions for Windows domain client services 







cd $topdir
rm -rfv $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt

