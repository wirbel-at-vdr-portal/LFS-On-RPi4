topdir=$(pwd)
err=0
set -e
chapter=fuse-3.17.2
err_report() {
    echo "chapter $chapter: $(date +'%Y.%m.%d %H:%M:%S') Error $? on line $1" | tee >> $topdir/log.txt
}
trap 'err_report $LINENO' ERR
echo "---------" >> $topdir/log.txt
echo chapter $chapter: start = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt




srcdir=../../src/fuse-3.17.2
tar xf ../../src/fuse-3.17.2.tar.gz -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir







# Introduction to Fuse
# 
# FUSE (Filesystem in Userspace) is a simple interface for userspace programs to export a virtual filesystem to the Linux kernel. Fuse also aims to provide a secure method for non privileged users to create and mount their own filesystem implementations.
# [Note] Note
# 
# Development versions of BLFS may not build or run some packages properly if LFS or dependencies have been updated since the most recent stable versions of the books.
# Package Information
# 
#     Download (HTTP): https://github.com/libfuse/libfuse/releases/download/fuse-3.17.2/fuse-3.17.2.tar.gz
# 
#     Download MD5 sum: 55c21312d50b20190807bf053a08c558
# 
#     Download size: 5.3 MB
# 
#     Estimated disk space required: 73 MB (with tests and documentation)
# 
#     Estimated build time: 0.2 SBU (add 0.3 SBU for tests)
# 
# Fuse Dependencies
# Optional
# 
# Doxygen-1.14.0 (to rebuild the API documentation), pytest-8.3.5 (required for tests), and looseversion (for tests)
# Kernel Configuration
# 
# Enable the following options in the kernel configuration and recompile the kernel if necessary:
# 
# File systems --->
#   <*/M> FUSE (Filesystem in Userspace) support                         [FUSE_FS]
# 
# Character devices in userspace should be enabled too for running the tests:
# 
# File systems --->
#   <*/M> FUSE (Filesystem in Userspace) support                         [FUSE_FS]
#   <*/M>   Character device in Userspace support                           [CUSE]
# 
# Installation of Fuse
# 
# Install Fuse by running the following commands:
# 
# sed -i '/^udev/,$ s/^/#/' util/meson.build &&
# 
mkdir build &&
cd    build &&
# 
meson setup --prefix=/usr --buildtype=release .. &&
ninja
# 
# The API documentation is included in the package, but if you have Doxygen-1.14.0 installed and wish to rebuild it, issue:
# 
# pushd .. &&
#   doxygen doc/Doxyfile &&
# popd
# 
# To test the results, issue the following commands (as the root user):
# 
# python3 -m venv --system-site-packages testenv &&
# source testenv/bin/activate                    &&
# pip3 install looseversion                      &&
# python3 -m pytest
# deactivate
# 
# The pytest-8.3.5 Python module is required for the tests. One test named test_cuse will fail if the CONFIG_CUSE configuration item was not enabled when the kernel was built. One test, test/util.py, will output a warning due to the usage of an unknown mark in pytest.
# 
# Now, as the root user:
# 
ninja install                  &&
chmod u+s /usr/bin/fusermount3
#
#cd ..                          &&
#cp -Rv doc/html -T /usr/share/doc/fuse-3.17.2 &&
# install -v -m644   doc/{README.NFS,kernel.txt} \
#                    /usr/share/doc/fuse-3.17.2
# 
# Command Explanations
# 
# sed ... util/meson.build: This command disables the installation of a boot script and udev rule that are not needed.
# 
# --buildtype=release: Specify a buildtype suitable for stable releases of the package, as the default may produce unoptimized binaries.
# 
# --system-site-packages: Allow the Python3 venv module to access the system-installed /usr/lib/python3.13/site-packages directory.
# Configuring fuse
# Config Files
# 
# Some options regarding mount policy can be set in the file /etc/fuse.conf. To install the file run the following command as the root user:

cat > /etc/fuse.conf << "EOF"
# Set the maximum number of FUSE mounts allowed to non-root users.
# The default is 1000.
#
#mount_max = 1000

# Allow non-root users to specify the 'allow_other' or 'allow_root'
# mount options.
#
#user_allow_other
EOF

# Additional information about the meaning of the configuration options are found in the man page.
# Contents
# Installed Programs:
# fusermount3 and mount.fuse3
# Installed Libraries:
# libfuse3.so
# Installed Directory:
# /usr/include/fuse3 and /usr/share/doc/fuse-3.17.2
# Short Descriptions
# 
# fusermount3
# 	
# 
# is a suid root program to mount and unmount Fuse filesystems
# 
# mount.fuse3
# 	
# 
# is the command mount calls to mount a Fuse filesystem
# 
# libfuse3.so
# 	
# 
# contains the FUSE API functions 






cd $topdir
rm -rfv $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt

