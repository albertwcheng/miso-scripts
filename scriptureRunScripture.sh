#!/bin/bash

if [ $# -lt 3 ]; then
	echo $0 paired chromList chromFaDir
	exit
fi

paired=$1
chromList=$2
chromFaDir=$3


#load the chrom list
#/lab/jaenisch_albert/genomes/hg18/hg18_nr.sizes
#or
#/lab/jaenisch_albert/genomes/mm9/mm9_nr.sizes

#bsub bash scriptureRunScripture.sh 1 /lab/jaenisch_albert/genomes/mm9/mm9_nr.sizes /lab/jaenisch_albert/genomes/mm9/fa/byChr/


chroms=( `cut -f1 $chromList` )
echo There were ${#chroms[@]} chromosomes $chroms loaded from $chromList

scriptDir=`pwd`

cd ..

rootDir=`pwd`
tophatOutputDir=${rootDir}/tophatOutput

if [[ $paired == 1 ]]; then
	scriptureOutputDir=${rootDir}/scriptureOutput_paired
else
	scriptureOutputDir=${rootDir}/scriptureOutput
fi

#### old version ####
#tmpdir=$scriptureOutputDir/tmp

#if [ ! -e tmpdir ]; then
#	mkdir $tmpdir
#fi

############

#concatenate all alignment files
#cat $scriptureOutputDir/*/sorted*.sam > $scriptureOutputDir/all_alignments.sam  ###CHANGE BACK###CHANGE BACK###CHANGE BACK###CHANGE BACK###CHANGE BACK###CHANGE BACK

cd $scriptureOutputDir

###### old version #####
# use sort command of IGVTools to sort by start position
###
#echo "sort all_alignments.sam"
#igvtools sort -t $tmpdir all_alignments.sam all_alignments.sorted.sam
###

#use IGVTools to index the alignment file
#echo "index all_alignments.sorted.sam"
#igvtools index all_alignments.sorted.sam

#should now have all_alignments.sorted.sam and all_alignments.sorted.sam.sai

### end of old version ####

#use SamTools for BAM instead
echo "convert all_aligmnents.sam to all_aligments.bam"
samtools view -b -S -t $chromList -o all_alignments.bam all_alignments.sam

echo "sort all_alignments.bam as all_alignments.sorted.bam"
samtools sort all_alignments.bam all_alignments.sorted

echo "index all_alignments.sorted.bam as all_alignments.sorted.bam.bai"
samtools index all_alignments.sorted.bam


#should now have all_alignments.sorted.bam and all_alignments.sorted.bam.bai

if [[ $paired == 1 ]]; then
	#combined paired end alignment files
	#cat $scriptureOutputDir/*/paired.sam > all_alignments.paired.sam  ###CHANGE BACK###CHANGE BACK###CHANGE BACK###CHANGE BACK###CHANGE BACK###CHANGE BACK###CHANGE BACK
	
	##### old version #####
	#use sort command of IGV Tools to sort
	#echo "sort all_alignments.paired.sam"
	#igvtools sort -t $tmpdir all_alignments.paired.sam all_alignments.paired.sorted.sam
	
	#index
	#echo "index all_alignments.paired.sorted.sam"
	#igvtools index all_alignments.paired.sorted.sam
	
	#now we have all_alignments.paired.sorted.sam and all_alignments.paired.sorted.sam.sai
	####
	
	#use SamTools for BAM instead
	echo "convert all_alignments.paired.sam to all_alignments.paired.bam"
	samtools view -b -S -t $chromList -o all_alignments.paired.bam all_alignments.paired.sam
	
	echo "sort all_alignments.paired.bam as all_alignments.paired.sorted.bam"
	samtools sort all_alignments.paired.bam all_alignments.paired.sorted
	
	echo "index all_alignments.paired.sorted.bam as all_alignments.sorted.bam.bai"
	samtools index all_alignments.paired.sorted.bam
	
	#now we have all_alignments.paired.sorted.bam and all_alignments.paired.sorted.bam.bai

	
	
fi

#now we can run scripture
#do this for each chromosome

for chrom in ${chroms[@]}; do
echo submitting scripture segment task for chrom $chrom to cluster
	if [[ $paired == 1 ]]; then
		#bsub scripture -alignment all_alignments.sorted.sam -out $chrom.scriptureESTest.segments -sizeFile $chromList -chr $chrom -chrSequence $chromFaDir/${chrom}.fa -pairedEnd all_alignments.paired.sorted.sam
		 bsub scripture -alignment all_alignments.sorted.bam -out $chrom.scriptureESTest.segments -sizeFile $chromList -chr $chrom -chrSequence $chromFaDir/${chrom}.fa -pairedEnd all_alignments.paired.sorted.bam
	else
		#bsub scripture -alignment all_alignments.sorted.sam -out $chrom.scriptureESTest.segments -sizeFile $chromList -chr $chrom -chrSequence $chromFaDir/${chrom}.fa 
		bsub scripture -alignment all_alignments.sorted.bam -out $chrom.scriptureESTest.segments -sizeFile $chromList -chr $chrom -chrSequence $chromFaDir/${chrom}.fa 
	fi
done