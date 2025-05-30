#!/usr/bin/bash

# ===== 2.6. Setting the $LFS Variable and the Umask =====
topdir=$(pwd)
err=0
if [ "$EUID" -ne "0" ]; then
  echo "ERROR: Please run as root";stop
  exit 1
fi

#<p>
#
#  Throughout this book, the environment variable LFS 
#  will be used several times. You should ensure that this variable is always 
# defined throughout the LFS build process. It should be set to the name of the 
# directory where you will be building your LFS system - we will use /mnt/lfs 
#  as an example, but you may choose any directory name you want. If you are 
# building LFS on a separate partition, this directory will be the mount point 
# for the partition. Choose a directory location and set the variable with the 
# following command: 
#</p>

#********<pre>***********
export LFS=/mnt/lfs
#********</pre>**********
#<p>
#
#  Having this variable set is beneficial in that commands such as mkdir -v $LFS/tools
#  can be typed literally. The shell will automatically replace “$LFS”
#  with “/mnt/lfs”
#  (or whatever value the variable was set to) when it processes the command 
# line. 
#</p>
#<p>
#
#  Now set the file mode creation mask (umask) to 022 
#  in case the host distro uses a different default: 
#</p>

#********<pre>***********
umask 022
#********</pre>**********
#<p>
#
#  Setting the umask to 022 ensures that newly created files and directories are 
# only writable by their owner, but are readable and searchable (only for 
# directories) by anyone (assuming default modes are used by the [open(2)](https://man.archlinux.org/man/open.2)
#  system call, new files will end up with permission mode 644 and directories 
# with mode 755). An overly-permissive default can leave security holes in the 
# LFS system, and an overly-restrictive default can cause strange issues building 
# or using the LFS system. 
#</p>

# ====== Caution ======
#<p>
#
#  Do not forget to check that LFS 
#  is set and the umask is set to 022 
#  whenever you leave and reenter the current working environment (such as when 
# doing a su
#  to root 
#  or another user). Check that the LFS 
#  variable is set up properly with: 
#</p>

#********<pre>***********
echo $LFS
#********</pre>**********
#<p>
#
#  Make sure the output shows the path to your LFS system's build location, which 
# is /mnt/lfs 
#  if the provided example was followed. 
#</p>
#<p>
#
#  Check that the umask is set up properly with: 
#</p>

#********<pre>***********
umask
#********</pre>**********
#<p>
#
#  The output may be 0022 
#  or 022 
#  (the number of leading zeros depends on the host distro). 
#</p>
#<p>
#
#  If any output of these two commands is incorrect, use the command given 
# earlier on this page to set $LFS 
#  to the correct directory name and set umask to 022 
#  . 
#</p>

# ====== Note ======
#<p>
#
#  One way to ensure that the LFS 
#  variable and the umask are always set properly is to edit the .bash_profile 
#  file in both your personal home directory and in /root/.bash_profile 
#  and enter the export
#  and umask
#  commands above. In addition, the shell specified in the /etc/passwd 
#  file for all users that need the LFS 
#  variable must be bash to ensure that the .bash_profile 
#  file is incorporated as a part of the login process. 
#</p>
#<p>
#
#  Another consideration is the method that is used to log into the host system. 
# If logging in through a graphical display manager, the user's .bash_profile 
#  is not normally used when a virtual terminal is started. In this case, add the 
# commands to the .bashrc 
#  file for the user and root 
#  . In addition, some distributions use an "if" test, and do not run the 
# remaining .bashrc 
#  instructions for a non-interactive bash invocation. Be sure to place the 
# commands ahead of the test for non-interactive use. 
#</p>
