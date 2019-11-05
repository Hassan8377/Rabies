#! /bin/bash
set -e

rawFast5=$1
runname=$2

#basecall raw fast5 files
guppy_basecaller -r --input_path --require_barcodes_both_ends $rawFast5 --save_path "guppy_"$runname -c dna_r9.4.1_450bps_fast.cfg

# gather fastq files
artic gather --guppy --min-length 300 --prefix $runname "guppy_"$runname

#demultiplex with porechop
artic demultiplex --threads 4 $runname"_all.fastq"

#index raw reads
nanopolish index -d $rawFast5 $runname"_all.fastq"
