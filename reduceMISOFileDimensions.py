#!/usr/bin/env python

'''
ENAH.miso:

miso file format:

#isoforms=['ENAH@EXON1_ENAH@EXON2_ENAH@EXON3_ENAH@EXON4_ENAH@EXON5_ENAH@EXON6_ENAH@EXON7_ENAH@EXON8_ENAH@EXON9_ENAH@EXON10_ENAH@EXON11_ENAH@EXON12_ENAH@EXON13_ENAH@EXON14','ENAH@EXON15_ENAH@EXON16_ENAH@EXON17_ENAH@EXON18_ENAH@EXON19_ENAH@EXON20_ENAH@EXON21_ENAH@EXON22_ENAH@EXON23_ENAH@EXON24_ENAH@EXON25_ENAH@EXON26_ENAH@EXON27_ENAH@EXON28_ENAH@EXON29','ENAH@EXON30_ENAH@EXON31_ENAH@EXON32_ENAH@EXON33_ENAH@EXON34','ENAH@EXON35_ENAH@EXON36_ENAH@EXON37_ENAH@EXON38_ENAH@EXON39','ENAH@EXON40_ENAH@EXON41_ENAH@EXON42_ENAH@EXON43_ENAH@EXON44','ENAH@EXON45_ENAH@EXON46_ENAH@EXON47_ENAH@EXON48','ENAH@EXON49_ENAH@EXON50_ENAH@EXON51_ENAH@EXON52_ENAH@EXON53_ENAH@EXON54_ENAH@EXON55_ENAH@EXON56_ENAH@EXON57','ENAH@EXON58_ENAH@EXON59_ENAH@EXON60','ENAH@EXON61_ENAH@EXON62_ENAH@EXON63_ENAH@EXON64_ENAH@EXON65','ENAH@EXON66','ENAH@EXON67_ENAH@EXON68','ENAH@EXON69_ENAH@EXON70_ENAH@EXON71_ENAH@EXON72_ENAH@EXON73_ENAH@EXON74','ENAH@EXON75']        exon_lens=('ENAH@EXON1',10981),('ENAH@EXON2',58),('ENAH@EXON3',79),('ENAH@EXON4',67),('ENAH@EXON5',49),('ENAH@EXON6',58),('ENAH@EXON7',146),('ENAH@EXON8',305),('ENAH@EXON9',111),('ENAH@EXON10',368),('ENAH@EXON11',85),('ENAH@EXON12',178),('ENAH@EXON13',166),('ENAH@EXON14',458),('ENAH@EXON15',10981),('ENAH@EXON16',58),('ENAH@EXON17',79),('ENAH@EXON18',63),('ENAH@EXON19',67),('ENAH@EXON20',49),('ENAH@EXON21',58),('ENAH@EXON22',146),('ENAH@EXON23',305),('ENAH@EXON24',111),('ENAH@EXON25',368),('ENAH@EXON26',85),('ENAH@EXON27',178),('ENAH@EXON28',166),('ENAH@EXON29',461),('ENAH@EXON30',531),('ENAH@EXON31',46),('ENAH@EXON32',166),('ENAH@EXON33',155),('ENAH@EXON34',211),('ENAH@EXON35',736),('ENAH@EXON36',85),('ENAH@EXON37',178),('ENAH@EXON38',166),('ENAH@EXON39',82),('ENAH@EXON40',51),('ENAH@EXON41',178),('ENAH@EXON42',166),('ENAH@EXON43',58),('ENAH@EXON44',66),('ENAH@EXON45',475),('ENAH@EXON46',390),('ENAH@EXON47',58),('ENAH@EXON48',265),('ENAH@EXON49',2333),('ENAH@EXON50',58),('ENAH@EXON51',79),('ENAH@EXON52',63),('ENAH@EXON53',67),('ENAH@EXON54',49),('ENAH@EXON55',58),('ENAH@EXON56',146),('ENAH@EXON57',1457),('ENAH@EXON58',1081),('ENAH@EXON59',79),('ENAH@EXON60',67),('ENAH@EXON61',179),('ENAH@EXON62',58),('ENAH@EXON63',79),('ENAH@EXON64',67),('ENAH@EXON65',194),('ENAH@EXON66',1325),('ENAH@EXON67',168),('ENAH@EXON68',177),('ENAH@EXON69',592),('ENAH@EXON70',368),('ENAH@EXON71',85),('ENAH@EXON72',178),('ENAH@EXON73',166),('ENAH@EXON74',91),('ENAH@EXON75',708)
     iters=5000      burn_in=500     lag=10  percent_accept=0.88     proposal_type=drift     counts=(0,0,0,0,0,0,0,0,0,0,0,0,1):3,(0,0,0,0,0,0,0,0,0,0,0,1,0):3,(0,0,0,0,0,0,0,0,0,0,0,1,1):29,(0,0,0,0,0,0,0,0,0,0,1,0,0):13,(0,0,0,0,0,0,0,0,0,1,0,0,0):9,(0,0,0,0,0,0,0,1,0,0,0,0,0):1,(0,0,0,0,0,0,0,1,0,1,0,0,0):6,(0,0,0,0,0,0,1,0,0,0,0,0,0):6,(0,0,0,0,0,1,0,0,0,0,0,0,0):11,(0,0,0,1,0,0,0,0,0,0,0,0,0):6,(0,0,1,0,0,0,0,0,0,0,0,0,0):15,(0,1,0,0,0,0,1,0,0,0,0,0,0):38,(1,0,0,0,0,0,0,1,1,0,0,0,0):7,(1,1,0,0,0,0,0,0,0,0,0,0,0):586,(1,1,0,0,0,0,1,0,0,0,0,0,0):686,(1,1,0,0,0,0,1,0,0,0,1,0,0):187,(1,1,0,0,0,0,1,1,0,0,0,0,0):88,(1,1,0,0,0,0,1,1,1,0,0,0,0):41,(1,1,0,0,0,1,0,0,0,0,0,0,0):90,(1,1,0,0,0,1,1,1,0,0,0,0,0):105,(1,1,0,0,0,1,1,1,1,0,0,0,0):261,(1,1,0,0,0,1,1,1,1,1,0,0,0):14,(1,1,0,1,0,0,0,0,0,0,0,1,0):885,(1,1,0,1,1,0,0,0,0,0,0,1,0):223,(1,1,1,0,0,0,0,0,0,0,0,0,0):134,(1,1,1,0,0,0,1,0,0,0,0,0,0):121,(1,1,1,1,1,0,0,0,0,0,0,1,0):203   assigned_counts=0:308,1:848,2:167,3:1140,4:3,5:170,6:774,7:44,8:104,9:10,10:138,11:37,12:28
sampled_psi     log_score
0.0216,0.0299,0.0376,0.5346,0.0055,0.0558,0.1322,0.0121,0.0420,0.0071,0.0097,0.0092,0.1027      -37479.0016
0.0216,0.0299,0.0376,0.5346,0.0055,0.0558,0.1322,0.0121,0.0420,0.0071,0.0097,0.0092,0.1027      -37424.9787

/lab/jaenisch_albert/genomes/hg18/annos$ acembly.pe.exonStringMap.make.sh
/lab/jaenisch_albert/genomes/hg18/annos/oldStuff/old.acembly$ grep ENAH acembly.pe.exonStringMap
/lab/jaenisch_albert/genomes/hg18/annos/oldStuff/old.acembly$ grep ENAH acembly.pe.exonStringMap > byGenes/acembly.pe.exonStringMap.ENAH
/lab/jaenisch_albert/genomes/hg18/annos/oldStuff/old.acembly$ less byGenes/acembly.pe.exonStringMap.ENAH 
ENAH:mApr07-unspliced   ENAH@EXON66
ENAH:bApr07     ENAH@EXON1_ENAH@EXON2_ENAH@EXON3_ENAH@EXON4_ENAH@EXON5_ENAH@EXON6_ENAH@EXON7_ENAH@EXON8_ENAH@EXON9_ENAH@EXON10_ENAH@EXON11_ENAH@EXON12_ENAH@EXON13_ENAH@EXON14
ENAH:iApr07     ENAH@EXON58_ENAH@EXON59_ENAH@EXON60
ENAH:fApr07-unspliced   ENAH@EXON75
ENAH:jApr07     ENAH@EXON45_ENAH@EXON46_ENAH@EXON47_ENAH@EXON48
ENAH:eApr07     ENAH@EXON35_ENAH@EXON36_ENAH@EXON37_ENAH@EXON38_ENAH@EXON39
ENAH:dApr07     ENAH@EXON49_ENAH@EXON50_ENAH@EXON51_ENAH@EXON52_ENAH@EXON53_ENAH@EXON54_ENAH@EXON55_ENAH@EXON56_ENAH@EXON57
ENAH:hApr07     ENAH@EXON67_ENAH@EXON68
ENAH:aApr07     ENAH@EXON15_ENAH@EXON16_ENAH@EXON17_ENAH@EXON18_ENAH@EXON19_ENAH@EXON20_ENAH@EXON21_ENAH@EXON22_ENAH@EXON23_ENAH@EXON24_ENAH@EXON25_ENAH@EXON26_ENAH@EXON27_ENAH@EXON28_ENAH@EXON29
ENAH:lApr07     ENAH@EXON30_ENAH@EXON31_ENAH@EXON32_ENAH@EXON33_ENAH@EXON34
ENAH:gApr07     ENAH@EXON40_ENAH@EXON41_ENAH@EXON42_ENAH@EXON43_ENAH@EXON44
ENAH:cApr07     ENAH@EXON69_ENAH@EXON70_ENAH@EXON71_ENAH@EXON72_ENAH@EXON73_ENAH@EXON74
ENAH:kApr07     ENAH@EXON61_ENAH@EXON62_ENAH@EXON63_ENAH@EXON64_ENAH@EXON65
(END) 



/lab/jaenisch_albert/genomes/hg18/SplidarEventGff$ makeTranscriptExonStringFromGff.py allEvents.pe.GFF3 > allEvents.pe.exonString
cat allEvents.EBED | tr " " "\t" > allEvents.tabbed.ebed
cheng@tak /lab/jaenisch_albert/genomes/hg18/SplidarEventGff$ less allEvents.tabbed.ebed 

/lab/jaenisch_albert/genomes/hg18/SplidarEventGff$ rm  events2Transcript.map; Splidar.Splicing.matchEventToTranscript.py  allEvents.tabbed.ebed  ../annos/acembly.ebed  > events2Transcript.map

RI.ENAH.27053.1	ENAH.iApr07	chr1
RI.ENAH.27051.2	ENAH.jApr07	chr1
SE.ENAH.47366.2	ENAH.aApr07	chr1
RI.ENAH.27051.2	ENAH.kApr07	chr1
Alt3UTR.ENAH.2992.1	ENAH.aApr07	chr1
Alt3UTR.ENAH.2995.1	ENAH.aApr07	chr1
Alt3UTR.ENAH.2997.1	ENAH.aApr07	chr1
Alt3UTR.ENAH.2999.2	ENAH.aApr07	chr1
AFE.ENAH.43749.2	ENAH.aApr07	chr1
AFE.ENAH.43751.2	ENAH.aApr07	chr1
SE.ENAH.47366.1	ENAH.lApr07	chr1
RI.ENAH.27052.1	ENAH.iApr07	chr1
RI.ENAH.27052.2	ENAH.kApr07	chr1
Alt3UTR.ENAH.2993.1	ENAH.aApr07	chr1
Alt3UTR.ENAH.2996.1	ENAH.aApr07	chr1
Alt3UTR.ENAH.2998.1	ENAH.aApr07	chr1
Alt3UTR.ENAH.2999.1	ENAH.aApr07	chr1
RI.ENAH.27053.2	ENAH.jApr07	chr1
Alt3UTR.ENAH.2990.1	ENAH.aApr07	chr1
Alt3UTR.ENAH.2994.2	ENAH.aApr07	chr1
Alt3UTR.ENAH.2995.2	ENAH.aApr07	chr1
Alt3UTR.ENAH.2996.2	ENAH.aApr07	chr1


etc

/lab/jaenisch_albert/genomes/hg18/SplidarEventGff$ cat events2Transcript.map | tr "." ":" > events2Transcript.map.colon

rm ../annos/acembly.pe.exonStringMap.ENAH;  grep ENAH  ../annos/acembly.pe.exonStringMap >  ../annos/acembly.pe.exonStringMap.ENAH

/lab/jaenisch_albert/genomes/hg18/SplidarEventGff$ rm  events2Transcript.map.exonString.ENAH; joinu.py -1 2 -2 1  events2Transcript.map.colon  ../annos/acembly.pe.exonStringMap.ENAH > events2Transcript.map.exonString.ENAH

RI.ENAH.27053.1 ENAH.iApr07     chr1    ENAH@EXON48_ENAH@EXON49_ENAH@EXON50
RI.ENAH.27051.2 ENAH.jApr07     chr1    ENAH@EXON30_ENAH@EXON31_ENAH@EXON32_ENAH@EXON33
SE.ENAH.47366.2 ENAH.aApr07     chr1    ENAH@EXON15_ENAH@EXON16_ENAH@EXON17_ENAH@EXON18_ENAH@EXON19_ENAH@EXON20_ENAH@EXON21_ENAH@EXON22_ENAH@EXON23_ENAH@EXON24_ENAH@EXON25_ENAH@EXON26_ENAH@EXON27_ENAH@EXON28_ENAH@EXON29
RI.ENAH.27051.2 ENAH.kApr07     chr1    ENAH@EXON51_ENAH@EXON52_ENAH@EXON53_ENAH@EXON54_ENAH@EXON55
Alt3UTR.ENAH.2992.1     ENAH.aApr07     chr1    ENAH@EXON15_ENAH@EXON16_ENAH@EXON17_ENAH@EXON18_ENAH@EXON19_ENAH@EXON20_ENAH@EXON21_ENAH@EXON22_ENAH@EXON23_ENAH@EXON24_ENAH@EXON25_ENAH@EXON26_ENAH@EXON27_ENAH@EXON28_ENAH@EXON29
Alt3UTR.ENAH.2995.1     ENAH.aApr07     chr1    ENAH@EXON15_ENAH@EXON16_ENAH@EXON17_ENAH@EXON18_ENAH@EXON19_ENAH@EXON20_ENAH@EXON21_ENAH@EXON22_ENAH@EXON23_ENAH@EXON24_ENAH@EXON25_ENAH@EXON26_ENAH@EXON27_ENAH@EXON28_ENAH@EXON29
Alt3UTR.ENAH.2997.1     ENAH.aApr07     chr1    ENAH@EXON15_ENAH@EXON16_ENAH@EXON17_ENAH@EXON18_ENAH@EXON19_ENAH@EXON20_ENAH@EXON21_ENAH@EXON22_ENAH@EXON23_ENAH@EXON24_ENAH@EXON25_ENAH@EXON26_ENAH@EXON27_ENAH@EXON28_ENAH@EXON29
Alt3UTR.ENAH.2999.2     ENAH.aApr07     chr1    ENAH@EXON15_ENAH@EXON16_ENAH@EXON17_ENAH@EXON18_ENAH@EXON19_ENAH@EXON20_ENAH@EXON21_ENAH@EXON22_ENAH@EXON23_ENAH@EXON24_ENAH@EXON25_ENAH@EXON26_ENAH@EXON27_ENAH@EXON28_ENAH@EXON29
AFE.ENAH.43749.2        ENAH.aApr07     chr1    ENAH@EXON15_ENAH@EXON16_ENAH@EXON17_ENAH@EXON18_ENAH@EXON19_ENAH@EXON20_ENAH@EXON21_ENAH@EXON22_ENAH@EXON23_ENAH@EXON24_ENAH@EXON25_ENAH@EXON26_ENAH@EXON27_ENAH@EXON28_ENAH@EXON29
AFE.ENAH.43751.2        ENAH.aApr07     chr1    ENAH@EXON15_ENAH@EXON16_ENAH@EXON17_ENAH@EXON18_ENAH@EXON19_ENAH@EXON20_ENAH@EXON21_ENAH@EXON22_ENAH@EXON23_ENAH@EXON24_ENAH@EXON25_ENAH@EXON26_ENAH@EXON27_ENAH@EXON28_ENAH@EXON29
SE.ENAH.47366.1 ENAH.lApr07     chr1    ENAH@EXON34_ENAH@EXON35_ENAH@EXON36_ENAH@EXON37_ENAH@EXON38
RI.ENAH.27052.1 ENAH.iApr07     chr1    ENAH@EXON48_ENAH@EXON49_ENAH@EXON50
RI.ENAH.27052.2 ENAH.kApr07     chr1    ENAH@EXON51_ENAH@EXON52_ENAH@EXON53_ENAH@EXON54_ENAH@EXON55
Alt3UTR.ENAH.2993.1     ENAH.aApr07     chr1    ENAH@EXON15_ENAH@EXON16_ENAH@EXON17_ENAH@EXON18_ENAH@EXON19_ENAH@EXON20_ENAH@EXON21_ENAH@EXON22_ENAH@EXON23_ENAH@EXON24_ENAH@EXON25_ENAH@EXON26_ENAH@EXON27_ENAH@EXON28_ENAH@EXON29
Alt3UTR.ENAH.2996.1     ENAH.aApr07     chr1    ENAH@EXON15_ENAH@EXON16_ENAH@EXON17_ENAH@EXON18_ENAH@EXON19_ENAH@EXON20_ENAH@EXON21_ENAH@EXON22_ENAH@EXON23_ENAH@EXON24_ENAH@EXON25_ENAH@EXON26_ENAH@EXON27_ENAH@EXON28_ENAH@EXON29

rm events2Transcript.map.exonString.ENAH.col; stickColValues.py --internalfs , events2Transcript.map.exonString.ENAH 1 > events2Transcript.map.exonString.ENAH.col


colStat.py -r2 events2Transcript.map.exonString.ENAH.col  #events2TranscriptExonStringCol[:::::			R 2			:::::]
Index			Excel			Field
-----			-----			-----
1			A			RI.ENAH.27051.2
2			B			ENAH.jApr07,ENAH.kApr07,ENAH.dApr07,ENAH.bApr07,ENAH.aApr07
3			C			chr1
4			D			ENAH@EXON30_ENAH@EXON31_ENAH@EXON32_ENAH@EXON33,ENAH@EXON51_ENAH@EXON52_ENAH@EXON53_ENAH@EXON54_ENAH@EXON55,ENAH@EXON39_ENAH@EXON40_ENAH@EXON41_ENAH@EXON42_ENAH@EXON43_ENAH@EXON44_ENAH@EXON45_ENAH@EXON46_ENAH@EXON47,ENAH@EXON1_ENAH@EXON2_ENAH@EXON3_ENAH@EXON4_ENAH@EXON5_ENAH@EXON6_ENAH@EXON7_ENAH@EXON8_ENAH@EXON9_ENAH@EXON10_ENAH@EXON11_ENAH@EXON12_ENAH@EXON13_ENAH@EXON14,ENAH@EXON15_ENAH@EXON16_ENAH@EXON17_ENAH@EXON18_ENAH@EXON19_ENAH@EXON20_ENAH@EXON21_ENAH@EXON22_ENAH@EXON23_ENAH@EXON24_ENAH@EXON25_ENAH@EXON26_ENAH@EXON27_ENAH@EXON28_ENAH@EXON29
'''

from sys import *
import os.path
import os
from getopt import getopt

def parseMISOFile(filename):
	#return (sampled_psi[exonString][MISORow]=float,logScore[MISORow]=float)
	sampled_psi=dict()
	log_scores=[]
	
	fil=open(filename)
	lines=fil.readlines()
	fil.close()
	
	#first parse header	
	header=lines[0].rstrip("\r\n")
	
	try:
		if header[0:11]!="#isoforms=[":
			raise ValueError
		headerIsoformString=header[10:].split("\t")[0]
		isoformExonStrings=eval(headerIsoformString)				
	except:
		print >> stderr,"MISO Header Format Error filename="+filename
		exit()
	
	#print >> stderr,"isoformExonStrings",isoformExonStrings
	
	#now go to other lines
	if lines[1].split("\t")[0]!="sampled_psi":
		print >> stderr,"MISO Table Format Error filename="+filename
		exit()
	
	for isoformExonString in isoformExonStrings:
		sampled_psi[isoformExonString]=[]
	
	for lin in lines[2:]:
		try:
			sampled_psi_str,log_score=lin.rstrip("\r\n").split("\t")
			sampled_psi_str=sampled_psi_str.split(",")
			log_scores.append(log_score)
			for isoformExonString,sampled_psi_stron in zip(isoformExonStrings,sampled_psi_str):
				sampled_psi[isoformExonString].append(float(sampled_psi_stron))
		except:
			print >> stderr,"error at line:",lin
			print >> stderr,"sampled_psi_str:",sampled_psi_str
			exit()
			
	return (sampled_psi,log_scores)
	

