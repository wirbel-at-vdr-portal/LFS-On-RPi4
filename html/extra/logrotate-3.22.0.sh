topdir=$(pwd)
err=0
set -e
chapter=logrotate-3.22.0

err_report() {
    echo "chapter $chapter: $(date +'%Y.%m.%d %H:%M:%S') Error $? on line $1" | tee >> $topdir/log.txt
}
trap 'err_report $LINENO' ERR
echo "---------" >> $topdir/log.txt
echo chapter $chapter: start = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt




srcdir=../../src/logrotate-3.22.0
tar xf ../../src/logrotate-3.22.0.tar.xz -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir





# Introduction to Logrotate
# 
# The logrotate package allows automatic rotation, compression, removal, and mailing of log files.
# [Note] Note
# 
# Development versions of BLFS may not build or run some packages properly if LFS or dependencies have been updated since the most recent stable versions of the books.
# Package Information
# 
#     Download (HTTP): https://github.com/logrotate/logrotate/releases/download/3.22.0/logrotate-3.22.0.tar.xz
# 
#     Download MD5 sum: 2386501a53ff086f44eeada2b27d50b8
# 
#     Download size: 172 KB
# 
#     Estimated disk space required: 2.6 MB (add 38 MB for tests)
# 
#     Estimated build time: less than 0.1 SBU (add 0.1 SBU for tests)
# 
# Logrotate Dependencies
# Required
# 
# popt-1.19
# Recommended
# 
# Fcron-3.4.0 (runtime)
# Optional
# 
# An MTA (runtime)
# Installation of Logrotate
# 
# Install logrotate by running the following command:

./configure --prefix=/usr &&
make -j8

# To test the results, issue: make test. Two tests fail if an MTA is not installed.
# 
# Now, as the root user:

make install

# Configuring Logrotate
# 
# Logrotate needs a configuration file, which must be passed as an argument to the command when executed. Create the file as the root user:
# 
cat > /etc/logrotate.conf << EOF
# Begin /etc/logrotate.conf

# Rotate log files weekly
weekly

# Don't mail logs to anybody
nomail

# If the log file is empty, it will not be rotated
notifempty

# Number of backups that will be kept
# This will keep the 2 newest backups only
rotate 2

# Create new empty files after rotating old ones
# This will create empty log files, with owner
# set to root, group set to sys, and permissions 664
create 0664 root sys

# Compress the backups with gzip
compress

# No packages own lastlog or wtmp -- rotate them here
/var/log/wtmp {
    monthly
    create 0664 root utmp
    rotate 1
}

/var/log/lastlog {
    monthly
    rotate 1
}

# Some packages drop log rotation info in this directory
# so we include any file in it.
include /etc/logrotate.d

# End /etc/logrotate.conf
EOF

chmod -v 0644 /etc/logrotate.conf

# Now create the /etc/logrotate.d directory as the root user:

mkdir -p /etc/logrotate.d

# At this point additional log rotation commands can be entered, typically in the /etc/logrotate.d directory. For example:

cat > /etc/logrotate.d/sys.log << EOF
/var/log/sys.log {
   # If the log file is larger than 200kb, rotate it
   size   200k
   rotate 5
   weekly
   postrotate
      /bin/killall -HUP syslogd
   endscript
}
EOF

chmod -v 0644 /etc/logrotate.d/sys.log

# You can designate multiple files in one entry:
# 
# cat > /etc/logrotate.d/example.log << EOF
# file1
# file2
# file3 {
#    ...
#    postrotate
#     ...
#    endscript
# }
# EOF
# 
# chmod -v 0644 /etc/logrotate.d/example.log
# 
# You can use in the same line the list of files: file1 file2 file3. See the logrotate man page or https://www.techrepublic.com/article/manage-linux-log-files-with-logrotate/ for more examples.
# 
# The command logrotate /etc/logrotate.conf can be run manually, however, the command should be run daily. Other useful commands are logrotate -d /etc/logrotate.conf for debugging purposes and logrotate -f /etc/logrotate.conf forcing the logrotate commands to be run immediately. Combining the previous options -df, you can debug the effect of the force command. When debugging, the commands are only simulated and are not actually run. As a result, errors about files not existing will eventually appear because the files are not actually created.
# 
# To run the logrotate command daily, if you've installed Fcron-3.4.0 and completed the section on periodic jobs, execute the following commands, as the root user, to create a daily cron job:
# 
# cat > /etc/cron.daily/logrotate.sh << "EOF" &&
# #!/bin/bash
# /usr/sbin/logrotate /etc/logrotate.conf
# EOF
# chmod 754 /etc/cron.daily/logrotate.sh
# 
# Contents
# Installed Programs:
# logrotate
# Installed Library:
# None
# Installed Directories:
# None
# Short Descriptions
# 
# logrotate
# 	
# 
# performs the log maintenance functions defined in the configuration files 
# 








cd $topdir
rm -rf $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt

