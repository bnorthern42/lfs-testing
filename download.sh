#!/bin/bash

cat packages.csv | while read line; do
	NAME="`echo $line | cut -d\; -f1`"
	VERSION="`echo $line | cut -d\; -f2`"
	URL="`echo $line | cut -d\; -f3 | sed 's/@/'$VERSION'/g'`"
	MD5SUM="`echo $line | cut -d\; -f4`"

	CACHEFILE="$(basename "$URL")"


#	echo NAME $NAME
#	echo VERSION $VERSION
#	echo URL $URL
	#echo MD5 $MD5SUM
	#echo FILE $CACHEFILE



#if file does not exist yet
	if [ ! -f "$CACHEFILE" ]; then 
	#then start download process
		echo "Donwloading $URL"
		wget "$URL"	   
		if ! echo "$MD5SUM $CACHEFILE" | md5sum -c >/dev/null; then
			rm -f "$CACHEFILE"
			echo "Verification of $CACHEFILE Failed! MD5 mismatch!"
			exit 1
		fi
	fi
	
done
