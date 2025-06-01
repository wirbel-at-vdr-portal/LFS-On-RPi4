#!/usr/bin/bash

# ===== 8.59. Coreutils-9.7 =====
topdir=$(pwd)
err=0
set -e
chapter=8059
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



srcdir=../../src/coreutils-9.7
tar xf ../../src/coreutils-9.7.tar.xz -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir

#<p>
#
#  The Coreutils package contains the basic utility programs needed by every 
# operating system. 
#</p>

#  Approximate build time: 1.2 SBU
#  Required disk space: 182 MB
# ==== 8.59.1. Installation of Coreutils ====
#<p>
#
#  POSIX requires that programs from Coreutils recognize character boundaries 
# correctly even in multibyte locales. The following patch fixes this 
# non-compliance and other internationalization-related bugs. 
#</p>

#********<pre>***********
patch -Np1 -i ../coreutils-9.7-i18n-1.patch
#********</pre>**********

# ====== Note ======
#<p>
#
#  Many bugs have been found in this patch. When reporting new bugs to the 
# Coreutils maintainers, please check first to see if those bugs are reproducible 
# without this patch. 
#</p>
#<p>
#
#  Now prepare Coreutils for compilation: 
#</p>

#********<pre>***********
autoreconf -fv
automake -af
FORCE_UNSAFE_CONFIGURE=1 ./configure \
            --prefix=/usr            \
            --enable-no-install-program=kill,uptime
#********</pre>**********
#<p>
#
#  The meaning of the commands and configure options: 
#</p>

#autoreconf -fv
##<p>
#
#  The patch for internationalization has modified the build system, so the 
# configuration files must be regenerated. Normally we would use the -i 
#  option to update the standard auxiliary files, but for this package it does 
# not work because configure.ac 
#  specified an old gettext version. 
#</p>

#automake -af
##<p>
#
#  The automake auxiliary files were not updated by autoreconf
#  due to the missing -i 
#  option. This command updates them to prevent a build failure. 
#</p>

#FORCE_UNSAFE_CONFIGURE=1 
##<p>
#
#  This environment variable allows the package to be built by the root 
#  user. 
#</p>

#--enable-no-install-program=kill,uptime 
##<p>
#
#  The purpose of this switch is to prevent Coreutils from installing programs 
# that will be installed by other packages. 
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
#  Skip down to “Install the package”
#  if not running the test suite. 
#</p>
#<p>
#
#  Now the test suite is ready to be run. First, run the tests that are meant to 
# be run as user root 
#  : 
#</p>

#********<pre>***********
#make NON_ROOT_USERNAME=tester check-root
#********</pre>**********
#<p>
#
#  We're going to run the remainder of the tests as the tester 
#  user. Certain tests require that the user be a member of more than one group. 
# So that these tests are not skipped, add a temporary group and make the user tester 
#  a part of it: 
#</p>

#********<pre>***********
#groupadd -g 102 dummy -U tester
#********</pre>**********
#<p>
#
#  Fix some of the permissions so that the non- root 
#  user can compile and run the tests: 
#</p>

#********<pre>***********
#chown -R tester . 
#********</pre>**********
#<p>
#
#  Now run the tests (using /dev/null 
#  for the standard input, or two tests may be broken if building LFS in a 
# graphical terminal or a session in SSH or GNU Screen because the standard input 
# is connected to a PTY from host distro, and the device node for such a PTY 
# cannot be accessed from the LFS chroot environment): 
#</p>

#********<pre>***********
#su tester -c "PATH=$PATH make -k RUN_EXPENSIVE_TESTS=yes check" \
#   < /dev/null
#********</pre>**********
#<p>
#
#  Remove the temporary group: 
#</p>

#********<pre>***********
#groupdel dummy
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
#  Move programs to the locations specified by the FHS: 
#</p>

#********<pre>***********
mv -v /usr/bin/chroot /usr/sbin
mv -v /usr/share/man/man1/chroot.1 /usr/share/man/man8/chroot.8
sed -i 's/"1"/"8"/' /usr/share/man/man8/chroot.8
#********</pre>**********

# ==== 8.59.2. Contents of Coreutils ====

