#!/usr/bin/bash

# ===== 8.85. Cleaning Up =====
topdir=$(pwd)
err=0
set -e
chapter=8085
err_report() {
    echo "chapter $chapter: $(date +'%Y.%m.%d %H:%M:%S') Error $? on line $1" | tee >> $topdir/log.txt
}
trap 'err_report $LINENO' ERR
echo "---------" >> $topdir/log.txt
echo chapter $chapter: start = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt






#<p>
#
#  Finally, clean up some extra files left over from running tests: 
#</p>

#********<pre>***********
rm -rf /tmp/{*,.*}
#********</pre>**********
#<p>
#
#  There are also several files in the /usr/lib and /usr/libexec directories with 
# a file name extension of .la. These are "libtool archive" files. On a modern 
# Linux system the libtool .la files are only useful for libltdl. No libraries in 
# LFS are expected to be loaded by libltdl, and it's known that some .la files 
# can break BLFS package builds. Remove those files now: 
#</p>

#********<pre>***********
find /usr/lib /usr/libexec -name \*.la -delete
#********</pre>**********
#<p>
#
#  For more information about libtool archive files, see the [BLFS section "About Libtool Archive (.la) files"](https://www.linuxfromscratch.org/blfs/view/svn/introduction/la-files.html)
#  . 
#</p>
#<p>
#
#  The compiler built in [Chapter 6](../chapter06/chapter06.html)
#  and [Chapter 7](../chapter07/chapter07.html)
#  is still partially installed and not needed anymore. Remove it with: 
#</p>

#********<pre>***********
find /usr -depth -name $(uname -m)-lfs-linux-gnu\* | xargs rm -rf
#********</pre>**********
#<p>
#
#  Finally, remove the temporary 'tester' user account created at the beginning 
# of the previous chapter. 
#</p>

#********<pre>***********
userdel -r tester
#********</pre>**********
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt
