#!/usr/bin/bash

# ===== 8.36. Bash-5.2.37 =====
topdir=$(pwd)
err=0
set -e
chapter=8036
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



srcdir=../../src/bash-5.2.37
tar xf ../../src/bash-5.2.37.tar.gz -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir

#<p>
#
#  The Bash package contains the Bourne-Again Shell. 
#</p>

#  Approximate build time: 1.4 SBU
#  Required disk space: 53 MB
# ==== 8.36.1. Installation of Bash ====
#<p>
#
#  Prepare Bash for compilation: 
#</p>

#********<pre>***********
./configure --prefix=/usr             \
            --without-bash-malloc     \
            --with-installed-readline \
            --docdir=/usr/share/doc/bash-5.2.37
#********</pre>**********
#<p>
#
#  The meaning of the new configure option: 
#</p>

#--with-installed-readline 
##<p>
#
#  This option tells Bash to use the readline 
#  library that is already installed on the system rather than using its own 
# readline version. 
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
#  To prepare the tests, ensure that the tester 
#  user can write to the sources tree: 
#</p>

#********<pre>***********
chown -R tester .
#********</pre>**********
#<p>
#
#  The test suite of this package is designed to be run as a non- root 
#  user who owns the terminal connected to standard input. To satisfy the 
# requirement, spawn a new pseudo terminal using Expect
#  and run the tests as the tester 
#  user: 
#</p>

#********<pre>***********
su -s /usr/bin/expect tester << "EOF"
set timeout -1
spawn make tests
expect eof
lassign [wait] _ _ _ value
exit $value
EOF
#********</pre>**********
#<p>
#
#  The test suite uses diff
#  to detect the difference between test script output and the expected output. 
# Any output from diff
#  (prefixed with < 
#  and > 
#  ) indicates a test failure, unless there is a message saying the difference 
# can be ignored. One test named run-builtins 
#  is known to fail on some host distros with a difference on the first line of 
# the output. 
#</p>
#<p>
#
#  Install the package: 
#</p>

#********<pre>***********
make install
#********</pre>**********
#<p>
#
#  Run the newly compiled bash
#  program (replacing the one that is currently being executed): 
#</p>

#********<pre>***********
exec /usr/bin/bash --login
#********</pre>**********

# ==== 8.36.2. Contents of Bash ====

#  Installed programs: bash, bashbug, and sh (link to bash)
#  Installed directory: /usr/include/bash, /usr/lib/bash, and /usr/share/doc/bash-5.2.37
# ====== Short Descriptions ======

#--------------------------------------------
# | bash                                     | A widely-used command interpreter; it performs many types of expansions and substitutions on a given command line before executing it, thus making this interpreter a powerful tool
# | bashbug                                  | A shell script to help the user compose and mail standard formatted bug reports concerningbash                                    
# | sh                                       | A symlink to the                        bash                                    program; when invoked as                sh                                      ,                                       bash                                    tries to mimic the startup behavior of historical versions ofsh                                      as closely as possible, while conforming to the POSIX standard as well
#--------------------------------------------
cd $topdir
rm -rf $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt
