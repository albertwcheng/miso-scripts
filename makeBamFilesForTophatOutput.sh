
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

#cd $MISOPATH 

for sampleDir in $tophatOutputDir/*; do



echo $sampleDir

if [ -e $sampleDir/accepted_hits.bam ]; then
	bsub bash $thisScriptDir/sortAndIndexBam.sh $sampleDir
else
	if [ ! -e $sampleDir/accepted_hits.sam ];  then
		continue
	fi
	bsub sam_to_bam.py --convert $sampleDir/accepted_hits.sam $sampleDir/ --ref ${genomeSizes}
fi

done