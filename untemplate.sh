#!/bin/bash

for i in *.template; do
	
	untmpName=${i/.template/}
	echo -n untemplating $untmpName
	if [ -e $untmpName ]; then
		echo " not copied. existed already. Use untemplate -f to force overwrite"
	else
		echo " copied"
		cp $i $untmpName
	fi
	
done
	