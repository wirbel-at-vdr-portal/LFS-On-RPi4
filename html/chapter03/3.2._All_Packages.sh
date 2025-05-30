#!/usr/bin/bash

# ===== 3.2. All Packages =====
topdir=$(pwd)
err=0
set -e
chapter=3002
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


# ====== Note ======
#<p>
#
#  Read the [security advisories](https://www.linuxfromscratch.org/lfs/advisories/)
#  before downloading packages to figure out if a newer version of any package 
# should be used to avoid security vulnerabilities. 
#</p>
#<p>
#
#  The upstream sources may remove old releases, especially when those releases 
# contain a security vulnerability. If one URL below is not reachable, you should 
# read the security advisories first to figure out if a newer version (with the 
# vulnerability fixed) should be used. If not, try to download the removed 
# package from a mirror. Although it's possible to download an old release from a 
# mirror even if this release has been removed because of a vulnerability, it's 
# not a good idea to use a release known to be vulnerable when building your 
# system. 
#</p>
#<p>
#
#  Download or otherwise obtain the following packages: 
#</p>

#Acl (2.3.2) -363 KB:
##<p>
#
#  Home page: [https://savannah.nongnu.org/projects/acl](https://savannah.nongnu.org/projects/acl)
#</p>
#<p>
#
#  Download: [https://download.savannah.gnu.org/releases/acl/acl-2.3.2.tar.xz](https://download.savannah.gnu.org/releases/acl/acl-2.3.2.tar.xz)
#</p>
#<p>
#
#  MD5 sum: 590765dee95907dbc3c856f7255bd669 
#</p>

#Attr (2.5.2) -484 KB:
##<p>
#
#  Home page: [https://savannah.nongnu.org/projects/attr](https://savannah.nongnu.org/projects/attr)
#</p>
#<p>
#
#  Download: [https://download.savannah.gnu.org/releases/attr/attr-2.5.2.tar.gz](https://download.savannah.gnu.org/releases/attr/attr-2.5.2.tar.gz)
#</p>
#<p>
#
#  MD5 sum: 227043ec2f6ca03c0948df5517f9c927 
#</p>

#Autoconf (2.72) -1,360 KB:
##<p>
#
#  Home page: [https://www.gnu.org/software/autoconf/](https://www.gnu.org/software/autoconf/)
#</p>
#<p>
#
#  Download: [https://ftp.gnu.org/gnu/autoconf/autoconf-2.72.tar.xz](https://ftp.gnu.org/gnu/autoconf/autoconf-2.72.tar.xz)
#</p>
#<p>
#
#  MD5 sum: 1be79f7106ab6767f18391c5e22be701 
#</p>

#Automake (1.17) -1,614 KB:
##<p>
#
#  Home page: [https://www.gnu.org/software/automake/](https://www.gnu.org/software/automake/)
#</p>
#<p>
#
#  Download: [https://ftp.gnu.org/gnu/automake/automake-1.17.tar.xz](https://ftp.gnu.org/gnu/automake/automake-1.17.tar.xz)
#</p>
#<p>
#
#  MD5 sum: 7ab3a02318fee6f5bd42adfc369abf10 
#</p>

#Bash (5.2.37) -10,868 KB:
##<p>
#
#  Home page: [https://www.gnu.org/software/bash/](https://www.gnu.org/software/bash/)
#</p>
#<p>
#
#  Download: [https://ftp.gnu.org/gnu/bash/bash-5.2.37.tar.gz](https://ftp.gnu.org/gnu/bash/bash-5.2.37.tar.gz)
#</p>
#<p>
#
#  MD5 sum: 9c28f21ff65de72ca329c1779684a972 
#</p>

#Bc (7.0.3) -464 KB:
##<p>
#
#  Home page: [https://github.com/gavinhoward](https://github.com/gavinhoward)
#</p>
#<p>
#
#  Download: [https://github.com/gavinhoward/bc/releases/download/7.0.3/bc-7.0.3.tar.xz](https://github.com/gavinhoward/bc/releases/download/7.0.3/bc-7.0.3.tar.xz)
#</p>
#<p>
#
#  MD5 sum: ad4db5a0eb4fdbb3f6813be4b6b3da74 
#</p>

#Binutils (2.44) -26,647 KB:
##<p>
#
#  Home page: [https://www.gnu.org/software/binutils/](https://www.gnu.org/software/binutils/)
#</p>
#<p>
#
#  Download: [https://sourceware.org/pub/binutils/releases/binutils-2.44.tar.xz](https://sourceware.org/pub/binutils/releases/binutils-2.44.tar.xz)
#</p>
#<p>
#
#  MD5 sum: 49912ce774666a30806141f106124294 
#</p>

#Bison (3.8.2) -2,752 KB:
##<p>
#
#  Home page: [https://www.gnu.org/software/bison/](https://www.gnu.org/software/bison/)
#</p>
#<p>
#
#  Download: [https://ftp.gnu.org/gnu/bison/bison-3.8.2.tar.xz](https://ftp.gnu.org/gnu/bison/bison-3.8.2.tar.xz)
#</p>
#<p>
#
#  MD5 sum: c28f119f405a2304ff0a7ccdcc629713 
#</p>

#Bzip2 (1.0.8) -792 KB:
##<p>
#
#  Download: [https://www.sourceware.org/pub/bzip2/bzip2-1.0.8.tar.gz](https://www.sourceware.org/pub/bzip2/bzip2-1.0.8.tar.gz)
#</p>
#<p>
#
#  MD5 sum: 67e051268d0c475ea773822f7500d0e5 
#</p>

#Coreutils (9.7) -6,015 KB:
##<p>
#
#  Home page: [https://www.gnu.org/software/coreutils/](https://www.gnu.org/software/coreutils/)
#</p>
#<p>
#
#  Download: [https://ftp.gnu.org/gnu/coreutils/coreutils-9.7.tar.xz](https://ftp.gnu.org/gnu/coreutils/coreutils-9.7.tar.xz)
#</p>
#<p>
#
#  MD5 sum: 6b7285faf7d5eb91592bdd689270d3f1 
#</p>

