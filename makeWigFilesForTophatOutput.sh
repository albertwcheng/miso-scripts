if [ $# -ne 2 ]; then
	echo $0 MISOSettingFile "HttpAddress[\"\" = don't make bw]"
	exit
fi

COLOR[1]="255,0,0"
COLOR[2]="0,255,0"
COLOR[3]="0,0,255"
COLOR[4]="188,143,143"
COLOR[5]="255,0,255"
COLOR[6]="0,255,255"
COLOR[7]="0,0,0"

MISOSettingFile=$1
HttpAddress=$2

source $MISOSettingFile

thisScriptDir=`pwd`

cd ..

rootDir=`pwd`

tophatOutputDir=$rootDir/tophatOutput



bigWigOutputDir=$rootDir/bigWigUploads

if [[ $HttpAddress != "" ]]; then
mkdir $bigWigOutputDir
fi

sampleI=0

for sampleDir in $tophatOutputDir/*; do

sampleI=`expr $sampleI + 1`

sampleName=`basename $sampleDir`

if [ ! -e $sampleDir/accepted_hits.sorted.bam ] && [ ! -e $sampleDir/coverage.wig ];  then
	continue
fi

cd $sampleDir
#bam2wig.sh accepted_hits.sorted.bam ${sampleName} ${sampleName} "${sampleName} tophat mapping"

thisColor=${COLOR[$sampleI]}
if [[ thisColor == "" ]]; then
	thisColor=`awk 'BEGIN{srand();printf("%s,%s,%s\n",int(256*rand()),int(256*rand()),int(256*rand()));}'`;
fi

#bam2Wig --rpkm-auto --log 10 --pile-up --track-name $sampleName --track-description "$sampleName Log10 RPKM" --set color --with-value $thisColor  accepted_hits.sorted.bam > $sampleName.log10RPKM.wig #--bedgraph-exact-end 
#gzip < $sampleName.log10RPKM.wig > $sampleName.log10RPKM.wig.gz

#now let's make a track header
#if [ ! -e accepted_hits.sorted.bam.flagstat ]; then

#fi


if [[ $HttpAddress != "" ]]; then
tmName=`mktemp`
randSuffix=`basename $tmName`
fi

if [ -e coverage.wig ]; then
	bedGraphUsed=1
    samtools flagstat accepted_hits.sorted.bam > accepted_hits.sorted.bam.flagstat
    numOfReads=`awk -v FS=" " '{if(FNR==4 && $2=="mapped"){printf("%s\n",$1);}}' accepted_hits.sorted.bam.flagstat`
	echo "coverage.wig exists. Using it"
awk -v FS="\t" -v OFS="\t" -v numOfReads=$numOfReads '{if(FNR>1 && $2<$3 ){$4=$4*1000000.0/numOfReads; print;}}' coverage.wig > ${sampleName}.RPM.wig
else
	bedGraphUsed=0
	echo "coverage.wig does not exist. Use bam2Wig"
	bam2Wig --no-header --no-comment --rpm-auto accepted_hits.sorted.bam > ${sampleName}.RPM.wig
fi

if [[ $HttpAddress != "" ]]; then
	if [[ $bedGraphUsed == 1 ]]; then
		bedGraphToBigWig  ${sampleName}.RPM.wig $genomeSizes ${sampleName}.RPM.wig.bw
	else
		wigToBigWig  ${sampleName}.RPM.wig $genomeSizes ${sampleName}.RPM.wig.bw
	fi

rm -f $bigWigOutputDir/${sampleName}-*.RPM.wig.bw
mv ${sampleName}.RPM.wig.bw $bigWigOutputDir/${sampleName}-${randSuffix}.RPM.wig.bw
echo "track type=bigWig name=\"$sampleName.RPM\" description=\"RPM of $sampleName\" bigDataUrl=$HttpAddress/${sampleName}-${randSuffix}.RPM.wig.bw visibility=Full color=$thisColor alwaysZero=On" > $sampleName.RPM.bwlink.wig
echo "#number of reads: $numOfReads Unit: RPM=read*1000000/numOfReadsMapped" >> $sampleName.RPM.bwlink.wig
cp $sampleName.RPM.bwlink.wig $bigWigOutputDir/
fi

gzip -f ${sampleName}.RPM.wig


#log2(x+1)
if [ -e coverage.wig ]; then
	awk -v FS="\t" -v OFS="\t" -v numOfReads=$numOfReads 'BEGIN{logb=log(2)}{if(FNR>1 && $2<$3 ){$4=log($4*1000000.0/numOfReads+1)/logb; print;}}' coverage.wig > ${sampleName}.RPM.l2x1.wig
else
	bam2Wig --no-header --no-comment --rpm-auto --log 2 accepted_hits.sorted.bam > ${sampleName}.RPM.l2x1.wig
fi

if [[ $HttpAddress != "" ]]; then
	if [[ $bedGraphUsed == 1 ]]; then
		bedGraphToBigWig  ${sampleName}.RPM.l2x1.wig $genomeSizes ${sampleName}.RPM.l2x1.wig.bw
	else
		wigToBigWig  ${sampleName}.RPM.l2x1.wig $genomeSizes ${sampleName}.RPM.l2x1.wig.bw
	fi
	
rm -f  $bigWigOutputDir/${sampleName}-*.RPM.l2x1.wig.bw
mv ${sampleName}.RPM.l2x1.wig.bw $bigWigOutputDir/${sampleName}-${randSuffix}.RPM.l2x1.wig.bw
echo "track type=bigWig name=\"$sampleName.log2(RPM+1)\" description=\"log2(RPM+1) of $sampleName\" bigDataUrl=$HttpAddress/${sampleName}-${randSuffix}.RPM.l2x1.wig.bw visibility=Full color=$thisColor alwaysZero=On" > $sampleName.RPM.l2x1.bwlink.wig
echo "#number of reads: $numOfReads Unit: log2(RPM+1) RPM=read*1000000/numOfReadsMapped" >> $sampleName.RPM.l2x1.bwlink.wig
cp $sampleName.RPM.l2x1.bwlink.wig $bigWigOutputDir/
fi

gzip -f ${sampleName}.RPM.l2x1.wig

rm $tmName

cd $rootDir

done