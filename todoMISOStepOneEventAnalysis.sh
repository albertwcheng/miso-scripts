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

cd $MISOPATH 

tophatOutputDir=$rootDir/$bamFileSubRoot
MISOOutputDir=$rootDir/${MISOOutSubRoot}/MISOOutput
MISOSummaryDir=$rootDir/${MISOOutSubRoot}/MISOSummary

#mkdir $MISOSummaryDir
mkdir $rootDir/${MISOOutSubRoot}
mkdir $MISOOutputDir

for sampleDir in $tophatOutputDir/*; do

sampleName=`basename $sampleDir`

if [ ! -e $sampleDir/${targetBamFileBaseName} ];  then
	continue
fi

mkdir $MISOOutputDir/$sampleName
#pwd
command="python run_events_analysis.py --settings-filename $misoRunSetting --compute-genes-psi ${eventGff} $sampleDir/${targetBamFileBaseName} --output-dir $MISOOutputDir/$sampleName --read-len $readLen $pairedEndFlag $clusterFlag > $MISOOutputDir/$sampleName/run_events_analysis.stdout 2> $MISOOutputDir/$sampleName/run_events_analysis.stderr"

echo $command > $MISOOutputDir/$sampleName/qsub.sh
bsub bash $MISOOutputDir/$sampleName/qsub.sh
#echo $command | qsub

done

