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

cd $MISOPATH 

tophatOutputDir=$rootDir/$bamFileSubRoot
MISOOutputDir=$rootDir/${MISOOutSubRoot}/MISO_RPKM


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
command="python sam_rpkm.py --compute-rpkm ${rawGffFile} $sampleDir/${targetBamFileBaseName} $MISOOutputDir/$sampleName --read-len $readLen > $MISOOutputDir/$sampleName/$sampleName.rpkm.stdout 2> $MISOOutputDir/$sampleName/$sampleName.rpkm.stderr"

echo $command > $MISOOutputDir/$sampleName/qsub.sh
bsub bash $MISOOutputDir/$sampleName/qsub.sh


done