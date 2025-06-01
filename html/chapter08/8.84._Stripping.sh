#!/usr/bin/bash

# ===== 8.84. Stripping =====
topdir=$(pwd)
err=0
set -e
chapter=8084
err_report() {
    echo "chapter $chapter: $(date +'%Y.%m.%d %H:%M:%S') Error $? on line $1" | tee >> $topdir/log.txt
}
trap 'err_report $LINENO' ERR
echo "---------" >> $topdir/log.txt
echo chapter $chapter: start = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt






#<p>
#
#  This section is optional. If the intended user is not a programmer and does 
# not plan to do any debugging of the system software, the system's size can be 
# decreased by some 2 GB by removing the debugging symbols, and some unnecessary 
# symbol table entries, from binaries and libraries. This causes no real 
# inconvenience for a typical Linux user. 
#</p>
#<p>
#
#  Most people who use the commands mentioned below do not experience any 
# difficulties. However, it is easy to make a mistake and render the new system 
# unusable. So before running the strip
#  commands, it is a good idea to make a backup of the LFS system in its current 
# state. 
#</p>
#<p>
#
#  A strip
#  command with the --strip-unneeded 
#  option removes all debug symbols from a binary or library. It also removes all 
# symbol table entries not normally needed by the linker (for static libraries) 
# or dynamic linker (for dynamically linked binaries and shared libraries). Using --strip-debug 
#  does not remove symbol table entries that may be needed by some applications. 
# The difference between unneeded 
#  and debug 
#  is very small. For example, an unstripped libc.a 
#  is 22.4 MB. After stripping with --strip-debug 
#  it is 5.9 MB. Using --strip-unneeded 
#  only reduces the size further to 5.8 MB. 
#</p>
#<p>
#
#  The debugging symbols from selected libraries are compressed with Zstd
#  and preserved in separate files. That debugging information is needed to run 
# regression tests with [valgrind](https://www.linuxfromscratch.org/blfs/view/svn//general/valgrind.html)
#  or [gdb](https://www.linuxfromscratch.org/blfs/view/svn//general/gdb.html)
#  later, in BLFS. 
#</p>
#<p>
#
#  Note that strip
#  will overwrite the binary or library file it is processing. This can crash the 
# processes using code or data from the file. If the process running strip
#  is affected, the binary or library being stripped can be destroyed; this can 
# make the system completely unusable. To avoid this problem we copy some 
# libraries and binaries into /tmp 
#  , strip them there, then reinstall them with the install
#  command. (The related entry in [Section 8.2.1, “Upgrade Issues”](pkgmgt.html#pkgmgmt-upgrade-issues)
#  gives the rationale for using the install
#  command here.) 
#</p>

# ====== Note ======
#<p>
#
#  The ELF loader's name is ld-linux-x86-64.so.2 on 64-bit systems and 
# ld-linux.so.2 on 32-bit systems. The construct below selects the correct name 
# for the current architecture, excluding anything ending with g 
#  , in case the commands below have already been run. 
#</p>

# ====== Important ======
#<p>
#
#  If there is any package whose version is different from the version specified 
# by the book (either following a security advisory or satisfying personal 
# preference), it may be necessary to update the library file name in save_usrlib 
#  or online_usrlib 
#  . Failing to do so may render the system completely unusable.
#</p>

#********<pre>***********
save_usrlib="$(cd /usr/lib; ls ld-linux*[^g])
             libc.so.6
             libthread_db.so.1
             libquadmath.so.0.0.0
             libstdc++.so.6.0.33
             libitm.so.1.0.0
             libatomic.so.1.2.0"

cd /usr/lib

for LIB in $save_usrlib; do
    objcopy --only-keep-debug --compress-debug-sections=zstd $LIB $LIB.dbg
    cp $LIB /tmp/$LIB
    strip --strip-debug /tmp/$LIB
    objcopy --add-gnu-debuglink=$LIB.dbg /tmp/$LIB
    install -vm755 /tmp/$LIB /usr/lib
    rm /tmp/$LIB
done

online_usrbin="bash find strip"
online_usrlib="libbfd-2.44.so
               libsframe.so.1.0.0
               libhistory.so.8.2
               libncursesw.so.6.5
               libm.so.6
               libreadline.so.8.2
               libz.so.1.3.1
               libzstd.so.1.5.7
               $(cd /usr/lib; find libnss*.so* -type f)"

for BIN in $online_usrbin; do
    cp /usr/bin/$BIN /tmp/$BIN
    strip --strip-debug /tmp/$BIN
    install -vm755 /tmp/$BIN /usr/bin
    rm /tmp/$BIN
done

for LIB in $online_usrlib; do
    cp /usr/lib/$LIB /tmp/$LIB
    strip --strip-debug /tmp/$LIB
    install -vm755 /tmp/$LIB /usr/lib
    rm /tmp/$LIB
done

for i in $(find /usr/lib -type f -name \*.so* ! -name \*dbg) \
         $(find /usr/lib -type f -name \*.a)                 \
         $(find /usr/{bin,sbin,libexec} -type f); do
    case "$online_usrbin $online_usrlib $save_usrlib" in
        *$(basename $i)* )
            ;;
        * ) strip --strip-debug $i
            ;;
    esac
done

unset BIN LIB save_usrlib online_usrbin online_usrlib

#********</pre>**********
#<p>
#
#  A large number of files will be flagged as errors because their file format is 
# not recognized. These warnings can be safely ignored. They indicate that those 
# files are scripts, not binaries. 
#</p>
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt
