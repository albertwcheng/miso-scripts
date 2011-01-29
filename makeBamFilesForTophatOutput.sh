
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

#echo $tophatOutputDir

cd $MISOPATH 

for sampleDir in $tophatOutputDir/*; do



echo $sampleDir

if [ -e $sampleDir/accepted_hits.bam ]; then
	samtools sort $sampleDir/accepted_hits.bam $sampleDir/accepted_hits.sorted
	samtools index  $sampleDir/accepted_hits.sorted.bam
else
	if [ ! -e $sampleDir/accepted_hits.sam ];  then
		continue
	fi
	bsub python sam_to_bam.py --convert $sampleDir/accepted_hits.sam $sampleDir/ --ref ${genomeSizes}
fi

done