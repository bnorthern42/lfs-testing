#!/bin/bash


for p in m4 ncurses bash coreutils diffutils file findutils gawk grep gzip make patch sed tar xz binutils gcc; do 
	touch ${p}.sh;
done
