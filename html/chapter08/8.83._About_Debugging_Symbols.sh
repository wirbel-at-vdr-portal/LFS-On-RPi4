#!/usr/bin/bash

# ===== 8.83. About Debugging Symbols =====
topdir=$(pwd)
err=0
set -e
chapter=8083
err_report() {
    echo "chapter $chapter: $(date +'%Y.%m.%d %H:%M:%S') Error $? on line $1" | tee >> $topdir/log.txt
}
trap 'err_report $LINENO' ERR
echo "---------" >> $topdir/log.txt
echo chapter $chapter: start = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt






#<p>
#
#  Most programs and libraries are, by default, compiled with debugging symbols 
# included (with gcc
#  's -g 
#  option). This means that when debugging a program or library that was compiled 
# with debugging information, the debugger can provide not only memory addresses, 
# but also the names of the routines and variables. 
#</p>
#<p>
#
#  The inclusion of these debugging symbols enlarges a program or library 
# significantly. Here are two examples of the amount of space these symbols 
# occupy: 
#</p>

# ***** #<p>
#
#  A bash
#  binary with debugging symbols: 1200 KB 
#</p>

# ***** #<p>
#
#  A bash
#  binary without debugging symbols: 480 KB (60% smaller) 
#</p>

# ***** #<p>
#
#  Glibc and GCC files ( /lib 
#  and /usr/lib 
#  ) with debugging symbols: 87 MB 
#</p>

# ***** #<p>
#
#  Glibc and GCC files without debugging symbols: 16 MB (82% smaller) 
#</p>
#<p>
#
#  Sizes will vary depending on which compiler and C library were used, but a 
# program that has been stripped of debugging symbols is usually some 50% to 80% 
# smaller than its unstripped counterpart. Because most users will never use a 
# debugger on their system software, a lot of disk space can be regained by 
# removing these symbols. The next section shows how to strip all debugging 
# symbols from the programs and libraries. 
#</p>
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt
