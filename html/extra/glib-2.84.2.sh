topdir=$(pwd)
err=0
set -e
chapter=glib-2.84.2
err_report() {
    echo "chapter $chapter: $(date +'%Y.%m.%d %H:%M:%S') Error $? on line $1" | tee >> $topdir/log.txt
}
trap 'err_report $LINENO' ERR
echo "---------" >> $topdir/log.txt
echo chapter $chapter: start = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt




srcdir=../../src/glib-2.84.2
tar xf ../../src/glib-2.84.2.tar.xz -C ../../src
# Check, if we could extract the tarball and stop on error:
[ ! -d "$srcdir" ] && stop
cd $srcdir








patch -Np1 -i ../glib-skip_warnings-1.patch

mkdir build &&
cd    build &&

meson setup ..                  \
      --prefix=/usr             \
      --buildtype=release       \
      -D introspection=disabled \
      -D glib_debug=disabled    \
      -D sysprof=disabled       &&
ninja

ninja install


tar xf ../../gobject-introspection-1.84.0.tar.xz &&

meson setup gobject-introspection-1.84.0 gi-build \
            --prefix=/usr --buildtype=release     &&
ninja -C gi-build

ninja -C gi-build install

meson configure -D introspection=enabled &&
ninja
ninja install



cd $topdir
rm -rf $srcdir
echo chapter $chapter: stop  = $(date +'%Y.%m.%d %H:%M:%S') >> $topdir/log.txt
echo "---------" >> $topdir/log.txt

