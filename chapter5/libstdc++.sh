#!/bin/bash



mkdir -v build
cd build


../libstdc++-v3/configure \
	--host=$LFS_Target \
	--build=$(../config.guess) \
	--prefix=/usr \
	--disable-multilib \
	--disable-nls \
	--disable-libstdcxx-pch \
	--with-gxx-include-dir=/tools/$LFS_TGT/include/c++/$VERSION \
&& make \
&& make DESTDIR=$LFS install
