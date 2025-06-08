topdir=$(pwd)
err=0
set -e
chapter=raspberrypi-linux
err_report() {
    echo "chapter $chapter: $(date +'%Y.%m.%d %H:%M:%S') Error $? on line $1" | tee >> $topdir/log.txt
}
trap 'err_report $LINENO' ERR
echo "---------" >> $topdir/log.txt
echo chapter $chapter: start = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt


srcdir=../../src
cd $srcdir



# we need a few debian remains in /usr/share/doc for 'rpi-source' to work.
mount /dev/sdb2 /mnt/sdcard
cp -r /mnt/sdcard/usr/share/doc/raspi-* /usr/share/doc/
cp -r /mnt/sdcard/usr/share/doc/raspberrypi-* /usr/share/doc/
umount /dev/sdb2


# now, use a script from rpi distro
git clone https://github.com/RPi-Distro/../fix kernel detection.diff.git
cd rpi-source



# the rpi-source script is broken, use a workaround from git:
cat > ../rpi-source_fix-kernel-detection.diff << "EOF"
--- a/rpi-source
+++ b/rpi-source
@@ -281,6 +281,9 @@ def debian_method(fn):

     # Find first firmware entry in log (latest entries are at the top)
     fw_rev = re.search(r'firmware as of ([0-9a-fA-F]+)', debian_changelog.decode('utf-8'))
+    if not fw_rev:
+        fw_rev = re.search(r'raspi-firmware \((?:[0-9.]+:)?([0-9.]+)', debian_changelog.decode('utf-8'))
+
     if not fw_rev:
         fail("Could not identify latest firmware revision")

@@ -398,11 +401,14 @@ if not args.skip_gcc:

 check_bc()

-debianlog = "/usr/share/doc/raspberrypi-bootloader/changelog.Debian.gz"
-if os.path.exists(firmware_revision_path):
-    kernel = rpi_update_method(args.uri)
-elif os.path.exists(debianlog):
+debianlog = "/usr/share/doc/raspi-firmware/changelog.Debian.gz"
+if not os.path.exists(debianlog):
+    debianlog = "/usr/share/doc/raspberrypi-bootloader/changelog.Debian.gz"
+
+if os.path.exists(debianlog):
     kernel = debian_method(debianlog)
+elif os.path.exists(firmware_revision_path):
+    kernel = rpi_update_method(args.uri)
 else:
     fail("Can't find a source for this kernel")
EOF

patch -Np1 -i ../rpi-source_fix-kernel-detection.diff


# the script uses sudo, but LFS root:
cat > ../rpi-source_remove-sudo.diff << "EOF"
--- a/rpi-source
+++ b/rpi-source
@@ -171,7 +171,7 @@ def do_update():
     # MOD: replace current script; do not assume script is located at /usr/bin/rpi-source; also keep ownership and permissions
     script_name = argv[0]
     info("Updating rpi-source")
-    sh("sudo wget %s https://raw.githubusercontent.com/RPi-Distro/rpi-source/master/rpi-source -O %s" % ("-q" if args.quiet else "", script_name))
+    sh("wget %s https://raw.githubusercontent.com/RPi-Distro/rpi-source/master/rpi-source -O %s" % ("-q" if args.quiet else "", script_name))
     update_tag()
     info("Restarting rpi-source")
     argv.insert(0, sys.executable)
@@ -212,7 +212,7 @@ def check_gcc():

 def proc_config_gz():
     if not os.path.exists('/proc/config.gz'):
-        sh("sudo modprobe configs 2> /dev/null")
+        sh("modprobe configs 2> /dev/null")

     if not os.path.exists('/proc/config.gz'):
         return ''
@@ -364,7 +364,7 @@ def get_page_size():

 def check_bc():
     if not os.path.exists('/usr/bin/bc'):
-        fail("bc is NOT installed. Needed by 'make modules_prepare'. On Raspberry Pi OS,\nrun 'sudo apt install bc' to install it.")
+        fail("bc is NOT installed. Needed by 'make modules_prepare'. On Raspberry Pi OS,\nrun 'apt install bc' to install it.")

 ##############################################################################

@@ -451,9 +451,9 @@ sh("rm -f %s" % linux_symlink)
 sh("ln -s %s %s" % (linux_dir, linux_symlink))

 info("Create /lib/modules/<ver>/{build,source} symlinks")
-sh("sudo rm -rf /lib/modules/$(uname -r)/build /lib/modules/$(uname -r)/source")
-sh("sudo ln -sf %s /lib/modules/$(uname -r)/build" % linux_symlink)
-sh("sudo ln -sf %s /lib/modules/$(uname -r)/source" % linux_symlink)
+sh("rm -rf /lib/modules/$(uname -r)/build /lib/modules/$(uname -r)/source")
+sh("ln -sf %s /lib/modules/$(uname -r)/build" % linux_symlink)
+sh("ln -sf %s /lib/modules/$(uname -r)/source" % linux_symlink)

 if args.default_config or not kernel.config:
     info(".config (generating default)")
@@ -491,7 +491,7 @@ if not args.nomake:
     sh("cd %s && make modules_prepare %s" % (linux_symlink, (" > /dev/null" if args.quiet else "")))

 if not os.path.exists('/usr/include/ncurses.h'):
-    info("ncurses-devel is NOT installed. Needed by 'make menuconfig'. On Raspberry Pi OS,\nrun 'sudo apt install libncurses5-dev' to install it.")
+    info("ncurses-devel is NOT installed. Needed by 'make menuconfig'. On Raspberry Pi OS,\nrun 'apt install libncurses5-dev' to install it.")

 if args.delete:
     info("Delete downloaded archive")
EOF

patch -Np1 -i ../rpi-source_remove-sudo.diff

cp ./rpi-source /usr/bin
cd ..

###########################################################################
# now, we use the script.
# first, we check what would be done:
rpi-source --dest ../../src --dry-run --skip-update --download-only

# 
#  *** SoC: BCM2711
# 
#  *** Arch: 64-bit
# 
#  *** Page Size: 4096
# 
#  *** Using: /usr/share/doc/raspi-firmware/changelog.Debian.gz
# 
#  *** Latest firmware revision: 1.20250430
# 
#  *** Linux source commit: 3dd2c2c507c271d411fab2e82a2b3b7e0b6d3f16
# 
#  *** Download kernel source
# 
#  *** Downloaded kernel source tarball: /usr/src/src/linux-3dd2c2c507c271d411fab2e82a2b3b7e0b6d3f16.tar.gz
# 
# 

# looks good, proceed:
rpi-source --dest ../../src --skip-update --download-only


mv linux-3dd2c2c507c271d411fab2e82a2b3b7e0b6d3f16.tar.gz /usr/src
cd /usr/src
tar xf linux-3dd2c2c507c271d411fab2e82a2b3b7e0b6d3f16.tar.gz
ln -s linux-3dd2c2c507c271d411fab2e82a2b3b7e0b6d3f16 linux
cd linux

# copy current .config
modprobe configs
cp /proc/config.gz .
rmmod configs
gzip -d config.gz
ln -s config .config

make prepare

make menuconfig

make -j4

make -j4 modules

make modules_install
















cd $topdir
rm -rfv $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt

