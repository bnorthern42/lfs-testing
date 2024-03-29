#!/bin/bash

#bnorthern fix by adding lib64 directory
#First, create a symbolic link for LSB compliance.
case $(uname -m) in
    i?86)  sudo ln -sfv ld-linux.so.2 $LFS/lib/ld-lsb.so.3
    ;;
    x86_64) sudo ln -sfv ../lib/ld-linux-x86-64.so.2 $LFS/lib64
            sudo ln -sfv ../lib/ld-linux-x86-64.so.2 $LFS/lib64/ld-lsb-x86-64.so.3
    ;;
esac

patch -Np1 -i ../glibc-*-fhs-1.patch

mkdir -v build
cd build

echo "rootsbindir=/usr/sbin" > configparms

../configure                             \
      --prefix=/usr                      \
      --host=$LFS_TGT                    \
      --build=$(../scripts/config.guess) \
      --enable-kernel=3.2                \
      --with-headers=$LFS/usr/include    \
      libc_cv_slibdir=/usr/lib \
&& make -j1 \
&& make DESTDIR=$LFS install

sed '/RTLDLIST=/s@/usr@@g' -i $LFS/usr/bin/ldd


##Sanity Check
echo 'int main(){}' > dummy.c
$LFS_TGT-gcc dummy.c || exit 1
readelf -l a.out | grep '/ld-linux' || exit 1

sleep 5
#Once all is well, clean up the test files:
rm -v dummy.c a.out


$LFS/tools/libexec/gcc/$LFS_TGT/11.2.0/install-tools/mkheaders