#DejaGNU (1.6.3) -608 KB:
##<p>
#
#  Home page: [https://www.gnu.org/software/dejagnu/](https://www.gnu.org/software/dejagnu/)
#</p>
#<p>
#
#  Download: [https://ftp.gnu.org/gnu/dejagnu/dejagnu-1.6.3.tar.gz](https://ftp.gnu.org/gnu/dejagnu/dejagnu-1.6.3.tar.gz)
#</p>
#<p>
#
#  MD5 sum: 68c5208c58236eba447d7d6d1326b821 
#</p>

#Diffutils (3.12) -1,894 KB:
##<p>
#
#  Home page: [https://www.gnu.org/software/diffutils/](https://www.gnu.org/software/diffutils/)
#</p>
#<p>
#
#  Download: [https://ftp.gnu.org/gnu/diffutils/diffutils-3.12.tar.xz](https://ftp.gnu.org/gnu/diffutils/diffutils-3.12.tar.xz)
#</p>
#<p>
#
#  MD5 sum: d1b18b20868fb561f77861cd90b05de4 
#</p>

#E2fsprogs (1.47.2) -9,763 KB:
##<p>
#
#  Home page: [https://e2fsprogs.sourceforge.net/](https://e2fsprogs.sourceforge.net/)
#</p>
#<p>
#
#  Download: [https://downloads.sourceforge.net/project/e2fsprogs/e2fsprogs/v1.47.2/e2fsprogs-1.47.2.tar.gz](https://downloads.sourceforge.net/project/e2fsprogs/e2fsprogs/v1.47.2/e2fsprogs-1.47.2.tar.gz)
#</p>
#<p>
#
#  MD5 sum: 752e5a3ce19aea060d8a203f2fae9baa 
#</p>

#Elfutils (0.193) -11,695 KB:
##<p>
#
#  Home page: [https://sourceware.org/elfutils/](https://sourceware.org/elfutils/)
#</p>
#<p>
#
#  Download: [https://sourceware.org/ftp/elfutils/0.193/elfutils-0.193.tar.bz2](https://sourceware.org/ftp/elfutils/0.193/elfutils-0.193.tar.bz2)
#</p>
#<p>
#
#  MD5 sum: ceefa052ded950a4c523688799193a44 
#</p>

#Expat (2.7.1) -485 KB:
##<p>
#
#  Home page: [https://libexpat.github.io/](https://libexpat.github.io/)
#</p>
#<p>
#
#  Download: [https://github.com/libexpat/libexpat/releases/download/R_2_7_1/expat-2.7.1.tar.xz](https://github.com/libexpat/libexpat/releases/download/R_2_7_1/expat-2.7.1.tar.xz)
#</p>
#<p>
#
#  MD5 sum: 9f0c266ff4b9720beae0c6bd53ae4469 
#</p>

#Expect (5.45.4) -618 KB:
##<p>
#
#  Home page: [https://core.tcl.tk/expect/](https://core.tcl.tk/expect/)
#</p>
#<p>
#
#  Download: [https://prdownloads.sourceforge.net/expect/expect5.45.4.tar.gz](https://prdownloads.sourceforge.net/expect/expect5.45.4.tar.gz)
#</p>
#<p>
#
#  MD5 sum: 00fce8de158422f5ccd2666512329bd2 
#</p>

#File (5.46) -1,283 KB:
##<p>
#
#  Home page: [https://www.darwinsys.com/file/](https://www.darwinsys.com/file/)
#</p>
#<p>
#
#  Download: [https://astron.com/pub/file/file-5.46.tar.gz](https://astron.com/pub/file/file-5.46.tar.gz)
#</p>
#<p>
#
#  MD5 sum: 459da2d4b534801e2e2861611d823864 
#</p>

#Findutils (4.10.0) -2,189 KB:
##<p>
#
#  Home page: [https://www.gnu.org/software/findutils/](https://www.gnu.org/software/findutils/)
#</p>
#<p>
#
#  Download: [https://ftp.gnu.org/gnu/findutils/findutils-4.10.0.tar.xz](https://ftp.gnu.org/gnu/findutils/findutils-4.10.0.tar.xz)
#</p>
#<p>
#
#  MD5 sum: 870cfd71c07d37ebe56f9f4aaf4ad872 
#</p>

#Flex (2.6.4) -1,386 KB:
##<p>
#
#  Home page: [https://github.com/westes/flex](https://github.com/westes/flex)
#</p>
#<p>
#
#  Download: [https://github.com/westes/flex/releases/download/v2.6.4/flex-2.6.4.tar.gz](https://github.com/westes/flex/releases/download/v2.6.4/flex-2.6.4.tar.gz)
#</p>
#<p>
#
#  MD5 sum: 2882e3179748cc9f9c23ec593d6adc8d 
#</p>

#Flit-core (3.12.0) -53 KB:
##<p>
#
#  Home page: [https://pypi.org/project/flit-core/](https://pypi.org/project/flit-core/)
#</p>
#<p>
#
#  Download: [https://pypi.org/packages/source/f/flit-core/flit_core-3.12.0.tar.gz](https://pypi.org/packages/source/f/flit-core/flit_core-3.12.0.tar.gz)
#</p>
#<p>
#
#  MD5 sum: c538415c1f27bd69cbbbf3cdd5135d39 
#</p>

#Gawk (5.3.2) -3,662 KB:
##<p>
#
#  Home page: [https://www.gnu.org/software/gawk/](https://www.gnu.org/software/gawk/)
#</p>
#<p>
#
#  Download: [https://ftp.gnu.org/gnu/gawk/gawk-5.3.2.tar.xz](https://ftp.gnu.org/gnu/gawk/gawk-5.3.2.tar.xz)
#</p>
#<p>
#
#  MD5 sum: b7014650c5f45e5d4837c31209dc0037 
#</p>

