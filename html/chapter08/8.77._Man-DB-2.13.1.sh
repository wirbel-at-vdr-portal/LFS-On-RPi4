#!/usr/bin/bash

# ===== 8.77. Man-DB-2.13.1 =====
topdir=$(pwd)
err=0
set -e
chapter=8077
err_report() {
    echo "chapter $chapter: $(date +'%Y.%m.%d %H:%M:%S') Error $? on line $1" | tee >> $topdir/log.txt
}
trap 'err_report $LINENO' ERR
echo "---------" >> $topdir/log.txt
echo chapter $chapter: start = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt






srcdir=../../src/man-db-2.13.1
tar xf ../../src/man-db-2.13.1.tar.xz -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir

#<p>
#
#  The Man-DB package contains programs for finding and viewing man pages. 
#</p>

#  Approximate build time: 0.3 SBU
#  Required disk space: 44 MB
# ==== 8.77.1. Installation of Man-DB ====
#<p>
#
#  Prepare Man-DB for compilation: 
#</p>

#********<pre>***********
./configure --prefix=/usr                         \
            --docdir=/usr/share/doc/man-db-2.13.1 \
            --sysconfdir=/etc                     \
            --disable-setuid                      \
            --enable-cache-owner=bin              \
            --with-browser=/usr/bin/lynx          \
            --with-vgrind=/usr/bin/vgrind         \
            --with-grap=/usr/bin/grap             \
            --with-systemdtmpfilesdir=            \
            --with-systemdsystemunitdir=
#********</pre>**********
#<p>
#
#  The meaning of the configure options: 
#</p>

#--disable-setuid 
##<p>
#
#  This disables making the man
#  program setuid to user man 
#  . 
#</p>

#--enable-cache-owner=bin 
##<p>
#
#  This changes ownership of the system-wide cache files to user bin 
#  . 
#</p>

#--with-... 
##<p>
#
#  These three parameters are used to set some default programs. lynx
#  is a text-based web browser (see BLFS for installation instructions), vgrind
#  converts program sources to Groff input, and grap
#  is useful for typesetting graphs in Groff documents. The vgrind
#  and grap
#  programs are not normally needed for viewing manual pages. They are not part 
# of LFS or BLFS, but you should be able to install them yourself after finishing 
# LFS if you wish to do so. 
#</p>

#--with-systemd... 
##<p>
#
#  These parameters prevent installing unneeded systemd directories and files. 
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

# ==== 8.77.2. Non-English Manual Pages in LFS ====
#<p>
#
#  The following table shows the character set that Man-DB assumes manual pages 
# installed under /usr/share/man/<ll> 
#  will be encoded with. In addition to this, Man-DB correctly determines if 
# manual pages installed in that directory are UTF-8 encoded. 
#</p>
#<p>
#
#  Table 8.1. Expected character encoding of legacy 8-bit manual pages 
#</p>

#--------------------------------------------
# | Language (code)                          | Encoding                                 | Language (code)                          | Encoding                                
#--------------------------------------------
# | Danish (da)                              | ISO-8859-1                               | Croatian (hr)                            | ISO-8859-2                              
# | German (de)                              | ISO-8859-1                               | Hungarian (hu)                           | ISO-8859-2                              
# | English (en)                             | ISO-8859-1                               | Japanese (ja)                            | EUC-JP                                  
# | Spanish (es)                             | ISO-8859-1                               | Korean (ko)                              | EUC-KR                                  
# | Estonian (et)                            | ISO-8859-1                               | Lithuanian (lt)                          | ISO-8859-13                             
# | Finnish (fi)                             | ISO-8859-1                               | Latvian (lv)                             | ISO-8859-13                             
# | French (fr)                              | ISO-8859-1                               | Macedonian (mk)                          | ISO-8859-5                              
# | Irish (ga)                               | ISO-8859-1                               | Polish (pl)                              | ISO-8859-2                              
# | Galician (gl)                            | ISO-8859-1                               | Romanian (ro)                            | ISO-8859-2                              
# | Indonesian (id)                          | ISO-8859-1                               | Greek (el)                               | ISO-8859-7                              
# | Icelandic (is)                           | ISO-8859-1                               | Slovak (sk)                              | ISO-8859-2                              
# | Italian (it)                             | ISO-8859-1                               | Slovenian (sl)                           | ISO-8859-2                              
# | Norwegian Bokmal (nb)                    | ISO-8859-1                               | Serbian Latin (sr@latin)                 | ISO-8859-2                              
# | Dutch (nl)                               | ISO-8859-1                               | Serbian (sr)                             | ISO-8859-5                              
# | Norwegian Nynorsk (nn)                   | ISO-8859-1                               | Turkish (tr)                             | ISO-8859-9                              
# | Norwegian (no)                           | ISO-8859-1                               | Ukrainian (uk)                           | KOI8-U                                  
# | Portuguese (pt)                          | ISO-8859-1                               | Vietnamese (vi)                          | TCVN5712-1                              
# | Swedish (sv)                             | ISO-8859-1                               | Simplified Chinese (zh_CN)               | GBK                                     
# | Belarusian (be)                          | CP1251                                   | Simplified Chinese, Singapore (zh_SG)    | GBK                                     
# | Bulgarian (bg)                           | CP1251                                   | Traditional Chinese, Hong Kong (zh_HK)   | BIG5HKSCS                               
# | Czech (cs)                               | ISO-8859-2                               | Traditional Chinese (zh_TW)              | BIG5                                    
#--------------------------------------------

# ====== Note ======
#<p>
#
#  Manual pages in languages not in the list are not supported. 
#</p>

# ==== 8.77.3. Contents of Man-DB ====

#  Installed programs: accessdb, apropos (link to whatis), catman, lexgrog, man, man-recode, mandb, manpath, and whatis
#  Installed libraries: libman.so and libmandb.so (both in /usr/lib/man-db)
#  Installed directories: /usr/lib/man-db, /usr/libexec/man-db, and /usr/share/doc/man-db-2.13.1
# ====== Short Descriptions ======

#--------------------------------------------
# | accessdb                                 | Dumps the                               whatis                                  database contents in human-readable form
# | apropos                                  | Searches the                            whatis                                  database and displays the short descriptions of system commands that contain a given string
# | catman                                   | Creates or updates the pre-formatted manual pages
# | lexgrog                                  | Displays one-line summary information about a given manual page
# | man                                      | Formats and displays the requested manual page
# | man-recode                               | Converts manual pages to another encoding
# | mandb                                    | Creates or updates the                  whatis                                  database                                
# | manpath                                  | Displays the contents of $MANPATH or (if $MANPATH is not set) a suitable search path based on the settings in man.conf and the user's environment
# | whatis                                   | Searches the                            whatis                                  database and displays the short descriptions of system commands that contain the given keyword as a separate word
# | libman                                   | Contains run-time support for           man                                     
# | libmandb                                 | Contains run-time support for           man                                     
#--------------------------------------------
cd $topdir
rm -rf $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt
