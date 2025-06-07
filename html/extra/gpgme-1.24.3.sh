topdir=$(pwd)
err=0
set -e
chapter=gpgme-1.24.3
err_report() {
    echo "chapter $chapter: $(date +'%Y.%m.%d %H:%M:%S') Error $? on line $1" | tee >> $topdir/log.txt
}
trap 'err_report $LINENO' ERR
echo "---------" >> $topdir/log.txt
echo chapter $chapter: start = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt




srcdir=../../src/gpgme-1.24.3
tar xf ../../src/gpgme-1.24.3.tar.bz2 -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir









# Introduction to GPGME
# 
# The GPGME package is a C library that allows cryptography support to be added to a program. It is designed to make access to public key crypto engines like GnuPG or GpgSM easier for applications. GPGME provides a high-level crypto API for encryption, decryption, signing, signature verification and key management.
# [Note] Note
# 
# Development versions of BLFS may not build or run some packages properly if LFS or dependencies have been updated since the most recent stable versions of the books.
# Package Information
# 
#     Download (HTTP): https://www.gnupg.org/ftp/gcrypt/gpgme/gpgme-1.24.3.tar.bz2
# 
#     Download MD5 sum: c6f85ce24ad46c9469596df0301f32eb
# 
#     Download size: 1.8 MB
# 
#     Estimated disk space required: 352 MB (with tests)
# 
#     Estimated build time: 1.3 SBU (with all bindings and tests; with parallelism=4)
# 
# GPGME Dependencies
# Required
# 
# libassuan-3.0.2
# Optional
# 
# Doxygen-1.14.0 and Graphviz-12.2.1 (for API documentation), GnuPG-2.4.8 (required if Qt or SWIG are installed; used during the test suite), Clisp-2.49, Qt-6.9.0, and SWIG-4.3.1 (for language bindings)
# Installation of GPGME
# 
# Install GPGME by running the following commands:
# 
mkdir build &&
cd    build &&
# 
../configure --prefix=/usr --disable-gpg-test &&
make PYTHONS=
# 
# If SWIG-4.3.1 is installed, build the Python 3 binding as a wheel:
# 
# if swig -version > /dev/null; then
#   srcdir=$PWD/../lang/python \
#   top_builddir=$PWD          \
#   pip3 wheel -w dist --no-build-isolation --no-deps --no-cache-dir $PWD/lang/python
# fi
# 
# To test the results, you should have GnuPG-2.4.8 installed and remove the --disable-gpg-test above. Issue:
# 
# if swig -version > /dev/null; then
#   python3 -m venv testenv                                              &&
#   testenv/bin/pip3 install --no-index --find-links=dist --no-cache-dir \
#                            gpg                                         &&
#   sed '/PYTHON/s#run-tests.py#& --python-libdir=/dev/null#'            \
#       -i lang/python/tests/Makefile
# fi &&
# 
# make -k check PYTHONS= PYTHON=$PWD/testenv/bin/python3
# 
# Now, as the root user:
# 
make install PYTHONS=
# 
# If SWIG-4.3.1 is installed, still as the root user, install the Python 3 binding:
# 
# if swig -version > /dev/null; then
#   pip3 install --no-index --find-links dist --no-user gpg
# fi
# 
# Command Explanations
# 
# --disable-gpg-test: if this parameter is not passed to configure, the test programs are built during make stage, which requires GnuPG-2.4.8. This parameter is not needed if GnuPG-2.4.8 is installed.
# 
# PYTHONS=: Disable building Python binding using the deprecated python3 setup.py build command. The explicit instruction to build the Python 3 binding with the pip3 wheel command is provided.
# Contents
# Installed Program:
# gpgme-json, and gpgme-tool
# Installed Libraries:
# libgpgme.so, libgpgmepp.so, and libqgpgme.so
# Installed Directory:
# /usr/include/{gpgme++,qgpgme,QGpgME}, /usr/lib/cmake/{Gpgmepp,QGpgme}. /usr/lib/python3.13/site-packages/gpg{,-1.24.3.dist-info}, and /usr/share/common-lisp/source/gpgme
# Short Descriptions
# 
# gpgme-json
# 	
# 
# outputs GPGME commands in JSON format
# 
# gpgme-tool
# 	
# 
# is an assuan server exposing GPGME operations, such as printing fingerprints and keyids with keyservers
# 
# libgpgme.so
# 	
# 
# contains the GPGME API functions
# 
# libgpgmepp.so
# 	
# 
# contains the C++ GPGME API functions
# 
# libqgpgme.so
# 	
# 
# contains API functions for handling GPG operations in Qt applications 





cd $topdir
rm -rf $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt

