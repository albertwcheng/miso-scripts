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


if [ $# -ne 2 ]; then
	echo $0 MISOSettingFile "mode[normal|reduced]"
	exit
fi

MISOSettingFile=$1
mode=$2

source ${MISOSettingFile}

if [[ $splidarInfoFile == "" ]]; then 
	echo splidarInfoFile not set. Abort
	exit 1
fi


thisScriptDir=`pwd`

cd ..

rootDir=`pwd`


tophatOutputDir=$rootDir/$bamFileSubRoot
if [[ $mode == "normal" ]]; then
	echo remapToIsoformNames in the normal MISO mode
	MISOOutputDir=$rootDir/${MISOOutSubRoot}/MISOOutput
	MISOSummaryDir=$rootDir/${MISOOutSubRoot}/MISOSummary
	MISOComparisonsDir=$rootDir/${MISOOutSubRoot}/MISOComparisons
elif [[ $mode == "reduced" ]]; then
	echo summarizing the MISO full-transcript reduced to Splidar mode
	MISOOutputDir=$rootDir/${MISOOutSubRoot}/MISOOutput.reduced
	MISOSummaryDir=$rootDir/${MISOOutSubRoot}/MISOSummary.reduced
	MISOComparisonsDir=$rootDir/${MISOOutSubRoot}/MISOComparisons.reduced
else
	echo unknown summary mode $mode
	bash $0
	exit
fi

for sampleDir in $tophatOutputDir/*; do

sampleName=`basename $sampleDir`

if [ ! -e $sampleDir/${targetBamFileBaseName} ];  then
	continue
fi

cd $MISOSummaryDir/$sampleName/summary

echo working on summary for sample $sampleName

#first remove all the quote marks
dequote.sh ${sampleName}.miso_summary > ${sampleName}.miso_summary.dq

rawGffFileNoExt=${rawGffFile/.gff/}
rawGffFileNoExt=${rawGffFileNoExt/.GFF/}
rawGffFileNoExt=${rawGffFileNoExt/.gff3/}
rawGffFileNoExt=${rawGffFileNoExt/.GFF3/}


rmrie.sh ${sampleName}.miso_summary.splidarEvents.00
changeHeaderValueAtCol.sh ${sampleName}.miso_summary.dq 1 eventIDString > ${sampleName}.miso_summary.splidarEvents.00

joinu.py -1 .eventIDString -2 .eventIDString $splidarInfoFile ${sampleName}.miso_summary.splidarEvents.00 > ${sampleName}.miso_summary.splidarEvents.full

echo "Checking reverse join on splidarInfo. Should have no unmatched lines ${sampleName}.miso_summary.splidarEvents.00 against $splidarInfoFile"
joinu.py -w 2 -1 .eventIDString -2 .eventIDString  ${sampleName}.miso_summary.splidarEvents.00 $splidarInfoFile > /dev/null #making sure
echo "End of checking"

#now trim the unwnated fields
cuta.py -f.eventIDString,.eventType,.eventID,.locusName,.chr,.strand,.inc/excBound,.UCSCGenomeBrowser,.miso_posterior_mean,.ci_low,.ci_high ${sampleName}.miso_summary.splidarEvents.full > ${sampleName}.miso_summary.splidarEvents.tab

cd $rootDir



done


if [ -e $MISOComparisonsDir ]; then

for i in $MISOComparisonsDir/*/*/bayes-factors/*.miso_bf; do

echo working on comparison file $i
#these are copied from above but modifying ${sampleName}.miso_summary to ${i}

dequote.sh ${i} > ${i}.dq

rawGffFileNoExt=${rawGffFile/.gff/}
rawGffFileNoExt=${rawGffFileNoExt/.GFF/}
rawGffFileNoExt=${rawGffFileNoExt/.gff3/}
rawGffFileNoExt=${rawGffFileNoExt/.GFF3/}

changeHeaderValueAtCol.sh ${i}.dq 1 eventIDString > ${i}.splidarEvents.00

tpf=`tempfile`

joinu.py -1 .eventIDString -2 .eventIDString $splidarInfoFile ${i}.splidarEvents.00 | splitlines.py - 1 ${i}.splidarEvents.full,$tpf

colBayesFactor=`colSelect.py ${i}.splidarEvents.full .bayes_factor`

sort -k$colBayesFactor,$colBayesFactor -t$'\t' -g -r $tpf >> ${i}.splidarEvents.full

#now trim the unwnated fields
cuta.py -f.eventIDString,.eventType,.eventID,.locusName,.chr,.strand,.inc/excBound,.UCSCGenomeBrowser,.sample1_posterior_mean,.sample1_ci_low,.sample1_ci_high,.sample2_posterior_mean,.sample2_ci_low,.sample2_ci_high,.diff,.bayes_factor ${i}.splidarEvents.full > ${i}.splidarEvents.tab

python $thisScriptDir/MISOScripts.collapseMISOSplidarEventOnBFAndDiffByEGString.py ${i}.splidarEvents.full ${i}.splidarEvents.full.collapsed

done

fi

