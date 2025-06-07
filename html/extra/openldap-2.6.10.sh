topdir=$(pwd)
err=0
set -e
chapter=openldap-2.6.10
err_report() {
    echo "chapter $chapter: $(date +'%Y.%m.%d %H:%M:%S') Error $? on line $1" | tee >> $topdir/log.txt
}
trap 'err_report $LINENO' ERR
echo "---------" >> $topdir/log.txt
echo chapter $chapter: start = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt




srcdir=../../src/openldap-2.6.10
tar xf ../../src/openldap-2.6.10.tgz -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir







# OpenLDAP-2.6.10
# Introduction to OpenLDAP
# 
# The OpenLDAP package provides an open source implementation of the Lightweight Directory Access Protocol.
# [Note] Note
# 
# Development versions of BLFS may not build or run some packages properly if LFS or dependencies have been updated since the most recent stable versions of the books.
# Package Information
# 
#     Download (HTTP): https://www.openldap.org/software/download/OpenLDAP/openldap-release/openldap-2.6.10.tgz
# 
#     Download MD5 sum: 6be5e6c43d599e7a422669c70229ca74
# 
#     Download size: 6.2 MB
# 
#     Estimated disk space required: 100 MB (client and server)
# 
#     Estimated build time: 0.3 SBU (client), 0.8 SBU (server)
# 
# Additional Downloads
# 
#     Required patch: https://www.linuxfromscratch.org/patches/blfs/svn/openldap-2.6.10-consolidated-1.patch
# 
# OpenLDAP Dependencies
# Recommended
# 
# Cyrus SASL-2.1.28
# Optional
# 
# GnuTLS-3.8.9, unixODBC-2.3.12, MariaDB-11.4.5 or PostgreSQL-17.5 or MySQL, OpenSLP, WiredTiger, and Berkeley DB (deprecated) (for slapd, also deprecated)
# Installation of OpenLDAP
# [Note] Note
# 
# If you only need to install the client side ldap* binaries, corresponding man pages,
# libraries and header files (referred to as a “client-only” install), issue these
# commands instead of the following ones (no test suite available):

patch -Np1 -i ../openldap-2.6.10-consolidated-1.patch &&
autoconf &&

./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --disable-static  \
            --enable-dynamic  \
            --disable-debug   \
            --disable-slapd   &&

