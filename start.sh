#!/bin/bash

if [ -z $1 ]
then
	echo "File argument missing, terminating (ERROR 122)"
	exit 122
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
./dist/boolcompiler.out $1
exit 0
