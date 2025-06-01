#!/usr/bin/bash

# ===== 8.81. Sysklogd-2.7.2 =====
topdir=$(pwd)
err=0
set -e
chapter=8081
err_report() {
    echo "chapter $chapter: $(date +'%Y.%m.%d %H:%M:%S') Error $? on line $1" | tee >> $topdir/log.txt
}
trap 'err_report $LINENO' ERR
echo "---------" >> $topdir/log.txt
echo chapter $chapter: start = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt






srcdir=../../src/sysklogd-2.7.2
tar xf ../../src/sysklogd-2.7.2.tar.gz -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir

#<p>
#
#  The Sysklogd package contains programs for logging system messages, such as 
# those emitted by the kernel when unusual things happen. 
#</p>

#  Approximate build time: less than 0.1 SBU
#  Required disk space: 4.1 MB
# ==== 8.81.1. Installation of Sysklogd ====
#<p>
#
#  Prepare the package for compilation: 
#</p>

#********<pre>***********
./configure --prefix=/usr      \
            --sysconfdir=/etc  \
            --runstatedir=/run \
            --without-logger   \
            --disable-static   \
            --docdir=/usr/share/doc/sysklogd-2.7.2
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
#  This package does not come with a test suite. 
#</p>
#<p>
#
#  Install the package: 
#</p>

#********<pre>***********
make install
#********</pre>**********

# ==== 8.81.2. Configuring Sysklogd ====
#<p>
#
#  Create a new /etc/syslog.conf 
#  file by running the following: 
#</p>

#********<pre>***********
cat > /etc/syslog.conf << "EOF"
# Begin /etc/syslog.conf

auth,authpriv.* -/var/log/auth.log
*.*;auth,authpriv.none -/var/log/sys.log
daemon.* -/var/log/daemon.log
kern.* -/var/log/kern.log
mail.* -/var/log/mail.log
user.* -/var/log/user.log
*.emerg *

# Do not open any internet ports.
secure_mode 2

# End /etc/syslog.conf
EOF
#********</pre>**********

# ==== 8.81.3. Contents of Sysklogd ====

#  Installed program: syslogd
# ====== Short Descriptions ======

#--------------------------------------------
# | syslogd                                  | Logs the messages that system programs offer for logging [Every logged message contains at least a date stamp and a hostname, and normally the program's name too, but that depends on how trusting the logging daemon is told to be.]
#--------------------------------------------
cd $topdir
rm -rf $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt
