#!/usr/bin/env python

'''

 This is needed because MISO two isoform analysis from event Gff does not have an order in terms of which isoform of an event is the inclusion form. 
 While splidar event gff encodes the inclusion isoform with a suffix 1 and exclusion isoform with a suffix 2. 
 So we need to flip the psi values (the posterior means, and the CI low high values by 1-psi if 2 is the first one in the isoform

'''

from albertcommon import *
from sys import *
from getopt import getopt

def printUsageAndExit(programName):
	print >> stderr,"Usage:",programName,"[options] filename > outfile"
	print >> stderr,"Options:"
	print >> stderr,"--psicols colSelector  specify the psi value cols [@posterior_mean,@ci_low,@ci_high]"
	print >> stderr,"--transcriptcol colSelector specify the transcript col [.transcript]"
	explainColumns(stderr)
	exit()

if __name__=='__main__':
	
	startRow=2
	headerRow=1
	fs="\t" 
	eventIsoSep=","
	eventInSep="."  #SE.Sfrs14.25461.1,SE.Sfrs14.25461.2
	psicols="@posterior_mean,@ci_low,@ci_high"
	transcriptcol=".transcript"
	
	programName=argv[0]
	opts,args=getopt(argv[1:],'',['psicols=','transcriptcol='])
	
	for o,v in opts:
		if o=='--transciptcol':
			transcriptcol=v
		elif o=='--psicol':
			psicol=v
	
	try:
		filename,=args
	except:
		printUsageAndExit(programName)
	
	header,prestarts=getHeader(filename,headerRow,startRow,fs)

	psicols=getCol0ListFromCol1ListStringAdv(header,psicols)
	transcriptcol=getCol0ListFromCol1ListStringAdv(header,transcriptcol)[0]
	
	corrected=0
	
	fil=open(filename)
	lino=0
	for lin in fil:
		lino+=1
		fields=lin.rstrip("\r\n").split(fs)
		if lino<startRow:
			fields[transcriptcol]="eventIDString"
		else:
			transcriptValue=fields[transcriptcol].split(eventIsoSep)
			if len(transcriptValue)!=2:
				print >> stderr,"error: event isoform numbers !=2. Abort",fields
				exit()
			
			firstIsoform=transcriptValue[0]
			splidarIsoformFlag=firstIsoform.split(eventInSep)[-1]
			splidarEventNameString=eventInSep.join(firstIsoform.split(eventInSep)[:-1])
			fields[transcriptcol]=splidarEventNameString
			
			if splidarIsoformFlag not in ["1","2"]:
				print >> stderr,"splidar isoform flag error not 1 or 2",firstIsoform,".Abort"
				exit()
			
			if splidarIsoformFlag=="2": #exclusion-first MISO event cases: flip!
				corrected+=1
				for psicol in psicols:
					fields[psicol]=str(1.0-float(fields[psicol]))
			
			
			
			
		print >> stdout,fs.join(fields)
			
	fil.close()
	
	print >> stderr,"MISO Psi flipped %d times" %(corrected)