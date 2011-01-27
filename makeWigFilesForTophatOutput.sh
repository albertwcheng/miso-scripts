
if [ $# -lt 1 ]; then
	echo $0 MISOSettingFile
	exit
fi

COLOR[1]="255,0,0"
COLOR[2]="0,255,0"
COLOR[3]="0,0,255"
COLOR[4]="255,255,0"
COLOR[5]="255,0,255"
COLOR[6]="0,255,255"
COLOR[7]="0,0,0"

MISOSettingFile=$1

source $MISOSettingFile

thisScriptDir=`pwd`

cd ..

rootDir=`pwd`

tophatOutputDir=$rootDir/tophatOutput

sampleI=0

for sampleDir in $tophatOutputDir/*; do

sampleI=`expr $sampleI + 1`

sampleName=`basename $sampleDir`

if [ ! -e $sampleDir/accepted_hits.sorted.bam ];  then
	continue
fi

cd $sampleDir
#bam2wig.sh accepted_hits.sorted.bam ${sampleName} ${sampleName} "${sampleName} tophat mapping"

thisColor=COLOR[sampleI]
if [[ thisColor == "" ]];
	thisColor=`awk 'BEGIN{srand();printf("%s,%s,%s\n",int(256*rand()),int(256*rand()),int(256*rand()));}'`;
fi

bam2Wig --rpkm-auto --log 10 --bedgraph-exact-end --pile-up --track-name $sampleName --track-description "$sampleName Log10 RPKM" --set color --with-value $thisColor  accepted_hits.sorted.bam > $sampleName.log10RPKM.wig


cd $rootDir

done