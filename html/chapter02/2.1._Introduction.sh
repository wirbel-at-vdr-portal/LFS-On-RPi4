#!/usr/bin/bash

# ===== 2.1. Introduction =====
topdir=$(pwd)
err=0
if [ "$EUID" -ne "0" ]; then
  echo "ERROR: Please run as root";stop
  exit 1
fi

#<p>
#
#  In this chapter, the host tools needed for building LFS are checked and, if 
# necessary, installed. Then a partition which will host the LFS system is 
# prepared. We will create the partition itself, create a file system on it, and 
# mount it. 
#</p>
