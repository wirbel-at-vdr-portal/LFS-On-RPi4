topdir=$(pwd)
err=0
set -e
chapter=libtasn1-4.20.0
err_report() {
    echo "chapter $chapter: $(date +'%Y.%m.%d %H:%M:%S') Error $? on line $1" | tee >> $topdir/log.txt
}
trap 'err_report $LINENO' ERR
echo "---------" >> $topdir/log.txt
echo chapter $chapter: start = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt




srcdir=../../src/libtasn1-4.20.0
tar xf ../../src/libtasn1-4.20.0.tar.gz -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir


#Introduction to libtasn1
#
#libtasn1 is a highly portable C library that encodes and decodes DER/BER data following an ASN.1 schema.
#[Note] Note
#
#Development versions of BLFS may not build or run some packages properly if LFS or dependencies have been updated since the most recent stable versions of the books.
#Package Information
#
#    Download (HTTP): https://ftp.gnu.org/gnu/libtasn1/libtasn1-4.20.0.tar.gz
#
#    Download MD5 sum: 930f71d788cf37505a0327c1b84741be
#
#    Download size: 1.7 MB
#
#    Estimated disk space required: 16 MB (with tests)
#
#    Estimated build time: 0.3 SBU (with tests)
#
#libtasn1 Dependencies
#Optional
#
#GTK-Doc-1.34.0 and Valgrind-3.25.1
#Installation of libtasn1
#
#Install libtasn1 by running the following commands:

./configure --prefix=/usr --disable-static &&
make

#To test the results, issue: make check.
#
#Now, as the root user:

make install

#If you did not pass the --enable-gtk-doc parameter to the configure script, you can install the API documentation using the following command as the root user:
#
#make -C doc/reference install-data-local
#
#Command Explanations
#
#--disable-static: This switch prevents installation of static versions of the libraries.
#
#--enable-gtk-doc: This parameter is normally used if GTK-Doc is installed and you wish to rebuild and install the API documentation. It is broken for this package due to the use of a long deprecated gtk-doc program that is no longer available.
#Contents
#Installed Programs:
#asn1Coding, asn1Decoding and asn1Parser
#Installed Library:
#libtasn1.so
#Installed Directory:
#/usr/share/gtk-doc/html/libtasn1
#Short Descriptions
#
#asn1Coding
#	
#
#is an ASN.1 DER encoder
#
#asn1Decoding
#	
#
#is an ASN.1 DER decoder
#
#asn1Parser
#	
#
#is an ASN.1 syntax tree generator for libtasn1
#
#libtasn1.so
#	
#
#is a library for Abstract Syntax Notation One (ASN.1) and Distinguish Encoding Rules (DER) manipulation 

cd $topdir
rm -rfv $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt
 