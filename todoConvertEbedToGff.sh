#!/bin/bash

if [ $# -lt 1 ]; then
	echo $0 MISOSettingFile
	exit
fi

MISOSettingFile=$1

source ${MISOSettingFile}

misoRunSetting=`abspath.py $misoRunSetting`

echo using miso run setting file $misoRunSetting

ebedfile=$rawEbedFile
gffFile=$rawGffFile

sourceName=`basename $ebedfile`
sourceName=${sourceName/.ebed/}

ebed2GenePred.py $ebedfile > ${ebedfile/.ebed/}.genePred
RefGeneTable2sGFF3.py --source $sourceName --replace "_./" --with "@::" --input-is-gene-pred --expand-parents ${ebedfile/.ebed/}.genePred > $gffFile 
