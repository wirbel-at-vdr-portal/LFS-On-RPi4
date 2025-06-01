#!/usr/bin/bash

# ===== 8.33. Gettext-0.25 =====
topdir=$(pwd)
err=0
set -e
chapter=8033
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



srcdir=../../src/gettext-0.25
tar xf ../../src/gettext-0.25.tar.xz -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir

#<p>
#
#  The Gettext package contains utilities for internationalization and 
# localization. These allow programs to be compiled with NLS (Native Language 
# Support), enabling them to output messages in the user's native language. 
#</p>

#  Approximate build time: 1.7 SBU
#  Required disk space: 290 MB
# ==== 8.33.1. Installation of Gettext ====
#<p>
#
#  Prepare Gettext for compilation: 
#</p>

#********<pre>***********
./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/gettext-0.25
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
chmod -v 0755 /usr/lib/preloadable_libintl.so
#********</pre>**********

# ==== 8.33.2. Contents of Gettext ====

#  Installed programs: autopoint, envsubst, gettext, gettext.sh, gettextize, msgattrib, msgcat, msgcmp, msgcomm, msgconv, msgen, msgexec, msgfilter, msgfmt, msggrep, msginit, msgmerge, msgunfmt, msguniq, ngettext, recode-sr-latin, and xgettext
#  Installed libraries: libasprintf.so, libgettextlib.so, libgettextpo.so, libgettextsrc.so, libtextstyle.so, and preloadable_libintl.so
#  Installed directories: /usr/lib/gettext, /usr/share/doc/gettext-0.25, /usr/share/gettext, and /usr/share/gettext-0.25
# ====== Short Descriptions ======

#--------------------------------------------
# | autopoint                                | Copies standard Gettext infrastructure files into a source package
# | envsubst                                 | Substitutes environment variables in shell format strings
# | gettext                                  | Translates a natural language message into the user's language by looking up the translation in a message catalog
# | gettext.sh                               | Primarily serves as a shell function library for gettext
# | gettextize                               | Copies all standard Gettext files into the given top-level directory of a package to begin internationalizing it
# | msgattrib                                | Filters the messages of a translation catalog according to their attributes and manipulates the attributes
# | msgcat                                   | Concatenates and merges the given       .po                                     files                                   
# | msgcmp                                   | Compares two                            .po                                     files to check that both contain the same set of msgid strings
# | msgcomm                                  | Finds the messages that are common to the given.po                                     files                                   
# | msgconv                                  | Converts a translation catalog to a different character encoding
# | msgen                                    | Creates an English translation catalog  
# | msgexec                                  | Applies a command to all translations of a translation catalog
# | msgfilter                                | Applies a filter to all translations of a translation catalog
# | msgfmt                                   | Generates a binary message catalog from a translation catalog
# | msggrep                                  | Extracts all messages of a translation catalog that match a given pattern or belong to some given source files
# | msginit                                  | Creates a new                           .po                                     file, initializing the meta information with values from the user's environment
# | msgmerge                                 | Combines two raw translations into a single file
# | msgunfmt                                 | Decompiles a binary message catalog into raw translation text
# | msguniq                                  | Unifies duplicate translations in a translation catalog
# | ngettext                                 | Displays native language translations of a textual message whose grammatical form depends on a number
# | recode-sr-latin                          | Recodes Serbian text from Cyrillic to Latin script
# | xgettext                                 | Extracts the translatable message lines from the given source files to make the first translation template
# | libasprintf                              | Defines the                             autosprintf                             class, which makes C formatted output routines usable in C++ programs, for use with the<string>                                strings and the                         <iostream>                              streams                                 
# | libgettextlib                            | Contains common routines used by the various Gettext programs; these are not intended for general use
# | libgettextpo                             | Used to write specialized programs that process.po                                     files; this library is used when the standard applications shipped with Gettext (such asmsgcomm                                 ,                                       msgcmp                                  ,                                       msgattrib                               , and                                   msgen                                   ) will not suffice                      
# | libgettextsrc                            | Provides common routines used by the various Gettext programs; these are not intended for general use
# | libtextstyle                             | Text styling library                    
# | preloadable_libintl                      | A library, intended to be used by LD_PRELOAD, that helpslibintl                                 log untranslated messages               
#--------------------------------------------
cd $topdir
rm -rf $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt
