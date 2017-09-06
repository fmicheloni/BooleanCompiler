#!/bin/bash

if [ $# -eq 0 ];
then
        echo "No parameters provided, use flag -h for a quick introduction on how to use the tool"
	exit 15
elif [ $# -eq 1 ];
then
        file=$1
elif [ $# -eq 2 ];
then
        file=$2
elif [ $# -eq 3 ];
then
        file=$3
elif [ $# -ge 4 ];
then
        echo "Unrecognized parameters, use flag -h for a quick introduction on how to use the tool"
	exit 16
fi

debug=false

while test $# -gt 0
do
	case "$1" in
	-h)
		echo "./start.sh [flag(s)] file"
		echo ""
		echo "file : file path to be passed to the Boolean Compiler"
		echo ""
		echo "flags :"
		echo "-d - activate debug mode"
		echo "-F - force recompiling before parsing"
		echo "-h - show this help message and quit"
		exit 0
		;;
        -d)
		echo "Debug mode active"
		debug=true
		;;
        -F)
		echo "Forcing source recompiling"
		bash build.sh
		;;
	-dF|-Fd)
		echo "Forcing source recompiling"
                bash build.sh
		echo "Debug mode active"
                debug=true
                ;;
        -*)
		echo "Unrecognized flag $1, use flag -h for a quick introduction on how to use the tool"
		exit 12
		;;
	esac
	shift
done

if [ -z $file ]
then
	echo "File argument missing, terminating (ERROR 122)"
	exit 122
fi

if [ ! -f $file ]
then
        echo "File not found (ERROR 107)"
        exit 107
fi

if [ -d dist/ ]
then
	if [ ! -f dist/boolcompiler.out ]
	then
		echo "Compilation not complete, restoring..."
		bash build.sh
	fi
else
	echo "Uncompiled, compiling..."
	bash build.sh
fi

echo "Starting..."
./dist/boolcompiler.out $file
exit 0
