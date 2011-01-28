if [ $# -ne 2 ]; then
	echo $0 MISOSettingFile HttpAddress
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
HttpAddress=$2

source $MISOSettingFile

thisScriptDir=`pwd`

cd ..

rootDir=`pwd`

tophatOutputDir=$rootDir/tophatOutput
bigWigOutputDir=$rootDir/bigWigUploads

mkdir $bigWigOutputDir

sampleI=0

for sampleDir in $tophatOutputDir/*; do

sampleI=`expr $sampleI + 1`

sampleName=`basename $sampleDir`

if [ ! -e $sampleDir/accepted_hits.sorted.bam ];  then
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
samtools flagstat accepted_hits.sorted.bam > accepted_hits.sorted.bam.flagstat
#fi

numOfReads=`awk -v FS=" " '{if(FNR==4 && $2=="mapped"){printf("%s\n",$1);}}' accepted_hits.sorted.bam.flagstat`

tmName=`mktemp`
randSuffix=`basename $tmName`


awk -v FS="\t" -v OFS="\t" -v numOfReads=$numOfReads '{if(FNR>1 && $2<$3 ){$4=$4*1000000.0/numOfReads; print;}}' coverage.wig > ${sampleName}.RPM.wig
bedGraphToBigWig  ${sampleName}.RPM.wig $genomeSizes ${sampleName}.RPM.wig.bw
rm -f $bigWigOutputDir/${sampleName}-*.RPM.wig.bw
mv ${sampleName}.RPM.wig.bw $bigWigOutputDir/${sampleName}-${randSuffix}.RPM.wig.bw
echo "track type=bigWig name=\"$sampleName.RPM\" description=\"RPM of $sampleName\" bigDataUrl=$HttpAddress/${sampleName}-${randSuffix}.RPM.wig.bw visibility=Full color=$thisColor alwaysZero=On" > $sampleName.RPM.bwlink.wig
echo "#number of reads: $numOfReads Unit: RPM=read*1000000/numOfReadsMapped" >> $sampleName.RPM.bwlink.wig
cp $sampleName.RPM.bwlink.wig $bigWigOutputDir/

#log2(x+1)
awk -v FS="\t" -v OFS="\t" -v numOfReads=$numOfReads 'BEGIN{logb=log(2)}{if(FNR>1 && $2<$3 ){$4=log($4*1000000.0/numOfReads+1)/logb; print;}}' coverage.wig > ${sampleName}.RPM.l2x1.wig
bedGraphToBigWig  ${sampleName}.RPM.l2x1.wig $genomeSizes ${sampleName}.RPM.l2x1.wig.bw
rm -f  $bigWigOutputDir/${sampleName}-*.RPM.l2x1.wig.bw
mv ${sampleName}.RPM.l2x1.wig.bw $bigWigOutputDir/${sampleName}-${randSuffix}.RPM.l2x1.wig.bw
echo "track type=bigWig name=\"$sampleName.log2(RPM+1)\" description=\"log2(RPM+1) of $sampleName\" bigDataUrl=$HttpAddress/${sampleName}-${randSuffix}.RPM.l2x1.wig.bw visibility=Full color=$thisColor alwaysZero=On" > $sampleName.RPM.l2x1.bwlink.wig
echo "#number of reads: $numOfReads Unit: log2(RPM+1) RPM=read*1000000/numOfReadsMapped" >> $sampleName.RPM.l2x1.bwlink.wig
cp $sampleName.RPM.l2x1.bwlink.wig $bigWigOutputDir/



rm $tmName

cd $rootDir

done