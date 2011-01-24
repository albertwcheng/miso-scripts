#!/bin/bash

if [ $# -lt 1 ]; then
	echo $0 MISOSettingFile
	exit
fi

MISOSettingFile=$1

source ${MISOSettingFile}

if [ -e $transcrriptExonStringMap ]; then
	echo transcrriptExonStringMap "existed as" $transcrriptExonStringMap
else
	echo make transcript exon string from gff
	makeTranscriptExonStringFromGff.py ${transcriptGff} > ${transcrriptExonStringMap}
fi

cat $rawEbedFile | tr " " "\t" > $rawEbedFile.tabbed

Splidar.Splicing.matchEventToTranscript.py $rawEbedFile.tabbed $transcriptEbed > ${event2TranscriptMap}

cuta.py -f4 $rawEbedFile.tabbed | awk '($0!~/track/){split($0,a,"."); printf("%s",a[1]); for(i=2;i<length(a);i++){ printf(".%s",a[i]);} printf("\n"); }' | tr "." ":" | tr "_" "@" | tr "/" ":" | sort | uniq > $rawEbedFile.tabbed.colonID


cat ${event2TranscriptMap} | tr "." ":" | tr "/" ":" | tr "_" "@" > ${event2TranscriptMap}.colon

joinu.py -1 2 -2 1 ${event2TranscriptMap}.colon ${transcrriptExonStringMap} > ${event2TranscriptMap}.exonString

stickColValues.py --printlino 10000 --internalfs , ${event2TranscriptMap}.exonString 1 > ${event2TranscriptMap}.exonString.col

cuta.py -f3 ${event2TranscriptMap}.exonString | sort | uniq > chroms.00

chroms=( `cat chroms.00` )

for chrom in ${chroms[@]}; do
	echo "working on chrom $chrom"
	awk -v FS="\t" -v OFS="\t" -v chrom=$chrom '($3==chrom)' ${event2TranscriptMap}.exonString > ${event2TranscriptMap}.exonString.$chrom
	wc -l ${event2TranscriptMap}.exonString.$chrom
	stickColValues.py --printlino 10000 --internalfs , ${event2TranscriptMap}.exonString.$chrom 1 > ${event2TranscriptMap}.exonString.$chrom.col
done

echo "now combine all chromosomes"

ls ${event2TranscriptMap}.exonString.*.col

cat ${event2TranscriptMap}.exonString.*.col > ${event2TranscriptMap}.exonString.col

rm ${event2TranscriptMap}.exonString.*.col 

cuta.py -f4 $rawEbedFile.tabbed | tr "." ":" | tr "_" "@" | tr "/" ":" | grep ":" > $rawEbedFile.tabbed.colonID

cuta.py -f1 ${event2TranscriptMap}.exonString.col > ${event2TranscriptMap}.exonString.col.colonID

subtractSets.py  $rawEbedFile.tabbed.colonID ${event2TranscriptMap}.exonString.col.colonID > ${event2TranscriptMap}.exonString.col.notmapped.colonID

rm ${event2TranscriptMap}.exonString.col.colonID
rm  $rawEbedFile.tabbed.colonID