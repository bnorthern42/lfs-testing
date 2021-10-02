#!/bin/bash

./configure --prefix=/usr \
	--host=$LFS_TGT \
	--build=$(build-aux/config.guess) \
	--disable-static \
	--docdir=/usr/share/doc/xz-$VERSION \
&& make \
&& make DESTDIR=$LFS install
