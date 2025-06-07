topdir=$(pwd)
err=0
set -e
chapter=make-ca-1.16
err_report() {
    echo "chapter $chapter: $(date +'%Y.%m.%d %H:%M:%S') Error $? on line $1" | tee >> $topdir/log.txt
}
trap 'err_report $LINENO' ERR
echo "---------" >> $topdir/log.txt
echo chapter $chapter: start = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt




srcdir=../../src/make-ca-1.16
tar xf ../../src/make-ca-1.16.tar.gz -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir

# Beyond Linux® From Scratch (System V Edition) - Version r12.3-759
# Chapter 4. Security
# 
#     Prev
# 
#     Vulnerabilities
#     Next
# 
#     CrackLib-2.10.3
#     Up
#     Home
# 
# make-ca-1.16
# Introduction to make-ca
# 
# Public Key Infrastructure (PKI) is a method to validate the authenticity of an otherwise unknown entity across untrusted networks. PKI works by establishing a chain of trust, rather than trusting each individual host or entity explicitly. In order for a certificate presented by a remote entity to be trusted, that certificate must present a complete chain of certificates that can be validated using the root certificate of a Certificate Authority (CA) that is trusted by the local machine.
# 
# Establishing trust with a CA involves validating things like company address, ownership, contact information, etc., and ensuring that the CA has followed best practices, such as undergoing periodic security audits by independent investigators and maintaining an always available certificate revocation list. This is well outside the scope of BLFS (as it is for most Linux distributions). The certificate store provided here is taken from the Mozilla Foundation, who have established very strict inclusion policies described here.
# [Note] Note
# 
# Development versions of BLFS may not build or run some packages properly if LFS or dependencies have been updated since the most recent stable versions of the books.
# Package Information
# 
#     Download (HTTP): https://github.com/lfs-book/make-ca/archive/v1.16/make-ca-1.16.tar.gz
# 
#     Download size: 40 KB
# 
#     Download MD5 Sum: bf1497691f72ec79d5e0456e3ac3eadc
# 
#     Estimated disk space required: 164 KB (with all runtime deps)
# 
#     Estimated build time: less than 0.1 SBU (with all runtime deps)
# 
# [Note] Note
# 
# This package ships a CA certificate for validating the identity of https://hg-edge.mozilla.org/. If the trust chain of this website has been changed after the release of make-ca-1.16, it may fail to get the revision of certdata.txt from server. Use an updated make-ca release at the release page if this issue happens.
# make-ca Dependencies
# Required
# 
# p11-kit-0.25.5 (runtime, built after libtasn1-4.20.0, required in the following instructions to generate certificate stores from trust anchors, and each time make-ca is run)
cd $topdir
rm -rfv $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt

# Optional (runtime)
# 
# nss-3.112 (to generate a shared NSSDB)
# Installation of make-ca and Generation of the CA-certificates stores
# 
# The make-ca script will download and process the certificates included in the certdata.txt file for use as trust anchors for the p11-kit-0.25.5 trust module. Additionally, it will generate system certificate stores used by BLFS applications (if the recommended and optional applications are present on the system). Any local certificates stored in /etc/ssl/local will be imported to both the trust anchors and the generated certificate stores (overriding Mozilla's trust). Additionally, any modified trust values will be copied from the trust anchors to /etc/ssl/local prior to any updates, preserving custom trust values that differ from Mozilla when using the trust utility from p11-kit to operate on the trust store.
# 
# To install the various certificate stores, first install the make-ca script into the correct location. As the root user:
# 
make install &&
install -vdm755 /etc/ssl/local
# 
# [Important] Important
# 
# Technically, this package is already installed at this point. But most packages listing make-ca as a dependency actually require the system certificate store set up by this package, rather than the make-ca program itself. So the instructions for using make-ca for setting up the system certificate store are included in this section. You should make sure the required runtime dependency for make-ca is satisfied now, and continue to follow the instructions.
# 
# As the root user, download the certificate source and prepare for system use with the following command:
# [Note] Note
# 
# If running the script a second time with the same version of certdata.txt, for instance, to update the stores when make-ca is upgraded, or to add additional stores as the requisite software is installed, replace the -g switch with the -r switch in the command line. If packaging, run make-ca --help to see all available command line options.
# 
/usr/sbin/make-ca -g
# 
# You should periodically update the store with the above command, either manually, or via a cron job. If you've installed Fcron-3.4.0 and completed the section on periodic jobs, execute the following commands, as the root user, to create a weekly cron job:
# 
cat > /etc/cron.weekly/update-pki.sh << "EOF" &&
#!/bin/bash
/usr/sbin/make-ca -g
EOF
chmod 754 /etc/cron.weekly/update-pki.sh