#GCC (14.2.0) -90,144 KB:
##<p>
#
#  Home page: [https://gcc.gnu.org/](https://gcc.gnu.org/)
#</p>
#<p>
#
#  Download: [https://ftp.gnu.org/gnu/gcc/gcc-14.2.0/gcc-14.2.0.tar.xz](https://ftp.gnu.org/gnu/gcc/gcc-14.2.0/gcc-14.2.0.tar.xz)
#</p>
#<p>
#
#  MD5 sum: 2268420ba02dc01821960e274711bde0 
#</p>

#GDBM (1.25) -1,196 KB:
##<p>
#
#  Home page: [https://www.gnu.org/software/gdbm/](https://www.gnu.org/software/gdbm/)
#</p>
#<p>
#
#  Download: [https://ftp.gnu.org/gnu/gdbm/gdbm-1.25.tar.gz](https://ftp.gnu.org/gnu/gdbm/gdbm-1.25.tar.gz)
#</p>
#<p>
#
#  MD5 sum: 46266720c7980b75f29e3554aeaeb7a8 
#</p>

#Gettext (0.25) -9,701 KB:
##<p>
#
#  Home page: [https://www.gnu.org/software/gettext/](https://www.gnu.org/software/gettext/)
#</p>
#<p>
#
#  Download: [https://ftp.gnu.org/gnu/gettext/gettext-0.25.tar.xz](https://ftp.gnu.org/gnu/gettext/gettext-0.25.tar.xz)
#</p>
#<p>
#
#  MD5 sum: 355a09fa53ae2e87dd493e040d437874 
#</p>

#Glibc (2.41) -18,892 KB:
##<p>
#
#  Home page: [https://www.gnu.org/software/libc/](https://www.gnu.org/software/libc/)
#</p>
#<p>
#
#  Download: [https://ftp.gnu.org/gnu/glibc/glibc-2.41.tar.xz](https://ftp.gnu.org/gnu/glibc/glibc-2.41.tar.xz)
#</p>
#<p>
#
#  MD5 sum: 19862601af60f73ac69e067d3e9267d4 
#</p>

# ====== Note ======
#<p>
#
#  The Glibc developers maintain a [Git branch](https://sourceware.org/git/?p=glibc.git;a=shortlog;h=refs/heads/release/2.41/master)
#  containing patches considered worthy for Glibc-2.41 but unfortunately 
# developed after Glibc-2.41 release. The LFS editors will issue a security 
# advisory if any security fix is added into the branch, but no actions will be 
# taken for other newly added patches. You may review the patches yourself and 
# incorporate some patches if you consider them important. 
#</p>

#GMP (6.3.0) -2,046 KB:
##<p>
#
#  Home page: [https://www.gnu.org/software/gmp/](https://www.gnu.org/software/gmp/)
#</p>
#<p>
#
#  Download: [https://ftp.gnu.org/gnu/gmp/gmp-6.3.0.tar.xz](https://ftp.gnu.org/gnu/gmp/gmp-6.3.0.tar.xz)
#</p>
#<p>
#
#  MD5 sum: 956dc04e864001a9c22429f761f2c283 
#</p>

#Gperf (3.3) -1,789 KB:
##<p>
#
#  Home page: [https://www.gnu.org/software/gperf/](https://www.gnu.org/software/gperf/)
#</p>
#<p>
#
#  Download: [https://ftp.gnu.org/gnu/gperf/gperf-3.3.tar.gz](https://ftp.gnu.org/gnu/gperf/gperf-3.3.tar.gz)
#</p>
#<p>
#
#  MD5 sum: 31753b021ea78a21f154bf9eecb8b079 
#</p>

#Grep (3.12) -1,874 KB:
##<p>
#
#  Home page: [https://www.gnu.org/software/grep/](https://www.gnu.org/software/grep/)
#</p>
#<p>
#
#  Download: [https://ftp.gnu.org/gnu/grep/grep-3.12.tar.xz](https://ftp.gnu.org/gnu/grep/grep-3.12.tar.xz)
#</p>
#<p>
#
#  MD5 sum: 5d9301ed9d209c4a88c8d3a6fd08b9ac 
#</p>

#Groff (1.23.0) -7,259 KB:
##<p>
#
#  Home page: [https://www.gnu.org/software/groff/](https://www.gnu.org/software/groff/)
#</p>
#<p>
#
#  Download: [https://ftp.gnu.org/gnu/groff/groff-1.23.0.tar.gz](https://ftp.gnu.org/gnu/groff/groff-1.23.0.tar.gz)
#</p>
#<p>
#
#  MD5 sum: 5e4f40315a22bb8a158748e7d5094c7d 
#</p>

#GRUB (2.12) -6,524 KB:
##<p>
#
#  Home page: [https://www.gnu.org/software/grub/](https://www.gnu.org/software/grub/)
#</p>
#<p>
#
#  Download: [https://ftp.gnu.org/gnu/grub/grub-2.12.tar.xz](https://ftp.gnu.org/gnu/grub/grub-2.12.tar.xz)
#</p>
#<p>
#
#  MD5 sum: 60c564b1bdc39d8e43b3aab4bc0fb140 
#</p>

#Gzip (1.14) -865 KB:
##<p>
#
#  Home page: [https://www.gnu.org/software/gzip/](https://www.gnu.org/software/gzip/)
#</p>
#<p>
#
#  Download: [https://ftp.gnu.org/gnu/gzip/gzip-1.14.tar.xz](https://ftp.gnu.org/gnu/gzip/gzip-1.14.tar.xz)
#</p>
#<p>
#
#  MD5 sum: 4bf5a10f287501ee8e8ebe00ef62b2c2 
#</p>

#Iana-Etc (20250407) -592 KB:
##<p>
#
#  Home page: [https://www.iana.org/protocols](https://www.iana.org/protocols)
#</p>
#<p>
#
#  Download: [https://github.com/Mic92/iana-etc/releases/download/20250407/iana-etc-20250407.tar.gz](https://github.com/Mic92/iana-etc/releases/download/20250407/iana-etc-20250407.tar.gz)
#</p>
#<p>
#
#  MD5 sum: 3bd31fb7fd47dccd4bf74cd5ae4046d9 
#</p>

#Inetutils (2.6) -1,724 KB:
##<p>
#
#  Home page: [https://www.gnu.org/software/inetutils/](https://www.gnu.org/software/inetutils/)
#</p>
#<p>
#
#  Download: [https://ftp.gnu.org/gnu/inetutils/inetutils-2.6.tar.xz](https://ftp.gnu.org/gnu/inetutils/inetutils-2.6.tar.xz)
#</p>
#<p>
#
#  MD5 sum: 401d7d07682a193960bcdecafd03de94 
#</p>

#Intltool (0.51.0) -159 KB:
##<p>
#
#  Home page: [https://freedesktop.org/wiki/Software/intltool](https://freedesktop.org/wiki/Software/intltool)
#</p>
#<p>
#
#  Download: [https://launchpad.net/intltool/trunk/0.51.0/+download/intltool-0.51.0.tar.gz](https://launchpad.net/intltool/trunk/0.51.0/+download/intltool-0.51.0.tar.gz)
#</p>
#<p>
#
#  MD5 sum: 12e517cac2b57a0121cda351570f1e63 
#</p>

#IPRoute2 (6.14.0) -908 KB:
##<p>
#
#  Home page: [https://www.kernel.org/pub/linux/utils/net/iproute2/](https://www.kernel.org/pub/linux/utils/net/iproute2/)
#</p>
#<p>
#
#  Download: [https://www.kernel.org/pub/linux/utils/net/iproute2/iproute2-6.14.0.tar.xz](https://www.kernel.org/pub/linux/utils/net/iproute2/iproute2-6.14.0.tar.xz)
#</p>
#<p>
#
#  MD5 sum: 84ee9c0b8bc09623e20c1341c9525024 
#</p>

#Jinja2 (3.1.6) -240 KB:
##<p>
#
#  Home page: [https://jinja.palletsprojects.com/en/3.1.x/](https://jinja.palletsprojects.com/en/3.1.x/)
#</p>
#<p>
#
#  Download: [https://pypi.org/packages/source/J/Jinja2/jinja2-3.1.6.tar.gz](https://pypi.org/packages/source/J/Jinja2/jinja2-3.1.6.tar.gz)
#</p>
#<p>
#
#  MD5 sum: 66d4c25ff43d1deaf9637ccda523dec8 
#</p>

#Kbd (2.7.1) -1,438 KB:
##<p>
#
#  Home page: [https://kbd-project.org/](https://kbd-project.org/)
#</p>
#<p>
#
#  Download: [https://www.kernel.org/pub/linux/utils/kbd/kbd-2.7.1.tar.xz](https://www.kernel.org/pub/linux/utils/kbd/kbd-2.7.1.tar.xz)
#</p>
#<p>
#
#  MD5 sum: f15673d9f748e58f82fa50cff0d0fd20 
#</p>

#Kmod (34.2) -434 KB:
##<p>
#
#  Home page: [https://github.com/kmod-project/kmod](https://github.com/kmod-project/kmod)
#</p>
#<p>
#
#  Download: [https://www.kernel.org/pub/linux/utils/kernel/kmod/kmod-34.2.tar.xz](https://www.kernel.org/pub/linux/utils/kernel/kmod/kmod-34.2.tar.xz)
#</p>
#<p>
#
#  MD5 sum: 36f2cc483745e81ede3406fa55e1065a 
#</p>

#Less (668) -635 KB:
##<p>
#
#  Home page: [https://www.greenwoodsoftware.com/less/](https://www.greenwoodsoftware.com/less/)
#</p>
#<p>
#
#  Download: [https://www.greenwoodsoftware.com/less/less-668.tar.gz](https://www.greenwoodsoftware.com/less/less-668.tar.gz)
#</p>
#<p>
#
#  MD5 sum: d72760386c5f80702890340d2f66c302 
#</p>

#LFS-Bootscripts (20240825) -34 KB:
##<p>
#
#  Download: [https://www.linuxfromscratch.org/lfs/downloads/development/lfs-bootscripts-20240825.tar.xz](https://www.linuxfromscratch.org/lfs/downloads/development/lfs-bootscripts-20240825.tar.xz)
#</p>
#<p>
#
#  MD5 sum: 62863abd18f567e48a391407da117b1e 
#</p>

#Libcap (2.76) -195 KB:
##<p>
#
#  Home page: [https://sites.google.com/site/fullycapable/](https://sites.google.com/site/fullycapable/)
#</p>
#<p>
#
#  Download: [https://www.kernel.org/pub/linux/libs/security/linux-privs/libcap2/libcap-2.76.tar.xz](https://www.kernel.org/pub/linux/libs/security/linux-privs/libcap2/libcap-2.76.tar.xz)
#</p>
#<p>
#
#  MD5 sum: 449ade7d620b5c4eeb15a632fbaa4f74 
#</p>

#Libffi (3.4.8) -1,366 KB:
##<p>
#
#  Home page: [https://sourceware.org/libffi/](https://sourceware.org/libffi/)
#</p>
#<p>
#
#  Download: [https://github.com/libffi/libffi/releases/download/v3.4.8/libffi-3.4.8.tar.gz](https://github.com/libffi/libffi/releases/download/v3.4.8/libffi-3.4.8.tar.gz)
#</p>
#<p>
#
#  MD5 sum: ba5fc49d57d13b9e6cecd0c78d76688b 
#</p>

#Libpipeline (1.5.8) -1046 KB:
##<p>
#
#  Home page: [https://libpipeline.nongnu.org/](https://libpipeline.nongnu.org/)
#</p>
#<p>
#
#  Download: [https://download.savannah.gnu.org/releases/libpipeline/libpipeline-1.5.8.tar.gz](https://download.savannah.gnu.org/releases/libpipeline/libpipeline-1.5.8.tar.gz)
#</p>
#<p>
#
#  MD5 sum: 17ac6969b2015386bcb5d278a08a40b5 
#</p>

#Libtool (2.5.4) -1,033 KB:
##<p>
#
#  Home page: [https://www.gnu.org/software/libtool/](https://www.gnu.org/software/libtool/)
#</p>
#<p>
#
#  Download: [https://ftp.gnu.org/gnu/libtool/libtool-2.5.4.tar.xz](https://ftp.gnu.org/gnu/libtool/libtool-2.5.4.tar.xz)
#</p>
#<p>
#
#  MD5 sum: 22e0a29df8af5fdde276ea3a7d351d30 
#</p>

#Libxcrypt (4.4.38) -612 KB:
##<p>
#
#  Home page: [https://github.com/besser82/libxcrypt/](https://github.com/besser82/libxcrypt/)
#</p>
#<p>
#
#  Download: [https://github.com/besser82/libxcrypt/releases/download/v4.4.38/libxcrypt-4.4.38.tar.xz](https://github.com/besser82/libxcrypt/releases/download/v4.4.38/libxcrypt-4.4.38.tar.xz)
#</p>
#<p>
#
#  MD5 sum: 1796a5d20098e9dd9e3f576803c83000 
#</p>

#Linux (6.14.6) -145,972 KB:
##<p>
#
#  Home page: [https://www.kernel.org/](https://www.kernel.org/)
#</p>
#<p>
#
#  Download: [https://www.kernel.org/pub/linux/kernel/v6.x/linux-6.14.6.tar.xz](https://www.kernel.org/pub/linux/kernel/v6.x/linux-6.14.6.tar.xz)
#</p>
#<p>
#
#  MD5 sum: 994a5e99e8529bf69e9a2e4f52c0a832 
#</p>

# ====== Note ======
#<p>
#
#  The Linux kernel is updated quite frequently, many times due to discoveries of 
# security vulnerabilities. The latest available stable kernel version may be 
# used, unless the errata page says otherwise. 
#</p>
#<p>
#
#  For users with limited speed or expensive bandwidth who wish to update the 
# Linux kernel, a baseline version of the package and patches can be downloaded 
# separately. This may save some time or cost for a subsequent patch level 
# upgrade within a minor release. 
#</p>

#Lz4 (1.10.0) -379 KB:
##<p>
#
#  Home page: [https://lz4.org/](https://lz4.org/)
#</p>
#<p>
#
#  Download: [https://github.com/lz4/lz4/releases/download/v1.10.0/lz4-1.10.0.tar.gz](https://github.com/lz4/lz4/releases/download/v1.10.0/lz4-1.10.0.tar.gz)
#</p>
#<p>
#
#  MD5 sum: dead9f5f1966d9ae56e1e32761e4e675 
#</p>

#M4 (1.4.20) -1,997 KB:
##<p>
#
#  Home page: [https://www.gnu.org/software/m4/](https://www.gnu.org/software/m4/)
#</p>
#<p>
#
#  Download: [https://ftp.gnu.org/gnu/m4/m4-1.4.20.tar.xz](https://ftp.gnu.org/gnu/m4/m4-1.4.20.tar.xz)
#</p>
#<p>
#
#  MD5 sum: 6eb2ebed5b24e74b6e890919331d2132 
#</p>

#Make (4.4.1) -2,300 KB:
##<p>
#
#  Home page: [https://www.gnu.org/software/make/](https://www.gnu.org/software/make/)
#</p>
#<p>
#
#  Download: [https://ftp.gnu.org/gnu/make/make-4.4.1.tar.gz](https://ftp.gnu.org/gnu/make/make-4.4.1.tar.gz)
#</p>
#<p>
#
#  MD5 sum: c8469a3713cbbe04d955d4ae4be23eeb 
#</p>

#Man-DB (2.13.1) -2,061 KB:
##<p>
#
#  Home page: [https://www.nongnu.org/man-db/](https://www.nongnu.org/man-db/)
#</p>
#<p>
#
#  Download: [https://download.savannah.gnu.org/releases/man-db/man-db-2.13.1.tar.xz](https://download.savannah.gnu.org/releases/man-db/man-db-2.13.1.tar.xz)
#</p>
#<p>
#
#  MD5 sum: b6335533cbeac3b24cd7be31fdee8c83 
#</p>

#Man-pages (6.14) -1,814 KB:
##<p>
#
#  Home page: [https://www.kernel.org/doc/man-pages/](https://www.kernel.org/doc/man-pages/)
#</p>
#<p>
#
#  Download: [https://www.kernel.org/pub/linux/docs/man-pages/man-pages-6.14.tar.xz](https://www.kernel.org/pub/linux/docs/man-pages/man-pages-6.14.tar.xz)
#</p>
#<p>
#
#  MD5 sum: d0c9b48d6c4b4c26ec580970c461ebfa 
#</p>

#MarkupSafe (3.0.2) -21 KB:
##<p>
#
#  Home page: [https://palletsprojects.com/p/markupsafe/](https://palletsprojects.com/p/markupsafe/)
#</p>
#<p>
#
#  Download: [https://pypi.org/packages/source/M/MarkupSafe/markupsafe-3.0.2.tar.gz](https://pypi.org/packages/source/M/MarkupSafe/markupsafe-3.0.2.tar.gz)
#</p>
#<p>
#
#  MD5 sum: cb0071711b573b155cc8f86e1de72167 
#</p>

#Meson (1.8.0) -2,281 KB:
##<p>
#
#  Home page: [https://mesonbuild.com](https://mesonbuild.com)
#</p>
#<p>
#
#  Download: [https://github.com/mesonbuild/meson/releases/download/1.8.0/meson-1.8.0.tar.gz](https://github.com/mesonbuild/meson/releases/download/1.8.0/meson-1.8.0.tar.gz)
#</p>
#<p>
#
#  MD5 sum: 74664d20851d29bc3e491d502d66e1f7 
#</p>

#MPC (1.3.1) -756 KB:
##<p>
#
#  Home page: [https://www.multiprecision.org/](https://www.multiprecision.org/)
#</p>
#<p>
#
#  Download: [https://ftp.gnu.org/gnu/mpc/mpc-1.3.1.tar.gz](https://ftp.gnu.org/gnu/mpc/mpc-1.3.1.tar.gz)
#</p>
#<p>
#
#  MD5 sum: 5c9bc658c9fd0f940e8e3e0f09530c62 
#</p>

#MPFR (4.2.2) -1,471 KB:
##<p>
#
#  Home page: [https://www.mpfr.org/](https://www.mpfr.org/)
#</p>
#<p>
#
#  Download: [https://ftp.gnu.org/gnu/mpfr/mpfr-4.2.2.tar.xz](https://ftp.gnu.org/gnu/mpfr/mpfr-4.2.2.tar.xz)
#</p>
#<p>
#
#  MD5 sum: 7c32c39b8b6e3ae85f25156228156061 
#</p>

#Ncurses (6.5) -2,156 KB:
##<p>
#
#  Home page: [https://www.gnu.org/software/ncurses/](https://www.gnu.org/software/ncurses/)
#</p>
#<p>
#
#  Download: [https://invisible-mirror.net/archives/ncurses/ncurses-6.5.tar.gz](https://invisible-mirror.net/archives/ncurses/ncurses-6.5.tar.gz)
#</p>
#<p>
#
#  MD5 sum: ac2d2629296f04c8537ca706b6977687 
#</p>

#Ninja (1.12.1) -235 KB:
##<p>
#
#  Home page: [https://ninja-build.org/](https://ninja-build.org/)
#</p>
#<p>
#
#  Download: [https://github.com/ninja-build/ninja/archive/v1.12.1/ninja-1.12.1.tar.gz](https://github.com/ninja-build/ninja/archive/v1.12.1/ninja-1.12.1.tar.gz)
#</p>
#<p>
#
#  MD5 sum: 6288992b05e593a391599692e2f7e490 
#</p>

#OpenSSL (3.5.0) -51,892 KB:
##<p>
#
#  Home page: [https://www.openssl-library.org/](https://www.openssl-library.org/)
#</p>
#<p>
#
#  Download: [https://github.com/openssl/openssl/releases/download/openssl-3.5.0/openssl-3.5.0.tar.gz](https://github.com/openssl/openssl/releases/download/openssl-3.5.0/openssl-3.5.0.tar.gz)
#</p>
#<p>
#
#  MD5 sum: 51da7d2bdf7f4f508cb024f562eb9b03 
#</p>

#Packaging (25.0) -162 KB:
##<p>
#
#  Home page: [https://pypi.org/project/packaging/](https://pypi.org/project/packaging/)
#</p>
#<p>
#
#  Download: [https://files.pythonhosted.org/packages/source/p/packaging/packaging-25.0.tar.gz](https://files.pythonhosted.org/packages/source/p/packaging/packaging-25.0.tar.gz)
#</p>
#<p>
#
#  MD5 sum: ab0ef21ddebe09d1803575120d3f99f8 
#</p>

#Patch (2.8) -886 KB:
##<p>
#
#  Home page: [https://savannah.gnu.org/projects/patch/](https://savannah.gnu.org/projects/patch/)
#</p>
#<p>
#
#  Download: [https://ftp.gnu.org/gnu/patch/patch-2.8.tar.xz](https://ftp.gnu.org/gnu/patch/patch-2.8.tar.xz)
#</p>
#<p>
#
#  MD5 sum: 149327a021d41c8f88d034eab41c039f 
#</p>

#Perl (5.40.2) -13,598 KB:
##<p>
#
#  Home page: [https://www.perl.org/](https://www.perl.org/)
#</p>
#<p>
#
#  Download: [https://www.cpan.org/src/5.0/perl-5.40.2.tar.xz](https://www.cpan.org/src/5.0/perl-5.40.2.tar.xz)
#</p>
#<p>
#
#  MD5 sum: 9ad7a269dc4053cdbeecd4fde444291b 
#</p>

#Pkgconf (2.4.3) -314 KB:
##<p>
#
#  Home page: [https://github.com/pkgconf/pkgconf](https://github.com/pkgconf/pkgconf)
#</p>
#<p>
#
#  Download: [https://distfiles.ariadne.space/pkgconf/pkgconf-2.4.3.tar.xz](https://distfiles.ariadne.space/pkgconf/pkgconf-2.4.3.tar.xz)
#</p>
#<p>
#
#  MD5 sum: 781a513f4ca3d068155482a37986d594 
#</p>

#Procps (4.0.5) -1,483 KB:
##<p>
#
#  Home page: [https://gitlab.com/procps-ng/procps/](https://gitlab.com/procps-ng/procps/)
#</p>
#<p>
#
#  Download: [https://sourceforge.net/projects/procps-ng/files/Production/procps-ng-4.0.5.tar.xz](https://sourceforge.net/projects/procps-ng/files/Production/procps-ng-4.0.5.tar.xz)
#</p>
#<p>
#
#  MD5 sum: 90803e64f51f192f3325d25c3335d057 
#</p>

#Psmisc (23.7) -423 KB:
##<p>
#
#  Home page: [https://gitlab.com/psmisc/psmisc](https://gitlab.com/psmisc/psmisc)
#</p>
#<p>
#
#  Download: [https://sourceforge.net/projects/psmisc/files/psmisc/psmisc-23.7.tar.xz](https://sourceforge.net/projects/psmisc/files/psmisc/psmisc-23.7.tar.xz)
#</p>
#<p>
#
#  MD5 sum: 53eae841735189a896d614cba440eb10 
#</p>

#Python (3.13.3) -22,124 KB:
##<p>
#
#  Home page: [https://www.python.org/](https://www.python.org/)
#</p>
#<p>
#
#  Download: [https://www.python.org/ftp/python/3.13.3/Python-3.13.3.tar.xz](https://www.python.org/ftp/python/3.13.3/Python-3.13.3.tar.xz)
#</p>
#<p>
#
#  MD5 sum: 8bb5f0b8c9d9d7b87d7d98510e8d58e5 
#</p>

#Python Documentation (3.13.3) -10,112 KB:
##<p>
#
#  Download: [https://www.python.org/ftp/python/doc/3.13.3/python-3.13.3-docs-html.tar.bz2](https://www.python.org/ftp/python/doc/3.13.3/python-3.13.3-docs-html.tar.bz2)
#</p>
#<p>
#
#  MD5 sum: 5b65ca5579dac14e425cd247af6fd043 
#</p>

#Readline (8.2.13) -2,974 KB:
##<p>
#
#  Home page: [https://tiswww.case.edu/php/chet/readline/rltop.html](https://tiswww.case.edu/php/chet/readline/rltop.html)
#</p>
#<p>
#
#  Download: [https://ftp.gnu.org/gnu/readline/readline-8.2.13.tar.gz](https://ftp.gnu.org/gnu/readline/readline-8.2.13.tar.gz)
#</p>
#<p>
#
#  MD5 sum: 05080bf3801e6874bb115cd6700b708f 
#</p>

#Sed (4.9) -1,365 KB:
##<p>
#
#  Home page: [https://www.gnu.org/software/sed/](https://www.gnu.org/software/sed/)
#</p>
#<p>
#
#  Download: [https://ftp.gnu.org/gnu/sed/sed-4.9.tar.xz](https://ftp.gnu.org/gnu/sed/sed-4.9.tar.xz)
#</p>
#<p>
#
#  MD5 sum: 6aac9b2dbafcd5b7a67a8a9bcb8036c3 
#</p>

#Setuptools (80.7.1) -1,289 KB:
##<p>
#
#  Home page: [https://pypi.org/project/setuptools/](https://pypi.org/project/setuptools/)
#</p>
#<p>
#
#  Download: [https://pypi.org/packages/source/s/setuptools/setuptools-80.7.1.tar.gz](https://pypi.org/packages/source/s/setuptools/setuptools-80.7.1.tar.gz)
#</p>
#<p>
#
#  MD5 sum: dc25a6f2961f8615199e9a63e6c4b431 
#</p>

#Shadow (4.17.4) -2,273 KB:
##<p>
#
#  Home page: [https://github.com/shadow-maint/shadow/](https://github.com/shadow-maint/shadow/)
#</p>
#<p>
#
#  Download: [https://github.com/shadow-maint/shadow/releases/download/4.17.4/shadow-4.17.4.tar.xz](https://github.com/shadow-maint/shadow/releases/download/4.17.4/shadow-4.17.4.tar.xz)
#</p>
#<p>
#
#  MD5 sum: 469666ea82c203ce5b0116d26b3793a9 
#</p>

#Sysklogd (2.7.2) -474 KB:
##<p>
#
#  Home page: [https://www.infodrom.org/projects/sysklogd/](https://www.infodrom.org/projects/sysklogd/)
#</p>
#<p>
#
#  Download: [https://github.com/troglobit/sysklogd/releases/download/v2.7.2/sysklogd-2.7.2.tar.gz](https://github.com/troglobit/sysklogd/releases/download/v2.7.2/sysklogd-2.7.2.tar.gz)
#</p>
#<p>
#
#  MD5 sum: af60786956a2dc84054fbf46652e515e 
#</p>

#Systemd (257.3) -15,847 KB:
##<p>
#
#  Home page: [https://www.freedesktop.org/wiki/Software/systemd/](https://www.freedesktop.org/wiki/Software/systemd/)
#</p>
#<p>
#
#  Download: [https://github.com/systemd/systemd/archive/v257.3/systemd-257.3.tar.gz](https://github.com/systemd/systemd/archive/v257.3/systemd-257.3.tar.gz)
#</p>
#<p>
#
#  MD5 sum: 8e4fc90c7aead651fa5c50bd1b34abc2 
#</p>

#Systemd Man Pages (257.3) -733 KB:
##<p>
#
#  Home page: [https://www.freedesktop.org/wiki/Software/systemd/](https://www.freedesktop.org/wiki/Software/systemd/)
#</p>
#<p>
#
#  Download: [https://anduin.linuxfromscratch.org/LFS/systemd-man-pages-257.3.tar.xz](https://anduin.linuxfromscratch.org/LFS/systemd-man-pages-257.3.tar.xz)
#</p>
#<p>
#
#  MD5 sum: 9b77c3b066723d490cb10aed4fb05696 
#</p>

# ====== Note ======
#<p>
#
#  The Linux From Scratch team generates its own tarball of the man pages using 
# the systemd source. This is done in order to avoid unnecessary dependencies. 
#</p>

#SysVinit (3.14) -236 KB:
##<p>
#
#  Home page: [https://savannah.nongnu.org/projects/sysvinit](https://savannah.nongnu.org/projects/sysvinit)
#</p>
#<p>
#
#  Download: [https://github.com/slicer69/sysvinit/releases/download/3.14/sysvinit-3.14.tar.xz](https://github.com/slicer69/sysvinit/releases/download/3.14/sysvinit-3.14.tar.xz)
#</p>
#<p>
#
#  MD5 sum: bc6890b975d19dc9db42d0c7364dd092 
#</p>

#Tar (1.35) -2,263 KB:
##<p>
#
#  Home page: [https://www.gnu.org/software/tar/](https://www.gnu.org/software/tar/)
#</p>
#<p>
#
#  Download: [https://ftp.gnu.org/gnu/tar/tar-1.35.tar.xz](https://ftp.gnu.org/gnu/tar/tar-1.35.tar.xz)
#</p>
#<p>
#
#  MD5 sum: a2d8042658cfd8ea939e6d911eaf4152 
#</p>

#Tcl (8.6.16) -11,406 KB:
##<p>
#
#  Home page: [https://tcl.sourceforge.net/](https://tcl.sourceforge.net/)
#</p>
#<p>
#
#  Download: [https://downloads.sourceforge.net/tcl/tcl8.6.16-src.tar.gz](https://downloads.sourceforge.net/tcl/tcl8.6.16-src.tar.gz)
#</p>
#<p>
#
#  MD5 sum: eaef5d0a27239fb840f04af8ec608242 
#</p>

#Tcl Documentation (8.6.16) -1,169 KB:
##<p>
#
#  Download: [https://downloads.sourceforge.net/tcl/tcl8.6.16-html.tar.gz](https://downloads.sourceforge.net/tcl/tcl8.6.16-html.tar.gz)
#</p>
#<p>
#
#  MD5 sum: 750c221bcb6f8737a6791c1fbe98b684 
#</p>

#Texinfo (7.2) -6,259 KB:
##<p>
#
#  Home page: [https://www.gnu.org/software/texinfo/](https://www.gnu.org/software/texinfo/)
#</p>
#<p>
#
#  Download: [https://ftp.gnu.org/gnu/texinfo/texinfo-7.2.tar.xz](https://ftp.gnu.org/gnu/texinfo/texinfo-7.2.tar.xz)
#</p>
#<p>
#
#  MD5 sum: 11939a7624572814912a18e76c8d8972 
#</p>

#Time Zone Data (2025b) -454 KB:
##<p>
#
#  Home page: [https://www.iana.org/time-zones](https://www.iana.org/time-zones)
#</p>
#<p>
#
#  Download: [https://www.iana.org/time-zones/repository/releases/tzdata2025b.tar.gz](https://www.iana.org/time-zones/repository/releases/tzdata2025b.tar.gz)
#</p>
#<p>
#
#  MD5 sum: ad65154c48c74a9b311fe84778c5434f 
#</p>

#Udev-lfs Tarball (udev-lfs-20230818) -10 KB:
##<p>
#
#  Download: [https://anduin.linuxfromscratch.org/LFS/udev-lfs-20230818.tar.xz](https://anduin.linuxfromscratch.org/LFS/udev-lfs-20230818.tar.xz)
#</p>
#<p>
#
#  MD5 sum: acd4360d8a5c3ef320b9db88d275dae6 
#</p>

#Util-linux (2.41) -9,313 KB:
##<p>
#
#  Home page: [https://git.kernel.org/pub/scm/utils/util-linux/util-linux.git/](https://git.kernel.org/pub/scm/utils/util-linux/util-linux.git/)
#</p>
#<p>
#
#  Download: [https://www.kernel.org/pub/linux/utils/util-linux/v2.41/util-linux-2.41.tar.xz](https://www.kernel.org/pub/linux/utils/util-linux/v2.41/util-linux-2.41.tar.xz)
#</p>
#<p>
#
#  MD5 sum: e666a34b03554c18a1073347b16661ce 
#</p>

#Vim (9.1.1353) -18,318 KB:
##<p>
#
#  Home page: [https://www.vim.org](https://www.vim.org)
#</p>
#<p>
#
#  Download: [https://github.com/vim/vim/archive/v9.1.1353/vim-9.1.1353.tar.gz](https://github.com/vim/vim/archive/v9.1.1353/vim-9.1.1353.tar.gz)
#</p>
#<p>
#
#  MD5 sum: 3234f9dfc973bbfc6ce2441c9fd8ab76 
#</p>

# ====== Note ======
#<p>
#
#  The version of vim changes daily. To get the latest version, go to [https://github.com/vim/vim/tags](https://github.com/vim/vim/tags)
#  . 
#</p>

#Wheel (0.46.1) -54 KB:
##<p>
#
#  Home page: [https://pypi.org/project/wheel/](https://pypi.org/project/wheel/)
#</p>
#<p>
#
#  Download: [https://pypi.org/packages/source/w/wheel/wheel-0.46.1.tar.gz](https://pypi.org/packages/source/w/wheel/wheel-0.46.1.tar.gz)
#</p>
#<p>
#
#  MD5 sum: 65e09ee84af36821e3b1e9564aa91bd5 
#</p>

#XML::Parser (2.47) -276 KB:
##<p>
#
#  Home page: [https://github.com/chorny/XML-Parser](https://github.com/chorny/XML-Parser)
#</p>
#<p>
#
#  Download: [https://cpan.metacpan.org/authors/id/T/TO/TODDR/XML-Parser-2.47.tar.gz](https://cpan.metacpan.org/authors/id/T/TO/TODDR/XML-Parser-2.47.tar.gz)
#</p>
#<p>
#
#  MD5 sum: 89a8e82cfd2ad948b349c0a69c494463 
#</p>

#Xz Utils (5.8.1) -1,428 KB:
##<p>
#
#  Home page: [https://tukaani.org/xz](https://tukaani.org/xz)
#</p>
#<p>
#
#  Download: [https://github.com//tukaani-project/xz/releases/download/v5.8.1/xz-5.8.1.tar.xz](https://github.com//tukaani-project/xz/releases/download/v5.8.1/xz-5.8.1.tar.xz)
#</p>
#<p>
#
#  MD5 sum: cf5e1feb023d22c6bdaa30e84ef3abe3 
#</p>

#Zlib (1.3.1) -1,478 KB:
##<p>
#
#  Home page: [https://zlib.net/](https://zlib.net/)
#</p>
#<p>
#
#  Download: [https://zlib.net/fossils/zlib-1.3.1.tar.gz](https://zlib.net/fossils/zlib-1.3.1.tar.gz)
#</p>
#<p>
#
#  MD5 sum: 9855b6d802d7fe5b7bd5b196a2271655 
#</p>

#Zstd (1.5.7) -2,378 KB:
##<p>
#
#  Home page: [https://facebook.github.io/zstd/](https://facebook.github.io/zstd/)
#</p>
#<p>
#
#  Download: [https://github.com/facebook/zstd/releases/download/v1.5.7/zstd-1.5.7.tar.gz](https://github.com/facebook/zstd/releases/download/v1.5.7/zstd-1.5.7.tar.gz)
#</p>
#<p>
#
#  MD5 sum: 780fc1896922b1bc52a4e90980cdda48 
#</p>

# make our sources available for user lfs:

chmod -R 777 src

#<p>
#
#  Total size of these packages: about 565 MB 
#</p>
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt
