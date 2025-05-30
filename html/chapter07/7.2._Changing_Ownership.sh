#!/usr/bin/bash

# ===== 7.2. Changing Ownership =====
topdir=$(pwd)
err=0
set -e
chapter=7002
err_report() {
    echo "chapter $chapter: $(date +'%Y.%m.%d %H:%M:%S') Error $? on line $1" | tee >> $topdir/log.txt
}
trap 'err_report $LINENO' ERR
echo "---------" >> $topdir/log.txt
echo chapter $chapter: start = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt

if [[ -z "${LFS}" ]]; then
  echo "ERROR: 'LFS' is not set.";stop
  exit 1
fi

grep -q $LFS /proc/mounts || err=1
if [ "$err" -eq "1" ]; then
  echo "ERROR: The '$LFS' partition must be mounted.";stop
  exit 1
fi

if [ "$EUID" -ne "0" ]; then
  echo "ERROR: Please run as root, not as user id = $EUID";stop
  exit 1
fi


# ====== Note ======
#<p>
#
#  The commands in the remainder of this book must be performed while logged in 
# as user root 
#  and no longer as user lfs 
#  . Also, double check that $LFS 
#  is set in root 
#  's environment. 
#</p>
#<p>
#
#  Currently, the whole directory hierarchy in $LFS 
#  is owned by the user lfs 
#  , a user that exists only on the host system. If the directories and files 
# under $LFS 
#  are kept as they are, they will be owned by a user ID without a corresponding 
# account. This is dangerous because a user account created later could get this 
# same user ID and would own all the files under $LFS 
#  , thus exposing these files to possible malicious manipulation. 
#</p>
#<p>
#
#  To address this issue, change the ownership of the $LFS/* 
#  directories to user root 
#  by running the following command: 
#</p>

#********<pre>***********
chown --from lfs -R root:root $LFS/{usr,lib,var,etc,bin,sbin,tools}
case $(uname -m) in
  x86_64) chown --from lfs -R root:root $LFS/lib64 ;;
esac
#********</pre>**********
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt
