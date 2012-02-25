#!/bin/bash

:<<'COMMENT'

cheng@tak /lab/solexa_jaenisch4/Albert/mRNASeqLibs/ESC_EpiSC/MISOOnPE_splidarEvents/MISOComparisons/Alb_mEpiSCLib2-Alb_mESCLib2/Alb_mEpiSCLib2_vs_Alb_mESCLib2/bayes-factors$ colStat.py -r1,2 *.tab
[:::::			R 1			:::::]
Index			Excel			Field
-----			-----			-----
1			A			eventIDString
2			B			sample1_posterior_mean
3			C			sample1_ci_low
4			D			sample1_ci_high
5			E			sample2_posterior_mean
6			F			sample2_ci_low
7			G			sample2_ci_high
8			H			diff
9			I			bayes_factor
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



COMMENT

if [ $# -ne 2 ]; then
	echo $0 MISOSettingFile "mode[normal|reduced]"
	exit
fi

MISOSettingFile=$1
mode=$2

source ${MISOSettingFile}

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


if [ ! -e $MISOComparisonsDir ]; then
	echo $MISOComparisonsDir not exists. Abort
	exit;
fi

theAwkProgram='function abs(x){if(x<0){return -x;}return x;}{split($eventIDStringCol,a,"."); if((a[1]==eventType && abs($dPsiCol)>=dPsiCutOff && $bayesFactorCol>=bfThreshold )  || FNR==1){print;}}'

for misobfFilename in $MISOComparisonsDir/*/*/bayes-factors/*.miso_bf.splidarEvents.tab; do

bnMISOBFFILENAME=`basename $misobfFilename` #Alb_mEpiSCLib2_vs_Alb_mESCLib2.miso_bf.splidarEvents.tab
comparisonName=${bnMISOBFFILENAME/.miso_bf.splidarEvents.tab/} #Alb_mEpiSCLib2_vs_Alb_mESCLib2
parentDir=`absdirname.py $misobfFilename` #/lab/solexa_jaenisch4/Albert/mRNASeqLibs/ESC_EpiSC/MISOOnPE_splidarEvents/MISOComparisons/Alb_mEpiSCLib2-Alb_mESCLib2/Alb_mEpiSCLib2_vs_Alb_mESCLib2/bayes-factors
	
	
	for splidarEventType in ${splidarEventTypes[@]}; do
		echo making $splidarEventType for comparison ${comparisonName}
		thisEventTypeFolder=${parentDir}/${splidarEventType} #/lab/solexa_jaenisch4/Albert/mRNASeqLibs/ESC_EpiSC/MISOOnPE_splidarEvents/MISOComparisons/Alb_mEpiSCLib2-Alb_mESCLib2/Alb_mEpiSCLib2_vs_Alb_mESCLib2/bayes-factors/SE/
		mkdir $thisEventTypeFolder
		
		eventIDStringCol=`colSelect.py ${misobfFilename} .eventIDString`
		dPsiCol=`colSelect.py ${misobfFilename} .diff`
		bayesFactorCol=`colSelect.py ${misobfFilename} .bayes_factor`

		misobfFilenameFull=${misobfFilename/.tab/}.full
		eventIDStringColFull=`colSelect.py ${misobfFilenameFull} .eventIDString`
		dPsiColFull=`colSelect.py ${misobfFilenameFull} .diff`
		bayesFactorColFull=`colSelect.py ${misobfFilenameFull} .bayes_factor`
		
		awk -v FS="\t" -v OFS="\t" -v eventType=${splidarEventType} -v eventIDStringCol=$eventIDStringCol -v dPsiCol=$dPsiCol -v dPsiCutOff=0.0 -v bayesFactorCol=$bayesFactorCol -v bfThreshold=0.0 'function abs(x){if(x<0){return -x;}return x;}{split($eventIDStringCol,a,"."); if((a[1]==eventType && abs($dPsiCol)>=dPsiCutOff && $bayesFactorCol>=bfThreshold )  || FNR==1){print;}}' ${misobfFilename} > ${thisEventTypeFolder}/${comparisonName}.${splidarEventType}.miso_bf.splidarEvents.tab
		
		awk -v FS="\t" -v OFS="\t" -v eventType=${splidarEventType} -v eventIDStringCol=$eventIDStringColFull -v dPsiCol=$dPsiColFull -v dPsiCutOff=0.0 -v bayesFactorCol=$bayesFactorColFull -v bfThreshold=0.0 'function abs(x){if(x<0){return -x;}return x;}{split($eventIDStringCol,a,"."); if((a[1]==eventType && abs($dPsiCol)>=dPsiCutOff && $bayesFactorCol>=bfThreshold )  || FNR==1){print;}}' $misobfFilenameFull > ${thisEventTypeFolder}/${comparisonName}.${splidarEventType}.miso_bf.splidarEvents.full
		
		for bfThreshold in ${bfThresholds[@]}; do
			awk -v FS="\t" -v OFS="\t" -v eventType=${splidarEventType} -v eventIDStringCol=$eventIDStringCol -v dPsiCol=$dPsiCol -v dPsiCutOff=0.0 -v bayesFactorCol=$bayesFactorCol -v bfThreshold=${bfThreshold} 'function abs(x){if(x<0){return -x;}return x;}{split($eventIDStringCol,a,"."); if((a[1]==eventType && abs($dPsiCol)>=dPsiCutOff && $bayesFactorCol>=bfThreshold )  || FNR==1){print;}}' ${misobfFilename} > ${thisEventTypeFolder}/${comparisonName}.${splidarEventType}.bf${bfThreshold}.miso_bf.splidarEvents.tab
			
			awk -v FS="\t" -v OFS="\t" -v eventType=${splidarEventType} -v eventIDStringCol=$eventIDStringColFull -v dPsiCol=$dPsiColFull -v dPsiCutOff=0.0 -v bayesFactorCol=$bayesFactorColFull -v bfThreshold=${bfThreshold} 'function abs(x){if(x<0){return -x;}return x;}{split($eventIDStringCol,a,"."); if((a[1]==eventType && abs($dPsiCol)>=dPsiCutOff && $bayesFactorCol>=bfThreshold )  || FNR==1){print;}}' $misobfFilenameFull > ${thisEventTypeFolder}/${comparisonName}.${splidarEventType}.bf${bfThreshold}.miso_bf.splidarEvents.full
			
			for dPsiCutOff in ${dPsiCutOffs[@]}; do
				awk -v FS="\t" -v OFS="\t" -v eventType=${splidarEventType} -v eventIDStringCol=$eventIDStringCol -v dPsiCol=$dPsiCol -v dPsiCutOff=${dPsiCutOff} -v bayesFactorCol=$bayesFactorCol -v bfThreshold=${bfThreshold} 'function abs(x){if(x<0){return -x;}return x;}{split($eventIDStringCol,a,"."); if((a[1]==eventType && abs($dPsiCol)>=dPsiCutOff && $bayesFactorCol>=bfThreshold )  || FNR==1){print;}}' ${misobfFilename} > ${thisEventTypeFolder}/${comparisonName}.${splidarEventType}.bf${bfThreshold}.dPsi${dPsiCutOff}.miso_bf.splidarEvents.tab
							
				awk -v FS="\t" -v OFS="\t" -v eventType=${splidarEventType} -v eventIDStringCol=$eventIDStringColFull -v dPsiCol=$dPsiColFull -v dPsiCutOff=${dPsiCutOff} -v bayesFactorCol=$bayesFactorColFull -v bfThreshold=${bfThreshold} 'function abs(x){if(x<0){return -x;}return x;}{split($eventIDStringCol,a,"."); if((a[1]==eventType && abs($dPsiCol)>=dPsiCutOff && $bayesFactorCol>=bfThreshold )  || FNR==1){print;}}' $misobfFilenameFull > ${thisEventTypeFolder}/${comparisonName}.${splidarEventType}.bf${bfThreshold}.dPsi${dPsiCutOff}.miso_bf.splidarEvents.full
				
			done
		
		done
		
	done

done