make depend &&
make
# 
# Then, as the root user:
# 
make install
# 
# There should be a dedicated user and group to take control of the slapd daemon after it is started. Issue the following commands as the root user:
# 
# groupadd -g 83 ldap &&
# useradd  -c "OpenLDAP Daemon Owner" \
#          -d /var/lib/openldap -u 83 \
#          -g ldap -s /bin/false ldap
# 
# Install OpenLDAP by running the following commands:
# 
# patch -Np1 -i ../openldap-2.6.10-consolidated-1.patch &&
# autoconf &&
# 
# ./configure --prefix=/usr         \
#             --sysconfdir=/etc     \
#             --localstatedir=/var  \
#             --libexecdir=/usr/lib \
#             --disable-static      \
#             --disable-debug       \
#             --with-tls=openssl    \
#             --with-cyrus-sasl     \
#             --without-systemd     \
#             --enable-dynamic      \
#             --enable-crypt        \
#             --enable-spasswd      \
#             --enable-slapd        \
#             --enable-modules      \
#             --enable-rlookups     \
#             --enable-backends=mod \
#             --disable-sql         \
#             --disable-wt          \
#             --enable-overlays=mod &&
# 
# make depend &&
# make
# 
# The tests are fragile, and errors may cause the tests to abort prior to finishing. Some errors may happen due to timing problems. The tests take around an hour, and the time is CPU independent due to delays in the tests. On most systems, the tests will run up to the test065-proxyauth for mdb test. To test the results, issue: make test.
# 
# Now, as the root user:
# 
# make install &&
# 
# sed -e "s/\.la/.so/" -i /etc/openldap/slapd.{conf,ldif}{,.default} &&
# 
# install -v -dm700 -o ldap -g ldap /var/lib/openldap     &&
# 
# install -v -dm700 -o ldap -g ldap /etc/openldap/slapd.d &&
# chmod   -v    640     /etc/openldap/slapd.{conf,ldif}   &&
# chown   -v  root:ldap /etc/openldap/slapd.{conf,ldif}   &&
# 
# install -v -dm755 /usr/share/doc/openldap-2.6.10 &&
# cp      -vfr      doc/{drafts,rfc,guide} \
#                   /usr/share/doc/openldap-2.6.10
# 
# Command Explanations
# 
# --disable-static: This switch prevents installation of static versions of the libraries.
# 
# --disable-debug: This switch disables the debugging code in OpenLDAP.
# 
# --enable-dynamic: This switch forces the OpenLDAP libraries to be dynamically linked to the executable programs.
# 
# --enable-crypt: This switch enables using crypt(3) passwords.
# 
# --enable-spasswd: This switch enables SASL password verification.
# 
# --enable-modules: This switch enables dynamic module support.
# 
# --enable-rlookups: This switch enables reverse lookups of client hostnames.
# 
# --enable-backends: This switch enables all available backends.
# 
# --enable-overlays: This switch enables all available overlays.
# 
# --disable-sql: This switch explicitly disables the SQL backend. Omit this switch if a SQL server is installed and you are going to use a SQL backend.
# 
# --disable-wt: This switch explicitly disables the WiredTiger backend. Omit this switch if WiredTiger is installed and you are going to use a WiredTiger backend.
# 
# --libexecdir=/usr/lib: This switch controls where the /usr/lib/openldap directory is installed. Everything in that directory is a library, so it belongs under /usr/lib instead of /usr/libexec.
# 
# --enable-slp: This switch enables SLPv2 support. Use it if you have installed OpenSLP.
# 
# --disable-versioning: This switch disables symbol versioning in the OpenLDAP libraries. The default is to have symbol versioning. Note that if you have built applications using this package with symbol versioning, and remove the symbols, the applications may fail to run.
# [Note] Note
# 
# You can run ./configure --help to see if there are other switch you can pass to the configure command to enable other options or dependency packages.
# 
# install ..., chown ..., and chmod ...: Having slapd configuration files and ldap databases in /var/lib/openldap readable by anyone is a SECURITY ISSUE, especially since a file stores the admin password in PLAIN TEXT. That's why mode 640 and root:ldap ownership were used. The owner is root, so only root can modify the file, and group is ldap, so that the group which owns slapd daemon could read but not modify the file in case of a security breach.
# Configuring OpenLDAP
# Config Files
# 
#     For LDAP client: /etc/openldap/ldap.conf and ~/.ldaprc
# 
#     For LDAP server, two configuration mechanisms are used: a legacy /etc/openldap/slapd.conf configuration file and the recommended slapd-config system, using an LDIF database stored in /etc/openldap/slapd.d.
# 
# Configuration Information
# 
# Configuring the slapd servers can be complex. Securing the LDAP directory, especially if you are storing non-public data such as password databases, can also be a challenging task. In order to set up OpenLDAP, you'll need to modify either the /etc/openldap/slapd.conf file (old method), or the /etc/openldap/slapd.ldif file and then use ldapadd to create the LDAP configuration database in /etc/openldap/slapd.d (recommended by the OpenLDAP documentation).
# [Warning] Warning
# 
# The instructions above install an empty LDAP structure and a default /etc/openldap/slapd.conf file, which are suitable for testing the build and other packages using LDAP. Do not use them on a production server.
# 
# Resources to assist you with topics such as choosing a directory configuration, backend and database definitions, access control settings, running as a user other than root and setting a chroot environment include:
# 
#     The slapd(8) man page.
# 
#     The slapd.conf(5) and slapd-config(5) man pages.
# 
#     The OpenLDAP 2.6 Administrator's Guide (also installed locally in /usr/share/doc/openldap-2.6.10/guide/admin).
# 
#     Documents located at https://www.openldap.org/pub/.
# 
# Boot Script
# 
# To automate the startup of the LDAP server at system bootup, install the /etc/rc.d/init.d/slapd init script included in the blfs-bootscripts-20250225 package using the following command:
# 
# make install-slapd
# 
# [Note] Note
# 
# You'll need to modify /etc/sysconfig/slapd to include the parameters needed for your specific configuration. See the slapd man page for parameter information.
# Testing the Configuration
# 
# Start the LDAP server using the init script:
# 
# /etc/rc.d/init.d/slapd start
# 
# Verify access to the LDAP server with the following command:
# 
# ldapsearch -x -b '' -s base '(objectclass=*)' namingContexts
# 
# The expected result is:
# 
# # extended LDIF
# #
# # LDAPv3
# # base <> with scope baseObject
# # filter: (objectclass=*)
# # requesting: namingContexts
# #
# 
# #
# dn:
# namingContexts: dc=my-domain,dc=com
# 
# # search result
# search: 2
# result: 0 Success
# 
# # numResponses: 2
# # numEntries: 1
# 
# Contents
# Installed Programs:
# ldapadd, ldapcompare, ldapdelete, ldapexop, ldapmodify, ldapmodrdn, ldappasswd, ldapsearch, ldapurl, ldapvc, ldapwhoami, slapacl, slapadd, slapauth, slapcat, slapd, slapdn, slapindex, slapmodify, slappasswd, slapschema, and slaptest
# Installed Libraries:
# liblber.so, libldap.so, and several under /usr/lib/openldap
# Installed Directories:
# /etc/openldap, /{usr,var}/lib/openldap, and /usr/share/doc/openldap-2.6.10
# Short Descriptions
# 
# ldapadd
# 	
# 
# opens a connection to an LDAP server, binds and adds entries
# 
# ldapcompare
# 	
# 
# opens a connection to an LDAP server, binds and performs a compare using specified parameters
# 
# ldapdelete
# 	
# 
# opens a connection to an LDAP server, binds and deletes one or more entries
# 
# ldapexop
# 	
# 
# issues the LDAP extended operation specified by oid or one of the special keywords whoami, cancel, or refresh
# 
# ldapmodify
# 	
# 
# opens a connection to an LDAP server, binds and modifies entries
# 
# ldapmodrdn
# 	
# 
# opens a connection to an LDAP server, binds and modifies the RDN of entries
# 
# ldappasswd
# 	
# 
# is a tool used to set the password of an LDAP user
# 
# ldapsearch
# 	
# 
# opens a connection to an LDAP server, binds and performs a search using specified parameters
# 
# ldapurl
# 	
# 
# is a command that allows to either compose or decompose LDAP URIs
# 
# ldapvc
# 	
# 
# verifies LDAP credentials
# 
# ldapwhoami
# 	
# 
# opens a connection to an LDAP server, binds and displays whoami information
# 
# slapacl
# 	
# 
# is used to check the behavior of slapd by verifying access to directory data according to the access control list directives defined in its configuration
# 
# slapadd
# 	
# 
# is used to add entries specified in LDAP Directory Interchange Format (LDIF) to an LDAP database
# 
# slapauth
# 	
# 
# is used to check the behavior of the slapd in mapping identities for authentication and authorization purposes, as specified in slapd.conf
# 
# slapcat
# 	
# 
# is used to generate an LDAP LDIF output based upon the contents of a slapd database
# 
# slapd
# 	
# 
# is the standalone LDAP server
# 
# slapdn
# 	
# 
# checks a list of string-represented DNs based on schema syntax
# 
# slapindex
# 	
# 
# is used to regenerate slapd indexes based upon the current contents of a database
# 
# slapmodify
# 	
# 
# modifies entries in a slapd database
# 
# slappasswd
# 	
# 
# is an OpenLDAP password utility
# 
# slapschema
# 	
# 
# is used to check schema compliance of the contents of a slapd database
# 
# slaptest
# 	
# 
# checks the sanity of the slapd.conf file
# 
# liblber.so
# 	
# 
# is a set of Lightweight Basic Encoding Rules routines. These routines are used by the LDAP library routines to encode and decode LDAP protocol elements using the (slightly simplified) Basic Encoding Rules defined by LDAP. They are not normally used directly by an LDAP application program except in the handling of controls and extended operations
# 
# libldap.so
#	
#
#supports the LDAP programs and provide functionality for other programs interacting with LDAP 









cd $topdir
rm -rf $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt

