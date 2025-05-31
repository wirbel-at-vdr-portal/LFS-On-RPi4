#!/usr/bin/bash

# ===== 7.9. Perl-5.40.2 =====
topdir=$(pwd)
err=0
set -e
chapter=7009
err_report() {
    echo "chapter $chapter: $(date +'%Y.%m.%d %H:%M:%S') Error $? on line $1" | tee >> $topdir/log.txt
}
trap 'err_report $LINENO' ERR
echo "---------" >> $topdir/log.txt
echo chapter $chapter: start = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt


srcdir=../src/perl-5.40.2
tar xf ../src/perl-5.40.2.tar.xz -C ../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir

#<p>
#
#  The Perl package contains the Practical Extraction and Report Language. 
#</p>

#  Approximate build time: 0.6 SBU
#  Required disk space: 285 MB
# ==== 7.9.1. Installation of Perl ====
#<p>
#
#  Prepare Perl for compilation: 
#</p>

#********<pre>***********
sh Configure -des                                         \
             -D prefix=/usr                               \
             -D vendorprefix=/usr                         \
             -D useshrplib                                \
             -D privlib=/usr/lib/perl5/5.40/core_perl     \
             -D archlib=/usr/lib/perl5/5.40/core_perl     \
             -D sitelib=/usr/lib/perl5/5.40/site_perl     \
             -D sitearch=/usr/lib/perl5/5.40/site_perl    \
             -D vendorlib=/usr/lib/perl5/5.40/vendor_perl \
             -D vendorarch=/usr/lib/perl5/5.40/vendor_perl
#********</pre>**********
#<p>
#
#  The meaning of the Configure options: 
#</p>

#-des 
##<p>
#
#  This is a combination of three options: -d uses defaults for all items; -e 
# ensures completion of all tasks; -s silences non-essential output. 
#</p>

#-D vendorprefix=/usr 
##<p>
#
#  This ensures perl
#  knows how to tell packages where they should install their Perl modules. 
#</p>

#-D useshrplib 
##<p>
#
#  Build libperl 
#  needed by some Perl modules as a shared library, instead of a static library. 
#</p>

#-D privlib,-D archlib,-D sitelib,... 
##<p>
#
#  These settings define where Perl looks for installed modules. The LFS editors 
# chose to put them in a directory structure based on the MAJOR.MINOR version of 
# Perl (5.40) which allows upgrading Perl to newer patch levels (the patch level 
# is the last dot separated part in the full version string like 5.40.2) without 
# reinstalling all of the modules. 
#</p>
#<p>
#
#  Compile the package: 
#</p>

#********<pre>***********
make
#********</pre>**********
#<p>
#
#  Install the package: 
#</p>

#********<pre>***********
make install
#********</pre>**********
#<p>
#
#  Details on this package are located in [Section 8.43.2, “Contents of Perl.”](../chapter08/perl.html#contents-perl)
#</p>

cd $topdir
rm -rf $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt
