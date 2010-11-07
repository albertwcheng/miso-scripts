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

mkdir $MISOSummaryDir


# summarize

for sampleDir in $tophatOutputDir/*; do

sampleName=`basename $sampleDir`
echo "trying to summarize sample $sampleName"



misoOutputDirPerSample=$MISOOutputDir/$sampleName
misoSummaryDirPerSample=$MISOSummaryDir/$sampleName
mkdir $misoSummaryDirPerSample

rm -f $misoOutputDirPerSample/summarize_samples.std*
rm -f $misoSummaryDirPerSample/summarize_samples.std*

for prevOut in $misoOutputDirPerSample/*.std*; do
	bn=`basename $prevOut`
	mv $prevOut $MISOOutputDir/$sampleName.$bn
done

rm -Rf $misoSummaryDirPerSample/summary
rm -Rf $misoOutputDirPerSample/summary

python run_miso.py --settings-filename $misoRunSetting  --summarize-samples $misoOutputDirPerSample $misoSummaryDirPerSample > $misoSummaryDirPerSample/summarize_samples.stdout 2> $misoSummaryDirPerSample/summarize_samples.stderr

done

#COMMENT