#  Installed programs: [, b2sum, base32, base64, basename, basenc, cat, chcon, chgrp, chmod, chown, chroot, cksum, comm, cp, csplit, cut, date, dd, df, dir, dircolors, dirname, du, echo, env, expand, expr, factor, false, fmt, fold, groups, head, hostid, id, install, join, link, ln, logname, ls, md5sum, mkdir, mkfifo, mknod, mktemp, mv, nice, nl, nohup, nproc, numfmt, od, paste, pathchk, pinky, pr, printenv, printf, ptx, pwd, readlink, realpath, rm, rmdir, runcon, seq, sha1sum, sha224sum, sha256sum, sha384sum, sha512sum, shred, shuf, sleep, sort, split, stat, stdbuf, stty, sum, sync, tac, tail, tee, test, timeout, touch, tr, true, truncate, tsort, tty, uname, unexpand, uniq, unlink, users, vdir, wc, who, whoami, and yes
#  Installed library: libstdbuf.so (in /usr/libexec/coreutils)
#  Installed directory: /usr/libexec/coreutils
# ====== Short Descriptions ======

#--------------------------------------------
# | [                                        | Is an actual command, /usr/bin/[; it is a synonym for thetest                                    command                                 
# | base32                                   | Encodes and decodes data according to the base32 specification (RFC 4648)
# | base64                                   | Encodes and decodes data according to the base64 specification (RFC 4648)
# | b2sum                                    | Prints or checks BLAKE2 (512-bit) checksums
# | basename                                 | Strips any path and a given suffix from a file name
# | basenc                                   | Encodes or decodes data using various algorithms
# | cat                                      | Concatenates files to standard output   
# | chcon                                    | Changes security context for files and directories
# | chgrp                                    | Changes the group ownership of files and directories
# | chmod                                    | Changes the permissions of each file to the given mode; the mode can be either a symbolic representation of the changes to be made, or an octal number representing the new permissions
# | chown                                    | Changes the user and/or group ownership of files and directories
# | chroot                                   | Runs a command with the specified directory as the/                                       directory                               
# | cksum                                    | Prints the Cyclic Redundancy Check (CRC) checksum and the byte counts of each specified file
# | comm                                     | Compares two sorted files, outputting in three columns the lines that are unique and the lines that are common
# | cp                                       | Copies files                            
# | csplit                                   | Splits a given file into several new files, separating them according to given patterns or line numbers, and outputting the byte count of each new file
# | cut                                      | Prints sections of lines, selecting the parts according to given fields or positions
# | date                                     | Displays the current date and time in the given format, or sets the system date and time
# | dd                                       | Copies a file using the given block size and count, while optionally performing conversions on it
# | df                                       | Reports the amount of disk space available (and used) on all mounted file systems, or only on the file systems holding the selected files
# | dir                                      | Lists the contents of each given directory (the same as thels                                      command)                                
# | dircolors                                | Outputs commands to set the             LS_COLOR                                environment variable to change the color scheme used byls                                      
# | dirname                                  | Extracts the directory portion(s) of the given name(s)
# | du                                       | Reports the amount of disk space used by the current directory, by each of the given directories (including all subdirectories) or by each of the given files
# | echo                                     | Displays the given strings              
# | env                                      | Runs a command in a modified environment
# | expand                                   | Converts tabs to spaces                 
# | expr                                     | Evaluates expressions                   
# | factor                                   | Prints the prime factors of the specified integers
# | false                                    | Does nothing, unsuccessfully; it always exits with a status code indicating failure
# | fmt                                      | Reformats the paragraphs in the given files
# | fold                                     | Wraps the lines in the given files      
# | groups                                   | Reports a user's group memberships      
# | head                                     | Prints the first ten lines (or the given number of lines) of each given file
# | hostid                                   | Reports the numeric identifier (in hexadecimal) of the host
# | id                                       | Reports the effective user ID, group ID, and group memberships of the current user or specified user
# | install                                  | Copies files while setting their permission modes and, if possible, their owner and group
# | join                                     | Joins the lines that have identical join fields from two separate files
# | link                                     | Creates a hard link (with the given name) to a file
# | ln                                       | Makes hard links or soft (symbolic) links between files
# | logname                                  | Reports the current user's login name   
# | ls                                       | Lists the contents of each given directory
# | md5sum                                   | Reports or checks Message Digest 5 (MD5) checksums
# | mkdir                                    | Creates directories with the given names
# | mkfifo                                   | Creates First-In, First-Outs (FIFOs), "named pipes" in UNIX parlance, with the given names
# | mknod                                    | Creates device nodes with the given names; a device node is a character special file, a block special file, or a FIFO
# | mktemp                                   | Creates temporary files in a secure manner; it is used in scripts
# | mv                                       | Moves or renames files or directories   
# | nice                                     | Runs a program with modified scheduling priority
# | nl                                       | Numbers the lines from the given files  
# | nohup                                    | Runs a command immune to hangups, with its output redirected to a log file
# | nproc                                    | Prints the number of processing units available to a process
# | numfmt                                   | Converts numbers to or from human-readable strings
# | od                                       | Dumps files in octal and other formats  
# | paste                                    | Merges the given files, joining sequentially corresponding lines side by side, separated by tab characters
# | pathchk                                  | Checks if file names are valid or portable
# | pinky                                    | Is a lightweight finger client; it reports some information about the given users
# | pr                                       | Paginates and columnates files for printing
# | printenv                                 | Prints the environment                  
# | printf                                   | Prints the given arguments according to the given format, much like the C printf function
# | ptx                                      | Produces a permuted index from the contents of the given files, with each keyword in its context
# | pwd                                      | Reports the name of the current working directory
# | readlink                                 | Reports the value of the given symbolic link
# | realpath                                 | Prints the resolved path                
# | rm                                       | Removes files or directories            
# | rmdir                                    | Removes directories if they are empty   
# | runcon                                   | Runs a command with specified security context
# | seq                                      | Prints a sequence of numbers within a given range and with a given increment
# | sha1sum                                  | Prints or checks 160-bit Secure Hash Algorithm 1 (SHA1) checksums
# | sha224sum                                | Prints or checks 224-bit Secure Hash Algorithm checksums
# | sha256sum                                | Prints or checks 256-bit Secure Hash Algorithm checksums
# | sha384sum                                | Prints or checks 384-bit Secure Hash Algorithm checksums
# | sha512sum                                | Prints or checks 512-bit Secure Hash Algorithm checksums
# | shred                                    | Overwrites the given files repeatedly with complex patterns, making it difficult to recover the data
# | shuf                                     | Shuffles lines of text                  
# | sleep                                    | Pauses for the given amount of time     
# | sort                                     | Sorts the lines from the given files    
# | split                                    | Splits the given file into pieces, by size or by number of lines
# | stat                                     | Displays file or filesystem status      
# | stdbuf                                   | Runs commands with altered buffering operations for its standard streams
# | stty                                     | Sets or reports terminal line settings  
# | sum                                      | Prints checksum and block counts for each given file
# | sync                                     | Flushes file system buffers; it forces changed blocks to disk and updates the super block
# | tac                                      | Concatenates the given files in reverse 
# | tail                                     | Prints the last ten lines (or the given number of lines) of each given file
# | tee                                      | Reads from standard input while writing both to standard output and to the given files
# | test                                     | Compares values and checks file types   
# | timeout                                  | Runs a command with a time limit        
# | touch                                    | Changes file timestamps, setting the access and modification times of the given files to the current time; files that do not exist are created with zero length
# | tr                                       | Translates, squeezes, and deletes the given characters from standard input
# | true                                     | Does nothing, successfully; it always exits with a status code indicating success
# | truncate                                 | Shrinks or expands a file to the specified size
# | tsort                                    | Performs a topological sort; it writes a completely ordered list according to the partial ordering in a given file
# | tty                                      | Reports the file name of the terminal connected to standard input
# | uname                                    | Reports system information              
# | unexpand                                 | Converts spaces to tabs                 
# | uniq                                     | Discards all but one of successive identical lines
# | unlink                                   | Removes the given file                  
# | users                                    | Reports the names of the users currently logged on
# | vdir                                     | Is the same as                          ls -l                                   
# | wc                                       | Reports the number of lines, words, and bytes for each given file, as well as grand totals when more than one file is given
# | who                                      | Reports who is logged on                
# | whoami                                   | Reports the user name associated with the current effective user ID
# | yes                                      | Repeatedly outputs                      y                                       or a given string, until killed         
# | libstdbuf                                | Library used by                         stdbuf                                  
#--------------------------------------------
cd $topdir
rm -rf $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt
