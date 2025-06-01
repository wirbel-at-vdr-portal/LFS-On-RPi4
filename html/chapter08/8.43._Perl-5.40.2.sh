#!/usr/bin/bash

# ===== 8.43. Perl-5.40.2 =====
topdir=$(pwd)
err=0
set -e
chapter=8043
err_report() {
    echo "chapter $chapter: $(date +'%Y.%m.%d %H:%M:%S') Error $? on line $1" | tee >> $topdir/log.txt
}
trap 'err_report $LINENO' ERR
echo "---------" >> $topdir/log.txt
echo chapter $chapter: start = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt




if [ "$EUID" -ne "0" ]; then
  echo "ERROR: Please run as root, not as user id = $EUID";stop
  exit 1
fi

grep -q $LFS/dev/pts /proc/mounts || err=1
if [ "$err" -eq "1" ]; then
  echo "ERROR: The '$LFS/dev/pts' partition must be mounted.";stop
  exit 1
fi

grep -q $LFS/dev /proc/mounts || err=1
if [ "$err" -eq "1" ]; then
  echo "ERROR: The '$LFS/dev' partition must be mounted.";stop
  exit 1
fi

grep -q $LFS/proc /proc/mounts || err=1
if [ "$err" -eq "1" ]; then
  echo "ERROR: The '$LFS/proc' partition must be mounted.";stop
  exit 1
fi

grep -q $LFS/sys /proc/mounts || err=1
if [ "$err" -eq "1" ]; then
  echo "ERROR: The '$LFS/sys' partition must be mounted.";stop
  exit 1
fi

grep -q $LFS/run /proc/mounts || err=1
if [ "$err" -eq "1" ]; then
  echo "ERROR: The '$LFS/run' partition must be mounted.";stop
  exit 1
fi



srcdir=../../src/perl-5.40.2
tar xf ../../src/perl-5.40.2.tar.xz -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir

#<p>
#
#  The Perl package contains the Practical Extraction and Report Language. 
#</p>

#  Approximate build time: 1.3 SBU
#  Required disk space: 245 MB
# ==== 8.43.1. Installation of Perl ====
#<p>
#
#  This version of Perl builds the Compress::Raw::Zlib and Compress::Raw::BZip2 
# modules. By default Perl will use an internal copy of the sources for the 
# build. Issue the following command so that Perl will use the libraries 
# installed on the system: 
#</p>

#********<pre>***********
export BUILD_ZLIB=False
export BUILD_BZIP2=0
#********</pre>**********
#<p>
#
#  To have full control over the way Perl is set up, you can remove the “-des”
#  options from the following command and hand-pick the way this package is 
# built. Alternatively, use the command exactly as shown below to use the 
# defaults that Perl auto-detects: 
#</p>

#********<pre>***********
sh Configure -des                                          \
             -D prefix=/usr                                \
             -D vendorprefix=/usr                          \
             -D privlib=/usr/lib/perl5/5.40/core_perl      \
             -D archlib=/usr/lib/perl5/5.40/core_perl      \
             -D sitelib=/usr/lib/perl5/5.40/site_perl      \
             -D sitearch=/usr/lib/perl5/5.40/site_perl     \
             -D vendorlib=/usr/lib/perl5/5.40/vendor_perl  \
             -D vendorarch=/usr/lib/perl5/5.40/vendor_perl \
             -D man1dir=/usr/share/man/man1                \
             -D man3dir=/usr/share/man/man3                \
             -D pager="/usr/bin/less -isR"                 \
             -D useshrplib                                 \
             -D usethreads
#********</pre>**********
#<p>
#
#  The meaning of the new Configure options: 
#</p>

#-D pager="/usr/bin/less -isR" 
##<p>
#
#  This ensures that less 
#  is used instead of more 
#  . 
#</p>

#-D man1dir=/usr/share/man/man1 -D man3dir=/usr/share/man/man3 
##<p>
#
#  Since Groff is not installed yet, Configure
#  will not create man pages for Perl. These parameters override this behavior. 
#</p>

#-D usethreads 
##<p>
#
#  Build Perl with support for threads. 
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
#  To test the results, issue: 
#</p>

#********<pre>***********
TEST_JOBS=$(nproc) make test_harness
#********</pre>**********
#<p>
#
#  Install the package and clean up: 
#</p>

#********<pre>***********
make install
unset BUILD_ZLIB BUILD_BZIP2
#********</pre>**********

# ==== 8.43.2. Contents of Perl ====

#  Installed programs: corelist, cpan, enc2xs, encguess, h2ph, h2xs, instmodsh, json_pp, libnetcfg, perl, perl5.40.2 (hard link to perl), perlbug, perldoc, perlivp, perlthanks (hard link to perlbug), piconv, pl2pm, pod2html, pod2man, pod2text, pod2usage, podchecker, podselect, prove, ptar, ptardiff, ptargrep, shasum, splain, xsubpp, and zipdetails
#  Installed libraries: Many which cannot all be listed here
#  Installed directory: /usr/lib/perl5
# ====== Short Descriptions ======

#--------------------------------------------
# | corelist                                 | A command line front end to Module::CoreList
# | cpan                                     | Interact with the Comprehensive Perl Archive Network (CPAN) from the command line
# | enc2xs                                   | Builds a Perl extension for the Encode module from either Unicode Character Mappings or Tcl Encoding Files
# | encguess                                 | Guess the encoding type of one or several files
# | h2ph                                     | Converts                                .h                                      C header files to                       .ph                                     Perl header files                       
# | h2xs                                     | Converts                                .h                                      C header files to Perl extensions       
# | instmodsh                                | Shell script for examining installed Perl modules; it can create a tarball from an installed module
# | json_pp                                  | Converts data between certain input and output formats
# | libnetcfg                                | Can be used to configure the            libnet                                  Perl module                             
# | perl                                     | Combines some of the best features of C,sed                                     ,                                       awk                                     and                                     sh                                      into a single Swiss Army language       
# | perl5.40.2                               | A hard link to                          perl                                    
# | perlbug                                  | Used to generate bug reports about Perl, or the modules that come with it, and mail them
# | perldoc                                  | Displays a piece of documentation in pod format that is embedded in the Perl installation tree or in a Perl script
# | perlivp                                  | The Perl Installation Verification Procedure; it can be used to verify that Perl and its libraries have been installed correctly
# | perlthanks                               | Used to generate thank you messages to mail to the Perl developers
# | piconv                                   | A Perl version of the character encoding convertericonv                                   
# | pl2pm                                    | A rough tool for converting Perl4       .pl                                     files to Perl5                          .pm                                     modules                                 
# | pod2html                                 | Converts files from pod format to HTML format
# | pod2man                                  | Converts pod data to formatted *roff input
# | pod2text                                 | Converts pod data to formatted ASCII text
# | pod2usage                                | Prints usage messages from embedded pod docs in files
# | podchecker                               | Checks the syntax of pod format documentation files
# | podselect                                | Displays selected sections of pod documentation
# | prove                                    | Command line tool for running tests against the Test::Harness module
# | ptar                                     | A                                       tar                                     -like program written in Perl           
# | ptardiff                                 | A Perl program that compares an extracted archive with an unextracted one
# | ptargrep                                 | A Perl program that applies pattern matching to the contents of files in a tar archive
# | shasum                                   | Prints or checks SHA checksums          
# | splain                                   | Is used to force verbose warning diagnostics in Perl
# | xsubpp                                   | Converts Perl XS code into C code       
# | zipdetails                               | Displays details about the internal structure of a Zip file
#--------------------------------------------
cd $topdir
rm -rf $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt
