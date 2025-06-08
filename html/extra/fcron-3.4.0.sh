topdir=$(pwd)
err=0
set -e
chapter=fcron-3.4.0
err_report() {
    echo "chapter $chapter: $(date +'%Y.%m.%d %H:%M:%S') Error $? on line $1" | tee >> $topdir/log.txt
}
trap 'err_report $LINENO' ERR
echo "---------" >> $topdir/log.txt
echo chapter $chapter: start = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt




srcdir=../../src/fcron-3.4.0
tar xf ../../src/fcron-3.4.0.src.tar.gz -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir




# Introduction to Fcron
# 
# The Fcron package contains a periodical command scheduler which aims at replacing Vixie Cron.
# [Note] Note
# 
# Development versions of BLFS may not build or run some packages properly if LFS or dependencies have been updated since the most recent stable versions of the books.
# Package Information
# 
#     Download (HTTP): http://fcron.free.fr/archives/fcron-3.4.0.src.tar.gz
# 
#     Download MD5 sum: 5732a766df42a090749c0c96a6afd42b
# 
#     Download size: 608 KB
# 
#     Estimated disk space required: 4.2 MB
# 
#     Estimated build time: less than 0.1 SBU
# 
# Fcron Dependencies
# Optional
# 
# An MTA, text editor (default is vi from the Vim-9.1.1418 package), Linux-PAM-1.7.0, and DocBook-utils-0.6.14
# Installation of Fcron
# 
# Fcron uses the cron facility of syslog to log all messages. Since LFS does not
# set up this facility in /etc/syslog.conf, it needs to be done prior to
# installing Fcron. This command will append the necessary line to the current
# /etc/syslog.conf (perform as the root user):

cat >> /etc/syslog.conf << "EOF"
# Begin fcron addition to /etc/syslog.conf

cron.* -/var/log/cron.log

# End fcron addition
EOF

# The configuration file has been modified, so reloading the sysklogd daemon
# will activate the changes (again as the root user).

/etc/rc.d/init.d/sysklogd reload

# For security reasons, an unprivileged user and group for Fcron should be created (perform as the root user):

groupadd -g 22 fcron &&
useradd -d /dev/null -c "Fcron User" -g fcron -s /bin/false -u 22 fcron

# Now fix some locations hard coded in the documentation:

find doc -type f -exec sed -i 's:/usr/local::g' {} \;

# Install Fcron by running the following commands:

./configure --prefix=/usr          \
            --sysconfdir=/etc      \
            --localstatedir=/var   \
            --without-sendmail     \
            --with-boot-install=no \
            --with-systemdsystemunitdir=no &&
make -j8

# This package does not come with a test suite.
# 
# Now, as the root user:

make install

# DESTDIR install must be done as root user. Furthermore, if PAM configuration files should be installed in /etc/pam.d, you have to create this directory in the DESTDIR before doing the install.
# Command Explanations
# 
# --without-sendmail: By default, Fcron will attempt to use the sendmail command from an MTA package to email you the results of the fcron script. This switch is used to disable default email notification. Omit the switch to enable the default. Alternatively, you can use the --with-sendmail=</path/to/MTA command> to use a different mailer command.
# 
# --with-boot-install=no: This prevents installation of the bootscript included with the package.
# 
# --with-systemdsystemunitdir=no: This prevents building the systemd units, which are not needed for a SYS V system.
# 
# --with-editor=</path/to/editor>: This switch allows you to set the default text editor.
# 
# --with-dsssl-dir=</path/to/dsssl-stylesheets>: May be used if you have DocBook-utils-0.6.14 installed. Currently, the dsssl stylesheets are located at /usr/share/sgml/docbook/dsssl-stylesheets-1.79.
# Configuring Fcron
# Config Files
# 
# /etc/fcron.conf, /etc/fcron.allow, and /etc/fcron.deny
# Configuration Information
# 
# There are no required changes in any of the config files. Configuration information can be found in the man page for fcron.conf.
# 
# fcron scripts are written using fcrontab. Refer to the fcrontab man page for proper parameters to address your situation.
# 
# If Linux-PAM is installed, two PAM configuration files are installed in etc/pam.d. Alternatively if
# etc/pam.d is not used, the installation will append two configuration sections to the existing /etc/pam.conf file.
# You should ensure the files match your preferences. Modify them as required to suit your needs.
# Periodic Jobs
# 
# If you would like to set up a periodic hierarchy for the root user, first issue the
# following commands (as the root user) to create the /usr/bin/run-parts script:
#    
#    cat > /usr/bin/run-parts << "EOF" &&
#    #!/bin/sh
#    # run-parts:  Runs all the scripts found in a directory.
#    # from Slackware, by Patrick J. Volkerding with ideas borrowed
#    # from the Red Hat and Debian versions of this utility.
#    
#    # keep going when something fails
#    set +e
#    
#    if [ $# -lt 1 ]; then
#      echo "Usage: run-parts <directory>"
#      exit 1
#    fi
#    
#    if [ ! -d $1 ]; then
#      echo "Not a directory: $1"
#      echo "Usage: run-parts <directory>"
#      exit 1
#    fi
#    
#    # There are several types of files that we would like to
#    # ignore automatically, as they are likely to be backups
#    # of other scripts:
#    IGNORE_SUFFIXES="~ ^ , .bak .new .rpmsave .rpmorig .rpmnew .swp"
#    
#    # Main loop:
#    for SCRIPT in $1/* ; do
#      # If this is not a regular file, skip it:
#      if [ ! -f $SCRIPT ]; then
#        continue
#      fi
#      # Determine if this file should be skipped by suffix:
#      SKIP=false
#      for SUFFIX in $IGNORE_SUFFIXES ; do
#        if [ ! "$(basename $SCRIPT $SUFFIX)" = "$(basename $SCRIPT)" ]; then
#          SKIP=true
#          break
#        fi
#      done
#      if [ "$SKIP" = "true" ]; then
#        continue
#      fi
#      # If we've made it this far, then run the script if it's executable:
#      if [ -x $SCRIPT ]; then
#        $SCRIPT || echo "$SCRIPT failed."
#      fi
#    done
#    
#    exit 0
#    EOF
#    chmod -v 755 /usr/bin/run-parts
# 
# Next, create the directory layout for the periodic jobs (again as the root user):
# 
# install -vdm754 /etc/cron.{hourly,daily,weekly,monthly}
# 
# Finally, add the run-parts to the system fcrontab (while still the root user):
# 
# cat > /var/spool/fcron/systab.orig << "EOF"
# &bootrun 01 * * * * root run-parts /etc/cron.hourly
# &bootrun 02 4 * * * root run-parts /etc/cron.daily
# &bootrun 22 4 * * 0 root run-parts /etc/cron.weekly
# &bootrun 42 4 1 * * root run-parts /etc/cron.monthly
# EOF

# Boot Script
# 
# Install the /etc/rc.d/init.d/fcron init script from the blfs-bootscripts-20250225 package.

cd /usr/src/blfs-bootscripts-20250225
make install-fcron
cd -


# Finally, again as the root user, start fcron and generate the /var/spool/fcron/systab file:

/etc/rc.d/init.d/fcron start &&
fcrontab -z -u systab

# Contents
# Installed Programs:
# fcron, fcrondyn, fcronsighup, and fcrontab
# Installed Libraries:
# None
# Installed Directories:
# /usr/share/doc/fcron-3.4.0 and /var/spool/fcron
# Short Descriptions
# 
# fcron
# 	
# 
# is the scheduling daemon
# 
# fcrondyn
# 	
# 
# is a user tool intended to interact with a running fcron daemon
# 
# fcronsighup
# 	
# 
# instructs fcron to reread the Fcron tables
# 
# fcrontab
# 	
# 
# is a program used to install, edit, list and remove the tables used by fcron
# 


cd $topdir
rm -rfv $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt

