
if [ $# -lt 1 ]; then
	echo $0 MISOSettingFile
	exit
fi

MISOSettingFile=$1

source $MISOSettingFile

thisScriptDir=`pwd`

cd ..

rootDir=`pwd`

tophatOutputDir=$rootDir/tophatOutput

for sampleDir in $tophatOutputDir/*; do

sampleName=`basename $sampleDir`

if [ ! -e $sampleDir/accepted_hits.sorted.bam ];  then
	continue
fi

cd $sampleDir
bam2wig.sh accepted_hits.sorted.bam ${sampleName} ${sampleName} "${sampleName} tophat mapping"
cd $rootDir

done