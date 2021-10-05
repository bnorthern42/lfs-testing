#!/bin/bash

#if [ "$EUID" -ne 0 ]
#  then echo "Please run as root"
#    exit
# fi

##SETUP HOST SYSTEM
#sudo apt-get install -y bash binutils bison bzip2 coreutils diffutils gawk gcc glibc-source grep gzip m4 make patch perl python sed tar texinfo xz-utils help2man

##LFS PARAMS
export LFS=/mnt/lfs
export LFS_Target=x86_64-lfs-linux-gnu
export LFS_TGT=x86_64-lfs-linux-gnu
export LFS_DISK=/dev/sdb 

## DO PARTITION SETUP IF IT DOES NOT ALREADY EXIST
if ! grep -q "$LFS" /proc/mounts; then
	source setupdisk.sh "$LFS_DISK"
#	sudo mkdir -pv "$LFS"
#	mkdir -f $LFS/home
#	mount -v -t ext4  "${LFS_DISK}2" $LFS/home
	sudo mount -v -t ext4 "${LFS_DISK}2" "$LFS"
	sudo chown -v $USER "$LFS"
fi
echo 'now on to good stuffs'
sleep 4
## MKDIR FOR BASE LINUX SYSTEM
mkdir -pv $LFS/sources
mkdir -pv $LFS/tools

mkdir -pv $LFS/boot
mkdir -pv $LFS/etc
mkdir -pv $LFS/bin
mkdir -pv $LFS/lib
#bnorthern fix:
mkdir -pv $LFS/lib64
#end fix
mkdir -pv $LFS/sbin
mkdir -pv $LFS/usr
mkdir -pv $LFS/var


for i in bin lib sbin; do
	ln -sv usr/$i $LFS/$i
done

case $(uname -m) in
	x86_64) mkdir -pv $LFS/lib64 ;;
esac
 
# if id -u "lfs" >/dev/null 2>&1; then
    # echo 'user exists'
   # else
    # echo 'user missing'
    # groupadd lfs
    # useradd -s /bin/bash -g lfs -m -k /dev/null lfs
    # passwd lfs
    # chown -v lfs $LFS/{usr{,/*},lib,var,etc,bin,sbin,tools}
    # case $(uname -m) in
    	# x86_64) chown -v lfs $LFS/lib64 ;;
    # esac
    # chown -v lfs $LFS/sources
    # su - lfs
    # 
# fi


	
## MOVE scripts to the mount area
cp -rf *.sh chapter* packages.csv "$LFS/sources"
cd "$LFS/sources"

export PATH="$LFS/tools/bin:$PATH"

#download the packages
source download.sh
#because the headers is really a part of the kernel and not really a package. also see below I made a "special" flag for 
#these types of custom scripts in the packageinstall.sh
#cp linux-*.tar* linux.tar.xz
#source packageinstall.sh 5 linux-api-headers


## NOTE linux in ch 5 is really the api-headers but uses same tar as kernel...
# binutils gcc
T="TRUE"
F="FALSE"
S="gcc"
CURR="6" 
#install packages chapter 5 # 
	for package in binutils linux gcc glibc; do
		
			echo "doing package: $package"		
#			sleep 2
#			source packageinstall.sh 5 $package $F
			echo "done with package: $package"
#			sleep 3
	done
#libstdc++ lib:	
#source packageinstall.sh 5 $S $T

for package in m4 ncurses bash coreutils diffutils file findutils gawk grep gzip make patch sed tar xz binutils gcc; do
		echo "doing package: $package"
#		sleep 2
#		source packageinstall.sh 6 $package $F
		echo "done with package: $package"
#		sleep 4
done


