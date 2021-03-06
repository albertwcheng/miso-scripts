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
	echo differential using the normal MISO mode
	MISOOutputDir=$rootDir/${MISOOutSubRoot}/MISOOutput
	MISOSummaryDir=$rootDir/${MISOOutSubRoot}/MISOSummary
	MISOComparisonsDir=$rootDir/${MISOOutSubRoot}/MISOComparisons
elif [[ $mode == "reduced" ]]; then
	echo differential using the MISO full-transcript reduced to Splidar mode
	MISOOutputDir=$rootDir/${MISOOutSubRoot}/MISOOutput.reduced
	MISOSummaryDir=$rootDir/${MISOOutSubRoot}/MISOSummary.reduced
	MISOComparisonsDir=$rootDir/${MISOOutSubRoot}/MISOComparisons.reduced	
else
	echo unknown summary mode $mode
	bash $0
	exit
fi	

mkdir $MISOComparisonsDir


# differential, all pairwise, all directions

for sampleDirx in $tophatOutputDir/*; do
sampleNamex=`basename $sampleDirx`
for sampleDiry in $tophatOutputDir/*; do
sampleNamey=`basename $sampleDiry`

if [[ $sampleNamex == $sampleNamey ]]; then
	continue
fi

echo "trying to compare sample $sampleNamex and $sampleNamey"



misoOutputDirPerSamplex=$MISOOutputDir/$sampleNamex
misoOutputDirPerSampley=$MISOOutputDir/$sampleNamey
misoComparisonsDirPerPairs=$MISOComparisonsDir/${sampleNamex}-${sampleNamey}

mkdir $misoComparisonsDirPerPairs

rm -f $misoComparisonsDirPerPairs/compare_samples.std*



echo "run_miso.py --compare-samples $misoOutputDirPerSamplex $misoOutputDirPerSampley $misoComparisonsDirPerPairs > $misoComparisonsDirPerPairs/compare_samples.stdout 2> $misoComparisonsDirPerPairs/compare_samples.stderr" | bsub

done
done

#COMMENT