#!/bin/bash


cd ..

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