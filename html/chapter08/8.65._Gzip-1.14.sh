#!/usr/bin/bash

# ===== 8.65. Gzip-1.14 =====
topdir=$(pwd)
err=0
set -e
chapter=8065
err_report() {
    echo "chapter $chapter: $(date +'%Y.%m.%d %H:%M:%S') Error $? on line $1" | tee >> $topdir/log.txt
}
trap 'err_report $LINENO' ERR
echo "---------" >> $topdir/log.txt
echo chapter $chapter: start = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt






srcdir=../../src/gzip-1.14
tar xf ../../src/gzip-1.14.tar.xz -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir

#<p>
#
#  The Gzip package contains programs for compressing and decompressing files. 
#</p>

#  Approximate build time: 0.3 SBU
#  Required disk space: 21 MB
# ==== 8.65.1. Installation of Gzip ====
#<p>
#
#  Prepare Gzip for compilation: 
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

# ==== 8.65.2. Contents of Gzip ====

#  Installed programs: gunzip, gzexe, gzip, uncompress (hard link with gunzip), zcat, zcmp, zdiff, zegrep, zfgrep, zforce, zgrep, zless, zmore, and znew
# ====== Short Descriptions ======

#--------------------------------------------
# | gunzip                                   | Decompresses gzipped files              
# | gzexe                                    | Creates self-decompressing executable files
# | gzip                                     | Compresses the given files using Lempel-Ziv (LZ77) coding
# | uncompress                               | Decompresses compressed files           
# | zcat                                     | Decompresses the given gzipped files to standard output
# | zcmp                                     | Runs                                    cmp                                     on gzipped files                        
# | zdiff                                    | Runs                                    diff                                    on gzipped files                        
# | zegrep                                   | Runs                                    egrep                                   on gzipped files                        
# | zfgrep                                   | Runs                                    fgrep                                   on gzipped files                        
# | zforce                                   | Forces a                                .gz                                     extension on all given files that are gzipped files, so thatgzip                                    will not compress them again; this can be useful when file names were truncated during a file transfer
# | zgrep                                    | Runs                                    grep                                    on gzipped files                        
# | zless                                    | Runs                                    less                                    on gzipped files                        
# | zmore                                    | Runs                                    more                                    on gzipped files                        
# | znew                                     | Re-compresses files from                compress                                format to                               gzip                                    format—                                 .Z                                      to                                      .gz                                     
#--------------------------------------------
cd $topdir
rm -rf $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt
