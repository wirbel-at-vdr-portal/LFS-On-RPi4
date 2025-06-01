#!/usr/bin/bash

# ===== 8.51. Python-3.13.3 =====
topdir=$(pwd)
err=0
set -e
chapter=8051
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



srcdir=../../src/Python-3.13.3
tar xf ../../src/Python-3.13.3.tar.xz -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir

#<p>
#
#  The Python 3 package contains the Python development environment. It is useful 
# for object-oriented programming, writing scripts, prototyping large programs, 
# and developing entire applications. Python is an interpreted computer language. 
#</p>

#  Approximate build time: 2.1 SBU
#  Required disk space: 501 MB
# ==== 8.51.1. Installation of Python 3 ====
#<p>
#
#  Prepare Python for compilation: 
#</p>

#********<pre>***********
./configure --prefix=/usr        \
            --enable-shared      \
            --with-system-expat  \
            --enable-optimizations
#********</pre>**********
#<p>
#
#  The meaning of the configure options: 
#</p>

#--with-system-expat 
##<p>
#
#  This switch enables linking against the system version of Expat
#  . 
#</p>

#--enable-optimizations 
##<p>
#
#  This switch enables extensive, but time-consuming, optimization steps. The 
# interpreter is built twice; tests performed on the first build are used to 
# improve the optimized final version. 
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
#  Some tests are known to occasionally hang indefinitely. So to test the 
# results, run the test suite but set a 2-minute time limit for each test case: 
#</p>

#********<pre>***********
#make test TESTOPTS="--timeout 120"
#********</pre>**********
#<p>
#
#  For a relatively slow system you may need to increase the time limit and 1 SBU 
# (measured when building Binutils pass 1 with one CPU core) should be enough. 
# Some tests are flaky, so the test suite will automatically re-run failed tests. 
# If a test failed but then passed when re-run, it should be considered as 
# passed. One test, test_ssl, is known to fail in the chroot environment. 
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
#  We use the pip3
#  command to install Python 3 programs and modules for all users as root 
#  in several places in this book. This conflicts with the Python developers' 
# recommendation: to install packages into a virtual environment, or into the 
# home directory of a regular user (by running pip3
#  as this user). A multi-line warning is triggered whenever pip3
#  is issued by the root 
#  user. 
#</p>
#<p>
#
#  The main reason for the recommendation is to avoid conflicts with the system's 
# package manager ( dpkg
#  , for example). LFS does not have a system-wide package manager, so this is 
# not a problem. Also, pip3
#  will check for a new version of itself whenever it's run. Since domain name 
# resolution is not yet configured in the LFS chroot environment, pip3
#  cannot check for a new version of itself, and will produce a warning. 
#</p>
#<p>
#
#  After we boot the LFS system and set up a network connection, a different 
# warning will be issued, telling the user to update pip3
#  from a pre-built wheel on PyPI (whenever a new version is available). But LFS 
# considers pip3
#  to be a part of Python 3, so it should not be updated separately. Also, an 
# update from a pre-built wheel would deviate from our objective: to build a 
# Linux system from source code. So the warning about a new version of pip3
#  should be ignored as well. If you wish, you can suppress all these warnings by 
# running the following command, which creates a configuration file: 
#</p>

#********<pre>***********
cat > /etc/pip.conf << EOF
[global]
root-user-action = ignore
disable-pip-version-check = true
EOF

#********</pre>**********

# ====== Important ======
#<p>
#
#  In LFS and BLFS we normally build and install Python modules with the pip3
#  command. Please be sure that the pip3 install
#  commands in both books are run as the root 
#  user (unless it's for a Python virtual environment). Running pip3 install
#  as a non- root 
#  user may seem to work, but it will cause the installed module to be 
# inaccessible by other users. 
#</p>
#<p>
#pip3 install
#  will not reinstall an already installed module automatically. When using the pip3 install
#  command to upgrade a module (for example, from meson-0.61.3 to meson-0.62.0), 
# insert the option --upgrade 
#  into the command line. If it's really necessary to downgrade a module, or 
# reinstall the same version for some reason, insert --force-reinstall --no-deps 
#  into the command line. 
#</p>
#<p>
#
#  If desired, install the preformatted documentation: 
#</p>

#********<pre>***********
install -v -dm755 /usr/share/doc/python-3.13.3/html

tar --strip-components=1  \
    --no-same-owner       \
    --no-same-permissions \
    -C /usr/share/doc/python-3.13.3/html \
    -xvf ../python-3.13.3-docs-html.tar.bz2
#********</pre>**********
#<p>
#
#  The meaning of the documentation install commands: 
#</p>

#--no-same-owner and--no-same-permissions 
##<p>
#
#  Ensure the installed files have the correct ownership and permissions. Without 
# these options, tar
#  will install the package files with the upstream creator's values. 
#</p>

# ==== 8.51.2. Contents of Python 3 ====

#  Installed programs: 2to3, idle3, pip3, pydoc3, python3, and python3-config
#  Installed library: libpython3.13.so and libpython3.so
#  Installed directories: /usr/include/python3.13, /usr/lib/python3, and /usr/share/doc/python-3.13.3
# ====== Short Descriptions ======

#--------------------------------------------
# | 2to3                                     | is a                                    Python                                  program that reads                      Python 2.x                              source code and applies a series of fixes to transform it into validPython 3.x                              code                                    
# | idle3                                    | is a wrapper script that opens a        Python                                  aware GUI editor. For this script to run, you must have installedTk                                      before Python, so that the Tkinter Python module is built.
# | pip3                                     | The package installer for Python. You can use pip to install packages from Python Package Index and other indexes.
# | pydoc3                                   | is the                                  Python                                  documentation tool                      
# | python3                                  | is the interpreter for Python, an interpreted, interactive, object-oriented programming language
#--------------------------------------------
cd $topdir
rm -rf $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt
