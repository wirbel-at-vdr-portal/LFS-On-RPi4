#!/usr/bin/bash

# ===== 4.3. Adding the LFS User =====
topdir=$(pwd)
err=0
set -e
chapter=4003
err_report() {
    echo "chapter $chapter: $(date +'%Y.%m.%d %H:%M:%S') Error $? on line $1" | tee >> $topdir/log.txt
}
trap 'err_report $LINENO' ERR
echo "---------" >> $topdir/log.txt
echo chapter $chapter: start = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt

if [ "$EUID" -ne "0" ]; then
  echo "ERROR: Please run as root";stop
  exit 1
fi

if [[ -z "${LFS}" ]]; then
  echo "ERROR: 'LFS' is not set.";stop
  exit 1
fi

grep -q ${LFS} /proc/mounts || err=1
if [ "$err" -eq "1" ]; then
  echo "ERROR: The '$LFS' partition must be mounted.";stop
  exit 1
fi

#<p>
#
#  When logged in as user root 
#  , making a single mistake can damage or destroy a system. Therefore, the 
# packages in the next two chapters are built as an unprivileged user. You could 
# use your own user name, but to make it easier to set up a clean working 
# environment, we will create a new user called lfs 
#  as a member of a new group (also named lfs 
#  ) and run commands as lfs 
#  during the installation process. As root 
#  , issue the following commands to add the new user: 
#</p>

#********<pre>***********
groupadd lfs
useradd -s /bin/bash -g lfs -m -k /dev/null lfs
#********</pre>**********
#<p>
#
#  This is what the command line options mean: 
#</p>

#-s /bin/bash 
##<p>
#
#  This makes bash
#  the default shell for user lfs 
#  . 
#</p>

#-g lfs 
##<p>
#
#  This option adds user lfs 
#  to group lfs 
#  . 
#</p>

#-m 
##<p>
#
#  This creates a home directory for lfs 
#  . 
#</p>

#-k /dev/null 
##<p>
#
#  This parameter prevents possible copying of files from a skeleton directory 
# (the default is /etc/skel 
#  ) by changing the input location to the special null device. 
#</p>

#lfs 
##<p>
#
#  This is the name of the new user. 
#</p>
#<p>
#
#  If you want to log in as lfs 
#  or switch to lfs 
#  from a non- root 
#  user (as opposed to switching to user lfs 
#  when logged in as root 
#  , which does not require the lfs 
#  user to have a password), you need to set a password for lfs 
#  . Issue the following command as the root 
#  user to set the password: 
#</p>

#********<pre>***********
passwd lfs
#********</pre>**********
#<p>
#
#  Grant lfs 
#  full access to all the directories under $LFS 
#  by making lfs 
#  the owner: 
#</p>

#********<pre>***********
chown -v lfs $LFS/{usr{,/*},var,etc,tools}
case $(uname -m) in
  x86_64) chown -v lfs $LFS/lib64 ;;
esac
#********</pre>**********

# ====== Note ======
#<p>
#
#  In some host systems, the following su
#  command does not complete properly and suspends the login for the lfs 
#  user to the background. If the prompt "lfs:~$" does not appear immediately, 
# entering the fg
#  command will fix the issue. 
#</p>
#<p>
#
#  Next, start a shell running as user lfs 
#  . This can be done by logging in as lfs 
#  on a virtual console, or with the following substitute/switch user command: 
#</p>

#********<pre>***********
su - lfs
#********</pre>**********
#<p>
#
#  The “- ”
#  instructs su
#  to start a login shell as opposed to a non-login shell. The difference between 
# these two types of shells is described in detail in [bash(1)](https://man.archlinux.org/man/bash.1)
#  and info bash
#  . 
#</p>
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt
