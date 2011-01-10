#!/bin/bash

:<<'COMMENT'
/lab/solexa_jaenisch4/Albert/mRNASeqLibs/ESC_EpiSC/miso-scripts$ colStat.py -r1,2 ../MISOOnPE_splidarEvents/MISOSummary/Alb_mEpiSCLib2/summary/Alb_mEpiSCLib2.miso_summary
[:::::			R 1			:::::]
Index			Excel			Field
-----			-----			-----
1			A			event_name
2			B			miso_posterior_mean
3			C			ci_low
4			D			ci_high
5			E			isoforms   x
6			F			counts     x
7			G			assigned_counts   x
[:::::			R 2			:::::]
Index			Excel			Field
-----			-----			-----
1			A			A5SS
2			B			0.28
3			C			0.08
4			D			0.46
5			E			'A5SS.Jak3andInsl3.10101@EXON1_A5SS.Jak3andInsl3.10101@EXON2','A5SS.Jak3andInsl3.10101@EXON3_A5SS.Jak3andInsl3.10101@EXON4'
6			F			(1,1):28
7			G			0:0,1:28

/lab/solexa_jaenisch4/Albert/mRNASeqLibs/ESC_EpiSC/miso-scripts$ colStat.py -r1,2 ../MISOOnPE_splidarEvents/MISOComparisons/Alb_mEpiSCLib2-Alb_mESCLib2/Alb_mEpiSCLib2_vs_Alb_mESCLib2/bayes-factors/Alb_mEpiSCLib2_vs_Alb_mESCLib2.miso_bf 
[:::::			R 1			:::::]
Index			Excel			Field
-----			-----			-----
1			A			event_name
2			B			sample1_posterior_mean
3			C			sample1_ci_low
4			D			sample1_ci_high
5			E			sample2_posterior_mean
6			F			sample2_ci_low
7			G			sample2_ci_high
8			H			diff                   
9			I			bayes_factor
10			J			isoforms
11			K			sample1_counts
12			L			sample1_assigned_counts
13			M			sample2_counts
14			N			sample2_assigned_counts
[:::::			R 2			:::::]
Index			Excel			Field
-----			-----			-----
1			A			A5SS.Jak3andInsl3.10101
2			B			0.28
3			C			0.08
4			D			0.46
5			E			0.29
6			F			0.10
7			G			0.47
8			H			-0.01
9			I			0.50
10			J			'A5SS.Jak3andInsl3.10101@EXON1_A5SS.Jak3andInsl3.10101@EXON2','A5SS.Jak3andInsl3.10101@EXON3_A5SS.Jak3andInsl3.10101@EXON4'
11			K			(1,1):28
12			L			0:0,1:28
13			M			(1,1):21
14			N			0:0,1:21


COMMENT


if [ $# -lt 1 ]; then
	echo $0 MISOSettingFile
	exit
fi

MISOSettingFile=$1

source ${MISOSettingFile}

thisScriptDir=`pwd`

cd ..

rootDir=`pwd`


tophatOutputDir=$rootDir/$bamFileSubRoot
MISOOutputDir=$rootDir/${MISOOutSubRoot}/MISOOutput
MISOSummaryDir=$rootDir/${MISOOutSubRoot}/MISOSummary
MISOComparisonsDir=$rootDir/${MISOOutSubRoot}/MISOComparisons


for sampleDir in $tophatOutputDir/*; do

sampleName=`basename $sampleDir`

if [ ! -e $sampleDir/${targetBamFileBaseName} ];  then
	continue
fi

cd $MISOSummaryDir/$sampleName/summary

#first remove all the quote marks
dequote.sh ${sampleName}.miso_summary > ${sampleName}.miso_summary.dq

#now extract the isform column
cuta.py -f.isoforms ${sampleName}.miso_summary.dq | awk -v FS="\t" -v OFS="\t" '{printf("%d\t%s\n",FNR,$0);}' > ${sampleName}.miso_summary.isoforms

#now dissociate
dissociateColValues.py -i, -s2 ${sampleName}.miso_summary.isoforms > ${sampleName}.miso_summary.isoforms.dissociated

#now map
joinu.py -1.isoforms -2.isoforms ${sampleName}.miso_summary.isoforms.dissociated ${rawGffFile/.gff/}.exonStringMap > ${sampleName}.miso_summary.isoforms.dissociated.2transcriptName

#now collapse
stickColValues.py --internalfs "," ${sampleName}.miso_summary.isoforms.dissociated.2transcriptName 1 | cut -f2,3 > ${sampleName}.miso_summary.isoforms.2transcriptName

joinu.py -1.isoforms -2.isoforms ${sampleName}.miso_summary.dq ${sampleName}.miso_summary.isoforms.2transcriptName > ${sampleName}.miso_summary.2transcriptName

python $thisScriptDir/correctMISOForSplidarEvents.py ${sampleName}.miso_summary.2transcriptName > ${sampleName}.miso_summary.splidarEvents.00

#now trim the unwnated fields
cuta.py -f.eventIDString,.miso_posterior_mean,.ci_low,.ci_high ${sampleName}.miso_summary.splidarEvents.00 > ${sampleName}.miso_summary.splidarEvents.tab

cd $rootDir



done


if [ -e $MISOComparisonsDir ]; then

for i in $MISOComparisonsDir/*/*/bayes-factors/*.miso_bf; do


#these are copied from above but modifying ${sampleName}.miso_summary to ${i}

dequote.sh ${i} > ${i}.dq

cuta.py -f.isoforms ${i}.dq | awk -v FS="\t" -v OFS="\t" '{printf("%d\t%s\n",FNR,$0);}' > ${i}.isoforms

#now dissociate
dissociateColValues.py -i, -s2 ${i}.isoforms > ${i}.isoforms.dissociated

#now map
joinu.py -1.isoforms -2.isoforms ${i}.isoforms.dissociated ${rawGffFile/.gff/}.exonStringMap > ${i}.isoforms.dissociated.2transcriptName

#now collapse
stickColValues.py --internalfs "," ${i}.isoforms.dissociated.2transcriptName 1 | cut -f2,3 > ${i}.isoforms.2transcriptName

joinu.py -1.isoforms -2.isoforms ${i}.dq ${i}.isoforms.2transcriptName > ${i}.2transcriptName

python $thisScriptDir/correctMISOForSplidarEvents.py ${i}.2transcriptName > ${i}.splidarEvents.00

#now trim the unwnated fields
cuta.py -f.eventIDString,.sample1_posterior_mean,.sample1_ci_low,.sample1_ci_high,.sample2_posterior_mean,.sample2_ci_low,.sample2_ci_high,.diff,.bayes_factor ${i}.splidarEvents.00 > ${i}.splidarEvents.tab


done

fi

