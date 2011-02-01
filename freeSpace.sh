#!/bin/bash

for i in ../tophatOutput/*; do
	if [ -e $i/accepted_hits.sorted.bam ]; then
		rm $i/accepted_hits.bam
		rm $i/accepted_hits.sam
	else
		if [ -e $i/accepted_hits.bam ]; then
			rm $i/accepted_hits.sam
		else
			echo "$i/accepted_hits.bam not exist. abort"
		fi
	fi
done