#!/bin/bash

CHAPTER="$1"
PACKAGE="$2"
SPECIAL="$3"


#if [[ "$PACKAGE" == *"lah"* ]]; then
#	echo "\n*************************************** "
#	echo "\nRunning Script $PACKAGE\n"
#		pushd /gcc
#		if ! source "./chapter$CHAPTER/$PACKAGE.sh" 2>&1 | tee "../log/chapter$CHAPTER/$PACKAGE.log"; then
#			echo "Compiling $PACKAGE FAILED!"
#			exit 1
#		fi
#fi 

echo "DEBUG: pckg: $PACKAGE"
if [ "$SPECIAL" == "FALSE" ]; then
 cat packages.csv |grep -i "^$PACKAGE;"| grep -i -v "\.patch;" | while read line; do
       # NAME="`echo $line | cut -d\; -f1`"
	    export VERSION="`echo $line | cut -d\; -f2`"
        URL="`echo $line | cut -d\; -f3 | sed 's/@/'$VERSION'/g'`"
       # MD5SUM="`echo $line | cut -d\; -f4`"
        CACHEFILE="$(basename "$URL")"
		DIRNAME="$(echo "$CACHEFILE"| sed 's/\(.*\)\.tar\..*/\1/')"

		if [ -d "$DIRNAME" ]; then
			rm -rf "$DIRNAME"
		fi
		
       	mkdir -pv "$DIRNAME"
		       	
       	echo "Extracting $CACHEFILE"
       	tar -xf "$CACHEFILE" -C "$DIRNAME"

		pushd "$DIRNAME"

		#if dir has only one dir where we extract for example bob.zip becomes bob/bob/... then it will move /... stuff to bob/...
       	if [ "$(ls -1A | wc -l)" == "1" ]; then
       		mv $(ls -1A)/* ./ 
		fi
		echo "\n*************************************** "
		echo "\nCompiling $PACKAGE\n"
		
		# Sanity Check
		sleep 7
		mkdir -pv "../log/chapter$CHAPTER/"
		
		if ! source "../chapter$CHAPTER/$PACKAGE.sh" 2>&1 | tee "../log/chapter$CHAPTER/$PACKAGE.log"; then
			echo "Compiling $PACKAGE FAILED!"
			popd
			exit 1
		fi
		
		echo "Done Compiling $PACKAGE"
      popd 	                                
done
fi

if [ "$SPECIAL" == "TRUE" ]; then
 	    #Special case since libstdc++ uses the gcc source but 
  		#needs to be un'tar'd' to a different source directory

  		# v2.0 essentially: see 5.6 "note"
  cat packages.csv |grep -i "^$PACKAGE;"| grep -i -v "\.patch;" | while read line; do
  if [ "$PACKAGE" == "gcc" ]; then
		echo "HELLO WORLD"	
        export VERSION="`echo $line | cut -d\; -f2`"
        URL="`echo $line | cut -d\; -f3 | sed 's/@/'$VERSION'/g'`"
       # MD5SUM="`echo $line | cut -d\; -f4`"
        CACHEFILE="$(basename "$URL")"
		DIRNAME="$(echo "$CACHEFILE"| sed 's/\(.*\)\.tar\..*/\1/')"
		
		#DIRNAME="gcc-B"
		if [ -d "$DIRNAME" ]; then
		   rm -rf "$DIRNAME"
		fi
				
       	mkdir -pv "$DIRNAME"
       	echo "CF:$CACHEFILE"
       	echo "Extracting $CACHEFILE to: $DIRNAME"
       	tar -xf "$CACHEFILE" -C "$DIRNAME"
		pushd "$DIRNAME"
			
		
		#if dir has only one dir where we extract for example bob.zip becomes bob/bob/... then it will move /... stuff to bob/...
       	if [ "$(ls -1A | wc -l)" == "1" ]; then
       		mv $(ls -1A)/* ./ 
		fi
		echo "\n*************************************** "
		echo "\nCompiling libstdc++\n"
		
		# Sanity Check
		sleep 7
		mkdir -pv "../log/chapter$CHAPTER/"
		
		if ! source "../chapter$CHAPTER/libstdc++.sh" 2>&1 | tee "../log/chapter$CHAPTER/libstd$PACKAGE.log"; then
			echo "Compiling libstdc++ in $PACKAGE FAILED!"
			popd
			exit 1
		fi
		
		echo "Done Compiling libstdc++ in $PACKAGE"
  fi
	
	
      popd
  done
fi
