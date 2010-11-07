#!/bin/bash

forceOverwrite=0

if [ $# -gt 0 ]; then
   if [[ $1 == "-f" ]]; then
      forceOverwrite=1
   else
      echo $0 "[-f]"   
  fi
fi

for i in *.template; do
	
	untmpName=${i/.template/}
	echo -n untemplating $untmpName
	if [[ -e $untmpName ]] && [[ $forceOverwrite != 1 ]] ; then
		echo " not copied. existed already. Use untemplate -f to force overwrite"
	else
		echo " copied"
		cp $i $untmpName
	fi
	
done
	