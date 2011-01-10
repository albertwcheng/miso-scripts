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
MISOComparisonsDir=$rootDir/${MISOOutSubRoot}/MISOComparisons

mkdir $MISOComparisonsDir


# summarize

for sampleDirx in $tophatOutputDir/*; do
sampleNamex=`basename $sampleDirx`
for sampleDiry in $tophatOutputDir/*; do
sampleNamey=`basename $sampleDiry`

if [[ $sampleNamex == $sampleNamey ]]; then
	continue
fi

echo "trying to compare sample $sampleNamex and $sampleNamey"

#continue

misoOutputDirPerSamplex=$MISOOutputDir/$sampleNamex
misoOutputDirPerSampley=$MISOOutputDir/$sampleNamey
misoComparisonsDirPerPairs=$MISOComparisonsDir/${sampleNamex}-${sampleNamey}

mkdir $misoComparisonsDirPerPairs

rm -f $misoComparisonsDirPerPairs/compare_samples.std*

#for prevOut in $misoComparisonsDirPerPairs/*.std*; do
#	bn=`basename $prevOut`
#	mv $prevOut $MISOOutputDir/$sampleName.$bn
#done

#rm -Rf $misoSummaryDirPerSample/summary
#rm -Rf $misoOutputDirPerSample/summary

python run_miso.py --compare-samples $misoOutputDirPerSamplex $misoOutputDirPerSampley $misoComparisonsDirPerPairs > $misoComparisonsDirPerPairs/compare_samples.stdout 2> $misoComparisonsDirPerPairs/compare_samples.stderr

done
done

#COMMENT