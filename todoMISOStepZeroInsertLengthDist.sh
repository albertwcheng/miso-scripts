#!/bin/bash

if [ $# -lt 1 ]; then
	echo $0 MISOSettingFile
	exit
fi

MISOSettingFile=$1

source ${MISOSettingFile}

misoRunSetting=`abspath.py $misoRunSetting`

echo using miso run setting file $misoRunSetting

if [[ $constExonGff == "" ]]; then
	echo "Error: ConstExonGff not specified"
	exit
fi

if [ ! -e $constExonGff ]; then
	echo "Error: ConstExonGff=$constExonGff does not exist. Please construct these using exon_utils descripted in MISO documentation"
	exit
fi

#now for each $targetBamFileBaseName file in tophat/* folder, use pe_util to calculate insert length
thisScriptDir=`pwd`

cd ..

rootDir=`pwd`

#cd $MISOPATH #run_event_analysis.py is now assumed to be in path

tophatOutputDir=$rootDir/$bamFileSubRoot

cd $tophatOutputDir

for i in `ls -d *`; do
	if [ ! -e $i/$targetBamFileBaseName ]; then
		continue
	fi

	bsub pe_utils.py --compute-insert-len $i/$targetBamFileBaseName $constExonGff --output-dir $i/insert-dist
done	