# Configuring make-ca
# 
# For most users, no additional configuration is necessary, however, the default certdata.txt file provided by make-ca is obtained from the mozilla-release branch, and is modified to provide a Mercurial revision. This will be the correct version for most systems. There are several other variants of the file available for use that might be preferred for one reason or another, including the files shipped with Mozilla products in this book. RedHat and OpenSUSE, for instance, use the version included in nss-3.112. Additional upstream downloads are available at the links included in /etc/make-ca/make-ca.conf.dist. Simply copy the file to /etc/make-ca.conf and edit as appropriate.
# About Trust Arguments
# 
# There are three trust types that are recognized by the make-ca script, SSL/TLS, S/Mime, and code signing. For OpenSSL, these are serverAuth, emailProtection, and codeSigning respectively. If one of the three trust arguments is omitted, the certificate is neither trusted, nor rejected for that role. Clients that use OpenSSL or NSS encountering this certificate will present a warning to the user. Clients using GnuTLS without p11-kit support are not aware of trusted certificates. To include this CA into the ca-bundle.crt, email-ca-bundle.crt, or objsign-ca-bundle.crt files (the GnuTLS legacy bundles), it must have the appropriate trust arguments.
# Adding Additional CA Certificates
# 
# The /etc/ssl/local directory is available to add additional CA certificates to the system trust store. This directory is also used to store certificates that were added to or modified in the system trust store by p11-kit-0.25.5 so that trust values are maintained across upgrades. Files in this directory must be in the OpenSSL trusted certificate format. Certificates imported using the trust utility from p11-kit-0.25.5 will utilize the x509 Extended Key Usage values to assign default trust values for the system anchors.
# 
# If you need to override trust values, or otherwise need to create an OpenSSL trusted certificate manually from a regular PEM encoded file, you need to add trust arguments to the openssl command, and create a new certificate. For example, using the CAcert roots, if you want to trust both for all three roles, the following commands will create appropriate OpenSSL trusted certificates (run as the root user after Wget-1.25.0 is installed):
# 
wget http://www.cacert.org/certs/root.crt &&
wget http://www.cacert.org/certs/class3.crt &&
openssl x509 -in root.crt -text -fingerprint -setalias "CAcert Class 1 root" \
        -addtrust serverAuth -addtrust emailProtection -addtrust codeSigning \
        > /etc/ssl/local/CAcert_Class_1_root.pem &&
openssl x509 -in class3.crt -text -fingerprint -setalias "CAcert Class 3 root" \
        -addtrust serverAuth -addtrust emailProtection -addtrust codeSigning \
        > /etc/ssl/local/CAcert_Class_3_root.pem &&
/usr/sbin/make-ca -r
# 
# Overriding Mozilla Trust
# 
# Occasionally, there may be instances where you don't agree with Mozilla's inclusion of a particular certificate authority. If you'd like to override the default trust of a particular CA, simply create a copy of the existing certificate in /etc/ssl/local with different trust arguments. For example, if you'd like to distrust the "Makebelieve_CA_Root" file, run the following commands:
# 
# openssl x509 -in /etc/ssl/certs/Makebelieve_CA_Root.pem \
#              -text \
#              -fingerprint \
#              -setalias "Disabled Makebelieve CA Root" \
#              -addreject serverAuth \
#              -addreject emailProtection \
#              -addreject codeSigning \
#        > /etc/ssl/local/Disabled_Makebelieve_CA_Root.pem &&
# /usr/sbin/make-ca -r
# 
# Contents
# Installed Programs:
# make-ca
# Installed Directories:
# /etc/ssl/{certs,local} and /etc/pki/{nssdb,anchors,tls/{certs,java}}
# Short Descriptions
# 
# make-ca
# 	
# 
# is a shell script that adapts a current version of certdata.txt, and prepares it for use as the system trust store
# 