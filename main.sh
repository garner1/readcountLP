#!/usr/bin/env bash

window=1000000			# size of the window
genome=hg19
sliding=500000			# how much to slide before starting the second window

name=$1				# ex: XZ114
bamfile=$2  			# ex: /media/garner1/hdd/XZ114/outdata/GTCGTCGC.deduplicated.bam
k=$3				# rank threshold in svd

datadir=~/Work/dataset/readcountLP/$name

old_dir=$PWD

mkdir -p $datadir
cd $datadir
if [ ! -f ../"$window"_"$genome"_"$sliding" ]; then
    cd ..
    ~/Work/pipelines/aux.scripts/make-windows.sh $window $genome $sliding > "$window"_"$genome"_"$sliding" #PREPARE BINS BED FILES
    cd -
fi

bedtools intersect -a ../"$window"_"$genome"_"$sliding" -b $bamfile -wa -wb | cut -f1,2,5 > chr-bin-start.tsv  #INTERSECT BINS AND BAM FILE (check if chr labels are homogeneous in bed and bam files)

awk '{print $1$3 > $1"_"$2".dat"}' chr-bin-start.tsv
parallel "cat {} | datamash transpose > {.}.aux && mv {.}.aux {}" ::: `ls *.dat`
cat chr*.dat > genome.tsv
# parallel "cat chr{}_*.dat > chr{}.tsv" ::: `seq 1 22`
rm *.dat 

cd $old_dir
python vectorization.py $datadir/genome.tsv $k  # 1 is the rank truncation in svd
# parallel "python vectorization.py $datadir/chr{}.tsv $k" ::: `seq 1 22` # 1 is the rank truncation in svd
