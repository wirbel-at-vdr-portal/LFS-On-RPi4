#!/usr/bin/bash

# ===== 8.63. Groff-1.23.0 =====
topdir=$(pwd)
err=0
set -e
chapter=8063
err_report() {
    echo "chapter $chapter: $(date +'%Y.%m.%d %H:%M:%S') Error $? on line $1" | tee >> $topdir/log.txt
}
trap 'err_report $LINENO' ERR
echo "---------" >> $topdir/log.txt
echo chapter $chapter: start = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt






srcdir=../../src/groff-1.23.0
tar xf ../../src/groff-1.23.0.tar.gz -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir

#<p>
#
#  The Groff package contains programs for processing and formatting text and 
# images. 
#</p>

#  Approximate build time: 0.2 SBU
#  Required disk space: 108 MB
# ==== 8.63.1. Installation of Groff ====
#<p>
#
#  Groff expects the environment variable PAGE 
#  to contain the default paper size. For users in the United States, PAGE=letter 
#  is appropriate. Elsewhere, PAGE=A4 
#  may be more suitable. While the default paper size is configured during 
# compilation, it can be overridden later by echoing either “A4”
#  or “letter”
#  to the /etc/papersize 
#  file. 
#</p>
#<p>
#
#  Prepare Groff for compilation: 
#</p>

#********<pre>***********
PAGE=A4 ./configure --prefix=/usr
#********</pre>**********
#<p>
#
#  Build the package: 
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

# ==== 8.63.2. Contents of Groff ====

#  Installed programs: addftinfo, afmtodit, chem, eqn, eqn2graph, gdiffmk, glilypond, gperl, gpinyin, grap2graph, grn, grodvi, groff, groffer, grog, grolbp, grolj4, gropdf, grops, grotty, hpftodit, indxbib, lkbib, lookbib, mmroff, neqn, nroff, pdfmom, pdfroff, pfbtops, pic, pic2graph, post-grohtml, preconv, pre-grohtml, refer, roff2dvi, roff2html, roff2pdf, roff2ps, roff2text, roff2x, soelim, tbl, tfmtodit, and troff
#  Installed directories: /usr/lib/groff and /usr/share/doc/groff-1.23.0, /usr/share/groff
# ====== Short Descriptions ======

#--------------------------------------------
# | addftinfo                                | Reads a troff font file and adds some additional font-metric information that is used by thegroff                                   system                                  
# | afmtodit                                 | Creates a font file for use with        groff                                   and                                     grops                                   
# | chem                                     | Groff preprocessor for producing chemical structure diagrams
# | eqn                                      | Compiles descriptions of equations embedded within troff input files into commands that are understood bytroff                                   
# | eqn2graph                                | Converts a troff EQN (equation) into a cropped image
# | gdiffmk                                  | Marks differences between groff/nroff/troff files
# | glilypond                                | Transforms sheet music written in the lilypond language into the groff language
# | gperl                                    | Preprocessor for groff, allowing the insertion of perl code into groff files
# | gpinyin                                  | Preprocessor for groff, allowing the insertion of Pinyin (Mandarin Chinese spelled with the Roman alphabet) into groff files.
# | grap2graph                               | Converts a grap program file into a cropped bitmap image (grap is an old Unix programming language for creating diagrams)
# | grn                                      | A                                       groff                                   preprocessor for gremlin files          
# | grodvi                                   | A driver for                            groff                                   that produces TeX dvi format output files
# | groff                                    | A front end to the groff document formatting system; normally, it runs thetroff                                   program and a post-processor appropriate for the selected device
# | groffer                                  | Displays groff files and man pages on X and tty terminals
# | grog                                     | Reads files and guesses which of the    groff                                   options                                 -e                                      ,                                       -man                                    ,                                       -me                                     ,                                       -mm                                     ,                                       -ms                                     ,                                       -p                                      ,                                       -s                                      , and                                   -t                                      are required for printing files, and reports thegroff                                   command including those options         
# | grolbp                                   | Is a                                    groff                                   driver for Canon CAPSL printers (LBP-4 and LBP-8 series laser printers)
# | grolj4                                   | Is a driver for                         groff                                   that produces output in PCL5 format suitable for an HP LaserJet 4 printer
# | gropdf                                   | Translates the output of GNU            troff                                   to PDF                                  
# | grops                                    | Translates the output of GNU            troff                                   to PostScript                           
# | grotty                                   | Translates the output of GNU            troff                                   into a form suitable for typewriter-like devices
# | hpftodit                                 | Creates a font file for use with        groff -Tlj4                             from an HP-tagged font metric file      
# | indxbib                                  | Creates an inverted index for the bibliographic databases with a specified file for use withrefer                                   ,                                       lookbib                                 , and                                   lkbib                                   
# | lkbib                                    | Searches bibliographic databases for references that contain specified keys and reports any references found
# | lookbib                                  | Prints a prompt on the standard error (unless the standard input is not a terminal), reads a line containing a set of keywords from the standard input, searches the bibliographic databases in a specified file for references containing those keywords, prints any references found on the standard output, and repeats this process until the end of input
# | mmroff                                   | A simple preprocessor for               groff                                   
# | neqn                                     | Formats equations for American Standard Code for Information Interchange (ASCII) output
# | nroff                                    | A script that emulates the              nroff                                   command using                           groff                                   
# | pdfmom                                   | Is a wrapper around groff that facilitates the production of PDF documents from files formatted with the mom macros.
# | pdfroff                                  | Creates pdf documents using groff       
# | pfbtops                                  | Translates a PostScript font in         .pfb                                    format to ASCII                         
# | pic                                      | Compiles descriptions of pictures embedded within troff or TeX input files into commands understood by TeX ortroff                                   
# | pic2graph                                | Converts a PIC diagram into a cropped image
# | post-grohtml                             | Translates the output of GNU            troff                                   to HTML                                 
# | preconv                                  | Converts encoding of input files to something GNUtroff                                   understands                             
# | pre-grohtml                              | Translates the output of GNU            troff                                   to HTML                                 
# | refer                                    | Copies the contents of a file to the standard output, except that lines between.[                                      and                                     .]                                      are interpreted as citations, and lines between.R1                                     and                                     .R2                                     are interpreted as commands for how citations are to be processed
# | roff2dvi                                 | Transforms roff files into DVI format   
# | roff2html                                | Transforms roff files into HTML format  
# | roff2pdf                                 | Transforms roff files into PDFs         
# | roff2ps                                  | Transforms roff files into ps files     
# | roff2text                                | Transforms roff files into text files   
# | roff2x                                   | Transforms roff files into other formats
# | soelim                                   | Reads files and replaces lines of the form.so file                                by the contents of the mentioned        file                                    
# | tbl                                      | Compiles descriptions of tables embedded within troff input files into commands that are understood bytroff                                   
# | tfmtodit                                 | Creates a font file for use with        groff -Tdvi                             
# | troff                                    | Is highly compatible with Unix          troff                                   ; it should usually be invoked using thegroff                                   command, which will also run preprocessors and post-processors in the appropriate order and with the appropriate options
#--------------------------------------------
cd $topdir
rm -rf $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt
