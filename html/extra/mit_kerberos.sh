topdir=$(pwd)
err=0
set -e
chapter=mit_kerberos
err_report() {
    echo "chapter $chapter: $(date +'%Y.%m.%d %H:%M:%S') Error $? on line $1" | tee >> $topdir/log.txt
}
trap 'err_report $LINENO' ERR
echo "---------" >> $topdir/log.txt
echo chapter $chapter: start = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt




srcdir=../../src/krb5-1.21.3
tar xf ../../src/krb5-1.21.3.tar.gz -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir








# Introduction to MIT Kerberos V5
# 
# MIT Kerberos V5 is a free implementation of Kerberos 5. Kerberos is a network authentication protocol. It centralizes the authentication database and uses kerberized applications to work with servers or services that support Kerberos allowing single logins and encrypted communication over internal networks or the Internet.
# [Note] Note
# 
# Development versions of BLFS may not build or run some packages properly if LFS or dependencies have been updated since the most recent stable versions of the books.
# Package Information
# 
#     Download (HTTP): https://kerberos.org/dist/krb5/1.21/krb5-1.21.3.tar.gz
# 
#     Download MD5 sum: beb34d1dfc72ba0571ce72bed03e06eb
# 
#     Download size: 8.7 MB
# 
#     Estimated disk space required: 95 MB (add 14 MB for tests)
# 
#     Estimated build time: 0.3 SBU (Using parallelism=4; add 1.1 SBU for tests)
# 
# MIT Kerberos V5 Dependencies
# Optional
# 
# BIND Utilities-9.20.9, CrackLib-2.10.3 (/usr/share/dict/words referred by some tests), GnuPG-2.4.8 (to authenticate the package), keyutils-1.6.3, OpenLDAP-2.6.10, Valgrind-3.25.1 (used during the test suite), yasm-1.3.0, libedit, cmocka, kdcproxy, pyrad, and resolv_wrapper
# [Note] Note
# 
# Some sort of time synchronization facility on your system (like ntp-4.2.8p18) is required since Kerberos won't authenticate if there is a time difference between a kerberized client and the KDC server.
# Installation of MIT Kerberos V5
# 
# Build MIT Kerberos V5 by running the following commands:
# 
cd src &&
sed -i -e '/eq 0/{N;s/12 //}' plugins/kdb/db2/libdb2/test/run.test &&
 
./configure --prefix=/usr            \
            --sysconfdir=/etc        \
            --localstatedir=/var/lib \
            --runstatedir=/run       \
            --with-system-et         \
            --with-system-ss         \
            --with-system-verto=no   \
            --enable-dns-for-realm   \
            --disable-rpath          &&
