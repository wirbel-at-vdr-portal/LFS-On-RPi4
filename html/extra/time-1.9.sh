topdir=$(pwd)
err=0
set -e
chapter=time-1.9

err_report() {
    echo "chapter $chapter: $(date +'%Y.%m.%d %H:%M:%S') Error $? on line $1" | tee >> $topdir/log.txt
}
trap 'err_report $LINENO' ERR
echo "---------" >> $topdir/log.txt
echo chapter $chapter: start = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt




srcdir=../../src/time-1.9
tar xf ../../src/time-1.9.tar.gz -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir










# Introduction to Time
# 
# The time utility is a program that measures many of the CPU resources, such as time and memory, that other programs use. The GNU version can format the output in arbitrary ways by using a printf-style format string to include various resource measurements.
# 
# Although the shell has a builtin command providing similar functionalities, this utility is required by the LSB.
# [Note] Note
# 
# Development versions of BLFS may not build or run some packages properly if LFS or dependencies have been updated since the most recent stable versions of the books.
# Package Information
# 
#     Download (HTTP): https://ftp.gnu.org/gnu/time/time-1.9.tar.gz
# 
#     Download MD5 sum: d2356e0fe1c0b85285d83c6b2ad51b5f
# 
#     Download size: 584 KB
# 
#     Estimated disk space required: 4.0 MB (with tests)
# 
#     Estimated build time: 0.1 SBU (with tests)
#                                                      
# Installation of Time                                 
#                                                      
# Install Time by running the following commands:      
                                                     
./configure --prefix=/usr &&                         
make                                                 
                                                     
# To test the results, issue: make check.              
#                                                      
# Now, as the root user:                               
                                                     
make install                                         
                                                     cd $topdir
#Contents                                             rm -rf $srcdir
#Installed Program:                                   echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
#time                                                 echo "---------" >> $topdir/log.txt
#Installed Library:                                   
#None                                                 
#Installed Directory:                                 
#None                                                 
#Short Descriptions                                   
#                                                     
#time                                                 
# 	                                                  
#                                                      
# reports various statistics about an executed command 
# 





cd $topdir
rm -rf $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt

