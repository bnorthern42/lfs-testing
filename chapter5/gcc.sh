#!/bin/bash

mkdir mpfr gmp mpc

tar -xf ../mpfr-*.tar.xz -C mpfr --strip-components=1
tar -xf ../gmp-*.tar.xz -C gmp --strip-components=1
tar -xf ../mpc-*.tar.gz -C mpc --strip-components=1

## On x86_64 hosts, set the default directory name for 64-bit libraries to lib:
case $(uname -m) in
 x86_64)
     sed -e '/m64=/s/lib64/lib/' \
         -i.orig gcc/config/i386/t-linux64
 ;;
esac

mkdir -v build
cd build


../configure \
 --target=$LFS_TGT \
 --prefix=$LFS/tools \
 --with-glibc-version=2.11 \
 --with-sysroot=$LFS \
 --with-newlib \
 --without-headers \
 --enable-initfini-array \
 --disable-nls \
 --disable-shared \
 --disable-multilib \
 --disable-decimal-float \
 --disable-threads \
 --disable-libatomic \
 --disable-libgomp \
 --disable-libquadmath \
 --disable-libssp \
 --disable-libvtv \
 --disable-libstdcxx \
 --enable-languages=c,c++ \
&& make -j1\
&& make install

echo "%%% doing cat command with gcc dirname thingy %%%"
cd ..
cat gcc/limitx.h gcc/glimits.h gcc/limity.h > \
 `dirname $($LFS_TGT-gcc -print-libgcc-file-name)`/install-tools/include/limits.h

echo "%%% done doing cat command with gcc dirname thingy %%%"
