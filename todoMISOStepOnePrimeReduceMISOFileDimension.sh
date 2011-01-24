#!/bin/bash

if [ $# -lt 1 ]; then
	echo $0 MISOSettingFile
	exit
fi

MISOSettingFile=$1

source ${MISOSettingFile}


thisScriptDir=`pwd`

cd ..

rootDir=`pwd`

tophatOutputDir=$rootDir/$bamFileSubRoot
MISOOutputDir=$rootDir/${MISOOutSubRoot}/MISOOutput
MISOOutputReducedDir=$rootDir/${MISOOutSubRoot}/MISOOutput.reduced

mkdir $MISOOutputReducedDir



# reduce

for sampleDir in $tophatOutputDir/*; do

sampleName=`basename $sampleDir`
echo "trying to reduce sample $sampleName"

misoFileDir=$rootDir/$transcriptMISOOutput/$sampleName
events2TranscriptExonStringColFile=$event2TranscriptMap.exonString.col
outputMISODir=$MISOOutputReducedDir/$sampleName

mkdir $MISOOutputReducedDir/$sampleName

python $thisScriptDir/reduceMISOFileDimensions.py $misoFileDir $events2TranscriptExonStringColFile $outputMISODir  2> $MISOOutputReducedDir/$sampleName/reduction.stderr

done
