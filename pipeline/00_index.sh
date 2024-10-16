#!/usr/bin/bash -l
module load samtools
module load bwa-mem2
module load bwa
if [ -f config.txt ]; then
	source config.txt
fi
FASTAFILE=$REFGENOME
if [[ ! -f $FASTAFILE.fai || $FASTAFILE -nt $FASTAFILE.fai ]]; then
	samtools faidx $FASTAFILE
fi
if [[ ! -f $FASTAFILE.bwt || $FASTAFILE -nt $FASTAFILE.bwt ]]; then
	bwa index $FASTAFILE
	bwa-mem2 index $FASTAFILE
fi

DICT=$(basename $FASTAFILE .fasta)".dict"

if [[ ! -f $DICT || $FASTAFILE -nt $DICT ]]; then
	rm -f $DICT
	samtools dict $FASTAFILE > $DICT
	ln -s $DICT $FASTAFILE.dict 
fi
grep ">" $FASTAFILE | perl -p -e 's/>(scaffold_(\d+))/1,$2/' > $GENOMEFOLDER/chrom_nums.csv
popd
