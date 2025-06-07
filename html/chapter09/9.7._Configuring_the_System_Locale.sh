#!/usr/bin/bash

# ===== 9.7. Configuring the System Locale =====
topdir=$(pwd)
err=0
set -e
chapter=9007
err_report() {
    echo "chapter $chapter: $(date +'%Y.%m.%d %H:%M:%S') Error $? on line $1" | tee >> $topdir/log.txt
}
trap 'err_report $LINENO' ERR
echo "---------" >> $topdir/log.txt
echo chapter $chapter: start = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt




#<p>
#
#  Some environment variables are necessary for native language support. Setting 
# them properly results in: 
#</p>

# ***** #<p>
#
#  The output of programs being translated into your native language 
#</p>

# ***** #<p>
#
#  The correct classification of characters into letters, digits and other 
# classes. This is necessary for bash
#  to properly accept non-ASCII characters in command lines in non-English 
# locales 
#</p>

# ***** #<p>
#
#  The correct alphabetical sorting order for the country 
#</p>

# ***** #<p>
#
#  The appropriate default paper size 
#</p>

# ***** #<p>
#
#  The correct formatting of monetary, time, and date values 
#</p>
#<p>
#
#  Replace <ll> 
#  below with the two-letter code for your desired language (e.g., en 
#  ) and <CC> 
#  with the two-letter code for the appropriate country (e.g., GB 
#  ). <charmap> 
#  should be replaced with the canonical charmap for your chosen locale. Optional 
# modifiers such as @euro 
#  may also be present. 
#</p>
#<p>
#
#  The list of all locales supported by Glibc can be obtained by running the 
# following command: 
#</p>

#********<pre>***********
locale -a
#********</pre>**********
#<p>
#
#  Charmaps can have a number of aliases, e.g., ISO-8859-1 
#  is also referred to as iso8859-1 
#  and iso88591 
#  . Some applications cannot handle the various synonyms correctly (e.g., 
# require that UTF-8 
#  is written as UTF-8 
#  , not utf8 
#  ), so it is the safest in most cases to choose the canonical name for a 
# particular locale. To determine the canonical name, run the following command, 
# where <locale name> 
#  is the output given by locale -a
#  for your preferred locale ( en_GB.iso88591 
#  in our example). 
#</p>

#********<pre>***********
LC_ALL=<locale name> locale charmap
#********</pre>**********
#<p>
#
#  For the en_GB.iso88591 
#  locale, the above command will print: 
#</p>

#********<pre>***********
#ISO-8859-1
#********</pre>**********
#<p>
#
#  This results in a final locale setting of en_GB.ISO-8859-1 
#  . It is important that the locale found using the heuristic above is tested 
# prior to it being added to the Bash startup files: 
#</p>

#********<pre>***********
LC_ALL=<locale name> locale language
LC_ALL=<locale name> locale charmap
LC_ALL=<locale name> locale int_curr_symbol
LC_ALL=<locale name> locale int_prefix
#********</pre>**********
#<p>
#
#  The above commands should print the language name, the character encoding used 
# by the locale, the local currency, and the prefix to dial before the telephone 
# number in order to get into the country. If any of the commands above fail with 
# a message similar to the one shown below, this means that your locale was 
# either not installed in Chapter 8 or is not supported by the default 
# installation of Glibc. 
#</p>

#********<pre>***********
#locale: Cannot set LC_* to default locale: No such file or directory
#********</pre>**********
#<p>
#
#  If this happens, you should either install the desired locale using the localedef
#  command, or consider choosing a different locale. Further instructions assume 
# that there are no such error messages from Glibc. 
#</p>
#<p>
#
#  Other packages can also function incorrectly (but may not necessarily display 
# any error messages) if the locale name does not meet their expectations. In 
# those cases, investigating how other Linux distributions support your locale 
# might provide some useful information. 
#</p>
#<p>
#
#  The shell program /bin/bash
#  (here after referred as “the shell”
#  ) uses a collection of startup files to help create the environment to run in. 
# Each file has a specific use and may affect login and interactive environments 
# differently. The files in the /etc 
#  directory provide global settings. If equivalent files exist in the home 
# directory, they may override the global settings. 
#</p>
#<p>
#
#  An interactive login shell is started after a successful login, using /bin/login
#  , by reading the /etc/passwd 
#  file. An interactive non-login shell is started at the command-line (e.g. [prompt]$ /bin/bash
#  ). A non-interactive shell is usually present when a shell script is running. 
# It is non-interactive because it is processing a script and not waiting for 
# user input between commands. 
#</p>
#<p>
#
#  Create the /etc/profile once the proper locale settings have been determined to set the desired locale
#  , but set the C.UTF-8 
#  locale instead if running in the Linux console (to prevent programs from 
# outputting characters that the Linux console is unable to render): 
#</p>

#********<pre>***********
cat > /etc/profile << "EOF"
# Begin /etc/profile

for i in $(locale); do
  unset ${i%=*}
done

if [[ "$TERM" = linux ]]; then
  export LANG=C.UTF-8
else
  export LANG=<ll>_<CC>.<charmap><@modifiers>
fi

# End /etc/profile
EOF
#********</pre>**********
#<p>
#
#  The C 
#  (default) and en_US 
#  (the recommended one for United States English users) locales are different. C 
#  uses the US-ASCII 7-bit character set, and treats bytes with the high bit set 
# as invalid characters. That's why, e.g., the ls
#  command substitutes them with question marks in that locale. Also, an attempt 
# to send mail with such characters from Mutt or Pine results in 
# non-RFC-conforming messages being sent (the charset in the outgoing mail is 
# indicated as unknown 8-bit 
#  ). It's suggested that you use the C 
#  locale only if you are certain that you will never need 8-bit characters. 
#</p>
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt
