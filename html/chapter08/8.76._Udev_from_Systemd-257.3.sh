#!/usr/bin/bash

# ===== 8.76. Udev from Systemd-257.3 =====
topdir=$(pwd)
err=0
set -e
chapter=8076
err_report() {
    echo "chapter $chapter: $(date +'%Y.%m.%d %H:%M:%S') Error $? on line $1" | tee >> $topdir/log.txt
}
trap 'err_report $LINENO' ERR
echo "---------" >> $topdir/log.txt
echo chapter $chapter: start = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt






srcdir=../../src/systemd-257.3
tar xf ../../src/systemd-257.3.tar.gz -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir

#<p>
#
#  The Udev package contains programs for dynamic creation of device nodes. 
#</p>

#  Approximate build time: 0.3 SBU
#  Required disk space: 161 MB
# ==== 8.76.1. Installation of Udev ====
#<p>
#
#  Udev is part of the systemd-257.3 package. Use the systemd-257.3.tar.xz file 
# as the source tarball. 
#</p>
#<p>
#
#  Remove two unneeded groups, render 
#  and sgx 
#  , from the default udev rules: 
#</p>

#********<pre>***********
sed -e 's/GROUP="render"/GROUP="video"/' \
    -e 's/GROUP="sgx", //'               \
    -i rules.d/50-udev-default.rules.in
#********</pre>**********
#<p>
#
#  Remove one udev rule requiring a full Systemd installation: 
#</p>

#********<pre>***********
sed -i '/systemd-sysctl/s/^/#/' rules.d/99-systemd.rules.in
#********</pre>**********
#<p>
#
#  Adjust the hardcoded paths to network configuration files for the standalone 
# udev installation: 
#</p>

#********<pre>***********
sed -e '/NETWORK_DIRS/s/systemd/udev/' \
    -i src/libsystemd/sd-network/network-util.h
#********</pre>**********
#<p>
#
#  Prepare Udev for compilation: 
#</p>

#********<pre>***********
mkdir -p build
cd       build

meson setup ..                  \
      --prefix=/usr             \
      --buildtype=release       \
      -D mode=release           \
      -D dev-kvm-mode=0660      \
      -D link-udev-shared=false \
      -D logind=false           \
      -D vconsole=false
#********</pre>**********
#<p>
#
#  The meaning of the meson options: 
#</p>

#--buildtype=release 
##<p>
#
#  This switch overrides the default buildtype ( “debug”
#  ), which produces unoptimized binaries. 
#</p>

#-D mode=release 
##<p>
#
#  Disable some features considered experimental by upstream. 
#</p>

#-D dev-kvm-mode=0660 
##<p>
#
#  The default udev rule would allow all users to access /dev/kvm 
#  . The editors consider it dangerous. This option overrides it. 
#</p>

#-D link-udev-shared=false 
##<p>
#
#  This option prevents udev from linking to the internal systemd shared library, libsystemd-shared 
#  . This library is designed to be shared by many Systemd components and it's 
# too overkill for a udev-only installation. 
#</p>

#-D logind=false -D vconsole=false 
##<p>
#
#  These options prevent the generation of several udev rule files belonging to 
# the other Systemd components that we won't install. 
#</p>
#<p>
#
#  Get the list of the shipped udev helpers and save it into an environment 
# variable (exporting it is not strictly necessary, but it makes building as a 
# regular user or using a package manager easier): 
#</p>

#********<pre>***********
export udev_helpers=$(grep "'name' :" ../src/udev/meson.build | \
                      awk '{print $3}' | tr -d ",'" | grep -v 'udevadm')
#********</pre>**********
#<p>
#
#  Only build the components needed for udev: 
#</p>

#********<pre>***********
ninja udevadm systemd-hwdb                                           \
      $(ninja -n | grep -Eo '(src/(lib)?udev|rules.d|hwdb.d)/[^ ]*') \
      $(realpath libudev.so --relative-to .)                         \
      $udev_helpers
#********</pre>**********
#<p>
#
#  Install the package: 
#</p>