make -j4
# 
# To test the build, issue: make -j1 -k check. Some tests may fail with the latest version of dejagnu and glibc. Some tests may hang for a long time and fail if the system is not connected to a network. One test, t_kadm5srv, is known to fail. If keyutils-1.6.3 is installed but Keyutils Kernel Configuration is not satisfied, some tests will fail complaining keyctl failed with code 1.
# 
# Now, as the root user:
# 
make install
# cp -vfr ../doc -T /usr/share/doc/krb5-1.21.3
# 
# Command Explanations
# 
# The sed command removes a test that is known to fail.
# 
# --localstatedir=/var/lib: This option is used so that the Kerberos variable runtime data is located in /var/lib instead of /usr/var.
# 
# --runstatedir=/run: This option is used so that the Kerberos runtime state information is located in /run instead of the deprecated /var/run.
# 
# --with-system-et: This switch causes the build to use the system-installed versions of the error-table support software.
# 
# --with-system-ss: This switch causes the build to use the system-installed versions of the subsystem command-line interface software.
# 
# --with-system-verto=no: This switch fixes a bug in the package: it does not recognize its own verto library installed previously. This is not a problem, if reinstalling the same version, but if you are updating, the old library is used as system's one, instead of installing the new version.
# 
# --enable-dns-for-realm: This switch allows realms to be resolved using the DNS server.
# 
# --disable-rpath: This switch prevents hard coding library search paths (rpath) into the binary executable files and shared libraries. This package does not need rpath for an installation into the standard location, and rpath may sometimes cause unwanted effects or even security issues.
# 
# --with-ldap: Use this switch if you want to compile the OpenLDAP database backend module.
# Configuring MIT Kerberos V5
# Config Files
# 
# /etc/krb5.conf and /var/lib/krb5kdc/kdc.conf
# Configuration Information
# Kerberos Configuration
# [Tip] Tip
# 
# You should consider installing some sort of password checking dictionary so that you can configure the installation to only accept strong passwords. A suitable dictionary to use is shown in the CrackLib-2.10.3 instructions. Note that only one file can be used, but you can concatenate many files into one. The configuration file shown below assumes you have installed a dictionary to /usr/share/dict/words.
# 
# Create the Kerberos configuration file with the following commands issued by the root user:
# 
# cat > /etc/krb5.conf << "EOF"
# # Begin /etc/krb5.conf
# 
# [libdefaults]
#     default_realm = <EXAMPLE.ORG>
#     encrypt = true
# 
# [realms]
#     <EXAMPLE.ORG> = {
#         kdc = <belgarath.example.org>
#         admin_server = <belgarath.example.org>
#         dict_file = /usr/share/dict/words
#     }
# 
# [domain_realm]
#     .<example.org> = <EXAMPLE.ORG>
# 
# [logging]
#     kdc = SYSLOG:INFO:AUTH
#     admin_server = SYSLOG:INFO:AUTH
#     default = SYSLOG:DEBUG:DAEMON
# 
# # End /etc/krb5.conf
# EOF
# 
# You will need to substitute your domain and proper hostname for the occurrences of the <belgarath> and <example.org> names.
# 
# default_realm should be the name of your domain changed to ALL CAPS. This isn't required, but both Heimdal and MIT recommend it.
# 
# encrypt = true provides encryption of all traffic between kerberized clients and servers. It's not necessary and can be left off. If you leave it off, you can encrypt all traffic from the client to the server using a switch on the client program instead.
# 
# The [realms] parameters tell the client programs where to look for the KDC authentication services.
# 
# The [domain_realm] section maps a domain to a realm.
# 
# Create the KDC database:
# 
# kdb5_util create -r <EXAMPLE.ORG> -s
# 
# Now you should populate the database with principals (users). For now, just use your regular login name or root.
# 
# kadmin.local
# kadmin.local: add_policy dict-only
# kadmin.local: addprinc -policy dict-only <loginname>
# 
# The KDC server and any machine running kerberized server daemons must have a host key installed:
# 
# kadmin.local: addprinc -randkey host/<belgarath.example.org>
# 
# After choosing the defaults when prompted, you will have to export the data to a keytab file:
# 
# kadmin.local: ktadd host/<belgarath.example.org>
# 
# This should have created a file in /etc named krb5.keytab (Kerberos 5). This file should have 600 (root rw only) permissions. Keeping the keytab files from public access is crucial to the overall security of the Kerberos installation.
# 
# Exit the kadmin program (use quit or exit) and return back to the shell prompt. Start the KDC daemon manually, just to test out the installation:
# 
# /usr/sbin/krb5kdc
# 
# Attempt to get a ticket with the following command:
# 
# kinit <loginname>
# 
# You will be prompted for the password you created. After you get your ticket, you can list it with the following command:
# 
# klist
# 
# Information about the ticket should be displayed on the screen.
# 
# To test the functionality of the keytab file, issue the following command as the root user:
# 
# ktutil
# ktutil: rkt /etc/krb5.keytab
# ktutil: l
# 
# This should dump a list of the host principal, along with the encryption methods used to access the principal.
# 
# Create an empty ACL file that can be modified later:
# 
# touch /var/lib/krb5kdc/kadm5.acl
# 
# At this point, if everything has been successful so far, you can feel fairly confident in the installation and configuration of the package.
# Additional Information
# 
# For additional information consult the documentation for krb5-1.21.3 on which the above instructions are based.
# Init Script
# 
# If you want to start Kerberos services at boot, install the /etc/rc.d/init.d/krb5 init script included in the blfs-bootscripts-20250225 package using the following command:
# 
# make install-krb5
# 
# Contents
# Installed Programs:
# gss-client, gss-server, k5srvutil, kadmin, kadmin.local, kadmind, kdb5_ldap_util (optional), kdb5_util, kdestroy, kinit, klist, kpasswd, kprop, kpropd, kproplog, krb5-config, krb5-send-pr, krb5kdc, ksu, kswitch, ktutil, kvno, sclient, sim_client, sim_server, sserver, uuclient, and uuserver
# Installed Libraries:
# libgssapi_krb5.so, libgssrpc.so, libk5crypto.so, libkadm5clnt_mit.so, libkadm5clnt.so, libkadm5srv_mit.so, libkadm5srv.so, libkdb_ldap.so (optional), libkdb5.so, libkrad.so, libkrb5.so, libkrb5support.so, libverto.so, and some plugins under the /usr/lib/krb5 tree
# Installed Directories:
# /usr/include/{gssapi,gssrpc,kadm5,krb5}, /usr/lib/krb5, /usr/share/{doc/krb5-1.21.3,examples/krb5}, /var/lib/krb5kdc, and /run/krb5kdc
# Short Descriptions
# 
# gss-client
# 	
# 
# is a GSSAPI test client
# 
# gss-server
# 	
# 
# is a GSSAPI test server
# 
# k5srvutil
# 	
# 
# is a host keytable manipulation utility
# 
# kadmin
# 	
# 
# is an utility used to make modifications to the Kerberos database
# 
# kadmin.local
# 	
# 
# is an utility similar to kadmin, but if the database is db2, the local client kadmin.local, is intended to run directly on the master KDC without Kerberos authentication
# 
# kadmind
# 	
# 
# is a server for administrative access to a Kerberos database
# 
# kdb5_ldap_util (optional)
# 	
# 
# allows an administrator to manage realms, Kerberos services and ticket policies
# 
# kdb5_util
# 	
# 
# is the KDC database utility
# 
# kdestroy
# 	
# 
# removes the current set of tickets
# 
# kinit
# 	
# 
# is used to authenticate to the Kerberos server as a principal and acquire a ticket granting ticket that can later be used to obtain tickets for other services
# 
# klist
# 	
# 
# reads and displays the current tickets in the credential cache
# 
# kpasswd
# 	
# 
# is a program for changing Kerberos 5 passwords
# 
# kprop
# 	
# 
# takes a principal database in a specified format and converts it into a stream of database records
# 
# kpropd
# 	
# 
# receives a database sent by kprop and writes it as a local database
# 
# kproplog
# 	
# 
# displays the contents of the KDC database update log to standard output
# 
# krb5-config
# 	
# 
# gives information on how to link programs against libraries
# 
# krb5kdc
# 	
# 
# is the Kerberos 5 server
# 
# krb5-send-pr
# 	
# 
# sends a problem report (PR) to a central support site
# 
# ksu
# 	
# 
# is the super user program using Kerberos protocol. Requires a properly configured /etc/shells and ~/.k5login containing principals authorized to become super users
# 
# kswitch
# 	
# 
# makes the specified credential cache the primary cache for the collection, if a cache collection is available
# 
# ktutil
# 	
# 
# is a program for managing Kerberos keytabs
# 
# kvno
# 	
# 
# prints keyversion numbers of Kerberos principals
# 
# sclient
# 	
# 
# is used to contact a sample server and authenticate to it using Kerberos 5 tickets, then display the server's response
# 
# sim_client
# 	
# 
# is a simple UDP-based sample client program, for demonstration
# 
# sim_server
# 	
# 
# is a simple UDP-based server application, for demonstration
# 
# sserver
# 	
# 
# is the sample Kerberos 5 server
# 
# uuclient
# 	
# 
# is another sample client
# 
# uuserver
# 	
# 
# is another sample server
# 
# libgssapi_krb5.so
# 	
# 
# contains the Generic Security Service Application Programming Interface (GSSAPI) functions which provides security services to callers in a generic fashion, supportable with a range of underlying mechanisms and technologies and hence allowing source-level portability of applications to different environments
# 
# libkadm5clnt.so
# 	
# 
# contains the administrative authentication and password checking functions required by Kerberos 5 client-side programs
# 
# libkadm5srv.so
# 	
# 
# contains the administrative authentication and password checking functions required by Kerberos 5 servers
# 
# libkdb5.so
# 	
# 
# is a Kerberos 5 authentication/authorization database access library
# 
# libkrad.so
# 	
# 
# contains the internal support library for RADIUS functionality
# 
# libkrb5.so
#	
#
#is an all-purpose Kerberos 5 library 







cd $topdir
rm -rf $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt

