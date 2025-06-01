#!/usr/bin/bash

# ===== 8.72. Texinfo-7.2 =====
topdir=$(pwd)
err=0
set -e
chapter=8072
err_report() {
    echo "chapter $chapter: $(date +'%Y.%m.%d %H:%M:%S') Error $? on line $1" | tee >> $topdir/log.txt
}
trap 'err_report $LINENO' ERR
echo "---------" >> $topdir/log.txt
echo chapter $chapter: start = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt






srcdir=../../src/texinfo-7.2
tar xf ../../src/texinfo-7.2.tar.xz -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir

#<p>
#
#  The Texinfo package contains programs for reading, writing, and converting 
# info pages. 
#</p>

#  Approximate build time: 0.3 SBU
#  Required disk space: 160 MB
# ==== 8.72.1. Installation of Texinfo ====
#<p>
#
#  Prepare Texinfo for compilation: 
#</p>

#********<pre>***********
./configure --prefix=/usr
#********</pre>**********
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
#make check
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
#  Optionally, install the components belonging in a TeX installation: 
#</p>

#********<pre>***********
make TEXMF=/usr/share/texmf install-tex
#********</pre>**********
#<p>
#
#  The meaning of the make parameter: 
#</p>

#TEXMF=/usr/share/texmf 
##<p>
#
#  The TEXMF 
#  makefile variable holds the location of the root of the TeX tree if, for 
# example, a TeX package will be installed later. 
#</p>
#<p>
#
#  The Info documentation system uses a plain text file to hold its list of menu 
# entries. The file is located at /usr/share/info/dir 
#  . Unfortunately, due to occasional problems in the Makefiles of various 
# packages, it can sometimes get out of sync with the info pages installed on the 
# system. If the /usr/share/info/dir 
#  file ever needs to be recreated, the following optional commands will 
# accomplish the task: 
#</p>

#********<pre>***********
pushd /usr/share/info
  rm -v dir
  for f in *
    do install-info $f dir 2>/dev/null
  done
popd
#********</pre>**********

# ==== 8.72.2. Contents of Texinfo ====

#  Installed programs: info, install-info, makeinfo (link to texi2any), pdftexi2dvi, pod2texi, texi2any, texi2dvi, texi2pdf, and texindex
#  Installed library: MiscXS.so, Parsetexi.so, and XSParagraph.so (all in /usr/lib/texinfo)
#  Installed directories: /usr/share/texinfo and /usr/lib/texinfo
# ====== Short Descriptions ======

#--------------------------------------------
# | info                                     | Used to read info pages which are similar to man pages, but often go much deeper than just explaining all the available command line options [For example, compareman bison                               and                                     info bison                              .]                                      
# | install-info                             | Used to install info pages; it updates entries in theinfo                                    index file                              
# | makeinfo                                 | Translates the given Texinfo source documents into info pages, plain text, or HTML
# | pdftexi2dvi                              | Used to format the given Texinfo document into a Portable Document Format (PDF) file
# | pod2texi                                 | Converts Pod to Texinfo format          
# | texi2any                                 | Translate Texinfo source documentation to various other formats
# | texi2dvi                                 | Used to format the given Texinfo document into a device-independent file that can be printed
# | texi2pdf                                 | Used to format the given Texinfo document into a Portable Document Format (PDF) file
# | texindex                                 | Used to sort Texinfo index files        
#--------------------------------------------
cd $topdir
rm -rf $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt
