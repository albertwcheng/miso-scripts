#!/bin/bash

cd ..

cd scriptureOutput_*

for i in *.segments; do
echo processing $i
pref=${i/.segments/}
addIndexToCol.py $i 4 | awk -v FS="\t" -v OFS="\t" '{$6="+"; print;}' > $pref.ebed
ebed2GenePred.py $pref.ebed --ebed2exonebed  > $pref.eebed  #hack the strand
cuta.py -f1-3 $pref.eebed | sort +0 -1 -n +1 -3 | uniq > $pref.uniqExons.exonCoord
done

echo "combining"
cat *.ebed > all.EBED
cat *.eebed > all.EEBED
cat *.exonCoord > all.EXONCOORD.BED

exit

ebed2GenePred.py --ebed2ebedseq all.EXONCOORD.EEBEDSEQ all.EBED > all.EBEDSEQ