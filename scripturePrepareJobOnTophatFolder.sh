#!/bin/bash

if [ $# -lt 2 ]; then
	echo $0 sampleName paired [ 1 or 0 ]
	exit
fi

sampleName=$1
paired=$2


targetSam="accepted_hits.sam"
#according to scripture manual and examples

scriptDir=`pwd`

cd ..

rootDir=`pwd`




if [[ $paired == 1 ]]; then
	tophatOutputDir=${rootDir}/tophatOutput_paired
	scriptureOutputDir=${rootDir}/scriptureOutput_paired
else
	tophatOutputDir=${rootDir}/tophatOutput
	scriptureOutputDir=${rootDir}/scriptureOutput
fi


if [ ! -e $scriptureOutputDir ]; then
	mkdir $scriptureOutputDir
fi





#now sort individually
if [[ $paired == 1 ]]; then
	sampleNameL=${sampleName}_1
	sampleNameR=${sampleName}_2
	
	thisScripturePath=${scriptureOutputDir}/${sampleName}_paired  #path name to differentiate the unpaired ones
	mkdir $thisScripturePath
	
	

	#now remove @ and sort by readname
	sed '1,2d' ${tophatOutputDir}/${sampleNameL}/${targetSam} | sort > ${thisScripturePath}/sorted.1.sam
	sed '1,2d' ${tophatOutputDir}/${sampleNameR}/${targetSam} | sort > ${thisScripturePath}/sorted.2.sam
	
	#run scripture makePairedFile task
	scripture -task makePairedFile -pair1 ${thisScripturePath}/sorted.1.sam -pair2 ${thisScripturePath}/sorted.2.sam -out ${thisScripturePath}/paired.sam -sorted
	
else
	#single end data only
	thisScripturePath=${scriptureOutputDir}/${sampleName}
	mkdir $thisScripturePath
	
	sed '1,2d' ${tophatOutputDir}/${sampleName}/${targetSam} | sort > ${thisScripturePath}/sorted.sam
	
	#cannot run makePairedFile task
fi



	