#********<pre>***********
install -vm755 -d {/usr/lib,/etc}/udev/{hwdb.d,rules.d,network}
install -vm755 -d /usr/{lib,share}/pkgconfig
install -vm755 udevadm                             /usr/bin/
install -vm755 systemd-hwdb                        /usr/bin/udev-hwdb
ln      -svfn  ../bin/udevadm                      /usr/sbin/udevd
cp      -av    libudev.so{,*[0-9]}                 /usr/lib/
install -vm644 ../src/libudev/libudev.h            /usr/include/
install -vm644 src/libudev/*.pc                    /usr/lib/pkgconfig/
install -vm644 src/udev/*.pc                       /usr/share/pkgconfig/
install -vm644 ../src/udev/udev.conf               /etc/udev/
install -vm644 rules.d/* ../rules.d/README         /usr/lib/udev/rules.d/
install -vm644 $(find ../rules.d/*.rules \
                      -not -name '*power-switch*') /usr/lib/udev/rules.d/
install -vm644 hwdb.d/*  ../hwdb.d/{*.hwdb,README} /usr/lib/udev/hwdb.d/
install -vm755 $udev_helpers                       /usr/lib/udev
install -vm644 ../network/99-default.link          /usr/lib/udev/network
#********</pre>**********
#<p>
#
#  Install some custom rules and support files useful in an LFS environment: 
#</p>

#********<pre>***********
tar -xvf ../../udev-lfs-20230818.tar.xz
make -f udev-lfs-20230818/Makefile.lfs install
#********</pre>**********
#<p>
#
#  Install the man pages: 
#</p>

#********<pre>***********
tar -xf ../../systemd-man-pages-257.3.tar.xz                            \
    --no-same-owner --strip-components=1                              \
    -C /usr/share/man --wildcards '*/udev*' '*/libudev*'              \
                                  '*/systemd.link.5'                  \
                                  '*/systemd-'{hwdb,udevd.service}.8

sed 's|systemd/network|udev/network|'                                 \
    /usr/share/man/man5/systemd.link.5                                \
  > /usr/share/man/man5/udev.link.5

sed 's/systemd\(\\\?-\)/udev\1/' /usr/share/man/man8/systemd-hwdb.8   \
                               > /usr/share/man/man8/udev-hwdb.8

sed 's|lib.*udevd|sbin/udevd|'                                        \
    /usr/share/man/man8/systemd-udevd.service.8                       \
  > /usr/share/man/man8/udevd.8

rm /usr/share/man/man*/systemd*
#********</pre>**********
#<p>
#
#  Finally, unset the udev_helpers 
#  variable: 
#</p>

#********<pre>***********
unset udev_helpers
#********</pre>**********

# ==== 8.76.2. Configuring Udev ====
#<p>
#
#  Information about hardware devices is maintained in the /etc/udev/hwdb.d 
#  and /usr/lib/udev/hwdb.d 
#  directories. Udev
#  needs that information to be compiled into a binary database /etc/udev/hwdb.bin 
#  . Create the initial database: 
#</p>

#********<pre>***********
udev-hwdb update
#********</pre>**********
#<p>
#
#  This command needs to be run each time the hardware information is updated. 
#</p>

# ==== 8.76.3. Contents of Udev ====

#  Installed programs: udevadm, udevd (symlink to udevadm), and udev-hwdb
#  Installed libraries: libudev.so
#  Installed directories: /etc/udev and /usr/lib/udev
# ====== Short Descriptions ======

#--------------------------------------------
# | udevadm                                  | Generic udev administration tool: controls the udevd daemon, provides info from the Udev database, monitors uevents, waits for uevents to finish, tests Udev configuration, and triggers uevents for a given device
# | udevd                                    | A daemon that listens for uevents on the netlink socket, creates devices and runs the configured external programs in response to these uevents
# | udev-hwdb                                | Updates or queries the hardware database.
# | libudev                                  | A library interface to udev device information
# | /etc/udev                                | Contains Udev configuration files, device permissions, and rules for device naming
#--------------------------------------------
cd $topdir
rm -rf $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt
