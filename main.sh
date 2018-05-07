#!/usr/bin/env bash

window=1000000			# size of the window
genome=hg19
sliding=500000			# how much to slide before starting the second window
datadir=~/Work/dataset/readcountLP
bamfile=/media/garner1/hdd/XZ114/outdata/GTCGTCGC.deduplicated.bam

mkdir -p $datadir

cd $datadir

# if [ ! -f "$window"_"$genome"_"$sliding" ]; then
#     ~/Work/pipelines/aux.scripts/make-windows.sh $window $genome $sliding > "$window"_"$genome"_"$sliding"
# fi

# bedtools intersect -a "$window"_"$genome"_"$sliding" -b $bamfile -wa -wb | cut -f1,2,5 > chr-bin-start.tsv

# awk '{print $3 > $1"_"$2".dat"}' chr-bin-start.tsv
# parallel "cat {} | datamash transpose > {.}.tsv" ::: *.dat
parallel "cat chr{}_*.tsv > chr{}.tsv" ::: `seq 1 22`
rm *.dat chr*_*.tsv

# samtools view $bamfile | awk '{print $3"-"$4 > $3".txt"}' # for each chr list the read locations
# parallel "cat {} | datamash transpose | sed 's/chr//g'|tr '-' 'S' > {.}.1line" ::: chr*.txt
# # cat chr*.1line > chr-loc.dtm.tsv
# rm chr*.txt
