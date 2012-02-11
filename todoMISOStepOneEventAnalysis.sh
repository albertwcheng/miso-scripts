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

#cd $MISOPATH #run_event_analysis.py is now assumed to be in path

tophatOutputDir=$rootDir/$bamFileSubRoot
MISOOutputDir=$rootDir/${MISOOutSubRoot}/MISOOutput
MISOSummaryDir=$rootDir/${MISOOutSubRoot}/MISOSummary

#mkdir $MISOSummaryDir
mkdir $rootDir/${MISOOutSubRoot}
mkdir $MISOOutputDir


if [[ $readLen == "" ]]; then
	echo "readLen not specified. Abort"
	exit 1
fi


for sampleDir in $tophatOutputDir/*; do

sampleName=`basename $sampleDir`

if [ ! -e $sampleDir/${targetBamFileBaseName} ];  then
	continue
fi

#run_events_analysis.py --settings-filename /lab/solexa_jaenisch/Albert2/Lei/4AlbertFiltered/miso-scripts/miso_settings_burgeEvents.txt --compute-genes-psi /lab/jaenisch_albert/genomes/mm9/burgeLabEvents/mm9/pickled/SE /lab/solexa_jaenisch/Albert2/Lei/4AlbertFiltered/tophatOutput/pBAT/accepted_hits.sorted.bam --output-dir $outdir/pBAT --read-len 100 --paired-end 200 20 

mkdir $MISOOutputDir/$sampleName
#pwd

if [[ $useInsertLenStat == "yes" ]]; then
	if [ ! -e $sampleDir/insert-dist/$targetBamFileBaseName.insert_len.shvar ]; then
		echo "insert_len.shvar not exist for sample $sampleDir. Abort"
		echo "compute these using first todoMISOStepZeroInsertLengthDist.sh and then todoMISOStepPostZeroInsertLengthDistSummarize.sh"
		exit 1
	fi
	
	source $sampleDir/insert-dist/$targetBamFileBaseName.insert_len.shvar
	
	#now form the paired end flag
	
	echo using paired-end flag mean=$mean sdev=$sdev for sample $sampleName
	
	pairedEndFlag="--paired-end $mean $sdev"
	
	#continue
fi




command="run_events_analysis.py --settings-filename $misoRunSetting --compute-genes-psi ${eventGff} $sampleDir/${targetBamFileBaseName} --output-dir $MISOOutputDir/$sampleName --read-len $readLen $pairedEndFlag $clusterFlag > $MISOOutputDir/$sampleName/run_events_analysis.stdout 2> $MISOOutputDir/$sampleName/run_events_analysis.stderr"

echo $command > $MISOOutputDir/$sampleName/qsub.sh
bsub bash $MISOOutputDir/$sampleName/qsub.sh
#echo $command | qsub

done

