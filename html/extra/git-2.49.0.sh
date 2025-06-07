topdir=$(pwd)
err=0
set -e
chapter=git-2.49.0
err_report() {
    echo "chapter $chapter: $(date +'%Y.%m.%d %H:%M:%S') Error $? on line $1" | tee >> $topdir/log.txt
}
trap 'err_report $LINENO' ERR
echo "---------" >> $topdir/log.txt
echo chapter $chapter: start = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt




srcdir=../../src/git-2.49.0
tar xf ../../src/git-2.49.0.tar.xz -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir








# Introduction to Git
# 
# Git is a free and open source, distributed version control system designed to handle everything from small to very large projects with speed and efficiency. Every Git clone is a full-fledged repository with complete history and full revision tracking capabilities, not dependent on network access or a central server. Branching and merging are fast and easy to do. Git is used for version control of files, much like tools such as mercurial-7.0.1, Bazaar, Subversion-1.14.5, CVS, Perforce, and Team Foundation Server.
# [Note] Note
# 
# Development versions of BLFS may not build or run some packages properly if LFS or dependencies have been updated since the most recent stable versions of the books.
# Package Information
# 
#     Download (HTTP): https://www.kernel.org/pub/software/scm/git/git-2.49.0.tar.xz
# 
#     Download MD5 sum: 7e607007a44de52cccda06040fe9362c
# 
#     Download size: 7.4 MB
# 
#     Estimated disk space required: 541 MB (with downloaded documentation; add 19 MB for building docs; add 21 MB for tests)
# 
#     Estimated build time: 0.3 SBU (with parallelism=4; add 1.0 SBU for building docs, and up to 7 SBU (disk speed dependent) for tests)
# 
# Additional Downloads
# 
#     https://www.kernel.org/pub/software/scm/git/git-manpages-2.49.0.tar.xz (not needed if you've installed asciidoc-10.2.1, xmlto-0.0.29, and prefer to rebuild them)
# 
#     https://www.kernel.org/pub/software/scm/git/git-htmldocs-2.49.0.tar.xz and other docs (not needed if you've installed asciidoc-10.2.1 and want to rebuild the documentation).
# 
# Git Dependencies
# Recommended
# 
# cURL-8.14.0 (needed to use Git over http, https, ftp or ftps)
# Optional
# 
# Apache-2.4.63 (for some tests), Fcron-3.4.0 (runtime, for scheduling git maintenance jobs), GnuPG-2.4.8 (runtime, may be used to sign Git commits or tags, or verify the signatures of them), OpenSSH-10.0p1 (runtime, needed to use Git over ssh), pcre2-10.45, Subversion-1.14.5 with Perl bindings (runtime, for git svn), Tk-8.6.16 (gitk, a simple Git repository viewer, uses Tk at runtime), Valgrind-3.25.1, Authen::SASL (runtime, for git send-email), and IO-Socket-SSL-2.089 (runtime, for git send-email to connect to a SMTP server with SSL encryption)
# Optional (to create the man pages, html docs and other docs)
# 
# xmlto-0.0.29 and asciidoc-10.2.1, and also dblatex (for the PDF version of the user manual), and docbook2x to create info pages
# Installation of Git
# 
# Install Git by running the following commands:

./configure --prefix=/usr \
            --with-gitconfig=/etc/gitconfig \
            --with-python=python3 &&
make -j8

# You can build the man pages and/or html docs, or use downloaded ones. If you choose to build them, use the next two instructions.
# 
# If you have installed asciidoc-10.2.1 you can create the html version of the man pages and other docs:
# 
# make html
# 
# If you have installed asciidoc-10.2.1 and xmlto-0.0.29 you can create the man pages:
# 
# make man
# 
# The test suite can be run in parallel mode. To run the test suite, issue: GIT_UNZIP=nonexist make test -k |& tee test.log. The GIT_UNZIP setting prevents the test suite from using unzip, we need it because in BLFS unzip is a symlink to bsdunzip which does not satisfy the assumption of some tests cases. If any test case fails, the list of failed tests can be shown via grep '^not ok' test.log | grep -v TODO.
# 
# Now, as the root user:

make perllibdir=/usr/lib/perl5/5.40/site_perl install

