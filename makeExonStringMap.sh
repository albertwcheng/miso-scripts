#!/bin/bash

if [ $# -lt 1 ]; then
	echo $0 MISOSettingFile
	exit
fi

MISOSettingFile=$1

source ${MISOSettingFile}

makeTranscriptExonStringFromGff.py ${rawGffFile} > ${exonStringMap}