'''
misoFileDir=/lab/solexa_jaenisch/Albert2/mRNASeqLibs/EMT/MISOOnSE_acembly/MISOOutput.ENAH/Epithelial
events2TranscriptExonStringColFile=/lab/jaenisch_albert/genomes/hg18/SplidarEventGff/events2Transcript.map.exonString.ENAH.col
outputMISODir=/lab/solexa_jaenisch/Albert2/mRNASeqLibs/EMT/MISOOnSE_acembly_reduced/MISOOutput.ENAH/Epithelial

python reduceMISOFileDimensions.py $misoFileDir $events2TranscriptExonStringColFile $outputMISODir

'''


def printUsageAndExit(programName):
	print >> stderr,"Usage:",programName,"[--abort-less-than default:100] misoFileDir events2TranscriptExonStringColFile outputMISODir"
	exit()

if __name__=='__main__':
	programName=argv[0]
	opts,args=getopt(argv[1:],'',['abort-less-than='])
	
	abortLessThan=100
	
	for o,v in opts:
		if o=='--abort-less-than':
			abortLessThan=int(v)
	
	try:
		misoFileDir, events2TranscriptExonStringColFile, outputMISODir=args
	except:
		printUsageAndExit(programName)
	
	if not os.path.isdir(outputMISODir):
		os.makedirs(outputMISODir)
	
	E2TXStrMap=dict()
	GeneChromMap=dict()
	#E2TXStrMap[eventGeneName][eventName][1|2...]=([transcriptID...],[exonString,..])
	filE2TXStr=open(events2TranscriptExonStringColFile)
	for lin in filE2TXStr:
		fields=lin.rstrip("\r\n").split("\t")
		eventID=fields[0].split(":")
		eventGeneName=":".join(eventID[1:-2]) #Alt3UTR:ENAH:2995:1   -> ENAH
		eventIDIsoformIdx=int(eventID[-1])
		eventID=":".join(eventID[:-1])
		transcriptIDs=fields[1].split(",")
		exonStrings=fields[3].split(",")
		chrom=fields[2]
		try:
			eventGeneStruct=E2TXStrMap[eventGeneName]
		except KeyError:
			eventGeneStruct=dict()
			GeneChromMap[eventGeneName]=chrom
			E2TXStrMap[eventGeneName]=eventGeneStruct
		
		try:
			eventStruct=eventGeneStruct[eventID]
		except KeyError:
			eventStruct=dict()
			eventGeneStruct[eventID]=eventStruct
		
		if eventStruct.has_key(eventIDIsoformIdx):
			print >> stderr,"Error: event has been duplicated. Please col file before running"
			exit()
		eventStruct[eventIDIsoformIdx]=(transcriptIDs,exonStrings)
		
	
	filE2TXStr.close()
	
	#now go every event and process the corresponding eventGeneName.miso file
	for eventGeneName,eventGeneStruct in E2TXStrMap.items():
		chrom=GeneChromMap[eventGeneName]
		misoFileName=misoFileDir+"/"+chrom+"/"+eventGeneName+".miso"
		if not os.path.isfile(misoFileName):
			print >> stderr,"miso file for gene",eventGeneName,"does not exists:",misoFileName
			continue
			
		sampled_psi,log_score=parseMISOFile(misoFileDir+"/"+chrom+"/"+eventGeneName+".miso")
		for eventID,eventStruct in eventGeneStruct.items():
			
			outputMISOPath=outputMISODir+"/"+chrom
			if not os.path.isdir(outputMISOPath):
				os.makedirs(outputMISOPath)
			outputMISOFileName=outputMISOPath+"/"+eventID+".miso"
			

			
			eventIsoforms=[]
			eventIDIsoformIdxKeys=eventStruct.keys()
			eventIDIsoformIdxKeys.sort()
			
			if len(eventIDIsoformIdxKeys)<2: #only one isoform for this event mappable back to the transcript ignore
				continue
			
			foutputMISO=open(outputMISOFileName,"w")
			
			for eventIDIsoformIdx in eventIDIsoformIdxKeys:
				eventIsoforms.append("'"+eventID+"."+str(eventIDIsoformIdx)+"'")
			
			#now write new header
			new_header=["isoforms=["+",".join(eventIsoforms)+"]"]
			
			
			
			print >> foutputMISO,"#"+"\t".join(new_header)
			
			print >> foutputMISO,"sampled_psi\tlog_score"
			
			numValidLines=0
			numInvalidLines=0			
			sampled_psi_ave=[]
			log_score_ave=0.0
			
			for miso_row in range(0,len(log_score)):
				sampled_psi_out=[]
				isoform_cpsi=[]
				ccpsi=0.0
				for eventIDIsoformIdx in eventIDIsoformIdxKeys:
					transcriptIDs,exonStrings=eventStruct[eventIDIsoformIdx]
					cpsi=0.0
					for exonString in exonStrings:
						try:
							cpsi+=sampled_psi[exonString][miso_row]
						except KeyError:
							print >> stderr,"exon string",exonString,"in gene ",eventGeneName," requested. Presumably due to overlapping genes. pass"
							continue
							
					isoform_cpsi.append(cpsi)
					ccpsi+=cpsi
				
				if ccpsi==0.0:
					numInvalidLines+=1
					continue
				
				idxx=0
				
				numValidLines+=1
				
				for cpsi in isoform_cpsi:
					norm_psi=cpsi/ccpsi
					sampled_psi_out.append(str(norm_psi))
					if numValidLines==1:
						sampled_psi_ave.append(norm_psi)
					else:	
						sampled_psi_ave[idxx]+=norm_psi
					idxx+=1
				
				
				thislogscore=log_score[miso_row]
				log_score_ave+=float(thislogscore)
			
				sampled_psi_out=",".join(sampled_psi_out)
				print >> foutputMISO,sampled_psi_out+"\t"+thislogscore
	
			
			
			if numValidLines<abortLessThan:
				#delete this file:
				foutputMISO.close()
				os.remove(outputMISOFileName)
				print >> stderr,"file",outputMISOFileName,"removed because numValidLines<",abortLessThan
			else:
				#now calculate the average and fill up
				if numInvalidLines>0:
					for i in range(0,len(sampled_psi_ave)):
						sampled_psi_ave[i]=str(sampled_psi_ave[i]/numValidLines)
					
					log_score_ave=str(log_score_ave/numValidLines)
					outline=",".join(sampled_psi_ave)+"\t"+log_score_ave
					
					for i in range(0,numInvalidLines):
						print >> foutputMISO,outline
					
					print >> stderr,"fill", numInvalidLines,"invalid rows with average for file",outputMISOFileName
				
				
				foutputMISO.close()
			
			
			
				

			
