#!/bin/bash

 if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
    exit
 fi


export LFS=/mnt/lfs
export LFS_Target=x86_64-lfs-linux-gnu
export LFS_TGT=x86_64-lfs-linux-gnu
export LFS_DISK=/dev/sdb 
	
## lets backup this now:
	echo "now doing chroot things"
	#---source packageinstall.sh 6 m4 $F
	sleep 3
	chmod ugo+x preparechroot.sh
	chmod ugo+x insidechroot.sh
	echo "LFS:: $LFS"
	sudo ./preparechroot.sh "LFS" "1"
    sudo ./preparechroot.sh "$LFS"
		
	echo "ENTERING CHROOT ENVIRONMENT..."
	sleep 2
	echo "LFSch:: $LFS"
	echo "test: "
	pwd
	/usr/bin/env | grep HOME
    sudo chroot "$LFS" /usr/bin/env -v \
		HOME=/root \
		TERM="$TERM" \
		PS1="(lfs chroot) \u:\w\$" \
		PATH="/usr/bin:/usr/sbin" \
		/bin/bash --login +h -c "/sources/insidechroot.sh"
#Special Case libstdc++
#source packageinstall.sh 5 $S $T
