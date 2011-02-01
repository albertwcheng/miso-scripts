#!/bin/bash


cd ..


if [ -e fastq ]; then
cd fastq
for i in *.fastq; do
	gzip $i
done

for i in *.fasta; do
	gzip $i
done

for i in *.txt; do
	gzip $i
done
cd ..
fi

if [ -e mergedsolfq ]; then
cd mergedsolfq
for i in *.fastq; do
	gzip $i
done

for i in *.fasta; do
	gzip $i
done

for i in *.txt; do
	gzip $i
done
cd ..
fi