#!/bin/bash

export LFS="$1"
#un mount sfuff instead
um="$2"

if [ "$um" == "1" ]; then
	echo "in: $LFS"
 	echo "unmounting: dev/pts/, dev, proc, sys, and run"
	 sudo umount -l mnt/lfs/dev/pts
	 sudo umount -l mnt/lfs/dev
	 sudo umount -l mnt/lfs/proc
	 sudo umount -l mnt/lfs/sys
 	 sudo umount -l mnt/lfs/run
 	 echo "unlinking $LFS/dev/console and $LFS/dev/null"
 	 sudo unlink mnt/lfs/dev/console
 	 sudo unlink mnt/lfs/dev/null
 	 echo "deleting contents of $LFS/dev"
 	 sudo rm -rf mnt/lfs/dev
 	 echo "now exiting undoer..."
fi

if [ "$LFS" == "" ]; then
	echo "LFS empty!!"
	exit 1
fi
echo "LFS :::$LFS"
sudo chown -R root:root /mnt/lfs/{usr,lib,var,etc,bin,sbin,tools}

case $(uname -m) in
  x86_64) chown -R root:root "$LFS"/lib64 ;;
esac


mkdir -pv "$LFS"/{dev,proc,sys,run}

mknod -m 600 "$LFS"/dev/console c 5 1
mknod -m 666 "$LFS"/dev/null c 1 3


mount -v --bind /dev "$LFS"/dev

mount -v --bind /dev/pts $LFS/dev/pts
mount -vt proc proc $LFS/proc
mount -vt sysfs sysfs $LFS/sys
mount -vt tmpfs tmpfs $LFS/run
#export LFS="$1"


if [ -h $LFS/dev/shm ]; then
  mkdir -pv $LFS/$(readlink $LFS/dev/shm)
fi



