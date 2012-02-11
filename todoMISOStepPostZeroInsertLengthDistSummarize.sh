#!/bin/bash

if [ $# -lt 1 ]; then
	echo $0 MISOSettingFile
	exit 1;
fi

MISOSettingFile=$1

source ${MISOSettingFile}

#misoRunSetting=`abspath.py $misoRunSetting`

#echo using miso run setting file $misoRunSetting

#now for each $targetBamFileBaseName file in tophat/* folder, use pe_util to calculate insert length
thisScriptDir=`pwd`

cd ..

rootDir=`pwd`

#cd $MISOPATH #run_event_analysis.py is now assumed to be in path

tophatOutputDir=$rootDir/$bamFileSubRoot

cd $tophatOutputDir

echo -e "SampleName\tMean\tStdev\tDispersion\tNumPairs"


for i in `ls -d *`; do
	if [ ! -e $i/$targetBamFileBaseName ]; then
		continue
	fi
	
	insertLenFile=$i/insert-dist/$targetBamFileBaseName.insert_len
	insertLenBash=$i/insert-dist/$targetBamFileBaseName.insert_len.shvar
	
	if [ ! -e $insertLenFile ]; then
		echo "insert length not computed for sample $i. Abort"
		exit 1;
	fi
	
	# #mean=156.2,sdev=44.3,dispersion=3.5,num_pairs=663518
	
	head -n 1 $insertLenFile | tr -d "#" | tr "," "\n" > $insertLenBash
	
	source $insertLenBash
	
	echo -e "$i\t$mean\t$sdev\t$dispersion\t${num_pairs}"
	
done	