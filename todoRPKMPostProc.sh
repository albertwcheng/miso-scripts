#!/bin/bash

if [ $# -lt 1 ]; then
	echo $0 MISOSettingFile
	exit
fi

:<<'COMMENT'

...MISO_RPKM/sampleName/accepted_hits.sorted.bam.rpkm files:

[:::::			R 1			:::::]
Index			Excel			Field
-----			-----			-----
1			A			gene_id
2			B			rpkm
3			C			const_exon_lens
4			D			num_reads
[:::::			R 2			:::::]
Index			Excel			Field
-----			-----			-----
1			A			ENSMUSG00000028180
2			B			36.06
3			C			53,83,77,135,170
4			D			48,57,28,30,109


COMMENT

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

cd $MISOOutputDir/$sampleName

#now convert 
#from
# 1. GeneName
# 2. RPKM
# 3. Exon Lens (,)
# 4. Num Reads (,)
#to 
# 1. GeneName*
# 2. ExonLens 
# 3. TotalExonLen 
# 4. sample.NumReads 
# 5. sample.TotalNumReads
# 6. sample.RPKM 
######

rpkmOutFileName=${targetBamFileBaseName}.rpkm

awk -v FS="\t" -v OFS="\t" -v sampleName=$sampleName '{if(FNR==1){printf("GeneName\tExonLens\tTotalExonLen\t%s.NumReads\t%s.TotalNumReads\t%s.RPKM\n",sampleName,sampleName,sampleName);}else{RPKM=$2; exonLens=$3; split(exonLens,a,","); totalExonLen=0; for(i=1;i<=length(a);i++){totalExonLen+=a[i];}; numReads=$4; split(numReads,a,","); totalNumOfReads=0; for(i=1;i<=length(a);i++){totalNumOfReads+=a[i];}; $2=exonLens; $3=totalExonLen; $4=numReads; $5=totalNumOfReads; $6=RPKM; print;} }' $rpkmOutFileName > $rpkmOutFileName.table


done

cd $MISOOutputDir

multijoinu.sh "-1.GeneName,.ExonLens,.TotalExonLen -2.GeneName,.ExonLens,.TotalExonLen -f-"  combinedRPKM.table $MISOOutputDir/*/$rpkmOutFileName.table