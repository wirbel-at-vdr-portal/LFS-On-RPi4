#!/usr/bin/bash

# ===== 8.73. Vim-9.1.1353 =====
topdir=$(pwd)
err=0
set -e
chapter=8073
err_report() {
    echo "chapter $chapter: $(date +'%Y.%m.%d %H:%M:%S') Error $? on line $1" | tee >> $topdir/log.txt
}
trap 'err_report $LINENO' ERR
echo "---------" >> $topdir/log.txt
echo chapter $chapter: start = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt






srcdir=../../src/vim-9.1.1353
tar xf ../../src/vim-9.1.1353.tar.gz -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir

#<p>
#
#  The Vim package contains a powerful text editor. 
#</p>

#  Approximate build time: 3.4 SBU
#  Required disk space: 251 MB
# ====== Alternatives to Vim ======
#<p>
#
#  If you prefer another editor—such as Emacs, Joe, or Nano—please refer to [https://www.linuxfromscratch.org/blfs/view/svn/postlfs/editors.html](https://www.linuxfromscratch.org/blfs/view/svn/postlfs/editors.html)
#  for suggested installation instructions. 
#</p>

# ==== 8.73.1. Installation of Vim ====
#<p>
#
#  First, change the default location of the vimrc 
#  configuration file to /etc 
#  : 
#</p>

#********<pre>***********
echo '#define SYS_VIMRC_FILE "/etc/vimrc"' >> src/feature.h
#********</pre>**********
#<p>
#
#  Prepare Vim for compilation: 
#</p>

#********<pre>***********
./configure --prefix=/usr
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
#  To prepare the tests, ensure that user tester 
#  can write to the source tree and exclude one file containing tests requiring curl
#  or wget
#  : 
#</p>

#********<pre>***********
chown -R tester .
sed '/test_plugin_glvs/d' -i src/testdir/Make_all.mak
#********</pre>**********
#<p>
#
#  Now run the tests as user tester 
#  : 
#</p>

#********<pre>***********
#su tester -c "TERM=xterm-256color LANG=en_US.UTF-8 make -j1 test" \
#   &> vim-test.log
#********</pre>**********
#<p>
#
#  The test suite outputs a lot of binary data to the screen. This can cause 
# issues with the settings of the current terminal (especially while we are 
# overriding the TERM 
#  variable to satisfy some assumptions of the test suite). The problem can be 
# avoided by redirecting the output to a log file as shown above. A successful 
# test will result in the words ALL DONE 
#  in the log file at completion. 
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
#  Many users reflexively type vi
#  instead of vim
#  . To allow execution of vim
#  when users habitually enter vi
#  , create a symlink for both the binary and the man page in the provided 
# languages: 
#</p>

#********<pre>***********
ln -sv vim /usr/bin/vi
for L in  /usr/share/man/{,*/}man1/vim.1; do
    ln -sv vim.1 $(dirname $L)/vi.1
done
#********</pre>**********
#<p>
#
#  By default, Vim's documentation is installed in /usr/share/vim 
#  . The following symlink allows the documentation to be accessed via /usr/share/doc/vim-9.1.1353 
#  , making it consistent with the location of documentation for other packages: 
#</p>

#********<pre>***********
ln -sv ../vim/vim91/doc /usr/share/doc/vim-9.1.1353
#********</pre>**********
#<p>
#
#  If an X Window System is going to be installed on the LFS system, it may be 
# necessary to recompile Vim after installing X. Vim comes with a GUI version of 
# the editor that requires X and some additional libraries to be installed. For 
# more information on this process, refer to the Vim documentation and the Vim 
# installation page in the BLFS book at [https://www.linuxfromscratch.org/blfs/view/svn/postlfs/vim.html](https://www.linuxfromscratch.org/blfs/view/svn/postlfs/vim.html)
#  . 
#</p>

# ==== 8.73.2. Configuring Vim ====
#<p>
#
#  By default, vim
#  runs in vi-incompatible mode. This may be new to users who have used other 
# editors in the past. The “nocompatible”
#  setting is included below to highlight the fact that a new behavior is being 
# used. It also reminds those who would change to “compatible”
#  mode that it should be the first setting in the configuration file. This is 
# necessary because it changes other settings, and overrides must come after this 
# setting. Create a default vim
#  configuration file by running the following: 
#</p>

#********<pre>***********
cat > /etc/vimrc << "EOF"
" Begin /etc/vimrc

" Ensure defaults are set before customizing settings, not after
source $VIMRUNTIME/defaults.vim
let skip_defaults_vim=1

set nocompatible
set backspace=2
set mouse=
syntax on
if (&term == "xterm") || (&term == "putty")
  set background=dark
endif

" End /etc/vimrc
EOF
#********</pre>**********
#<p>
#
#  The set nocompatible 
#  setting makes vim
#  behave in a more useful way (the default) than the vi-compatible manner. 
# Remove the “no”
#  to keep the old vi
#  behavior. The set backspace=2 
#  setting allows backspacing over line breaks, autoindents, and the start of an 
# insert. The syntax on 
#  parameter enables vim's syntax highlighting. The set mouse= 
#  setting enables proper pasting of text with the mouse when working in chroot 
# or over a remote connection. Finally, the if
#  statement with the set background=dark 
#  setting corrects vim
#  's guess about the background color of some terminal emulators. This gives the 
# highlighting a better color scheme for use on the black background of these 
# programs. 
#</p>
#<p>
#
#  Documentation for other available options can be obtained by running the 
# following command: 
#</p>

#********<pre>***********
vim -c ':options'
#********</pre>**********

# ====== Note ======
#<p>
#
#  By default, vim only installs spell-checking files for the English language. 
# To install spell-checking files for your preferred language, copy the .spl 
#  and optionally, the .sug 
#  files for your language and character encoding from runtime/spell 
#  into /usr/share/vim/vim91/spell/ 
#  . 
#</p>
#<p>
#
#  To use these spell-checking files, some configuration in /etc/vimrc 
#  is needed, e.g.: 
#</p>

#********<pre>***********
#set spelllang=en,ru
#set spell
#********</pre>**********
#<p>
#
#  For more information, see runtime/spell/README.txt 
#  . 
#</p>

# ==== 8.73.3. Contents of Vim ====

#  Installed programs: ex (link to vim), rview (link to vim), rvim (link to vim), vi (link to vim), view (link to vim), vim, vimdiff (link to vim), vimtutor, and xxd
#  Installed directory: /usr/share/vim
# ====== Short Descriptions ======

#--------------------------------------------
# | ex                                       | Starts                                  vim                                     in ex mode                              
# | rview                                    | Is a restricted version of              view                                    ; no shell commands can be started and  view                                    cannot be suspended                     
# | rvim                                     | Is a restricted version of              vim                                     ; no shell commands can be started and  vim                                     cannot be suspended                     
# | vi                                       | Link to                                 vim                                     
# | view                                     | Starts                                  vim                                     in read-only mode                       
# | vim                                      | Is the editor                           
# | vimdiff                                  | Edits two or three versions of a file withvim                                     and shows differences                   
# | vimtutor                                 | Teaches the basic keys and commands of  vim                                     
# | xxd                                      | Creates a hex dump of the given file; it can also perform the inverse operation, so it can be used for binary patching
#--------------------------------------------
cd $topdir
rm -rf $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt
