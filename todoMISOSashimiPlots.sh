#!/usr/bin/bash

#first make the setting file by appending the $sashimiSetting with sample info

if [ $# -lt 3 ]; then
	echo $0 MISOSettingFile sampleOrdered"[sample1,sample2,…,sampleN]" toPlotEvents
	exit
fi

MISOSettingFile=$1
sampleOrdered=$2
toPlotEvents=$3

sampleOrdered=(`echo $sampleOrdered | tr "," "\n"`)

source ${MISOSettingFile}

if [[ $sashimiSetting == "" ]]; then
	echo sashimiSetting not set. abort
	exit 1
fi

#misoRunSetting=`abspath.py $misoRunSetting`

#echo using miso run setting file $misoRunSetting


thisScriptDir=`pwd`

cd ..

rootDir=`pwd`

#cd $MISOPATH #run_event_analysis.py is now assumed to be in path

tophatOutputDir=$rootDir/$bamFileSubRoot
MISOOutputDir=$rootDir/${MISOOutSubRoot}/MISOOutput
MISOSummaryDir=$rootDir/${MISOOutSubRoot}/MISOSummary

if [ ! -e $tophatOutputDir/flagstat.summary ]; then
	echo $tophatOutputDir/flagstat.summary required not exist. generate with bash tophatFlagStats.sh in RNASeqMappingScripts3
	exit 1
fi

tmpf=`tempfile`

echo "[data]" > $tmpf
echo bam_prefix = $tophatOutputDir/ >> $tmpf
echo miso_prefix = $MISOOutputDir/ >> $tmpf
echo bam_files = "[" >> $tmpf

cd $tophatOutputDir


#echo ${bamfiles[@]}
numSamples=${#sampleOrdered[@]}
numSamplesM1=`expr $numSamples - 1`

for((i=0;i<$numSamplesM1;i++)); do
	thisBamFile=${sampleOrdered[$i]}/${targetBamFileBaseName}
	echo -e "\t\"$thisBamFile\"," >> $tmpf
done
thisBamFile=${sampleOrdered[$numSamplesM1]}/${targetBamFileBaseName}
echo -e "\t\"$thisBamFile\" ]" >> $tmpf




cd $rootDir

cd $MISOOutputDir

echo miso_files = "[" >> $tmpf

for((i=0;i<$numSamplesM1;i++)); do
	thisMISOOut=${sampleOrdered[$i]}
	echo -e "\t\"$thisMISOOut\"," >> $tmpf
done
thisMISOOut=${sampleOrdered[$numSamplesM1]}
echo -e "\t\"$thisMISOOut\" ]" >> $tmpf


cd $rootDir

cd $thisScriptDir
cat $sashimiSetting >> $tmpf
toPlotEvents=(`cat $toPlotEvents`)

cd $rootDir

cd $tophatOutputDir

echo coverages = "[" >> $tmpf

for((i=0;i<$numSamplesM1;i++)); do
	thisNHitsFile=${sampleOrdered[$i]}/${targetBamFileBaseName}.nhits.txt
	read1Mapped=`tail -n 5 $thisNHitsFile | awk -v FS="\t" '$1=="TotalMapped"' | cut -f2`
	read2Mapped=`tail -n 5 $thisNHitsFile | awk -v FS="\t" '$1=="TotalMapped"' | cut -f3`
	thisCoverage=`expr $read1Mapped + $read2Mapped`
	echo -e "\t$thisCoverage," >> $tmpf
done

thisNHitsFile=${sampleOrdered[$numSamplesM1]}/${targetBamFileBaseName}.nhits.txt
read1Mapped=`tail -n 5 $thisNHitsFile | awk -v FS="\t" '$1=="TotalMapped"' | cut -f2`
read2Mapped=`tail -n 5 $thisNHitsFile | awk -v FS="\t" '$1=="TotalMapped"' | cut -f3`
thisCoverage=`expr $read1Mapped + $read2Mapped`
echo -e "\t$thisCoverage ]" >> $tmpf




cd $rootDir


cat $tmpf
#exit 0



for toPlotEvent in ${toPlotEvents[@]}; do
	echo plotting $toPlotEvent
	plot.py --plot-event "$toPlotEvent" $eventGff $tmpf --output-dir $rootDir/${MISOOutSubRoot}/sashimi
done