# If you created the man pages and/or html docs
# 
# Install the man pages as the root user:
# 
# make install-man
# 
# Install the html docs as the root user:
# 
# make htmldir=/usr/share/doc/git-2.49.0 install-html
# 
# If you downloaded the man pages and/or html docs
# 
# If you downloaded the man pages untar them as the root user:
# 
# tar -xf ../git-manpages-2.49.0.tar.xz \
#     -C /usr/share/man --no-same-owner --no-overwrite-dir
# 
# If you downloaded the html docs untar them as the root user:
# 
# mkdir -vp   /usr/share/doc/git-2.49.0 &&
# tar   -xf   ../git-htmldocs-2.49.0.tar.xz \
#       -C    /usr/share/doc/git-2.49.0 --no-same-owner --no-overwrite-dir &&
# 
# find        /usr/share/doc/git-2.49.0 -type d -exec chmod 755 {} \; &&
# find        /usr/share/doc/git-2.49.0 -type f -exec chmod 644 {} \;
# 
# Reorganize text and html in the html-docs (both methods)
# 
# For both methods, the html-docs include a lot of plain text files. Reorganize the files as the root user:
# 
# mkdir -vp /usr/share/doc/git-2.49.0/man-pages/{html,text}         &&
# mv        /usr/share/doc/git-2.49.0/{git*.adoc,man-pages/text}     &&
# mv        /usr/share/doc/git-2.49.0/{git*.,index.,man-pages/}html &&
# 
# mkdir -vp /usr/share/doc/git-2.49.0/technical/{html,text}         &&
# mv        /usr/share/doc/git-2.49.0/technical/{*.adoc,text}        &&
# mv        /usr/share/doc/git-2.49.0/technical/{*.,}html           &&
# 
# mkdir -vp /usr/share/doc/git-2.49.0/howto/{html,text}             &&
# mv        /usr/share/doc/git-2.49.0/howto/{*.adoc,text}            &&
# mv        /usr/share/doc/git-2.49.0/howto/{*.,}html               &&
# 
# sed -i '/^<a href=/s|howto/|&html/|' /usr/share/doc/git-2.49.0/howto-index.html &&
# sed -i '/^\* link:/s|howto/|&html/|' /usr/share/doc/git-2.49.0/howto-index.adoc
# 
# Command Explanations
# 
# --with-gitconfig=/etc/gitconfig: This sets /etc/gitconfig as the file that stores the default, system wide, Git settings.
# 
# --with-python=python3: Use this switch to use Python 3, instead of the EOL'ed Python 2. Python is used for the git p4 interface to Perforce repositories, and also used in some tests.
# 
# --with-libpcre2: Use this switch if PCRE2 is installed.
# 
# tar -xf ../git-manpages-2.49.0.tar.gz -C /usr/share/man --no-same-owner: This untars git-manpages-2.49.0.tar.gz. The -C option makes tar change directory to /usr/share/man before it starts to decompress the docs. The --no-same-owner option stops tar from preserving the user and group details of the files. This is useful as that user or group may not exist on your system; this could (potentially) be a security risk.
# 
# mv /usr/share/doc/git-2.49.0 ...: These commands move some of the files into subfolders to make it easier to sort through the docs and find what you're looking for.
# 
# find ... chmod ...: These commands correct the permissions in the shipped documentation tar file.
# Configuring Git
# Config Files
# 
# ~/.gitconfig and /etc/gitconfig
# Contents
# Installed Programs:
# git, git-receive-pack, git-upload-archive, and git-upload-pack (hardlinked to each other), git-cvsserver, git-shell, gitk, and scalar
# Installed Libraries:
# None
# Installed Directories:
# /usr/libexec/git-core, /usr/lib/perl5/5.40/site_perl/Git, and /usr/share/{doc/git-2.49.0,git-core,git-gui,gitk,gitweb}
# Short Descriptions
# 
# git
# 	
# 
# is the stupid content tracker
# 
# git-cvsserver
# 	
# 
# is a CVS server emulator for Git
# 
# gitk
# 	
# 
# is a graphical Git repository browser (needs Tk-8.6.16)
# 
# git-receive-pack
# 	
# 
# is invoked by git send-pack and updates the repository with the information fed from the remote end
# 
# git-shell
# 	
# 
# is a login shell for SSH accounts to provide restricted Git access
# 
# git-upload-archive
# 	
# 
# is invoked by git archive --remote and sends a generated archive to the other end over the git protocol
# 
# git-upload-pack
# 	
# 
# is invoked by git fetch-pack, it discovers what objects the other side is missing, and sends them after packing
# 
# scalar
# 	
# 
# is a repository management tool that optimizes Git for use in large repositories 









cd $topdir
rm -rf $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt

