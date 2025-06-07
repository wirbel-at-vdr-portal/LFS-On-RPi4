topdir=$(pwd)
err=0
set -e
chapter=p11-kit-0.25.5
err_report() {
    echo "chapter $chapter: $(date +'%Y.%m.%d %H:%M:%S') Error $? on line $1" | tee >> $topdir/log.txt
}
trap 'err_report $LINENO' ERR
echo "---------" >> $topdir/log.txt
echo chapter $chapter: start = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt




srcdir=../../src/p11-kit-0.25.5
tar xf ../../src/p11-kit-0.25.5.tar.xz -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir



#Introduction to p11-kit
#
#The p11-kit package provides a way to load and enumerate PKCS #11 (a Cryptographic Token Interface Standard) modules.
#[Note] Note
#
#Development versions of BLFS may not build or run some packages properly if LFS or dependencies have been updated since the most recent stable versions of the books.
#Package Information
#
#    Download (HTTP): https://github.com/p11-glue/p11-kit/releases/download/0.25.5/p11-kit-0.25.5.tar.xz
#
#    Download MD5 sum: e9c5675508fcd8be54aa4c8cb8e794fc
#
#    Download size: 980 KB
#
#    Estimated disk space required: 94 MB (with tests)
#
#    Estimated build time: 0.7 SBU (with tests)
#
#p11-kit Dependencies
#Recommended
#
#libtasn1-4.20.0
#Recommended (runtime)
#
#make-ca-1.16
#Optional
#
#GTK-Doc-1.34.0, libxslt-1.1.43, and nss-3.112 (runtime)
#Installation of p11-kit
#
#Prepare the distribution specific anchor hook:

sed '20,$ d' -i trust/trust-extract-compat &&

cat >> trust/trust-extract-compat << "EOF"
# Copy existing anchor modifications to /etc/ssl/local
/usr/libexec/make-ca/copy-trust-modifications

# Update trust stores
/usr/sbin/make-ca -r
EOF

#Install p11-kit by running the following commands:

mkdir p11-build &&
cd    p11-build &&

meson setup ..            \
      --prefix=/usr       \
      --buildtype=release \
      -D trust_paths=/etc/pki/anchors &&
ninja

#To test the results, issue: LC_ALL=C ninja test.
#
#Now, as the root user:

ninja install &&
ln -sfv /usr/libexec/p11-kit/trust-extract-compat \
        /usr/bin/update-ca-certificates

#Command Explanations
#
#--buildtype=release: Specify a buildtype suitable for stable releases of the package, as the default may produce unoptimized binaries.
#
#-D trust_paths=/etc/pki/anchors: this switch sets the location of trusted certificates used by libp11-kit.so.
#
#-D hash_impl=freebl: Use this switch if you want to use the Freebl library from NSS for SHA1 and MD5 hashing.
#
#-D gtk_doc=true: Use this switch if you have installed GTK-Doc-1.34.0 and libxslt-1.1.43 and wish to rebuild the documentation and generate manual pages.
#Configuring p11-kit
#
#The p11-kit trust module (/usr/lib/pkcs11/p11-kit-trust.so) can be used as a drop-in replacement for /usr/lib/libnssckbi.so to transparently make the system CAs available to NSS aware applications, rather than the static list provided by /usr/lib/libnssckbi.so. As the root user, execute the following commands:
#
#ln -sfv ./pkcs11/p11-kit-trust.so /usr/lib/libnssckbi.so
#
#Contents
#Installed Programs:
#p11-kit, trust, and update-ca-certificates
#Installed Libraries:
#libp11-kit.so and p11-kit-proxy.so
#Installed Directories:
#/etc/pkcs11, /usr/include/p11-kit-1, /usr/lib/pkcs11, /usr/libexec/p11-kit, /usr/share/gtk-doc/html/p11-kit, and /usr/share/p11-kit
#Short Descriptions
#
#p11-kit
#	
#
#is a command line tool that can be used to perform operations on PKCS#11 modules configured on the system
#
#trust
#	
#
#is a command line tool to examine and modify the shared trust policy store
#
#update-ca-certificates
#	
#
#is a command line tool to both extract local certificates from an updated anchor store, and regenerate all anchors and certificate stores on the system. This is done unconditionally on BLFS using the --force and --get flags to make-ca and should likely not be used for automated updates
#
#libp11-kit.so
#	
#
#contains functions used to coordinate initialization and finalization of any PKCS#11 module
#
#p11-kit-proxy.so
#	
#
#is the PKCS#11 proxy module 


cd $topdir
rm -rfv $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt
 