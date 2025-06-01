#!/usr/bin/bash

# ===== 8.67. Kbd-2.7.1 =====
topdir=$(pwd)
err=0
set -e
chapter=8067
err_report() {
    echo "chapter $chapter: $(date +'%Y.%m.%d %H:%M:%S') Error $? on line $1" | tee >> $topdir/log.txt
}
trap 'err_report $LINENO' ERR
echo "---------" >> $topdir/log.txt
echo chapter $chapter: start = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt






srcdir=../../src/kbd-2.7.1
tar xf ../../src/kbd-2.7.1.tar.xz -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir

#<p>
#
#  The Kbd package contains key-table files, console fonts, and keyboard 
# utilities. 
#</p>

#  Approximate build time: 0.1 SBU
#  Required disk space: 34 MB
# ==== 8.67.1. Installation of Kbd ====
#<p>
#
#  The behavior of the backspace and delete keys is not consistent across the 
# keymaps in the Kbd package. The following patch fixes this issue for i386 
# keymaps: 
#</p>

#********<pre>***********
patch -Np1 -i ../kbd-2.7.1-backspace-1.patch
#********</pre>**********
#<p>
#
#  After patching, the backspace key generates the character with code 127, and 
# the delete key generates a well-known escape sequence. 
#</p>
#<p>
#
#  Remove the redundant resizecons
#  program (it requires the defunct svgalib to provide the video mode files - for 
# normal use setfont
#  sizes the console appropriately) together with its manpage. 
#</p>

#********<pre>***********
sed -i '/RESIZECONS_PROGS=/s/yes/no/' configure
sed -i 's/resizecons.8 //' docs/man/man8/Makefile.in
#********</pre>**********
#<p>
#
#  Prepare Kbd for compilation: 
#</p>

#********<pre>***********
./configure --prefix=/usr --disable-vlock
#********</pre>**********
#<p>
#
#  The meaning of the configure option: 
#</p>

#--disable-vlock 
##<p>
#
#  This option prevents the vlock utility from being built because it requires 
# the PAM library, which isn't available in the chroot environment. 
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
#  To test the results, issue: 
#</p>

#********<pre>***********
#make check
#********</pre>**********
#<p>
#
#  Install the package: 
#</p>

#********<pre>***********
make install
#********</pre>**********

# ====== Note ======
#<p>
#
#  For some languages (e.g., Belarusian) the Kbd package doesn't provide a useful 
# keymap where the stock “by”
#  keymap assumes the ISO-8859-5 encoding, and the CP1251 keymap is normally 
# used. Users of such languages have to download working keymaps separately. 
#</p>
#<p>
#
#  If desired, install the documentation: 
#</p>

#********<pre>***********
cp -R -v docs/doc -T /usr/share/doc/kbd-2.7.1
#********</pre>**********

# ==== 8.67.2. Contents of Kbd ====

#  Installed programs: chvt, deallocvt, dumpkeys, fgconsole, getkeycodes, kbdinfo, kbd_mode, kbdrate, loadkeys, loadunimap, mapscrn, openvt, psfaddtable (link to psfxtable), psfgettable (link to psfxtable), psfstriptable (link to psfxtable), psfxtable, setfont, setkeycodes, setleds, setmetamode, setvtrgb, showconsolefont, showkey, unicode_start, and unicode_stop
#  Installed directories: /usr/share/consolefonts, /usr/share/consoletrans, /usr/share/keymaps, /usr/share/doc/kbd-2.7.1, and /usr/share/unimaps
# ====== Short Descriptions ======

#--------------------------------------------
# | chvt                                     | Changes the foreground virtual terminal 
# | deallocvt                                | Deallocates unused virtual terminals    
# | dumpkeys                                 | Dumps the keyboard translation tables   
# | fgconsole                                | Prints the number of the active virtual terminal
# | getkeycodes                              | Prints the kernel scancode-to-keycode mapping table
# | kbdinfo                                  | Obtains information about the status of a console
# | kbd_mode                                 | Reports or sets the keyboard mode       
# | kbdrate                                  | Sets the keyboard repeat and delay rates
# | loadkeys                                 | Loads the keyboard translation tables   
# | loadunimap                               | Loads the kernel unicode-to-font mapping table
# | mapscrn                                  | An obsolete program that used to load a user-defined output character mapping table into the console driver; this is now done bysetfont                                 
# | openvt                                   | Starts a program on a new virtual terminal (VT)
# | psfaddtable                              | Adds a Unicode character table to a console font
# | psfgettable                              | Extracts the embedded Unicode character table from a console font
# | psfstriptable                            | Removes the embedded Unicode character table from a console font
# | psfxtable                                | Handles Unicode character tables for console fonts
# | setfont                                  | Changes the Enhanced Graphic Adapter (EGA) and Video Graphics Array (VGA) fonts on the console
# | setkeycodes                              | Loads kernel scancode-to-keycode mapping table entries; this is useful if there are unusual keys on the keyboard
# | setleds                                  | Sets the keyboard flags and Light Emitting Diodes (LEDs)
# | setmetamode                              | Defines the keyboard meta-key handling  
# | setvtrgb                                 | Sets the console color map in all virtual terminals
# | showconsolefont                          | Shows the current EGA/VGA console screen font
# | showkey                                  | Reports the scancodes, keycodes, and ASCII codes of the keys pressed on the keyboard
# | unicode_start                            | Puts the keyboard and console in UNICODE mode [Don't use this program unless your keymap file is in the ISO-8859-1 encoding. For other encodings, this utility produces incorrect results.]
# | unicode_stop                             | Reverts keyboard and console from UNICODE mode
#--------------------------------------------
cd $topdir
rm -rf $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt
