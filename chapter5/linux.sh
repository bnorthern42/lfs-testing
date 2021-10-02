#!/bin/bash

##old:linux-api-headers.sh

##Make sure there are no stale files embedded in the package:
make mrproper


##Now extract the user-visible kernel headers from the source. The recommended make target headers_install cannot
##be used, because it requires rsync, which may not be available. The headers are first placed in ./usr, then copied
##to the needed location.
echo "**** making headers ****"
make headers
find usr/include -name '.*' -delete
rm usr/include/Makefile
cp -rv usr/include $LFS/usr
sleep 8
echo "**** Done with headers ****"
