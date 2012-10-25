#!/bin/bash

if [ $# -ne 2 ]; then
	echo $0 MISOSettingFile "mode[normal|reduced]"
	exit
fi

MISOSettingFile=$1
mode=$2

source ${MISOSettingFile}

misoRunSetting=`abspath.py $misoRunSetting`

echo using miso run setting file $misoRunSetting


thisScriptDir=`pwd`

cd ..

rootDir=`pwd`

#cd $MISOPATH 

tophatOutputDir=$rootDir/$bamFileSubRoot

if [[ $mode == "normal" ]]; then
	echo summarizing the normal MISO mode
	MISOOutputDir=$rootDir/${MISOOutSubRoot}/MISOOutput
	MISOSummaryDir=$rootDir/${MISOOutSubRoot}/MISOSummary
elif [[ $mode == "reduced" ]]; then
	echo summarizing the MISO full-transcript reduced to Splidar mode
	MISOOutputDir=$rootDir/${MISOOutSubRoot}/MISOOutput.reduced
	MISOSummaryDir=$rootDir/${MISOOutSubRoot}/MISOSummary.reduced
else
	echo unknown summary mode $mode
	bash $0
	exit
fi

echo "using MISOOutput folder $MISOOutputDir"
echo "output to MISOSummary folder $MISOSummaryDir"

mkdir $MISOSummaryDir


# summarize

for sampleDir in $tophatOutputDir/*; do

if [ ! -e $sampleDir/${targetBamFileBaseName} ];  then
	continue
fi

sampleName=`basename $sampleDir`
echo "trying to summarize sample $sampleName"



misoOutputDirPerSample=$MISOOutputDir/$sampleName
misoSummaryDirPerSample=$MISOSummaryDir/$sampleName
mkdir $misoSummaryDirPerSample

rm -f $misoOutputDirPerSample/summarize_samples.std*
rm -f $misoSummaryDirPerSample/summarize_samples.std*

#for prevOut in $misoOutputDirPerSample/*.std*; do
#	bn=`basename $prevOut`
#	mv $prevOut $MISOOutputDir/$sampleName.$bn
#done

rm -Rf $misoSummaryDirPerSample/summary
rm -Rf $misoOutputDirPerSample/summary

echo "run_miso.py --settings-filename $misoRunSetting  --summarize-samples $misoOutputDirPerSample $misoSummaryDirPerSample > $misoSummaryDirPerSample/summarize_samples.stdout 2> $misoSummaryDirPerSample/summarize_samples.stderr" | bsub

done

#COMMENT