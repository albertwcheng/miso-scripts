#!/bin/bash

if [ $# -lt 1 ]; then
	echo $0 MISOSettingFile
	exit
fi

MISOSettingFile=$1

source ${MISOSettingFile}

misoRunSetting=`abspath.py $misoRunSetting`

echo using miso run setting file $misoRunSetting


thisScriptDir=`pwd`

cd ..

rootDir=`pwd`

#cd $MISOPATH 
echo index_gff.py --index $rawGffFile $eventGff
index_gff.py --index $rawGffFile $eventGff #python -> use installed miso