#!/bin/bash
# Simple script to list version numbers of critical development tools
export LC_ALL=C
	bash --version | head -n1 | cut -d" " -f2-4
	MYSH=$(readlink -f /bin/sh)
	echo "/bin/sh -> $MYSH"
	echo $MYSH | grep -q bash || echo "ERROR: /bin/sh does not point to bash"
	unset MYSH
	echo -n "Binutils: "; ld --version | head -n1 | cut -d" " -f3-
	bison --version | head -n1
	if [ -h /usr/bin/yacc ]; then
		echo "/usr/bin/yacc -> `readlink -f /usr/bin/yacc`";
	elif [ -x /usr/bin/yacc ]; then
		echo yacc is `/usr/bin/yacc --version | head -n1`
	else
		echo "yacc not found"
	fi

	bzip2 --version 2>&1 < /dev/null | head -n1 | cut -d" " -f1,6-
	echo -n "Coreutils: "; chown --version | head -n1 | cut -d")" -f2
	diff --version | head -n1
	find --version | head -n1
	gawk --version | head -n1

	if [ -h /usr/bin/awk ]; then
		echo "/usr/bin/awk -> `readlink -f /usr/bin/awk`";
	elif [ -x /usr/bin/awk ]; then
		echo awk is `/usr/bin/awk --version | head -n1`
	else
		echo "awk not found"
	fi

	
